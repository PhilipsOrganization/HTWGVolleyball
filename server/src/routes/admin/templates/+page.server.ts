import { Role } from '$lib/db/role';
import { fail, redirect } from '@sveltejs/kit';
import type { Actions, PageServerLoad } from './$types';
import { accounts, courseTemplateTable, groups } from '$lib/db/schema';
import { z } from 'zod';
import { eq } from 'drizzle-orm';
import { hydrateCourseTemplate } from '$lib/helpers/courseTemplate';
import { serializeUser } from '$lib/helpers/account';

export const load: PageServerLoad = async ({ locals }) => {
	if (!locals.user || locals.user.role === Role.USER) {
		redirect(303, '/courses');
	}

	const g = await locals.db.select().from(groups).orderBy(groups.name);
	const courseTemplates = await locals.db
		.select()
		.from(courseTemplateTable)
		.leftJoin(groups, eq(courseTemplateTable.groupId, groups.id))
		.leftJoin(accounts, eq(courseTemplateTable.trainer, accounts.id))
		.orderBy(courseTemplateTable.day, courseTemplateTable.time);

	return {
		groups: g,
		courseTemplates: courseTemplates.map(({ course_template, groups, accounts }) =>
			hydrateCourseTemplate(course_template, groups, accounts)
		),
		globalUser: serializeUser(locals.user)
	};
};

const templateValidation = z.object({
	name: z.string().min(3).max(100),
	location: z.string().min(3).max(100),
	time: z
		.string()
		.length('HH:MM'.length)
		.regex(/^\d\d:\d\d$/),
	maxParticipants: z.coerce.number().min(1).max(50),
	publishDay: z.coerce.number().int().min(0).max(6),
	publishHour: z.coerce.number().int().min(0).max(23),
	day: z.coerce.number().int().min(0).max(6),
	maxStrikes: z.coerce.number().int().min(0).max(100).default(0),
	allowDoubleBookings: z.coerce
		.string()
		.default('off')
		.transform((v) => v === 'on'),
	autoCreate: z.coerce
		.string()
		.default('off')
		.transform((v) => v === 'on'),
	groupId: z.coerce.number().optional()
});

export const actions: Actions = {
	create: async ({ locals, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const form = await request.formData();
		const dto = templateValidation.safeParse(Object.fromEntries(form.entries()));

		if (!dto.success) {
			return {
				status: 400,
				body: { errors: dto.error.errors }
			};
		}

		const template = dto.data;

		if (template.groupId) {
			const [g] = await locals.db.select().from(groups).where(eq(groups.id, template.groupId)).limit(1);

			if (!g) {
				return fail(400, { groupId: 'Group not found' });
			}
		} else {
			template.groupId = undefined;
		}

		await locals.db.insert(courseTemplateTable).values({ ...template, trainer: template.autoCreate ? locals.user.id : null });
	},
	assign: async ({ locals, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const form = await request.formData();
		const courseId = parseInt(form.get('templateId') as string);

		const [template] = await locals.db.select().from(courseTemplateTable).where(eq(courseTemplateTable.id, courseId)).limit(1);

		if (!template) {
			return fail(400, { courseId: 'Course not found' });
		}

		await locals.db.update(courseTemplateTable).set({ trainer: locals.user.id }).where(eq(courseTemplateTable.id, courseId));
	},
	delete: async ({ locals, request }) => {
		if (!locals.user || locals.user.role === Role.USER) {
			redirect(303, '/login');
		}

		const form = await request.formData();
		const courseId = parseInt(form.get('templateId') as string);

		await locals.db.delete(courseTemplateTable).where(eq(courseTemplateTable.id, courseId));
	}
};
