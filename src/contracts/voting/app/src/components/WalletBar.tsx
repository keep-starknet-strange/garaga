import NetworkSelector from "@/components/NetworkSelector";
import WalletConnector from "@/components/WalletConnector";

export default function WalletBar() {
  return (
    <div>
      <NetworkSelector />
      <WalletConnector />
    </div>
  );
}
