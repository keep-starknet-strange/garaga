export type SiteConfig = typeof siteConfig;

export const siteConfig = {
  name: "Next.js + NextUI",
  description: "Make beautiful websites regardless of your design experience.",
  navItems: [
    {
      label: "Home",
      href: "/",
    },
    {
      label: "Sample App",
      href: "/polls",
    },
  ],
  navMenuItems: [
    {
      label: "Home",
      href: "/",
    },
    {
      label: "Sample App",
      href: "/polls",
    },
  ],
  links: {
    github: "https://github.com/keep-starknet-strange/garaga",
    telegram: "https://t.me/GaragaPairingCairo",
    docs: "https://garaga.gitbook.io/",
    sponsor: "https://app.onlydust.com/p/garaga",
  },
};
