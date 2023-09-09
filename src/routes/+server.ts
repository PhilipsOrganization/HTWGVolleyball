import { Course } from '$lib/db/entities/course.js';
import type { RequestHandler } from './$types';

export const POST: RequestHandler = async ({ locals, request }) => {
    const form = await request.formData()
    const data = Object.fromEntries(form)
    const post = new Course();

    post.title = data.title as string;

    await locals.em.persistAndFlush(post);
    return new Response(JSON.stringify(post.toJSON()));
}