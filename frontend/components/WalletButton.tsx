"use client";

import { ConnectButton } from "@rainbow-me/rainbowkit";
// 2025-11-16 12:33 - Code update

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

