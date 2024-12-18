export function brief(value: string, prefix = 6, suffix = 4): string {
  if (value.length <= prefix + 3 + suffix) return value;
  return value.slice(0, prefix) + '...' + value.slice(-suffix);
}

export function unixTimeISO(time: number): string {
  return new Date(time * 1000).toISOString();
}

export function unixTimeRelative(time: number): string {
  const now = Math.floor(Date.now() / 1000);
  const seconds = time - now;
  const weeks = Math.round(seconds / (7 * 24 * 60 * 60));
  const days = Math.round(seconds / (24 * 60 * 60));
  const hours = Math.round(seconds / (60 * 60));
  const minutes = Math.round(seconds / 60);
  if (weeks < -1) return `${-weeks} weeks ago`;
  if (weeks === -1) return `last week`;
  if (weeks === 1) return `next week`;
  if (weeks > 1) return `in ${weeks} weeks`;
  if (days < -1) return `${-days} days ago`;
  if (days === -1) return `yesterday`;
  if (days === 1) return `tomorrow`;
  if (days > 1) return `in ${days} days`;
  if (hours < 0) return `${-hours}h ago`;
  if (hours > 0) return `in ${hours}h`;
  if (minutes < 0) return `${-minutes}m ago`;
  if (minutes > 0) return `in ${minutes}m`;
  if (seconds < 0) return `${-seconds}s ago`;
  if (seconds > 0) return `in ${seconds}s`;
  return 'now';
}
