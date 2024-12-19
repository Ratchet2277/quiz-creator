import {$Enums, Language, PrismaClient, Question, Quiz, User} from "@prisma/client";
import {randomInt, randomUUID} from "node:crypto";
import * as Password from '@/services/PasswordService'
import AnswerType = $Enums.AnswerType;

const prisma = new PrismaClient();

async function main() {
    await seedUser()
    await seedQuiz()
}


async function seedUser(): Promise<User> {
    const uuid = "2e62af19-ca34-49ae-8135-91a88576ac6a"

    const [hash, salt] = Password.hashPassword("ThisIsATerriblePassword")

    return prisma.user.upsert({
        where: {id: uuid},
        update: {},
        create: {
            id: uuid,
            name: "Jérémy",
            email: "quiz@jeremy-saudemont.fr",
            passwordHash: hash,
            passwordSalt: salt,
        }
    })
}


async function seedQuiz(): Promise<void> {
    const uuid = "e5790d14-feed-46e8-b2e3-9ac27dc013a4"

    if (await prisma.quiz.findFirst({where: {id: uuid}})) {
        return
    }
    const quiz = prisma.quiz.create({
        data: {
            id: uuid,
            name: "Lorem Quiz",
            lang: Language.FR,
            userId: (await prisma.user.findFirst({where: {}}))?.id || ""
        }
    })

    await seedQuestions(5, await quiz)
}

async function seedQuestions(number: number, quiz: Quiz): Promise<void> {
    for (let i = 0; i < number; i++) {
        const question = await prisma.question.create({
            data: {
                id: randomUUID(),
                answerType: AnswerType.MULTIPLE_CHOICE_UNIQUE,
                quizId: quiz.id,
                text: `Question ${i}`
            }
        });

        await seedAnswer(4, question)
    }
}

async function seedAnswer(number: number, question: Question): Promise<void> {
    const goodAnswer = randomInt(0, number - 1);
    const promises = []
    for (let i = 0; i < number; i++) {
        promises.push(prisma.answer.create({
            data: {
                id: randomUUID(),
                text: `Answer ${i}`,
                isTrue: i === goodAnswer,
                questionId: question.id,
                order: i
            }
        }));
    }
    await Promise.all(promises);
    return;
}

main().then(() => {
    console.log("Seeding done")
    process.exit(0)
}).catch((e) => {
    console.error(e)
    process.exit(1)
})