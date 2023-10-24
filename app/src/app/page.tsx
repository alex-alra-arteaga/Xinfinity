import { getPosts } from "@/modules/posts/services/postCrud";
import Landing from "@/components/Landing";

export default async function Home() {
  return (
    <>
      <Landing />
    </>
  );
}
