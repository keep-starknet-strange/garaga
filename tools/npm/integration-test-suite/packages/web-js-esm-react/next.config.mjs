import { fileURLToPath } from 'node:url';

/** @type {import('next').NextConfig} */
const nextConfig = {
  turbopack: {
    // The conformance helper reads the shared Python proof fixtures.
    root: fileURLToPath(new URL('../../../../../', import.meta.url)),
  },
};

export default nextConfig;
