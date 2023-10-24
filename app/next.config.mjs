import "./src/env.mjs";
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    serverActions: true,
  },
  output: "standalone",
};
export default nextConfig;
