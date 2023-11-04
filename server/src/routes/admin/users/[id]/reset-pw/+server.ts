import { User } from "$lib/db/entities";
import { Role } from "$lib/db/role";
import { redirect, type RequestHandler } from "@sveltejs/kit";

export const POST: RequestHandler = async ({ locals, request }) => {
    if (!locals.user || locals.user.role !== Role.SUPER_ADMIN) {
        throw redirect(303, "/login")
    }

    const userId = await request.text();
    const user = await locals.em.findOneOrFail(User, { id: parseInt(userId) });

    const token = encodeURIComponent(crypto.getRandomValues(new Uint8Array(32)).join(""))
    const link = `/reset-pw?token=${token}&user=${locals.user.id}`;

    locals.em.assign(user, {
        resetToken: token,
        resetTokenExpires: new Date(Date.now() + 1000 * 60 * 60 * 24)
    });

    await locals.em.persistAndFlush(user);

    return new Response(JSON.stringify({ link }));
}
