import * as crypto from "node:crypto";


export function hashPassword(password: string): string {
    const passwordSalt = crypto.randomBytes(16).toString("hex");

    const passwordHash = crypto.pbkdf2Sync(password, passwordSalt,
        1000, 64, `sha512`).toString(`hex`);

    return `${passwordSalt}$${passwordHash}`;
}

export function validatePassword(password: string, hash: string): boolean {
    const [passwordSalt, passwordHash] = hash.split("$");
    const givenHash = crypto.pbkdf2Sync(password,
    passwordSalt, 1000, 64, `sha512`).toString(`hex`);
    return passwordHash === givenHash;
}