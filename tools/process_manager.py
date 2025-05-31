import os
import signal
import subprocess
import threading
from contextlib import contextmanager
from typing import List


class ProcessManager:
    """Smart process manager with interrupt handling and cleanup."""

    def __init__(self):
        self.processes: List[subprocess.Popen] = []
        self.shutdown_event = threading.Event()
        self.original_signal_handler = None
        self.main_process_group = None
        self.is_main_thread = threading.current_thread() is threading.main_thread()

    def __enter__(self):
        # Store the main process group (don't change it)
        self.main_process_group = os.getpgrp()

        # Only install signal handler in main thread
        if self.is_main_thread:
            try:
                self.original_signal_handler = signal.signal(
                    signal.SIGINT, self._signal_handler
                )
            except ValueError:
                # Signal operations not supported in this context, continue without signal handling
                self.is_main_thread = False

        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.cleanup()

    def _signal_handler(self, signum, frame):
        """Enhanced signal handler that kills all processes."""
        from rich.console import Console

        console = Console()
        console.print(
            "\n🛑 [bold red]Interrupt received - terminating all processes[/bold red]"
        )

        self.shutdown_event.set()
        self.cleanup()

        # Re-raise KeyboardInterrupt to properly exit
        raise KeyboardInterrupt("Process terminated by user")

    def cleanup(self):
        """Kill all tracked processes (but not the main process group)."""
        # Kill individual tracked processes more aggressively
        for proc in self.processes:
            try:
                if proc.poll() is None:  # Still running
                    proc.terminate()
                    try:
                        proc.wait(timeout=0.5)  # Reduced timeout
                    except subprocess.TimeoutExpired:
                        proc.kill()
                        try:
                            proc.wait(timeout=0.5)  # Reduced timeout for kill
                        except subprocess.TimeoutExpired:
                            pass  # Process is stuck, move on
            except Exception:
                try:
                    proc.kill()
                except Exception:
                    pass

        # Clear the process list
        self.processes.clear()

        # Restore original handler only if we set it up in main thread
        if self.is_main_thread and self.original_signal_handler:
            try:
                signal.signal(signal.SIGINT, self.original_signal_handler)
            except ValueError:
                # Signal operations not supported, ignore
                pass

    def run_subprocess(
        self,
        cmd: List[str],
        timeout: int = 900,
        check: bool = False,
        capture_output: bool = False,
        text: bool = False,
        **kwargs,
    ) -> subprocess.CompletedProcess:
        """Run subprocess with timeout and interrupt handling."""
        if self.shutdown_event.is_set():
            raise KeyboardInterrupt("Shutdown requested")

        # Handle capture_output parameter (convert to stdout/stderr settings)
        if capture_output:
            if "stdout" in kwargs or "stderr" in kwargs:
                raise ValueError(
                    "capture_output cannot be used with stdout or stderr arguments"
                )
            kwargs["stdout"] = subprocess.PIPE
            kwargs["stderr"] = subprocess.PIPE

        # Handle text parameter
        if text:
            kwargs["text"] = True

        # Only set up process groups on Unix-like systems and when not already specified
        import sys

        if sys.platform != "win32" and "preexec_fn" not in kwargs:
            try:
                kwargs["start_new_session"] = True
            except Exception:
                # If start_new_session fails, don't use it
                pass

        proc = subprocess.Popen(cmd, **kwargs)
        self.processes.append(proc)

        try:
            stdout, stderr = proc.communicate(timeout=timeout)
            completed_process = subprocess.CompletedProcess(
                cmd, proc.returncode, stdout, stderr
            )

            # Handle 'check' parameter like subprocess.run
            if check and proc.returncode != 0:
                raise subprocess.CalledProcessError(
                    proc.returncode, cmd, stdout, stderr
                )

            return completed_process
        except subprocess.TimeoutExpired:
            proc.kill()
            proc.wait()  # Clean up zombie
            raise
        except KeyboardInterrupt:
            proc.kill()
            proc.wait()  # Clean up zombie
            raise
        finally:
            # Remove from tracking list when done
            if proc in self.processes:
                self.processes.remove(proc)


@contextmanager
def managed_subprocess():
    """Context manager for subprocess calls with interrupt handling."""
    with ProcessManager() as pm:

        def run_cmd(cmd, **kwargs):
            return pm.run_subprocess(cmd, **kwargs)

        yield run_cmd, pm
