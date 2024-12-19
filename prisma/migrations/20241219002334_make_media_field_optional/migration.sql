-- DropForeignKey
ALTER TABLE "Answer" DROP CONSTRAINT "Answer_mediaId_fkey";

-- AlterTable
ALTER TABLE "Answer" ALTER COLUMN "mediaId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Answer" ADD CONSTRAINT "Answer_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES "Media"("id") ON DELETE SET NULL ON UPDATE CASCADE;
