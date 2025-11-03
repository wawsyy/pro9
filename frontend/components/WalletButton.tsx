"use client";

import { ConnectButton } from "@rainbow-me/rainbowkit";

// Wallet connection button component
export function WalletButton() {
  return (
    <ConnectButton
      showBalance={false}
      accountStatus={{
        largeScreen: "address",
        smallScreen: "avatar",
      }}
    />
  );
}

