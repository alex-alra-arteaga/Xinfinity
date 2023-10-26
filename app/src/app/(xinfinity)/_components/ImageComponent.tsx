import Image from "next/image";

interface ImageComponentProps {
  src1: string;
  alt1: string;
  src2: string;
  alt2: string;
}

const ImageComponent: React.FC<ImageComponentProps> = ({
  src1,
  alt1,
  src2,
  alt2,
}) => {
  return (
    <div className="round-lg relative flex items-center justify-center space-x-2">
      <div className="round-lg relative z-10 h-10 w-10">
        {" "}
        <Image
          src={src1}
          alt={alt1}
          layout="fill"
          objectFit="cover"
          className="rounded-lg"
        />
      </div>
      <div className="relative -left-6 z-0 h-10 w-10">
        {" "}
        <Image src={src2} alt={alt2} layout="fill" objectFit="cover"  />
      </div>
    </div>
  );
};

export default ImageComponent;
