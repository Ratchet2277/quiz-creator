/*
  Warnings:

  - You are about to drop the column `awnserType` on the `Question` table. All the data in the column will be lost.
  - You are about to drop the column `i18nId` on the `Question` table. All the data in the column will be lost.
  - You are about to drop the `Awnser` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `I18n` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `answerType` to the `Question` table without a default value. This is not possible if the table is not empty.
  - Added the required column `quizId` to the `Question` table without a default value. This is not possible if the table is not empty.
  - Added the required column `text` to the `Question` table without a default value. This is not possible if the table is not empty.
  - Added the required column `lang` to the `Quiz` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userId` to the `Quiz` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "AnswerType" AS ENUM ('MULTIPLE_CHOICE', 'MULTIPLE_CHOICE_UNIQUE', 'FREE_TEXT');

-- DropForeignKey
ALTER TABLE "Awnser" DROP CONSTRAINT "Awnser_i18nId_fkey";

-- DropForeignKey
ALTER TABLE "Awnser" DROP CONSTRAINT "Awnser_mediaId_fkey";

-- DropForeignKey
ALTER TABLE "Question" DROP CONSTRAINT "Question_i18nId_fkey";

-- DropForeignKey
ALTER TABLE "Question" DROP CONSTRAINT "Question_mediaId_fkey";

-- DropForeignKey
ALTER TABLE "Question" DROP CONSTRAINT "Question_userId_fkey";

-- AlterTable
ALTER TABLE "Question" DROP COLUMN "awnserType",
DROP COLUMN "i18nId",
ADD COLUMN     "answerType" "AnswerType" NOT NULL,
ADD COLUMN     "quizId" TEXT NOT NULL,
ADD COLUMN     "text" TEXT NOT NULL,
ALTER COLUMN "userId" DROP NOT NULL,
ALTER COLUMN "mediaId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Quiz" ADD COLUMN     "lang" "Language" NOT NULL,
ADD COLUMN     "userId" TEXT NOT NULL;

-- DropTable
DROP TABLE "Awnser";

-- DropTable
DROP TABLE "I18n";

-- DropEnum
DROP TYPE "AwnserType";

-- CreateTable
CREATE TABLE "Answer" (
    "id" TEXT NOT NULL,
    "order" INTEGER NOT NULL,
    "text" TEXT NOT NULL,
    "mediaId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "isTrue" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Answer_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Quiz" ADD CONSTRAINT "Quiz_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Question" ADD CONSTRAINT "Question_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES "Media"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Question" ADD CONSTRAINT "Question_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Question" ADD CONSTRAINT "Question_quizId_fkey" FOREIGN KEY ("quizId") REFERENCES "Quiz"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Answer" ADD CONSTRAINT "Answer_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES "Media"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Answer" ADD CONSTRAINT "Answer_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "Question"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
