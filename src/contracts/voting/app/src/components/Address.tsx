import { Button } from "@nextui-org/button";
import { Chip } from "@nextui-org/chip";
import { Link } from "@nextui-org/link";
import { useExplorer } from '@starknet-react/core';

import { CopyIcon } from '@/components/icons';
import { LinkIcon } from '@/components/icons';
import { brief } from '@/lib';

export default function Address({ address }: { address: string }) {
  const explorer = useExplorer();

  const url = explorer.contract(address);

  function copyAddressToClipboard() {
    // TODO implement copy to clipboard
  };

  const copyButton = (
    <Button
      isIconOnly
      size="sm"
      variant="light"
      onPress={copyAddressToClipboard}
      >
      <CopyIcon size={16} />
    </Button>
  );

  return (
    <Chip
      size="md"
      radius="sm"
      //endContent={copyButton}
      >
      <Link
        isExternal
        color="foreground"
        aria-label={address}
        href={url}
        >
        {brief(address, 6, 4)}&nbsp;<LinkIcon />
      </Link>
    </Chip>
  );
}
