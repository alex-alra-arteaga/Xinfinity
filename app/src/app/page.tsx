import { getPosts } from "@/modules/posts/services/postCrud";

export default async function Home() {
  const posts = await getPosts({
    limit: 10,
    page: 0,
  });

  return (
    <div className="h-[80vh] pt-[100px]">
      <p>Main Page</p>
      {posts.map((post) => (
        <div>
          <h2 className="text-black">Titulo del post: {post.title}</h2>
          <p>{post.content}</p>
        </div>
      ))}
    </div>
  );
}
