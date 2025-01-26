--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0 (Debian 16.0-1.pgdg120+1)
-- Dumped by pg_dump version 16.0 (Debian 16.0-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

------------------------------------------------------
-- start of custom script

-- Connect to the database
\c volleyball

-- Drop existing tables and sequences if they exist
DROP TABLE IF EXISTS public.accounts CASCADE;
DROP SEQUENCE IF EXISTS public.accounts_id_seq CASCADE;
DROP TABLE IF EXISTS public.course_spots CASCADE;
DROP SEQUENCE IF EXISTS public.course_spots_id_seq CASCADE;
DROP TABLE IF EXISTS public.courses CASCADE;
DROP SEQUENCE IF EXISTS public.courses_id_seq CASCADE;
DROP TABLE IF EXISTS public.mikro_orm_migrations CASCADE;
DROP SEQUENCE IF EXISTS public.mikro_orm_migrations_id_seq CASCADE;

CREATE DATABASE "volleyball" WITH OWNER "postgres" ENCODING 'UTF8' TEMPLATE template0;

-- end of custom script
------------------------------------------------------

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255),
    session_token character varying(255),
    role character varying(255) DEFAULT 'user'::character varying NOT NULL,
    strikes integer DEFAULT 0 NOT NULL,
    notes character varying(255),
    subscription_endpoint character varying(255),
    subscription_expiration_time character varying(255),
    subscription_p256dh character varying(255),
    subscription_auth character varying(255),
    created_at timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reset_token character varying(255),
    reset_token_expires timestamp(0) with time zone,
    last_login timestamp(0) with time zone,
    email_verification_token character varying(255),
    email_verified boolean DEFAULT false NOT NULL
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accounts_id_seq OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: course_spots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_spots (
    course_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp(0) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.course_spots OWNER TO postgres;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    date timestamp(3) with time zone NOT NULL,
    publish_on timestamp(3) with time zone NOT NULL,
    max_participants integer NOT NULL,
    location character varying(255) NOT NULL,
    "time" character varying(255) NOT NULL,
    created_at timestamp(0) with time zone NOT NULL,
    updated_at timestamp(0) with time zone NOT NULL,
    notification_sent boolean DEFAULT false NOT NULL
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.courses_id_seq OWNER TO postgres;

--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO postgres;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNER TO postgres;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (id, username, email, password, session_token, role, strikes, notes, subscription_endpoint, subscription_expiration_time, subscription_p256dh, subscription_auth, created_at, reset_token, reset_token_expires, last_login, email_verification_token, email_verified) FROM stdin;
45	Jannik Frank	jannikfrank88@gmail.com	\N	11128221172152101521161361686947245641883118712060201149517125105127134239132167219110	user	1	\N	\N	\N	\N	\N	2023-11-19 17:00:01+00	\N	\N	2024-09-29 20:24:20+00	\N	t
39	Louis Wegner	louis.wegner@yahoo.de	$2b$10$4z6ZzUx/B14i6INvMqE7XeNP/vnk99cRCOaQseEwxCAxtQB/ijDsG	24101601086499134148331301125625411023021913652161901655125142202181111851118196165	user	1	\N	\N	\N	\N	\N	2023-11-19 11:30:23+00	\N	\N	2024-09-30 13:38:39+00	\N	t
21	Medard Mario	medardmario3@gmail.com	\N	15828751128125225189923716824024513815211422591203175164131144671371351161374662182217	user	0	\N	\N	\N	\N	\N	2023-11-18 11:54:12+00	\N	\N	2024-10-03 10:00:49+00	\N	t
23	Bhargav Solanki	sbhargavsinh@gmail.com	$2b$10$H158GSryjEPuUDOs6OH/qeG286T2.dc/hwFO7ntiZPM2t/0skrrHm	2521474512317619883910911619720211875112244441764419871081356280761281021722925100	admin	0	Smooth Operator	\N	\N	\N	\N	2023-11-18 12:01:01+00	\N	\N	2024-10-03 17:48:20+00	\N	t
53	Erik Riefer	erik.riefer@htwg-konstanz.de	$2b$10$kGiMxxvt5jKt.uKcDP8loOA0Q.ev1fC9wmSHkt9Mf170MWEq1gOca	5zxk4h2kw5xvapbc45wmw	user	0	\N	\N	\N	\N	\N	2023-11-20 08:24:32+00	\N	\N	2024-03-02 13:55:13+00	\N	t
212	Patrycja Gromowska	patrycja.gromowska@wp.pl	$2b$10$Z2WW6setocyZ4m6J6CZXhuaqcGcZgciejPRjcx7/gWTVGuGAfM7Li	i7lrgbybzqdpi0t2ealrvq	user	0	\N	\N	\N	\N	\N	2024-01-06 17:24:33+00	\N	\N	2024-01-11 16:15:36+00	\N	t
196	Reni Lewandowski	rlewandowski120@gmail.com	$2b$10$BqV1CYCm2xQG4cum7YuEPu2vTIlOw.l9FgcuP0KT/Hufi8BCDzzEO	z78a0p73w6zvt9z8qphjd	user	0	\N	\N	\N	\N	\N	2023-12-13 09:25:46+00	\N	\N	2024-04-30 12:05:08+00	\N	t
193	Daniel Korobko	daniel.d.korobko@gmx.de	$2b$10$s1OzK/U/p30qusXnK.OysO8sC.thUvCY/IhrvukN8O.62E2.JmZKS	8925213878522619717512916123516212131664837252240862501981405726185261714869177238	user	1	\N	\N	\N	\N	\N	2023-12-11 10:39:11+00	\N	\N	2024-10-03 18:47:45+00	\N	t
198	Leonie Manno	mannoleonie@gmail.com	$2b$10$e25pKOO0vQbCoEjvVpuTfuwtc0gjMIJBYbsPp5kWofso81EQoMg26	xpck4iznfwdvnmalckgxoe	user	0	\N	\N	\N	\N	\N	2023-12-14 11:06:41+00	\N	\N	2024-01-19 14:22:51+00	\N	t
29	Florian Deguen	fdeguen@gmail.com	$2b$10$gay8517UB53XLhL5NiiezOEkOQoEBK6/BdYu72YmAQZXkv0WnvheC	t0mrm89cp2dn4c5uwoy9ym	user	0	\N	\N	\N	\N	\N	2023-11-18 18:51:51+00	\N	\N	2024-03-18 11:24:35+00	\N	t
14	Mathea Brückner	mathea.brueckner@gmx.de	$2b$10$9NVngL.hIxexiDfpQhKFhu4wS6SaBI1AiKL3lVmc.nBcTsmGFMbCq	668478445961251724924517923317122237145207140731581701061011564341781046823015863	admin	0	\N	\N	\N	\N	\N	2023-11-16 20:37:48+00	\N	\N	2024-09-12 10:59:16+00	\N	t
233	Sahin Karakoc	sa431kar@htwg-konstanz.de	$2b$10$cJGLaEkyOw8GPdQXq5UatuSDQ5CCXQY9A24HYXSiaZ5aCi4M67bj.	96791579021622629176215161140183198521516017313218105256881316940751281253918446	user	0	\N	\N	\N	\N	\N	2024-01-25 10:59:44+00	\N	\N	2024-09-12 11:13:10+00	\N	t
229	Fiona Sofie Hartges	fiona@hartges.de	$2b$10$29zMu6hTTd6c8/iWTgSMeuFNG6zoQ03QRIyskWgl68mnbAt9GHmTq	492idrqmpf5re4u9y4aohf	user	0	\N	\N	\N	\N	\N	2024-01-20 14:53:30+00	\N	\N	2024-01-20 14:55:18+00	\N	t
41	Katja Kummer	k.k2503@yahoo.de	$2b$10$QtOlLq25CAkgMM4qjvTY8.40bBjE78OVCPAO.OWZvufPII0IQ05My	8471775925416614173202164188189971811472451221851901371041951023717717011221324723832141	user	0	\N	\N	\N	\N	\N	2023-11-19 12:59:57+00	\N	\N	2024-10-07 15:58:02+00	\N	t
20	Leander Strobel	lele123463@gmail.com	$2b$10$fMBfxMDbwrd9jTP7ZhIRzez1GoMfy/VduOrq4DjJhTUDqtQneeflS	n7dinxhq9e9frw56mpm9p5	user	0	\N	\N	\N	\N	\N	2023-11-18 11:33:37+00	\N	\N	2024-04-21 17:39:27+00	\N	t
26	Lewis Richter	lewis.g.richter@googlemail.com	$2b$10$ThhQAK..nDQ0dmqmgx6hgen3.iJ51WFLe3E.k0NNUHsfoTPjnka0i	19114021461244264972061622551631690252911414919610847163216582102291792112324568163	user	0	\N	\N	\N	\N	\N	2023-11-18 16:11:49+00	\N	\N	2024-07-22 18:10:14+00	\N	t
35	Mirjam Gröger	mirjam.groeger@posteo.de	$2b$10$p7EZ1Lt77QUfZXsXN4GSW.nJyPtdOwTnp02qM44k4GBaWvkv75xAK	177771244416617620024464832232528323421122106185174361184121237452273239167230100103	user	0	\N	\N	\N	\N	\N	2023-11-19 07:12:14+00	\N	\N	2024-10-11 06:09:18+00	\N	t
109	Janis Baur	modjfy@gmail.com	\N	m9e6k6nnu16s375224edu	user	0	\N	https://fcm.googleapis.com/fcm/send/cEGsTmmV4E0:APA91bEQmlIFi1Niu3LmxjVn3yQXGmAp_3TSVXptMUceitNviZJIrvRvTr5H-GTKeoFx8ln7PIACPrijhJtXoj2Pr47a38e49I3JZ_TXi1k1JUhkaUjG6IYbrPRAfH2qSLmbIOYwhMeq	\N	BL-g9Xzyv7zYcOso8r00MHeqHGqeOtTizb1ZOXAQKKIWazaAKJJ3PFdeM5kh36GHrev0tTW0KQ5rhZDR6k1Tgy0	1wcoTomCeIfTIOLNoqAA2A	2023-11-20 22:18:07+00	\N	\N	2023-11-24 19:09:09+00	\N	t
224	Adrian Ruhe	adrian.ruhe@gmail.com	$2b$10$0gC5aQSXlBt2qgyFJoZWn.TT1QeW83RGKQjPnZcYgL8oimv4yGLwG	u96jjnv020hc0z96r1u3x	user	0	\N	\N	\N	\N	\N	2024-01-18 12:06:51+00	\N	\N	2024-02-05 14:56:00+00	\N	t
42	Marc Weiss	marcweiss1012@outlook.de	$2b$10$x5nl4P61zd9olNrsQfpb9./5yviNtT0RAoDM8YhlV93cDDFnZOQtC	yo1aa38zh4geht8dqj3t4	user	0	\N	\N	\N	\N	\N	2023-11-19 13:02:43+00	\N	\N	2023-11-24 19:48:04+00	\N	t
128	Vamsi Ganti	2003vamsi.krishna@gmail.com	$2b$10$5FoYQb9fxD3v3QBt0yJ2UeG0EAInt5haLRWrLQbr31ijoscdoA5fm	18867361792481251074152314714611212413828140102186240922304871870261311671086148	user	1	\N	\N	\N	\N	\N	2023-11-23 14:11:00+00	\N	\N	2024-09-04 15:03:00+00	\N	t
349	Katja	katjakummer98@gmail.com	\N	5715811972282272186951152182241291152441813425226103135862007219720473131144218124148	user	0		\N	\N	\N	\N	2024-05-31 07:50:38+00	\N	\N	2024-05-31 07:50:38+00	198227572232342412121813094882281082236941189818714611016719141249147821602258726	f
54	Serafin Engels	serafinengels@gmx.de	$2b$10$go3XDS/SrTwWo2.IBH/.neynujCVfZq5S4Q1CkRkw6dLx9F9YjqQq	t5l7crctyzf7dyidwobbvs	user	1	\N	\N	\N	\N	\N	2023-11-20 08:37:57+00	\N	\N	2024-02-20 14:13:46+00	\N	t
167	Linus Daerr	linusdaerr0504@gmail.com	$2b$10$VIGmwZGCI6zT3JOkxpfih.3iS0zFqHDHHi7LrvSai8bNF955.bIrW	11oidcgn98bcfi6k5i9mpk	user	0	\N	\N	\N	\N	\N	2023-12-01 16:16:59+00	\N	\N	2023-12-01 18:21:33+00	\N	t
34	Markus Hanna	hanna.markus@gmx.de	$2b$10$4mtZk.Kr8VXcAMWb6S8DzOI9Jbp90WgvrxDRKDO9nPOO.CIg5ApI2	256412120173207487016495122732541091512555779180186154207215125212951391523189160254	user	0	\N	\N	\N	\N	\N	2023-11-19 00:13:23+00	\N	\N	2024-09-25 15:26:17+00	\N	t
36	Lea-Sophie Frings	lea-sophie.frings@gmx.de	$2b$10$evSBoM1OGudQ7cDHJ8zxK.DHq1J7E0/fRcUGQIFmjrdYsuDlQ4K6q	hfcp78mqvpqjtio9jwcyao	user	0	\N	\N	\N	\N	\N	2023-11-19 09:26:04+00	\N	\N	2023-11-19 09:26:22+00	\N	t
313	Emily Zhang	2663252630@qq.com	$2b$10$pEikXGTrntU/eSAqvFmz/u4sGrHoe1QrPaYiwtA3HJq23Ypm225bS	t5jm3dq4wpa4bna0q3b8c	user	2	\N	\N	\N	\N	\N	2024-04-17 17:15:50+00	\N	\N	2024-05-15 18:48:15+00	\N	t
25	Elisa Dervishi	elisadervishi8@gmail.com	\N	q8dbzciu74a9lmfggzmxfs	user	0	\N	\N	\N	\N	\N	2023-11-18 16:09:40+00	\N	\N	2023-11-18 16:09:40+00	\N	t
145	Marius Härterich	haerterich.marius@gmail.com	\N	x2ge4dmpipfw17vu55gxq	user	0	\N	\N	\N	\N	\N	2023-11-25 07:50:49+00	\N	\N	2024-05-02 14:00:10+00	\N	t
161	Ella Klenge	ellaklenge@icloud.com	$2b$10$pI7FG.9EuRVwZrw97O.1F.OJGHaDGm5lcbPRJP3uNprtX0l8FFv7O	no67zpdegqaotz9ag4tov	user	0	\N	\N	\N	\N	\N	2023-11-30 11:11:30+00	\N	\N	2023-12-07 09:24:20+00	\N	t
292	Emelie Eggen	emelie-eggen@gmx.de	$2b$10$fUIb.SeFD88tdRFrx2ldfOT.hdFHZvh5yRDM8bgI17qJIQGDkxNum	vmzoi74qttphiqgsqmtl67	user	0	\N	\N	\N	\N	\N	2024-04-01 16:21:06+00	\N	\N	2024-04-15 15:16:20+00	\N	t
33	Steffen Haas	steffen.haas@htwg-konstanz.de	$2b$10$S1raLRdf6cP.eDKsfXAG.OI5Z3uw7SPjqQ99INsK8erIQDs0uKYCG	l696hrb01oxal1myozbr8	user	0	\N	\N	\N	\N	\N	2023-11-18 20:17:52+00	\N	\N	2023-11-18 20:17:52+00	jog4qwqrnperz4vvv9xb8	f
122	Milena Dörre	milenadoerre@web.de	$2b$10$qSQuWCGzbfTBt6wUWnvBkOaLN8O0HJZf9HRihQtXVAaX.Vz2E7CRW	69fje48fux6i6f5qmouy6	user	0	\N	\N	\N	\N	\N	2023-11-23 11:36:23+00	\N	\N	2023-11-30 16:47:22+00	\N	t
199	Britta Hofmann	britta.hofmann@htwg-konstanz.de	$2b$10$7P1sUjt8nz0JDFrxvt9Ypu3CHIk2IYCE6V0DpPtMP9IilElIzzVn6	0d009bulnulkz8midcvi53	user	0	\N	\N	\N	\N	\N	2023-12-14 11:51:59+00	\N	\N	2023-12-14 11:52:33+00	\N	t
61	Nico Schnorrer	nicoschnorrer@gmail.com	\N	s8x9sjma48c7m0c3txhw39	user	0	\N	\N	\N	\N	\N	2023-11-20 09:30:23+00	\N	\N	2024-02-02 14:58:38+00	\N	t
242	Emil Nikolov	emilnikolovproject@gmail.com	$2b$10$i/VIUD6D84y9zClvQ.CXfOZcS.629x6MMGm/eAw16fHB1odxo7EH6	bnq4yzgqnvt0xoopaxolj	user	0	\N	\N	\N	\N	\N	2024-02-16 22:13:30+00	\N	\N	2024-02-16 22:13:30+00	i5hgl18o2lk3lviwmmyy	f
62	Hannah wrobo	hannah.wroblowski@uni-konstanz.de	$2b$10$AWxd8hhthd3QohY91uZW/Oh5Xc47zYnaxbtpQ9atU23KxoTA3fF4u	uul2f216mgh35wp4s2yq	user	0	\N	\N	\N	\N	\N	2023-11-20 09:46:37+00	\N	\N	2023-12-12 22:44:44+00	\N	t
234	Georgette Tugliani	gtuglianiq@gmail.com	$2b$10$eQCi6LiQ7DMSI3FDjK/AzObrhngTnYvK/6Wj.LWk38weGUUsCVPwS	yjh0qabl49i01kf5kdstce	user	0	\N	\N	\N	\N	\N	2024-01-25 20:06:07+00	\N	\N	2024-01-25 20:19:28+00	\N	t
378	Abdul-Karym Ismail	abdul-karym.ismail@student.uni-siegen.de	$2b$10$4pqJ.n2B.4f3Yk/T3iE1..IEtTszxH1RJDnBxReaO7sK8tPcGdE/a	166411988021910158901312131805290131222106571161151136363441219820715981192223	user	0	\N	\N	\N	\N	\N	2024-08-10 06:31:25+00	\N	\N	\N	14310590190137153240251359234956114216326871516592442313919236807019118818525524	t
256	Leonie Streibl	leonie.streibl@uni-konstanz.de	$2b$10$tt3X5lSxQKAbx3muqt4s3uzIXP9bBqmy7rWoTLYMbYy27NG0hNcw2	rxhqavowxpsqqsnh4dwp	user	0	\N	\N	\N	\N	\N	2024-02-28 15:02:46+00	\N	\N	2024-02-28 15:03:05+00	\N	t
49	Caroline Zirk	caroline-zirk@web.de	$2b$10$w/l/IguHYbHRacQVBMYC5edMW/4dxMHeE9nZi7T1ZNIbZt./LSNWK	143672211091725122437136765499617917117109665422322314612717601932252392011158125	user	0	\N	\N	\N	\N	\N	2023-11-19 22:40:13+00	\N	\N	2024-07-08 14:18:26+00	\N	t
162	Samuel Henle	samuel.neuffen@web.de	$2b$10$m9qnM9NbZKVVWdtAusk/pOZbumf7NHjhICmkuokGtHH1HsQfwiJGS	4rk5xetaea79xuv7tun0jj	user	0	\N	\N	\N	\N	\N	2023-11-30 12:04:03+00	\N	\N	2023-12-06 08:27:36+00	\N	t
79	Zeus Mora	zeus.mora@gmail.com	$2b$10$6bGW1owrc.ngpBCEWuZ.CeG6G8lDFb0jibvmwxfgowTH45cZKYKv2	2242118017521211665137112103192159871392031671441362151255461141382105014623012318082105	user	0	\N	\N	\N	\N	\N	2023-11-20 13:02:28+00	\N	\N	2024-09-12 11:33:33+00	\N	t
71	Samuel Behrmann	samuel.behrmann@yahoo.de	$2b$10$Md/l3F/uYAKJNikKA0YSSOPmnfdUgndSxugY.ZdA2UxWgx3Jhn5i6	iy00p70voaaytlpkvl5rpg	user	0	\N	\N	\N	\N	\N	2023-11-20 13:00:40+00	\N	\N	2024-01-27 07:26:21+00	\N	t
65	Alina Hartung	ja.hartung@hotmail.com	$2b$10$fsAGA6mvfOdlYOL6TwV.nux7vA5zOytkPUc.L/f2kuP0e.HLv5tju	qfcrw5hcq7g578p0g8c4yv	user	0	\N	\N	\N	\N	\N	2023-11-20 11:16:41+00	\N	\N	2023-11-22 13:10:35+00	\N	t
110	Leon Beil	leonbeil@hotmail.de	$2b$10$Llgas0jSnsspa2oDuhiZIOainLMkdNbgbkwT0GE4ZmhWUggHcHjei	17621012913411788242231656814622619610572407912951197784611412969159134222204393	user	0	\N	\N	\N	\N	\N	2023-11-21 07:56:29+00	\N	\N	2024-09-13 16:25:31+00	\N	t
165	Ahmad Varasteh	varasteh@ugd.ai	\N	l74fcymewlrqqzebi9y9v	user	0	\N	\N	\N	\N	\N	2023-11-30 16:21:11+00	\N	\N	2024-03-14 18:17:48+00	\N	t
60	Silvan Schlag	silvan.schlag@uni-konstanz.de	$2b$10$ZwJN/uPXNJvk7X4PvhPFfO2FQCbhEusgW3Jf9F0GlXvKhdXK5/0NW	u9dzuqrw62e3sowz11zxo3	user	0	\N	\N	\N	\N	\N	2023-11-20 09:19:41+00	\N	\N	2023-11-20 09:20:25+00	\N	t
312	Jan Grimme	jan.grimme@htwg-konstanz.de	$2b$10$OJh1M8bO0cd.FAjYN.4NN.jMh54./1LpyhBd/rLqxdcoQBum3zC3u	5mq5969pq3eswxhsrbkpn	user	0	\N	\N	\N	\N	\N	2024-04-17 09:04:12+00	\N	\N	2024-05-15 18:23:18+00	\N	t
148	Ana Sanchez Acosta	anasanchezacosta@live.com	$2b$10$DYAM3P7xOiqE9mmlfg68gugY0uIDtiSt7o0yIBiJ84rrGtk2tI942	201142122718514232224242371404543252451999917011111321720215823811511455241256176154	user	0	\N	\N	\N	\N	\N	2023-11-26 11:18:39+00	\N	\N	2024-09-16 07:02:00+00	\N	t
217	Corinna Zürn	corinna.zuern@gmx.de	$2b$10$O2f6hVRilKR7GgPVP8A/dehtwREEvDtmNFpysm.FiIhpcLkBepuSa	dlpeahrqjif5u8zt1n2knu	user	0	\N	\N	\N	\N	\N	2024-01-11 13:43:35+00	\N	\N	2024-01-14 18:41:34+00	\N	t
57	Elena Dangmann	edangmann@gmail.com	\N	101205180191571353773915193222771362288021220316981128521412472301611091674012422581	user	1	\N	\N	\N	\N	\N	2023-11-20 08:49:57+00	\N	\N	2024-07-17 13:23:32+00	\N	t
75	Tobias Koppmann	t.eisure@web.de	$2b$10$mDC7Yqb2gi45N1ku5swmD.zPeO5EIjh1y/HZo3Gqico1pK0YTgduO	zm44r6e74qrvnkmbnpvjro	user	0	\N	\N	\N	\N	\N	2023-11-20 13:01:30+00	\N	\N	2024-04-02 04:13:32+00	\N	t
48	Julia Keller	juliakristin17@gmx.de	$2b$10$kCtHqwKnyVtF/ijrnfF3G.Ro.1MYxtawDbsK3Wma0C5P/d6L/HawW	bdhbjmbtxstqsf9rtbbhmh	user	0	\N	\N	\N	\N	\N	2023-11-19 22:34:58+00	\N	\N	2023-11-21 11:53:25+00	\N	t
88	Jana Bareth	jana.kristin@t-online.de	$2b$10$Q48o0TZYh4e6/.FDBYXip.y1Xbo60b9o3kIrXVFE2t2BHI18l9Fju	5323719715912348112331289813811031156237272407129228177541233622213516757362376	user	0	\N	\N	\N	\N	\N	2023-11-20 13:19:35+00	\N	\N	2024-09-28 21:06:13+00	\N	t
114	Moritz fuchsloch	moritz-fuchsloch@gmx.de	$2b$10$FFEUNId6vJZMxc5Zmo5wFOwhW3QwgHciDGP9U0MrmCyAQQP0Q8yUO	qut1b2uulzh4cp0w1sdn	user	0	\N	\N	\N	\N	\N	2023-11-22 18:37:56+00	\N	\N	2024-02-22 12:29:14+00	\N	t
78	Emilia Ott	emiliaott123@gmail.com	$2b$10$O90MDVyZ0W6bWEcFoD4JiuWqZfr..aT3VgD2K0l4F1ctuvpIhs2mi	2442479713112515211920714624422217988752551448502501192362231911267017824625139	user	0	\N	\N	\N	\N	\N	2023-11-20 13:02:04+00	\N	\N	2024-10-14 12:11:34+00	\N	t
150	Kevin muller	kevin.rgmueller@gmail.com	$2b$10$AXPusOFEmL8pmXBoWEEn.ex7NvquiDH5EyzvhIE3M7idNAk2i/3TK	v23q0772f10mp7qhgo97x9	user	0	\N	\N	\N	\N	\N	2023-11-26 12:39:50+00	\N	\N	2024-02-24 05:59:33+00	42f8nho4hmn50hhtriwtpp	f
116	Patrick Lauer	patrick.lauer@uni-konstanz.de	$2b$10$GzOSQ40Qx7Yh.7odwb3jBuXgBNhSf0XnRzVA8TvjcBPbQr.yJupb2	uousyb7h1bfq89l1m0gq3	user	0	\N	\N	\N	\N	\N	2023-11-22 20:17:40+00	\N	\N	2024-02-01 11:03:13+00	\N	t
377	Marvin Pesch	marvin.peschka@uni-konstanz.de	$2b$10$Az/wPY8u2b2qyQY1.CZCauahpDRII4v2cwDjoymM.uwnfG82VU./C	1301537639171406619755106255724391681711161212366124225092229183128371356174162	user	0	\N	\N	\N	\N	\N	2024-07-24 08:04:27+00	\N	\N	\N	291986354100242810242362486225064119146376235167193661112301741756144204209163252	t
74	Hannes Briegel	johannes.briegel@aol.de	$2b$10$2AEZSwEi9razSb93IOLywuHyjFeUrzXAfL/Vlea6sYRAzmKaRQ852	zgn6tud0kvoz5tcoj30skq	user	0	\N	\N	\N	\N	\N	2023-11-20 13:01:20+00	\N	\N	2023-12-04 13:49:28+00	\N	t
164	Hannah Andree	h.e.a366@hotmail.com	$2b$10$97MJgcjF8iUx0mdrIBI6DeP2jVTR90JT8DcHQ.HmC2QaonFu3evlO	lkhbsj7qp77rx8b8b8l9v	user	0	\N	\N	\N	\N	\N	2023-11-30 15:32:56+00	\N	\N	2024-03-13 11:55:41+00	\N	t
56	Estelle Mauch	mauchestelle@gmail.com	$2b$10$cfYf3CQjGLm3IuRybs2ZSOwiIWkfV4JY1e7TGb1YuQnZ3PbmmZG6a	cny7mjl96np45j8712kw9	user	0	\N	\N	\N	\N	\N	2023-11-20 08:40:24+00	\N	\N	2024-03-14 11:00:42+00	\N	t
117	Felix Engelhard	felix200179@gmail.com	$2b$10$tfClRBvyZ5Du.py8xWtSa.KpmxsMiWhXJbv5NBPSF9k3Pk.863pUy	gs9cz3jskj4e8kygo6gqwq	user	0	\N	\N	\N	\N	\N	2023-11-22 21:34:20+00	\N	\N	2023-12-04 15:10:57+00	\N	t
81	Maya Dauner	emiliaott03@icloud.com	$2b$10$QGNVsm.JIeYNCPoUxIMuVOTb05rEOniJfoKP33cQijwzG.JlpnSxO	wh2rmpt5m7gwhlm4eqzt8	user	0	\N	\N	\N	\N	\N	2023-11-20 13:05:10+00	\N	\N	2023-11-27 10:32:53+00	\N	t
68	Leander Ferino	le-ferino@t-online.de	$2b$10$6HLCSxc5T/h7LOzU55GEGe1ZAWI5CaMBZuUhXuep9J8SJXAPnfRFS	yz1e045sm2rlovulcm9fl	user	0	\N	\N	\N	\N	\N	2023-11-20 12:00:47+00	\N	\N	2023-11-20 12:01:08+00	\N	t
152	milena ilka	milkadre@gmail.com	\N	sjnixz8aqy11pmp45ytfy	user	0	\N	\N	\N	\N	\N	2023-11-27 12:04:09+00	\N	\N	2023-11-27 12:04:09+00	\N	t
69	Marcio Illi	marcio_illi@web.de	$2b$10$BrFTgf.1Giis7Po4JygFJuXdjunNa9qfMtLjlqT.kEQfnoynO6IfC	cfj7qmwios8fje2h56jxue	user	0	\N	\N	\N	\N	\N	2023-11-20 12:56:20+00	\N	\N	2023-11-20 12:56:57+00	\N	t
98	Lilly Schneider	lilly.schneider@htwg-konstanz.de	$2b$10$krljpU5k8hbzoo.26yONF.REDxBMCFUMdpXugd9RlgDhZt6bLkuw6	e0dhcczwk19uyfrv5s813l	user	0	\N	\N	\N	\N	\N	2023-11-20 13:58:45+00	\N	\N	2023-12-11 12:14:28+00	\N	t
154	Max Osterloff	max.osterloff@gmail.com	$2b$10$dMYQyszmt9qGwxqk/vnp4u2V40Xu9WXd/wZb6X5z4qU0/bslmGm8m	h3r5v3ai559r12lkr82vy	user	0	\N	\N	\N	\N	\N	2023-11-27 17:09:48+00	\N	\N	2023-12-07 15:42:49+00	\N	t
442	Lisa Maria	lisa.franzi12@gmail.com	\N	194548325119823322481081491401892356112921325411170146221211168521011318183063195183	user	0		\N	\N	\N	\N	2024-10-03 15:35:43+00	\N	\N	2024-10-03 15:39:27+00	162252179765146167112011420319213441202413014531247421011670224205181246398620364	f
203	Jakob Sanowski	htwg-volleyball@tuxerator.anonaddy.com	$2b$10$o2xK7UCUBQHgN2sA65p81eg2Bj/kLtF3UX/JoSO/dbj.diy6jGAQG	1210431922077418023718100250162197562221761262501271572238992394391107219224196161114	user	0	\N	\N	\N	\N	\N	2023-12-17 16:24:10+00	\N	\N	2024-09-18 13:35:09+00	\N	t
58	Fritz Raupach	fritz.raupach@htwg-konstanz.de	$2b$10$j/BSaHQotudWcUePtLbOkeHhVsnUgiJDjzsLCsgWUVFSnChp6gjcC	701242134264112512157817262111546555113991324121321621319117111124215189381932579	user	0	\N	\N	\N	\N	\N	2023-11-20 08:56:13+00	\N	\N	2024-07-20 12:21:47+00	\N	t
225	isabelle kohl	isabelle.kohl@web.de	$2b$10$pCP9I7X8xPKiY0eKGVarTevdbZdr6kPRtUS50lSKYbXj4bOmMo1wm	tz1i41j2dqj98dcbgnigoc	user	0	\N	\N	\N	\N	\N	2024-01-18 12:20:46+00	\N	\N	2024-01-22 07:37:00+00	\N	t
104	Irina Heinz	irina.heinz@uni-konstanz.de	$2b$10$UCGIWYuvR71Sz0x.se6GtuI4oxMsU4aEbfndwRliAwa7rinMoXXqC	2ybt4qa4gsuik6r751cy9h	user	0	\N	\N	\N	\N	\N	2023-11-20 16:37:03+00	\N	\N	2024-04-17 13:39:52+00	\N	t
95	Linda Gebauer	familie.gebauer.lg@gmail.com	$2b$10$AaLr8mALCw3XYSw3GkE6buva5x9xPMhbS4JSiw50IvZ93sms/jLny	qyibnxycwjhqql0fzi5b	user	0	\N	\N	\N	\N	\N	2023-11-20 13:48:42+00	\N	\N	2024-01-12 18:16:37+00	\N	t
121	Luis Frieder Reinalter	luis.reinalter@gmail.com	$2b$10$tiw3fNHRJA538Ov70aPUM.YWyQOIJLcifuzmFgs98l1koleiOgAAu	2218614335735915778261751682464551782275871532292137911040151722019117610862219	user	0	\N	\N	\N	\N	\N	2023-11-23 11:09:54+00	\N	\N	2024-07-22 07:14:42+00	\N	t
107	Leandra Aeckerle	leandraaeckerle16@web.de	$2b$10$gaD6Z7qLhnahjaRLTdTHPOvYpvtZVLII/ZzgQokhop2iT3hgZpxIu	vnh9f4zviapesp8xsrsal	user	2	\N	\N	\N	\N	\N	2023-11-20 17:56:16+00	\N	\N	2024-05-08 16:46:51+00	\N	t
115	Marleen Landes	marleen.landes@htwg-konstanz.de	$2b$10$ZXRAqEm8mBZhxJL6kZmqGu2SSJ.40kuKd3xro0CqeB1KAqk1.V./.	sme4h1roopklvomxtmdu3	user	0	\N	\N	\N	\N	\N	2023-11-22 19:46:12+00	\N	\N	2024-02-24 00:51:36+00	\N	t
178	Julia Fix	hoch.trank0i@icloud.com	$2b$10$nOZsWzVZJStII6MDdjy96.nvvdgwis/mGiqKnw.s6uOJG0lyKuO.2	wp3e5h3jz9cm55ar1ycirc	user	0	\N	\N	\N	\N	\N	2023-12-06 11:29:27+00	\N	\N	2023-12-10 16:52:24+00	\N	t
147	Philip E	philip.ehret@gmail.com	\N	20724869441771382272178610695168547319714070436620589481621901714882227775115547	user	2	\N	\N	\N	\N	\N	2023-11-25 10:35:01+00	\N	\N	2024-10-04 14:14:33+00	\N	t
86	Andreas Hermann	4ndr34s01@gmail.com	$2b$10$v1CjR9EM81IMJC/GugJPsuVdgU1tbo0fyjARINcTRWOJibYSllvme	1535715417717423850164230120175239176104172988715341911871562208912249219182492486286	user	0	\N	\N	\N	\N	\N	2023-11-20 13:17:07+00	\N	\N	2024-09-23 15:38:56+00	\N	t
140	Nicolas Helm	nicolas.uwe@web.de	$2b$10$LAKAQelovCvbq6FpgtaC.OuXMK434m8ZvhnEuSks3X/pcaxBhtdwi	1562231802495124964824116311793418714168137161230236115176169111251231661032615888141	user	10	\N	\N	\N	\N	\N	2023-11-24 14:37:15+00	\N	\N	2024-10-09 05:11:51+00	\N	t
92	Jan Aminger	jan.aminger@htwg-konstanz.de	$2b$10$cngUEhICM3XGIu6sBAevBea6UH.npFHetjK9cjUer0.hqPXZ8qlSK	w8cg7dbs3i2c5gc2gmrar	user	0	\N	\N	\N	\N	\N	2023-11-20 13:42:59+00	\N	\N	2023-11-20 13:44:15+00	\N	t
155	Florentin Wöhrn	florentinwoehrn@gmail.com	$2b$10$fgvhcd6ThPbkZ3CyK6IlBuyh8UYzOIQMTyeE53UEoZ1NpglvvbuxK	4224113819920627171611401921601721451062011821391721381955022976169246248996716939160148	user	0	\N	\N	\N	\N	\N	2023-11-27 19:35:48+00	\N	\N	2024-10-09 16:17:18+00	\N	t
124	Hanna Burger	hanna.burge@uni-konstanz.de	$2b$10$YN5HvLOgYUSMoqIHphrHruwYqG22C4mRW92S9mU5XYItZ08jIa4Oa	vs4r9pdklrojwomy70lp5a	user	0	\N	\N	\N	\N	\N	2023-11-23 12:27:24+00	10514122321216325320537124148621481012183720924750229681042101152431061641153585203211217	2023-12-04 17:25:51+00	2023-12-03 17:25:51+00	3trukiv50wcf6bkmlmwx7	f
125	Hanna Burger	hanna.burger2@gmail.com	$2b$10$A4iLxV1EFz.vDBfsCc8one7/FjNHv.RDfD.KnQI8lvJ.TU8LEWa.G	u75n2z0odpv4bytloj0wr	user	0	\N	\N	\N	\N	\N	2023-11-23 12:31:15+00	\N	\N	2023-12-03 17:28:28+00	\N	t
126	Alina Lohr	alina.lohr@gmx.de	$2b$10$V9INJLqnehFWLNvUt85.8eXuV2EoetnqKL305vSYXBQ5KTS.OPNQq	swjdt4v8lkaacusewl09m5	user	0	\N	\N	\N	\N	\N	2023-11-23 12:37:09+00	\N	\N	2024-02-25 17:05:42+00	\N	t
153	Olivia Konrad	konrad.oli@gmx.de	$2b$10$eUeKeZpZt5CXiUdQZkIiQe4K7uQL1m1SQHGxKMsOL6V1pn5CGWmna	2oqi6itjo5168d8ztw8dk6	user	0	\N	\N	\N	\N	\N	2023-11-27 14:25:05+00	\N	\N	2023-12-03 18:32:07+00	\N	t
274	Niklas Obert	niklas.obert@htwg-konstanz.de	$2b$10$/L96TceDx69BSYRISHB/OO.6NU1Q8wSZL/uQFu5ZOsg2otKtRR83a	48ev95xgm122ql142knd27	user	0	\N	\N	\N	\N	\N	2024-03-21 15:47:02+00	\N	\N	2024-03-21 16:03:15+00	\N	t
111	Isabell Sobik	isabell.sobik@uni-konstanz.de	$2b$10$FGviMEuwBch2Trol.5VADOQXNF/Kw5VRb75KAr/rhvL/AjFOxFcdi	68ckjeohqmdxyq1cg3yvti	user	0	\N	\N	\N	\N	\N	2023-11-21 12:15:19+00	\N	\N	2023-12-04 15:09:43+00	\N	t
112	Aylin Chausheva	aylin.eva07@web.de	$2b$10$BOm6ipySrTbEjN66X5M9/u12l5zNXBoth7WYWDOubSGiU6H6uIlMu	1952042011011444611410161821086911524115187115109797725220228207218321821222710319282	user	0	\N	\N	\N	\N	\N	2023-11-21 13:49:49+00	\N	\N	2024-06-14 14:15:50+00	\N	t
90	leandra karolin	leakaroak@gmail.com	\N	6uhfl3i3fdu18efac0t9h	user	1	\N	\N	\N	\N	\N	2023-11-20 13:26:20+00	\N	\N	2023-11-22 13:31:51+00	\N	t
108	Moritz Morgenthaler	moritz.morgenthaler@htwg-konstanz.de	$2b$10$BXQxVe.uYfcd0FUc0Zd15u.13/elTc6oxzeJcag2fGDHhRxc1Us3y	uiy3k56jlgdjmadyh80ix	user	0	\N	\N	\N	\N	\N	2023-11-20 17:56:26+00	\N	\N	2023-12-07 11:22:42+00	\N	t
91	Josefina Massaglia	josefina.massaglia@gmail.com	$2b$10$KNuqqR8kHAZpAzI9lncdL.2CLQABiiu3RRGiGbC1eBnq9WthdwnSi	nyocuve5ofghehoshvh066	user	0	\N	\N	\N	\N	\N	2023-11-20 13:27:25+00	\N	\N	2024-02-26 12:41:31+00	\N	t
235	Tim Schlösser	timschl@t-online.de	$2b$10$pmCfo/sB.qAXeaM7b6GCSuZBnEZognwCHTLa9lfJPImtWz61yndKy	dlbga646i4h6sdh9dl6pgm	user	0	\N	\N	\N	\N	\N	2024-01-27 08:54:29+00	\N	\N	2024-05-16 16:31:43+00	\N	t
101	Lars Neumann	larsneumannofficial@gmail.com	$2b$10$W28fawx1Ti9DgAhpb7wii.iXfwZXrk.OcP/34BKXO29dveGn6sVZ.	jnxedkr3jsrbyhwi43suo	user	0	\N	\N	\N	\N	\N	2023-11-20 14:31:42+00	\N	\N	2024-03-23 19:42:58+00	\N	t
283	Peter Brehm	peterjosefbrehm@gmail.com	\N	o8hsn8il3wbbb3oniok3sq	user	0	\N	\N	\N	\N	\N	2024-03-24 15:08:17+00	\N	\N	2024-03-24 15:08:17+00	\N	t
103	Philipp Haubrich	philipph26012003@gmail.com	$2b$10$SyWZLz0z9qlhDih5nWfdv.G0ytUK550bZBnX2LbcHvkIbccO3.dka	4hetl4xpi8avnpos0vzi0d	user	0	\N	\N	\N	\N	\N	2023-11-20 14:44:54+00	\N	\N	2023-11-20 14:46:23+00	\N	t
370	Shanice Merz	shanicemerz@gmail.com	\N	1991171110982358019122914676334922125017417396342161856217103203692075438247204163	user	0		\N	\N	\N	\N	2024-07-05 00:19:28+00	\N	\N	2024-07-05 00:19:28+00	35323430202237245491519020045182352451585360837392381143718813847190982266250	f
177	Julia Seelmeier	ju351see@htwg-konstanz.de	$2b$10$gPqYtk60Z1zJ9Jr2qwXAf.207anaLTCwghd30nQD5lRsSow98NTm2	6vghji7v9e9y6p6uq0bhw	user	0	\N	\N	\N	\N	\N	2023-12-06 11:29:15+00	\N	\N	2024-05-01 17:42:50+00	\N	t
163	Arnav Gupta	arnavguptacr7@gmail.com	$2b$10$QyzEH5CsPolDXsclfpwNReZ7ghHLbuTi/i7g50bCDO4lbbJFqjCVG	9klshsqcr9cbdjb2oj443m	user	0	\N	\N	\N	\N	\N	2023-11-30 12:53:29+00	\N	\N	2023-11-30 12:53:55+00	\N	t
303	Letizia Fronterre	letizia.fronterre@gmail.com	$2b$10$Sxl5Es9ZPiaBjCXk2bTnJ.ZwQm0f3GSOFYCQLYP7ESqnj6fPD8MgW	i4ap3qhrbj4748g3sqxg4	user	0	\N	\N	\N	\N	\N	2024-04-08 14:34:27+00	\N	\N	2024-05-02 06:40:54+00	\N	t
106	Benjamin Wagner	benny-wagner@web.de	\N	vbv8ojpuqdosbzl2ig2bp	user	0	\N	\N	\N	\N	\N	2023-11-20 17:28:30+00	\N	\N	2023-11-25 08:33:46+00	\N	t
94	Milena Pfeifle	milena-pfeifle@t-online.de	$2b$10$cJalsaAV2i6CgYECR3wt9.eYPaQVkjmYiSdAxdjatU1GKmA3ID7GW	6y317hhno9v2p8xov1e0dd	user	0	\N	\N	\N	\N	\N	2023-11-20 13:46:57+00	\N	\N	2024-01-11 12:39:15+00	\N	t
285	Lisa Eckhardt	eckhardt.lisa@gmx.net	$2b$10$J936N.8HbfHbgUIDcu.Tx.wF9IHsxYudh78xZ1d3k3bvm/g4XrQnq	yza8bn3ycj55c7gj4punu	user	0	\N	\N	\N	\N	\N	2024-03-25 09:22:26+00	\N	\N	2024-03-25 13:45:10+00	\N	t
139	Lydia Payer	ly681pay@htwg-konstanz.de	$2b$10$.FtXtPW4Pn9HRPEUrKAX5O4VvQ8/9FfAo/X5/9YiuM2cpSJNW4/Hu	vr60y04ew78k2lama2hfl	user	0	\N	\N	\N	\N	\N	2023-11-24 07:57:27+00	\N	\N	2023-11-28 07:01:00+00	\N	t
443	Lisa Maria Kuhn	lisa.kuhn999@gmx.de	$2b$10$9cGYOQn8XmsPgjyitf1RNO/Z5oxUb16AzTzV/XP3F4AQAirRXcmNy	7621931216361091333322275232872379610135117932532502242313737213193209119174205116135	user	0	\N	\N	\N	\N	\N	2024-10-03 15:41:03+00	\N	\N	\N	118151891371182542038317321013026230182233234632444737137225155217232931675652	t
156	Esther Ranf	esther.rang@uni-konstanz.de	$2b$10$o5PclpMSbWa626.U6aTwoegpvF/oPReDQI245e7hcx4setbRtgJT6	ab0zlk5j27wsf0705h9qjl	user	0	\N	\N	\N	\N	\N	2023-11-28 14:47:25+00	\N	\N	2023-11-28 14:48:30+00	\N	t
157	Esther Rg	esther.cnsr@gmail.com	\N	5lzkzfj2l1f7ggo8425f5c	user	0	\N	\N	\N	\N	\N	2023-11-28 14:51:57+00	\N	\N	2023-11-28 14:51:57+00	\N	t
168	bjoern eschle	bjoern.eschle@disroot.org	$2b$10$Cp4zd4SltKw9.EA6fWw6MutmUUg6zfoUPiv5mhyb4jhmkkTqDeMYG	a6fdat899vjrcd4ure7s99	user	0	\N	\N	\N	\N	\N	2023-12-01 17:01:36+00	\N	\N	2023-12-16 09:57:07+00	\N	t
331	Anastasiia Biliakova	nbelyakova1948@gmail.com	$2b$10$TblwHYsLdpXnAg6wSM2vHuRqAadXbZskq26m.f.uN7KWgzFtlrapu	21blzcteuh3fjlc0fsyoj	user	0	\N	\N	\N	\N	\N	2024-04-25 10:34:04+00	\N	\N	2024-04-25 10:38:28+00	\N	t
314	Xinyuan Zhang	zhangxinyuan0221@outlook.com	$2b$10$CJqpYhrea.nFRLDfMyGM8ePJE3XZBN3hHOTSH.qlk3UTOcg22QW7i	p7cuv2vs28qcxjk9abc2	user	0	\N	\N	\N	\N	\N	2024-04-18 09:53:05+00	\N	\N	2024-04-18 09:53:05+00	mq92pwq96ihmjfo62apjrj	f
146	Lis Liebhardt	lisshardt@gmail.com	$2b$10$Q40Rgy3wcBOYbtVMwyQ/xuqJi3Id08A4aaWcLDmiRs2vAXwUlPKQm	h3tqv2uericko0ncibhspp	user	1	\N	\N	\N	\N	\N	2023-11-25 10:02:34+00	\N	\N	2024-04-03 16:58:09+00	\N	t
149	Sofía Karsaclian	sofiakarsaclian@gmail.com	$2b$10$7ikdU9JaCbZsad0fzV.BeuItXZ10Aqmxoro8D.i.Gqr9Wt4gqgFHO	208592021622512151136167150202491411251032232061711511638239881071851722361568823833230	user	0	\N	\N	\N	\N	\N	2023-11-26 11:37:25+00	\N	\N	2024-09-29 08:13:07+00	\N	t
181	Max Döbele	ma871doe@htwg-konstanz.de	$2b$10$EbOftZjwRXUL7LPE06AY9OBdnqh41JqRuyMqw2stHWcEu038VbwUO	13645245143199881309294202224249396421910324023810206104989422817113099141189251106248	user	0	\N	\N	\N	\N	\N	2023-12-07 11:48:57+00	\N	\N	2024-10-07 07:20:18+00	\N	t
52	Anita Grath	anitagrath@web.de	$2b$10$4RIia8WB.FRHbRUvyRFg2.FMuQMKPcUAARIiEkIUj0oACqyIrYAL.	yw018m4ptqfgguyflk0qnt	user	0	\N	\N	\N	\N	\N	2023-11-20 07:29:29+00	\N	\N	2024-03-01 11:19:44+00	\N	t
138	Elena Putilova	e.s.putilova@gmail.com	$2b$10$bXrDUIAvTHvT08zJCN7OhuLPQAuN7Nng8xzIXOtK.W1iykdiOgQC6	ihexjxd9etk9a99v2yakuc	user	0	\N	\N	\N	\N	\N	2023-11-24 02:41:24+00	\N	\N	2023-12-01 08:51:18+00	2qlu05nu00fxbh9fweppmh	t
180	Daniel Dobler	daniel.dobler@uni-konstanz.de	$2b$10$qfB8QBCsorm7u3F5TvXDn.r1OqUmJiBUmH1RGW2s7yH5JnL4GeBpi	jhs38yk5i3aj7zi37obekl	user	0	\N	\N	\N	\N	\N	2023-12-07 11:33:46+00	\N	\N	2023-12-13 11:12:20+00	\N	t
134	Maxim Dinort	maxim.dinort0128@gmail.com	$2b$10$ivgV.WCDrZIAHtMjz.EoNOihEamogiagZVi.gJuZGkQNFLhD86w7e	0wkb6r5ac7bwqrgg4gwqpq	user	0	\N	\N	\N	\N	\N	2023-11-23 17:08:58+00	\N	\N	2023-12-07 15:42:47+00	\N	t
230	Robert Thome	rupert9961@gmail.com	$2b$10$Yb9OcJxo3wy/dzE0iEg/EuUdOIAeI.sJPbHE74dG/bqq3RMn5rKzG	c0ibaofj05vze8bc4glqmj	user	0	\N	\N	\N	\N	\N	2024-01-21 17:50:59+00	\N	\N	2024-01-22 15:53:04+00	\N	t
129	Jonas Scherer	jonas.scherer@htwg-konstanz.de	$2b$10$UR/khKjJ95OGAQ.h6oW4mOKxbgQ3xp9wSk/azLZP6KC6S.tvOx3se	7vbuxe178gwzlyqyequdlk	user	0	\N	\N	\N	\N	\N	2023-11-23 15:16:50+00	\N	\N	2024-01-12 13:00:59+00	\N	t
133	Aline kaussen	alinekaussen@web.de	$2b$10$13TOzc6Cx9eCE7BXZKxCiuEqxRPvgnMfOhgcOfBI6qlGyEtxqolj2	30sygobwu2p843y9oskj2h	user	0	\N	\N	\N	\N	\N	2023-11-23 16:56:16+00	\N	\N	2023-11-23 16:56:16+00	jls7w83mvl87fgbwmvsbzq	f
132	Paula Weinzierl	paula.weinzierl@gmail.com	$2b$10$2juEmqRW/4WQAU8tWY3/7.uDvETQfFcAHkVDzoupQnleTobTb3IZ2	mqyzio5zfpe9dbqi3nxw5	user	0	\N	\N	\N	\N	\N	2023-11-23 16:56:09+00	\N	\N	2023-11-23 16:56:22+00	\N	t
131	Rosa Lobo de Macedo	rosa.macedo@web.de	$2b$10$fMAl/WOb8j36gLV4U4LCN.wMjnU6R7upF6eV8lFA2/gyCkX4ehYC6	rk2p8e7mi4cgpx3dryg4g	user	0	\N	\N	\N	\N	\N	2023-11-23 16:55:55+00	\N	\N	2023-11-23 16:57:02+00	\N	t
119	Michael Honecker	michael.honecker@web.de	$2b$10$OdQEGgkvPZd1qSNMtvBeu.TDi3IUjF161P0l.MsNK/vsHN5g5rPYu	i6vh88yt675epjo7k91a8	user	0	\N	\N	\N	\N	\N	2023-11-23 03:27:57+00	\N	\N	2023-12-07 15:52:41+00	\N	t
158	Jona Digel	jonabdigel@gmail.com	$2b$10$iamrk93f9Oh4WuAkQ0ED6ugdx.OesRpUvokmRIj12xEXAOgkCCXL.	0fp4rbo04uyamg4c76bq4xb	user	0	\N	\N	\N	\N	\N	2023-11-28 18:32:33+00	\N	\N	2023-11-29 12:10:29+00	\N	t
175	Nicolai Ebner	nicolai.ebner@gmx.net	$2b$10$5Icd7n8819XxbxPoxBGnku/UHfYVWVtiNh/rEcANRdtnCwi11jTVa	7aoz4bjl3mkmpvz16oqn2i	user	0	\N	\N	\N	\N	\N	2023-12-04 12:50:31+00	\N	\N	2023-12-04 12:51:10+00	\N	t
251	Alina Rupp	a.rupp8@web.de	$2b$10$.1zN0xck2KIyLlv4iRExNuPnxAlJct3SmVG1tHCANsW120UPbPlua	24917314711228116561561301518279221884092221122414219911182121103112066139168228	user	0	\N	\N	\N	\N	\N	2024-02-25 09:53:35+00	\N	\N	2024-07-14 17:30:50+00	\N	t
143	Sachin Nandal	sa.na250303@gmail.com	$2b$10$Lsy/Jw2K2ErqlQhiMxusa.JsQ5Bu1Uwi6vFTeNo5zFdl.pixdcuI.	18413120432106262508312916613519823623213421573863234190139262431048332447424221288	user	0	sometimes late	\N	\N	\N	\N	2023-11-24 21:07:44+00	\N	\N	2024-06-21 14:02:06+00	\N	t
174	Hannah Seichter	hseichter.18@gmail.com	\N	78m7gnixydeycaowh689yd	user	0	\N	\N	\N	\N	\N	2023-12-04 12:12:55+00	\N	\N	2023-12-18 07:05:30+00	\N	t
135	Marcel Erbe	erbemarcel@gmail.com	$2b$10$3qAjgfXdnhUGY9YqZquze.7yLjfatwvRHvYR86YKJwOZnuyeaR7lq	2402401206974978379916079251719513821228683801483918212714010816912180182134152	user	0	\N	\N	\N	\N	\N	2023-11-23 19:22:42+00	\N	\N	2024-07-21 06:39:36+00	\N	t
142	Samuel	s.kopecek0107@gmail.com	\N	zpbez2iaikwy4iaglxc4	user	0	\N	\N	\N	\N	\N	2023-11-24 18:50:28+00	\N	\N	2023-11-24 18:50:28+00	\N	t
27	Lotte Hegemann	lotte.hegemann@googlemail.com	$2b$10$xA9Sl0FEtg9842xndLDOk.aD.q01Yecd6bVA.PXRMvgtDNrDqO/qm	zdmza6kmvrzdimbsdsb	user	0	\N	\N	\N	\N	\N	2023-11-18 16:11:59+00	189648820142691651251921101961487921371131228522321028297763742271463231729362	2023-11-24 13:18:25+00	2024-02-15 11:44:52+00	\N	t
118	Florian Pfitzke	florian@pfitzke.de	$2b$10$RvM3l7PESg/5ijmQaSS.xu30XuceiUDoEMFQcpom5TR/rO/fpR/FO	h4z2qx2anzuaplbvyf9nbq	user	0	\N	\N	\N	\N	\N	2023-11-22 23:49:04+00	\N	\N	2024-03-19 00:01:08+00	\N	t
170	Jony Hirsch	jonni.hirsch@googlemail.com	\N	2311931764020519813122529112551201221247625314723419931180157741024013414689175103161	user	0	\N	\N	\N	\N	\N	2023-12-01 22:16:39+00	\N	\N	2024-07-11 10:49:10+00	\N	t
89	Felizitas Amann	felizitas.amann@htwg-konstanz.de	$2b$10$srIuaJaI6R1XyIl7yI9dAOjqpG9qA5CmX338.UF8iN/V1uhy.Yc0S	xb2gmfam2kx5u7mg1d4b	user	0	\N	\N	\N	\N	\N	2023-11-20 13:20:29+00	\N	\N	2024-05-02 18:25:32+00	\N	t
355	Marvin P	marvin.peschka@uni.kn	$2b$10$lOuJP6Z0UmN6YriNom6Gae1KTxWn.9LhCyy1ii4u0F1X./7taKxr6	514777187891671487216764156992331131003616103149128130193165188301849312712767253100	user	0	\N	\N	\N	\N	\N	2024-06-03 12:10:41+00	\N	\N	\N	917713333217209134142171962923183535522726234251025524816750243124297183196147	t
166	Julius Grages	gragesjuk@gmail	$2b$10$StAufwz63pfS0iupBncel.2.mBcQtcRedGLQl9ZyA9Q0DDG56P4fa	dk093lfpjeatv3p0otc61	user	0	\N	\N	\N	\N	\N	2023-11-30 17:53:30+00	182481914915572180321651082301611756531761618348924530151243816183681521969223	2023-12-03 14:40:25+00	2023-12-02 14:40:25+00	fos7obhhi0bayg6d0wuqei	f
176	Lucian Fischer	lucian.fischer.13@gmail.com	$2b$10$lLUUhBQyeWMfGgZr78X9x.XTIreyO8/f30jq3vVOY90HBDFGCDyaG	0aukw9ao4z8m2fcmrey74if	user	0	\N	\N	\N	\N	\N	2023-12-04 14:07:28+00	\N	\N	2023-12-07 16:52:41+00	\N	t
120	Klara Martin	klaramartin0812@gmail.com	\N	2mcgmxozlk91l6okomvij	user	0	\N	\N	\N	\N	\N	2023-11-23 06:33:47+00	\N	\N	2023-12-08 01:15:36+00	\N	t
227	Ahmad Varasteh	ahmad.vh7@gmail.com	\N	43rcceokhsihfpry0637eb	user	0	\N	\N	\N	\N	\N	2024-01-19 14:33:44+00	\N	\N	2024-02-02 11:04:37+00	\N	t
130	Noah Auer	noahauer0405@gmail.com	$2b$10$rZ9cjsAKWWo0Vv1Fu7WOeeNw2oP.spgTipdzJzjTM2gnzssgQ0cNa	3mcajvdf47ei897ckru02	user	0	\N	\N	\N	\N	\N	2023-11-23 16:37:22+00	\N	\N	2024-02-03 11:30:27+00	\N	t
73	Marius Schön	marius.schoen@posteo.de	$2b$10$ojdNCCQkV5MdP7TOKbB3.ejAyt59VXjfAQwISeG23N6mNdVoM3HDK	69p06jc73ee7ayiqlogssj	user	0	\N	https://web.push.apple.com/QAtHzWvNt4FQ-tENETm40e3ygl5w7R7ZLdtueyyyXWEz_po_WOzc90Xn2vICRB9eU6mmsTgc0GRt70eTs7KjD-vzKUuXW4RmeEXy2NfiWD5S7PTKpDgvOLBIeBdHp_307SMvGGnF6k0tRUL91WP8hwi06H42yLV0-q7LywSf_8Q	\N	BERbaMjH7uys8hatatolxr6L1Zlmu5YMshGSDc-SC731VYJmylNaGH7LIf8rXsJaJvbaWIrpulSwz0zTi5kKb6k	_ngmrmJI6ZU0LxakivNqEQ	2023-11-20 13:01:05+00	\N	\N	2023-12-07 10:59:19+00	\N	t
237	Leonard Tiedemann	leonardtiedemann@web.de	$2b$10$hJOYdR2yNiFvXLbzot6cxegTrGpMXHWjwwx4jcO1aJBC.BaTJ5mXa	6t05m26tgf5hqxqjnfrkn	user	0	\N	\N	\N	\N	\N	2024-02-03 18:02:42+00	\N	\N	2024-02-03 18:02:52+00	\N	t
323	Eleonora Melikova	e.melikovaa@gmail.com	$2b$10$lwqredF9Tw8JOCy.jNpf0O6EFxLTRmh75chylEwMBeSl.avFoa1di	k0usn5ehxzb7p99ubuwn9	user	0	\N	\N	\N	\N	\N	2024-04-20 22:00:44+00	\N	\N	2024-04-25 10:36:51+00	\N	t
171	Theresa Göser	theresa.goeser@htwg-konstanz.de	$2b$10$s1kJa.5mN6Wswva3BKn5uOfcL6CkfMWW6MMJCqdeRvBYbSm7f227W	ykdn07j5z2p94rjebvq	user	0	\N	\N	\N	\N	\N	2023-12-03 10:01:47+00	\N	\N	2023-12-03 10:04:55+00	\N	t
190	Finja Fay Schmid	finja.schmid04@gmail.com	$2b$10$Mr3qUE.Sd6HNYfuSi/rUOOTr99OF/GYL2/bBilrW3q3tk8WICbWyS	4bfaw0chbz6a3i3jndqehp	user	0	\N	\N	\N	\N	\N	2023-12-11 08:03:12+00	\N	\N	2023-12-11 08:11:30+00	\N	t
228	Frank frank	sporttravelchild@gmail.com	$2b$10$P4uC3V.59LxbEbUEtQXQCu1cZ5M3qNk3UIW4y9.rbXGRE8WewtMMm	83qs6pk1g6494xaqdu3fz9	user	0	\N	\N	\N	\N	\N	2024-01-20 08:30:04+00	\N	\N	2024-01-20 08:33:23+00	\N	t
402	Maren Franke	maren.franke24@gmx.de	$2b$10$WGQ9W1cpSoGo7sApiV0fDe2wQkXWwPBfuPw8n2bvRKRlIOO8PaPfy	922351724642200232245912326886016225476350461471672294936819212224123214149102	user	0	\N	\N	\N	\N	\N	2024-09-26 13:56:52+00	\N	\N	\N	11416229245105167196372317016130164114174112150194503125858605019280189812309579	t
191	Pia Bogh	pia.marie.b1@gmail.com	\N	o5x80zogkk2rkgtbu4kv3	user	0	\N	\N	\N	\N	\N	2023-12-11 09:07:57+00	861154255210351462720966132111914529186459681632202635153220482112174110219224	2024-01-12 15:43:20+00	2024-01-11 15:43:20+00	\N	t
330	Lystopadov Nazar	lyst.germany@gmail.com	$2b$10$8zB2DkaRRpWvZvQGtPOjTukPyVEgddKyc7BrQDiQBk5taUDaAUUnm	83o4tsqs6lsiomwi0fcx4k	user	0	\N	\N	\N	\N	\N	2024-04-25 10:29:08+00	\N	\N	2024-04-25 10:38:35+00	\N	t
201	alex umlauf	alexander.umlauf@unitybox.de	$2b$10$ccYarzYw364B4ITL/VeLdusy9TVd5lZfGqbMwVzHNAr6HaESk1f1S	2ri2j4uedkco9uh8ste3ep	user	0	\N	\N	\N	\N	\N	2023-12-14 18:20:30+00	\N	\N	2023-12-14 18:21:43+00	\N	t
179	Milli Pfei	millismailbox@gmail.com	\N	t6trttqumqq0tsy8531hk	user	0	\N	\N	\N	\N	\N	2023-12-07 07:35:50+00	\N	\N	2023-12-14 18:39:03+00	\N	t
192	Anne Reistle	an872rei@htwg-konstanz.de	$2b$10$eRh59kGhvJFSgVRfgp6h.uiuyK9UQ8BMIWERUqWGhWtcJbnLnAuQ6	1204519311427157138189162141269141872355913111123570160184152208592125291647417730	user	0	\N	\N	\N	\N	\N	2023-12-11 09:10:39+00	\N	\N	2024-10-03 11:43:24+00	\N	t
207	Tanja Holetzke	t.holetzke12@gmail.com	\N	uiptfqequ9mhpzmqv6373s	user	0	\N	\N	\N	\N	\N	2023-12-19 16:36:20+00	\N	\N	2023-12-19 16:36:20+00	\N	t
219	Leander Streun	leander.streun@live.com	$2b$10$y6ju9gvF.J8D3o7gsjn4E.rY0OLFD6vcUc29rBB07/bMl1O5p.sdq	k7ts4zrjw6eciyrocdz12	user	0	\N	\N	\N	\N	\N	2024-01-12 11:47:02+00	\N	\N	2024-01-26 09:22:48+00	\N	t
263	Martin Stefke	m.stefke98@gmail.com	$2b$10$x2V6kWLFCoQcb58srIevIeu5M5RY3cuQzj4Fuzd//HY8GFVossTUu	dek258kpb58sdjeoz7apk	user	0	\N	\N	\N	\N	\N	2024-03-13 10:01:52+00	\N	\N	2024-04-22 10:37:13+00	\N	t
51	Tobias Heinz	tobias.heinz@uni-konstanz.de	$2b$10$LiCg.Jt.P9osqUJVMejSZu9CPGrh2iZGflJjkY1DsKuMarMTzV41e	24325550112227105155812472204180254159205225291891652261229127171207170201051777195103	user	0	\N	\N	\N	\N	\N	2023-11-20 07:18:16+00	\N	\N	2024-10-04 06:02:30+00	\N	t
206	Lukas Krause	lkrause2105@gmail.com	$2b$10$qR0.rnfQFlmKUANC1HSMGuYhqqc2dG9rUe4TWB3m8pQFmAYnOZi5O	kwhr0x8k5hgjx89resi85	user	0	\N	\N	\N	\N	\N	2023-12-18 15:37:36+00	\N	\N	2023-12-18 15:39:26+00	\N	t
194	Lukas Maurer	lukas.maurer99@web.de	$2b$10$gvVdS5VFTU.FE/l0pMg5IO77Csq5r.UukuA5x09ni.aeCSbjU5K9y	1561958220814624215120699169222212291342244202126195252154204198164717820320746752549	user	0	\N	\N	\N	\N	\N	2023-12-11 12:08:52+00	\N	\N	2024-06-09 09:15:28+00	\N	t
183	Johanna Beutel	johanna.beutel@uni-konstanz.de	$2b$10$8fN.Kt0MAEzzdwMRlJDbm.AI/j6OHuEZDJTvBxKRyqv/ubj9e1c.K	722125817942281671332821222297410314710313616011415516523930190213235142232673148210	user	0	\N	\N	\N	\N	\N	2023-12-07 16:45:53+00	\N	\N	2024-06-01 18:10:25+00	\N	t
215	Nikolai Löser	niko.loeser@gmail.com	$2b$10$FRd9EhXEjeONOdpob/QiM.e.a4xMeUFflsAR0fQuGYwQQjaDHJN/K	3cw7zfv4hzs3y7pq19sqji	user	0	\N	\N	\N	\N	\N	2024-01-08 15:49:50+00	\N	\N	2024-01-08 15:50:21+00	\N	t
216	Marvin Peschka	marvin.peschka@gmx.de	$2b$10$P9eEzyEsO/UGkx4S1tOQdum2azMS1Se7PUxpiIUEBtrSwwQGJa25S	3vbo68jv2bhbjwzq2x6cfv	user	0	\N	\N	\N	\N	\N	2024-01-08 16:47:38+00	\N	\N	2024-01-08 16:47:57+00	\N	t
123	Maximilian Hahn	maxihahn2@web.de	$2b$10$bRJalXvU83oGjnNF5TSrCuObqbw7V5UwNohdvCNYDf9a3S6xGUxkS	vdp8w57wyrxxr9bui4b2	user	0	\N	\N	\N	\N	\N	2023-11-23 12:11:59+00	\N	\N	2024-01-11 12:19:41+00	\N	t
151	Adrien Beckenbach	adrien.beckenbach@htwg-konstanz.de	$2b$10$RGoVPGO/4H/WPTMQAQZVtO97ZTQJHt0UiR/GckziCDc5lpEnecu/G	h83g6dpr0brtlp4aw8to2	user	0	\N	\N	\N	\N	\N	2023-11-26 17:58:14+00	\N	\N	2024-03-20 08:57:04+00	\N	t
218	Marius Beermann	mari_b_2000@web.de	$2b$10$zR4VUhoDh8vKXnKGw1JBCOCpdeLVMhpYj7vXvgcD17GBseHbx2slC	atttzqd1v8poc9rj03bsce	user	0	\N	\N	\N	\N	\N	2024-01-11 22:51:02+00	\N	\N	2024-01-15 17:38:32+00	\N	t
38	Francesca Frisoni	francesca.frisonirichard@gmail.com	$2b$10$LJ.qq0wyZzxSawBg7tzey.iTZ92ZCkFpobLDAv.BqaIRmUCtD9oem	81484191812311211634216903549164564221449132211168250132296324920540143204236	user	0	\N	\N	\N	\N	\N	2023-11-19 11:26:15+00	\N	\N	2024-06-13 19:15:14+00	\N	t
204	Thi Quynh Phuong Phan	qphuonglieb@gmail.com	$2b$10$MljmbnhhFvxitSyLhfGpeuglwZc5fWsMRNzI/6lJLP9m04TpgmmAW	ro62au87espmzmw5oru5j	user	0	\N	\N	\N	\N	\N	2023-12-18 11:34:10+00	\N	\N	2024-01-17 09:18:50+00	\N	t
261	Bianka Bran	bianka.bran@gmail.com	$2b$10$4e4qIf6Y69C.c1q6rwUZ2uZTU0heCAQLnuIMu7O94qE2hsiggAgCu	ucoox7d0b5jd27ou4xuj	user	0	\N	\N	\N	\N	\N	2024-03-12 18:09:15+00	\N	\N	2024-03-12 18:09:46+00	\N	t
17	Johann Sanowski	jo.sanowski@online.de	$2b$10$2n0d.jKGxn45BbfXTCBtpesy2VtiCJgZMZDfKWz.M1rF3mJ3VV9ou	183243201235210162202259119417811919225317133832032501821096515510214513822611587139109169	admin	0	Schluckspecht	\N	\N	\N	\N	2023-11-17 06:01:14+00	\N	\N	2024-10-11 04:46:18+00	\N	t
322	Roy aurelie	aurelie.roy@uni-konstanz.de	$2b$10$pCa/43bcwLG51Z0oeoRef.ey7e5J6j7xeSL00mAvgYT0a9kpOUAAS	r8fcbvdt6in95f1iqqe8po	user	0	\N	\N	\N	\N	\N	2024-04-20 19:55:18+00	\N	\N	2024-04-20 19:56:21+00	\N	t
232	Nils Wanner	nils.wanner@uni-konstanz.de	$2b$10$eVbabEnmHEEUQv6y7vdnWuuMjAPM7739JExYu1kltB0sw5R1Il1Cy	x487yud9kj8c0t9m6ij5g	user	0	\N	\N	\N	\N	\N	2024-01-24 09:39:50+00	\N	\N	2024-01-24 09:53:05+00	\N	t
262	Timo Haas	timohaas@web.de	$2b$10$RV.vxNMYSweaiZQNTQ.Need1Cwy0BRYD21u6AUOUm/ynZkYlU3CC2	5tvkzoj0td2x487fulfyl	user	0	\N	\N	\N	\N	\N	2024-03-12 21:07:33+00	\N	\N	2024-04-14 13:23:48+00	\N	t
326	Maria Falcon Rogin	maria.rogin13@gmail.com	$2b$10$46ix9iVBDFslcef27/2rfelu.mC9UuLeMdWGaOBYc56V7j1UjudCS	x245m7pk0pyst703mafc	user	0	\N	\N	\N	\N	\N	2024-04-23 17:14:47+00	\N	\N	2024-04-23 18:00:30+00	\N	t
327	Daniil Stynka	stynka2017@gmail.com	$2b$10$.reqAxg1OisFBda36yr.c.nu2qcOkV3zaISIi.pwXD7WXOLiaL3U2	1xyna1ppb46hjr6xmi0tpr	user	0	\N	\N	\N	\N	\N	2024-04-24 09:08:40+00	\N	\N	2024-04-24 09:08:51+00	\N	t
243	Felix Eschbach	flxschbch@gmail.com	$2b$10$y.W84yhob4mb/HDZkQ2TZOMuoGhVtgABdjaNUmEdmLPR3VDWp/Z.e	1837714162124761913620925511775120341722231552321111775245205741111421661309965187138	user	0	\N	\N	\N	\N	\N	2024-02-18 15:15:49+00	\N	\N	2024-07-08 14:29:02+00	\N	t
304	Maurice	Duerre85.1@web.de	\N	lk6ck4afqyfrq9skw8mfh	user	0	\N	\N	\N	\N	\N	2024-04-09 10:26:47+00	\N	\N	2024-04-09 10:26:47+00	\N	t
172	Lisa Marie Schultes	lisa.schultes@drumlin.de	$2b$10$zAoXVPK9vQ50okYt8I57UesGxwLd5YF9Lyhja2O4xBVl906jgCl2S	16725520918452211147819364113234408912451251592480116741413120221249635233128194	user	0	\N	\N	\N	\N	\N	2023-12-03 15:33:21+00	\N	\N	2024-07-14 19:49:20+00	\N	t
241	Jonas Zoller	ameisenaffe999@web.de	$2b$10$lVJgf59TJm2chXdI0ZRBFuADyNx28CNcVSCCTEutcyhuxwTCLbo22	1xly2yb8z10i8btbterraf9	user	0	\N	\N	\N	\N	\N	2024-02-16 22:09:50+00	\N	\N	2024-02-18 13:13:31+00	\N	t
113	Gabriel leguizamon	gablegui26@hotmail.com	$2b$10$0AiWFE1Pbp3okIzNJj7gQOQA3YzDeR7S1x4mTfiMrcBM4NjyxZghi	30l0lt7na9cke7aufsk6gd	user	0	\N	\N	\N	\N	\N	2023-11-22 08:46:33+00	\N	\N	2024-02-02 14:51:14+00	\N	t
185	Anna Reichling	anna.reichling2000@gmx.de	$2b$10$vBJmA4SCm4mgrnBcYktUt.PP4//v.opRKAGFgjmih5/ORySZGZmku	c1ngvomgwohrr8safniii	user	0	\N	\N	\N	\N	\N	2023-12-07 20:20:21+00	\N	\N	2024-02-02 15:06:13+00	\N	t
444	Hannes Beck	beckhannes04@gmail.com	$2b$10$3mm/v9KXK7lc0Pmhh474AO.Fx9co6/QlwS9Ck04PetRFyQM/NQ/WK	75179230423717879188198174136113121995115010587721131031301414013775117250241575221	user	0	\N	\N	\N	\N	\N	2024-10-03 16:14:21+00	\N	\N	\N	129190157216180451221913323160255361919883624922619842721711491549986161157114527	t
208	Chiara Probst	chiara.probst@phtg.ch	$2b$10$trxiFaSbkCAkZ.wGt8JY4egIdBExpD9gEJTIB.sEBhUS.wQ6IqVr.	oq8hrlroqjazqcayljlg5s	user	0	\N	\N	\N	\N	\N	2023-12-27 12:54:56+00	\N	\N	2023-12-27 13:27:14+00	\N	t
209	Constantin künne	constantin.kuenne@web.de	$2b$10$cFSj4DNhPS229gEEmapvje0TDUxMxvJPsuXtm7R2TIdW7SkKs/Sle	gbgpb57ykpini26u0ix1sj	user	0	\N	\N	\N	\N	\N	2024-01-03 01:30:38+00	\N	\N	2024-01-03 01:31:25+00	\N	t
259	Marco Klingberg	klingbergmarco@web.de	$2b$10$sixmjvbQE1D0GOlrAJzVaORIrID70fXf9WWXU4/XZoyohNa/bUDy6	900xr4yvmm749pe2zlry4	user	0	\N	https://fcm.googleapis.com/fcm/send/deQnSiLLpxI:APA91bGMKk9hiufSSaB-P6ydPYJm-6nEwglBb9zNABjLD0e285G3glta5zChfUmD9xOENdO5zkHAKzRPPXRAS1jE1diEgBf1iZ3-cRCe9kgidbKw-roFThjV5lTJLSX1pYjfP5cT7INH	\N	BJ3DfYErn63yQ6aIKaudVFoGjWH_P1zCMpKOeGH-sXCW-7WsjI81W_ydlq2mdXpcdhwfPhr9Rjmg7fNDaHXrz14	buykL-PPkwi45WExq8hN9w	2024-03-09 15:41:46+00	\N	\N	2024-03-30 15:27:31+00	\N	t
184	Paul Spickernagel	paul.spickernagel@gmail.com	$2b$10$jGgizA7J1q86T17ChZzDAOiBHeqoHKhF1zfjPcYLFVt0uKbUtjBVe	etmkftfm0luhlix4tx8pc	user	0	\N	\N	\N	\N	\N	2023-12-07 20:02:46+00	\N	\N	2023-12-11 10:41:06+00	\N	t
160	Marvin Kickuth	m.kickuth@gmail.com	$2b$10$2fzi85wmHol3qscSLtygsu0kDHGrUfdfPLUAe0lFw6aewVxYy0/Ra	45dudhts0srefii4b8jtqr	user	0	\N	\N	\N	\N	\N	2023-11-29 20:09:49+00	\N	\N	2024-02-04 10:49:50+00	\N	t
159	Julia Gmelin	julia.gmelin@gmx.de	$2b$10$8EOC.CWcz04y4M/enbAv4e92dlyRy3EutK10YudSISa1nWY9uP1e6	9522967198975154651953519621519713175237152207183116135741301521079221340223227255116	user	0	\N	\N	\N	\N	\N	2023-11-29 09:09:37+00	\N	\N	2024-09-12 12:32:27+00	\N	t
238	Test Name	keratin-hamster-0o@icloud.com	$2b$10$dYa07kjNDqUjmFsnOtwhJOwqHBsZEFC8dMYc4pzw7c.3vBfLWTEZ6	nanprgiin4hc4uhf6y7ky5	user	0	\N	\N	\N	\N	\N	2024-02-04 15:07:27+00	\N	\N	2024-02-04 15:07:55+00	\N	t
195	Franzi Sachse	franziskatheresasachse@gmail.com	$2b$10$nBsz86duuPLhhmuO7I4LaOylQdeQNQOK/1EdGlbBLqmrrib0xPY6S	6mss80oa1vigy7tmrmvj4i	user	0	\N	\N	\N	\N	\N	2023-12-11 13:28:29+00	\N	\N	2023-12-11 13:29:14+00	\N	t
210	Ian Kouzel	ian.kouzel@uni-konstanz.de	$2b$10$nUnYCMMb79bm1NTrejXG4OD0r52f14ai1gEloOm2ZG4MH543V41TO	oa6t38i542hwtpuixg8nr	user	0	\N	https://fcm.googleapis.com/fcm/send/egY0s1SfDv4:APA91bEat7C5_AUUhNH-zJ7Ah0EMNwAEwbgwwUKjFF7ftzLkgnxEqd1-UiW1bBi0ErXigX2LBOWSXnpCWfdsNs1NqRJF_WOlCXJF56SPpEQOvhxMnttjFwUsjpv7oXr888tcFqjIE2NV	\N	BPlUxsCcQ-dr3wXjwUErS5M9RATEDtezN5aQ03OKcgrdTylPxvvKwPztegy20kB71KAtCEoSl0BKWld2notvWVo	OSgwpv2vE9MBPI5cQQzesg	2024-01-03 19:41:30+00	\N	\N	2024-01-04 12:29:00+00	\N	t
288	Lena Buck	lena.buck@htwg-konstanz.de	$2b$10$pvJGD41v.NHt3uWHb8vWveqM4shux.TlYM09qqPiXouMayKDUbnwy	j9y0q4e5qmleanuu4tqhiu	user	0	\N	\N	\N	\N	\N	2024-03-30 17:15:58+00	\N	\N	2024-03-30 18:26:47+00	\N	t
202	Hoang Thuc Uyen Bach	uyenbach27@gmail.com	$2b$10$LB/aX8S8jwVHPVq2vFa1BulE10Ql3scvUSutbXBHAhvYOpO/.NeTW	grbf02expo4szkqngy3bnp	user	0	\N	\N	\N	\N	\N	2023-12-15 15:21:14+00	\N	\N	2023-12-15 15:21:26+00	\N	t
55	Alexandra Sofronoglou	alexsofro@gmx.de	$2b$10$2hMW2J7noGhpSmDszeQdQ.HAUzX5zHWEEM2aaxF7aLAyw6dS.W5mm	1744662301511949043226107229137157417222242139119192132842001461201381492411359784208	user	0	\N	\N	\N	\N	\N	2023-11-20 08:39:21+00	\N	\N	2024-09-28 08:32:19+00	\N	t
83	Julian Lechler	julian.lechler@icloud.com	$2b$10$bD.vo9XN9IKKz10RQwaM.OIzoXPCCicv8lv.1TsRrkmP1vgguzj7.	2212312174011818541204621224639179382233217321120815774151101761644723825322621856179	user	1	\N	\N	\N	\N	\N	2023-11-20 13:06:38+00	\N	\N	2024-06-16 19:15:51+00	\N	t
127	Matteo	matteogk21@gmail.com	\N	3012717290232197251172522273659110227102331872341893229441281911852471874610255191174	user	0	\N	\N	\N	\N	\N	2023-11-23 12:53:44+00	\N	\N	2024-10-06 16:45:46+00	\N	t
289	Julia Schramm	juliaschramm02@gmail.com	$2b$10$qxGSlGoopjZfZ0bK16xbSe0IEm6OVveNZ7mwF1PP64tqIb3Z.E7YO	pnr9zh8fvkj8nuql88ot5p	user	0	\N	\N	\N	\N	\N	2024-04-01 08:06:14+00	\N	\N	2024-04-01 08:06:52+00	\N	t
275	Dana Dieker	dana.dieker@yahoo.de	$2b$10$riJe8SJAw6o1XFwZe26Wa.jw53Gg0m7v0FO/bU2jFeRRkou2CFili	18556806915615417916523218610810054762271201872812306116170200881412091316480228	user	0	\N	\N	\N	\N	\N	2024-03-21 22:28:16+00	\N	\N	2024-10-10 11:51:36+00	\N	t
222	MICHAEL Löcklin	michael.loecklin@gmail.com	$2b$10$4QTw59JhphScZFPFiZPNoO3YBF9ASVO5McYf.MYXHmAtxPo.Re/la	86h08cto8mpillik22167	user	0	\N	\N	\N	\N	\N	2024-01-15 13:39:46+00	\N	\N	2024-01-15 13:39:46+00	mimbxhyc9ad60h7n64t31o	f
82	Josef Diegel	diegel.josef@gmx.de	$2b$10$q/ycI02Mve.QNW7pOSsjZO6lP3353VF6bFNBSkOaduaaWtV239oim	2051941872492471082361672532534619122232361151562051272319086291081991365213312218	user	0	\N	\N	\N	\N	\N	2023-11-20 13:05:15+00	\N	\N	2024-10-10 13:27:31+00	\N	t
417	Isabella Reisser	isabella.reisser@gmail.com	$2b$10$KiTYniuWQB/1I./GeveL9.bLcumQrpImf659sypw5cNHWBBm6BhIa	111028177213159151323955203231515816120110131212402472141096318019242759519119460	user	0	\N	\N	\N	\N	\N	2024-09-30 06:53:43+00	\N	\N	\N	391956151233182190125482377246188919122224118111414928158481046010822589118155165	f
211	Alejandro Ramirez Guzmán	alejorg@gmail.com	$2b$10$zUysl3lGGndeQFDzkwaWpuxI3ME4O6h3OKWcxtm9ofIaR6hIcLJaO	5e01evi7g5jqho7dbets3t	user	0	\N	\N	\N	\N	\N	2024-01-04 10:26:09+00	\N	\N	2024-03-25 16:19:07+00	\N	t
223	Florentin wöhrn	florentinwoehrm@gmail.com	$2b$10$0YqgGk3KF4vb8PrfITDfnet8bCGDaCs94y67JNEh/D5SlSkrgQxEq	xiosmlulcbq4687waetqqc	user	0	\N	\N	\N	\N	\N	2024-01-16 13:41:01+00	\N	\N	2024-03-25 16:24:06+00	hhlzumhbrevewzsb0782wj	f
197	Marie Luise Schönfeld	marie4.schoenfeld@gmail.com	$2b$10$Hs/8gijn4d/RdmniVovRJ.mA7GNzhe8BVLI0bv88146DiJsp1h6E2	429523612941231502111014323318913736213104414914546301891362092381301213610377186197	user	0	\N	\N	\N	\N	\N	2023-12-14 09:27:28+00	\N	\N	2024-10-02 13:03:20+00	\N	t
345	Viktor Lang-	vi261lan@htwg-konstanz.de	$2b$10$ktUOjqw0WggKMqXiOR9ku.OYtvBfAe9xi78tZbEpdk9IL0E01MqQO	7162321651161881069122246214636941702471381441410679176144205213461242531971155158	user	0	\N	\N	\N	\N	\N	2024-05-23 12:29:09+00	\N	\N	\N	21112117368238702321905373111471161565631284924420627712252381414991169183130187	f
255	Bo Li	bo352li@htwg-konstanz.de	$2b$10$nKzLZh6YExf2tURRxQUO9O8dk0JC/Loa8uZXppUqJBJT5sG1ga5Pm	3123191207136123494197501252302252342232228147564222320015023618887189247381425487	user	0	Typ - Fortgeschritten Nivaeu 	\N	\N	\N	\N	2024-02-27 20:18:26+00	\N	\N	2024-06-03 12:27:47+00	\N	t
231	Elias Heppner	elias.heppner@uni.kn	$2b$10$s92KJ.aZxWuJjASCLcFdiOLhUpy5EA4BXTxHxRBZh3nmatZZzbO9u	odiso586ls5tmzgtcmnys	user	0	\N	\N	\N	\N	\N	2024-01-22 10:00:12+00	\N	\N	2024-01-29 10:40:50+00	\N	t
287	Julian Rucj	julian.ruch@web.de	$2b$10$cJFtpN2DjtpFGBMWrZUDmuN8N9tblUTQKzkSR2YpoBciq4Kv0Nmw.	11216237191212251291092162492482531931912172231821342441829240208351141651281664311822894	user	0	\N	https://fcm.googleapis.com/fcm/send/dk-jPJnkpQQ:APA91bEEXjpn9bMq0E-T6IRvnSN4WYX8My3T2OO74vw6A0cI3tTIotcHqEtlSTHVvxsT6KP0M0QUrqQdfNlMtj6OfdqVDCJMGDp9XrrOMbiviy05Fo5VYr6l9GQIobcMD566wupg4soI	\N	BPwT6ZgQwRULAw7V8NW_cS6xM3Z_PD6WlhehLKf3UzDeXoA2nVtGG5EglkzZ2kip5PLo-iLil21azoXmSoouQRA	4frpxuqWlB78n-xopA9FiQ	2024-03-25 21:10:52+00	\N	\N	2024-07-08 12:49:54+00	\N	t
220	Michael Schäfer	michael.schaefer@uni-konstanz.de	$2b$10$/XDR27dj.9KZBl2KpefsZeilFtiZ3DTRFg8tHqdap3hboWBuh29jC	i66gaa1m7kw55aqtztx3b	user	0	\N	\N	\N	\N	\N	2024-01-12 17:01:13+00	\N	\N	2024-03-14 20:05:27+00	\N	t
30	Raphael Manno	mannoraphael@gmail.com	$2b$10$0w9nOvYbVFqDDc/JwmmKpe6faiWfmpy57fuXB403p77WA7335oWfi	5a4po4bnga8wz7j90s5op	user	0	\N	https://fcm.googleapis.com/fcm/send/f2IrjTUd3g0:APA91bElOaS0mVR_-3L-1Qlj1qtHinVIbuwhEFJfANaFmBTN6oTNZQ6gMDFx7RRyzDzfMpOtQKrrMLJsRYuJcMDSM8OEpncF1_7pUQkZmfDerphR4uOnhQ158MQNviqxP9lSigguZWzM	\N	BFioSfymke-cYlt5IafIDpVbCxgBWMUdMPX1UdVr3wJCqowYigMvlG03YG1zQCtNZIyGGc1UTFDGxxS16vXsJ2I	7LwujEjqmHnd_MfCKO_0mg	2023-11-18 18:51:59+00	\N	\N	2024-04-15 17:59:48+00	\N	t
332	Tao Min Kuan	taominhquan2004@gmail.com	$2b$10$niJVzVDVIxXCQIY7VVWyrOjwm.SoUX72dUyd/Fag/zDVMm89EfoL2	5s72ufazo6lhb6gavcek25	user	0	\N	\N	\N	\N	\N	2024-04-25 10:41:44+00	\N	\N	2024-04-25 10:42:22+00	\N	t
341	Milena Schuler	milena.schuler@uni-konstanz.de	$2b$10$XNvtBXWYjmTiNttOnwRZVuFke6GNVnL9QqkODqdhNPfX8oxHi6oqS	1671542371482126712725321881452616515524817515621911940241431465039769348104158249	user	0	\N	\N	\N	\N	\N	2024-05-09 10:14:42+00	\N	\N	2024-06-03 15:48:08+00	\N	t
258	Lana Oesterle	lana.oesterle@hotmail.de	$2b$10$pm2Mb8Z27EqNEQmvyCFFvuXbdNcVzd88MxWHU31nvGUJ6TYJ.ETrC	3422111114410117624611282235177522193218454254187562411171271042212218721624711917878	user	0	\N	\N	\N	\N	\N	2024-03-07 20:07:20+00	\N	\N	2024-08-15 21:21:19+00	\N	t
80	Jan Schlegel	schlegeljan@yahoo.com	$2b$10$vJjrVYw7lo8eptcjVwAQ7u6ffyX/IEuQgq9mQM2UF50MvFVINddcO	rjhyoitdwhh2ob14o79f1h	user	0	\N	\N	\N	\N	\N	2023-11-20 13:04:20+00	\N	\N	2024-03-18 18:37:56+00	\N	t
293	Maurice Dürre	duerre85.1@web.de	$2b$10$xj1262ajDazjbPkfr4i/CO/Zp.bYYf3J5ZQVg2LNvREImdnGeZZTO	m5mf10x2nfa8fr8lpg9g6	user	0	\N	https://updates.push.services.mozilla.com/wpush/v2/gAAAAABmFRi9Th80oHC-h3l8BASSZrwxac5F1bNIHphkW5SG3dY-yOFqR3_jkv6R_w3BCiBa1s9cvhX0UxaIqZaxJL9fF0k-cVXdJbmQjBvWtOkzR8Cpx_9kfKqFKBz16j9Fz3FoYAK-28Ra7ykgiyHtO_lVim4BLO3NJ0exvCYJDUWc1rcXlvs	\N	BDcm-MnlhCrZRaCq0VhQ6DUJmgD8VxQTtjmwg_kOXVzV_O5txLgSjAMuilyL4DDMilQXSvpQPRNTnFRmmc15ZNA	UQOVWigruUM701uRrhGDAw	2024-04-02 16:55:48+00	\N	\N	2024-04-17 19:10:34+00	\N	t
236	Marc Lindenmaier	marc.lindenmaier@outlook.de	$2b$10$xJ6YSlNdLU2sKqg3uSjIWuLsPgDKRz.y5xi3Nn4/HYj4uyQUSDYsu	72103459511714823983299483761726268861454912223925257979017951412322723322918	user	0	\N	\N	\N	\N	\N	2024-02-02 15:05:08+00	\N	\N	2024-10-04 07:01:02+00	\N	t
451	Jakob Fendt	jfendt40@gmail.com	$2b$10$RJ8ESkn.LESiTi0.bXO64eH62/9nlYUyHT2qq.m9X2aj2jjuXWf56	69286987103106215801912101552282441777215199626720412224419043136135219200119214187	user	0	\N	\N	\N	\N	\N	2024-10-06 13:38:54+00	\N	\N	\N	199661498417215393789815122622884392211818696250691687883206195250228233111156203	t
245	Esther Eydner	esther.eydner@web.de	$2b$10$m166Qvc0H.8ZAt1HhKrobOVTF9OKoVsnDil0r5.h.JrZzvH5wpr32	ewe1j0e427nrqrqmcgmya	user	0	\N	\N	\N	\N	\N	2024-02-22 12:06:28+00	\N	\N	2024-02-29 19:12:51+00	\N	t
239	Ahmad AL Farhan	ah.alfarhan@web.de	$2b$10$jSIB6wK/xzSn0mAQzwe54.vf4fXjPJEU.GsRq8xaXniofFdOX62ZC	fjti573vo9f6y7ljasupmt	user	0	\N	https://fcm.googleapis.com/fcm/send/dMiZxeoS2EQ:APA91bFMA56sfgWqioN-cClCTqBdrUupMsonD58s-19vsxdoizv-gTobXzmmnpiR0G_PotU8V9joxGzd6np-0p_XUt7NQcbVDdCxl6b-3_ZbUFiB64sGho601qFIJn5y_wqkOWPFC49e	\N	BJMikOh_aCYI6y2paEwBk6PKlZSdYmtq__HD9MvxZ21buJvqsMRzBoueiQIfuYNee7gsLRJ4Px4DnNS9haipsE4	49cft1KmWGPqMBoaZM7new	2024-02-09 01:23:10+00	\N	\N	2024-02-09 01:26:07+00	\N	t
254	Fangyi Cheng	fa871che@htwg-konstanz.de	$2b$10$Uf1F23qe0m3.PyeMZzzmsea6mFOpDDkdJqfyOTMGqdZJ1IOH4bYBy	206142219222594419116221908721102412032502534323994881992191248271013218056522	user	0	Nicht typ - Fortgeschritten Niveau	\N	\N	\N	\N	2024-02-27 20:09:19+00	\N	\N	2024-05-30 11:06:25+00	\N	t
333	cami vega	camivega401@gmail.com	\N	okytf5153cu2wenqkg4pb	user	0	\N	\N	\N	\N	\N	2024-04-25 11:39:40+00	\N	\N	2024-04-25 11:40:29+00	\N	t
240	Liv Reinalter	liv.reinalter@gmail.com	$2b$10$UARmjsDVoN8dtpmQ6GiRoO2mWU0Va/pszMQfYo2CRX10hLUdl/7XS	iyxsfakfjadfny42bje45l	user	0	\N	\N	\N	\N	\N	2024-02-15 12:01:32+00	\N	\N	2024-02-15 12:02:23+00	\N	t
316	CallMeNiko	ichspamdichweg@gmail.com	\N	21p4bmscaxs45v3z61io1r	user	0	\N	\N	\N	\N	\N	2024-04-18 11:31:50+00	\N	\N	2024-04-18 11:31:50+00	\N	t
250	Pantsidis Konstantinos	konstipan@gmx.de	$2b$10$ccUBgwqp4giRRY3D6NFcju8NRoFVoK5n0CRdNHpdPqn3UJniknoiG	03t786xqwv82am8iojscwq9	user	0	\N	\N	\N	\N	\N	2024-02-25 00:03:08+00	\N	\N	2024-03-02 20:27:35+00	\N	t
310	Emilie Janeta	emilie.janeta@gmail.com	$2b$10$4dKt02qjstFWFFvxx31PkOPu0euQFe7MzV9pgrLcSYHOvXJR8kYzm	3vrd0f7sdwjdeqarwc7s7j	user	0	\N	\N	\N	\N	\N	2024-04-14 08:12:39+00	\N	\N	2024-05-09 11:05:18+00	\N	t
295	Linus Schoch	linus.schoch02@gmail.com	$2b$10$1HtCjakzb4t6GYuj0/gGFeghBUcozsVrjRpVYTvkn5KhElpNsHUQO	31rs225tp7acqhhy09uytk	user	0	\N	\N	\N	\N	\N	2024-04-03 21:35:53+00	\N	\N	2024-05-10 07:57:34+00	\N	t
226	Marie Sophie Schmierer	marie-sophie.schmierer@uni-konstanz.de	$2b$10$5gPe2sRamUjV96JKwjeLMuCzhWJvD7WmEiwO2dSNoJrJ6gO8XqD2i	1516117413519414779824717439612622592451016616964128141163113121238514597214129	user	0	\N	\N	\N	\N	\N	2024-01-18 16:36:33+00	\N	\N	2024-09-30 14:47:58+00	\N	t
246	Till Messerschmidt	till.messerschmidt@gmx.de	$2b$10$1R8S450N8OgbZmpz/LSoH./WnRofZAgFtCNtHN23Xmi34WDtnmARi	wnjmi120lfar573nqtssa	user	0	\N	\N	\N	\N	\N	2024-02-24 00:49:47+00	\N	\N	2024-02-24 00:50:50+00	\N	t
249	Clara Jeschka	claralilly.je@gmail.com	$2b$10$67PDQD3ECK5z3w4pK00.ge0KKo5SfEeU3bJDLyi9dXIcSOy58d0qC	ihavh3lcdl4fvl37qnhe2	user	0	\N	\N	\N	\N	\N	2024-02-24 21:24:07+00	\N	\N	2024-05-14 22:26:44+00	\N	t
244	Luca Dziadek	lucad@t-online.de	$2b$10$JmkxT.//mQaZhE76GIXG5uYJg6yr8U8KGSUMrxwD6yxVsYvlThyw.	b7p1594ob2fal1adzexqll	user	0	\N	\N	\N	\N	\N	2024-02-19 16:18:18+00	\N	\N	2024-05-18 10:26:12+00	\N	t
248	Noah Glock	noah.glock@gmail.com	$2b$10$x8tZjhzdnf9DQob1jq.dMeaUoEIX93Bc9UakxBzeYlESOSSgos81e	w2r493r2uedrsuqvulzdh	user	0	\N	\N	\N	\N	\N	2024-02-24 21:12:29+00	\N	\N	2024-02-24 21:12:59+00	\N	t
342	Tuan Quach	lucatuan9@gmail.com	$2b$10$t7baWDcCi2DRkzaupFVdm.V96fgEN1CtmFb79Qz9yebZk0Uspl/hO	22169622122191442169141239172715913725511310857261561042469317122011514615016415222077	user	0	\N	\N	\N	\N	\N	2024-05-09 14:39:29+00	\N	\N	2024-05-27 15:31:57+00	\N	t
346	Minh Tuan Quach	quachminhtuan18@gmail.com	$2b$10$aOiwTwOkJ0KFTmueDpBIAOovoVRSGb428xbP4lUIY3sBmLnLCowti	70102112135144211215157163151662491172119217213052114232233119222495831011131941210	user	0	\N	\N	\N	\N	\N	2024-05-27 15:25:19+00	\N	\N	\N	1236852307714757372481051794102513215913264844114274817119410021210920440151126	t
247	Max Heim	max.heim98@web.de	$2b$10$zUkQb6qBZr5/gDQ6k59Vhui/vjVvQVk6w5uveJZQ/D2W7pnwLveoi	glcuok5gsgkojaferl682e	user	0	\N	\N	\N	\N	\N	2024-02-24 09:15:10+00	\N	\N	2024-02-26 13:01:50+00	\N	t
317	Sebastian Bruns	sbruns00@gmx.de	$2b$10$3KvXHAeP7BmMWArF79e3lur9acQpcbwa.L/i8IqjSFtjiNvrlFRoe	356djesz7wm4uwt6s5uade	user	0	\N	\N	\N	\N	\N	2024-04-18 11:47:47+00	\N	\N	2024-04-24 18:17:24+00	\N	t
37	Laurin Bauer	laurin.bauer@web.de	$2b$10$Lo69YsGvLNL.HJ/BADssHuHAHLT5UPCq1VeQmp/pLgkvfW55EyVRq	22415314071147821634623011112953179891061881052241433972772135517635682614510330141	user	0	\N	\N	\N	\N	\N	2023-11-19 10:35:38+00	\N	\N	2024-09-27 10:30:54+00	\N	t
182	Hendrik Aiple	hendrik.aiple@gmx.de	$2b$10$pPBN6bdvljgt.u4H7b6wT.OmRlmL7HZPowGhFX4gbcPzzOIH2/Fdq	22718118010436121925090581622683202130200147241207116154612210542194227183163213216	user	0	\N	\N	\N	\N	\N	2023-12-07 16:23:06+00	\N	\N	2024-09-30 14:09:42+00	\N	t
266	Nina Karl	nina.karl@gmx.de	$2b$10$Yn0KqOPgDTI6kfC/od7XvO4E2NLou70ihNfitTx6Kkji9GQSVmzG6	35182945513917816582122412971185214411198284118107024915612121091851769089243	user	0	\N	\N	\N	\N	\N	2024-03-15 17:48:19+00	\N	\N	2024-10-03 15:33:56+00	\N	t
286	Anna Rankl	anna.rankl@uni-konstanz.de	$2b$10$9xudmepefFRD13py69GcsOPm28ZcnrWEQ5hWx4DJhdvDikOvRlkBO	ugs5waognoooeraa488ak	user	0	\N	https://fcm.googleapis.com/fcm/send/eoyomjXh5tY:APA91bGglcKbBq8v2ZkdS1IDQ2SSfDNIY-NWpt96xnNOClpD7ml7qo1KK_KGCayWLwzJaw7W1-miKAMm4jqVSyoDTbJUJ-DnaXjV2Tzt7e9SRITlLnRuwbm6EMToAxYXkYjMXzSXV7w5	\N	BPC1h--eDBdMXCiHr7AQT62HCviAsjKXE57Ipb9di_q249Oga6UiHVxQWMVBYAjAqnFpw93QXTKEEnrCrEwTDnQ	5kkvpd0nJe-DtIKWOSQ57w	2024-03-25 14:51:06+00	\N	\N	2024-04-09 17:27:22+00	\N	t
350	Katja Luisa Kummer	katjakummer@yahoo.de	$2b$10$ieZr7dwgn2rtrp90QYrNpOutYlcQK9qVrZbTvshKBpw463TkH0XxS	184178431473416212812719911317818173209108249126232218127159971225117319213216995173241	user	0	\N	\N	\N	\N	\N	2024-05-31 07:52:17+00	\N	\N	\N	3371316717615471488621229233471481542532141791323027345915218316813124463232134116	t
299	Maya Iven	mayaiven24@gmail.com	$2b$10$74bpxhgyHGrK7gUMC0Rdl.g4GYrZdGfLaZY9pajyLnbG0BOoeK0KC	zeehyff7vdmjkkz9tedub	user	0	\N	\N	\N	\N	\N	2024-04-04 20:41:19+00	\N	\N	2024-04-25 11:03:17+00	\N	t
268	Fabienne megerle	fabi.m96@gmx.de	$2b$10$K551MZKnWY2BoOkyFpEsc.2Ats5sBTLEo6GXu8t2Siac0T43nK8R2	19515119881158718245321944124104451371471012101492002261061821721676660141208135240127	user	0	\N	\N	\N	\N	\N	2024-03-18 19:34:48+00	\N	\N	2024-10-09 20:24:43+00	\N	t
366	Arun Chander	arunbuull786@gmail.com	$2b$10$K6TAosMVu78XRvoPSOxh4.BKrkVJgny94JMEznCuGdoI0mBxssZsm	1081696716810515557509247201618814311985101226172185691193221206244292052512288091	user	0	\N	\N	\N	\N	\N	2024-06-21 16:31:17+00	\N	\N	2024-06-21 16:32:20+00	901413315513718440225157164546493552472506587211144421632082422351532381413410523170	t
44	Mailin Keller	mailinkeller@web.de	$2b$10$tdujfZk6A/aj8mIliPUNPuqt86W/Mgtol/ghz01FHc9BG.CIAw/wG	1041624021101471086525225524224491415924311919225194853018222638921022312310321653	user	0	hat eigentlich 1 strike	\N	\N	\N	\N	2023-11-19 14:16:23+00	\N	\N	2024-09-14 15:12:34+00	\N	t
276	Siriguine Chongkavinit	sea.chongkavinit@gmail.com	$2b$10$1i7690.bAXBLmb6IV2pkWeah9sdMLBCxnMqhATDAVu8RDZ46cMWEK	10097452855243235235149192226833025311724611319531251351171301781621446519013620151165	user	0	\N	\N	\N	\N	\N	2024-03-22 11:20:44+00	\N	\N	2024-10-10 11:52:04+00	\N	t
269	Paul Rilling	paul.rilling@htwg-konstanz.de	$2b$10$Q0VJQ.bUtkzKnqFgeCi.IuCxCQYs5jSvWp7L9I1C2/.YotIRwz7oy	q59ycy1yxv93qxvrjdf7n3	user	0	\N	\N	\N	\N	\N	2024-03-19 10:49:09+00	\N	\N	2024-03-19 10:49:33+00	\N	t
305	Moritz Weiler	mo682wei@htwg-konstanz.de	$2b$10$mJkEFKKLeyrrXmVOqJKOn.U4R96tkeDq7RWKIQxeHHkdIfAuuNWFe	5y4mo1pwcjciem48mc1rv	user	0	\N	\N	\N	\N	\N	2024-04-10 08:23:25+00	\N	\N	2024-04-10 09:21:17+00	\N	t
105	El Manu	ma871sch@htwg-konstanz.de	$2b$10$VCTxX0.DV0XFASyNKw8RWu7jz5chLwrRSNJqIgOdLWyhNH9OO07BK	2vgbsne8a4ebu7yl9tc569	user	0	\N	https://web.push.apple.com/QDISePZ-pZHSpfomi4GABrRzsOTMyHeQNgTMDPQRQkomYRcr7YlLST11_x-cTzkzGf3_9KB3Vwb6nUcuD2JUnRW9m2KhLegQnAYEIFBPf4fA4mgdbDq76VT7YPVKXey4YMjfRKzvBc3ymxCossA3fsxKX2TsrpA_uG9c2fwYViw	\N	BLUGTdSFx-IFbs4IBAWtZjnU3jEMnmmT0KUtsUMzppmYThBj7SqhagHq17aPQQoYZWM7mMZ6lNNw7BHeUN2TyKI	ElWdvZZfKGj5H8ZdzBaOPA	2023-11-20 17:12:48+00	\N	\N	2024-04-16 14:33:38+00	\N	t
271	Florian Fehr	flo.fehr@web.de	$2b$10$bKOXwWuDafjSbSz4pEbiLOJL4S1xNyGJ3zzzTk6fFCM4FiZqHOw8q	7jp9ppmfin9178qelo2025h	user	0	\N	https://fcm.googleapis.com/fcm/send/c8_kQe205rc:APA91bEZVmYQs5NGZ6rnBFcYAGjZ0RybYY6xd0IkQlMSSA_qqZt4WCLmnU6P-2jyaqU_WY7P99a8XapE4mBmW6FESau833AvbztMqoHyfOrR3jYn9LwWaL0dDu9tMnymyG-elhL6DAQH	\N	BPxxi-RUTDT5ZJ0TaFeZih8yGHbJPjCQwfCXl7Jp1UMQCQZld1TOOy2fxcJ58phaPsPMXLFra0pxAI45f2EZ7H8	2LgP0zhydaX1Y5Q08g6sXw	2024-03-20 06:55:25+00	\N	\N	2024-03-21 15:36:09+00	\N	t
335	Maxine Roesler	roeslermaxine@gmail.com	$2b$10$zkRwgUl5O48EQmsaxk23muyZTHTne2ce3MLOL3ONUJXOIZBzqPxDS	4v2xpd0cdhhknm7paw777	user	0	\N	\N	\N	\N	\N	2024-04-25 12:34:21+00	\N	\N	2024-04-25 12:34:36+00	\N	t
336	Prykhodko Vladyslav	vladyasimus@gmail.com	$2b$10$bKu5Nv4mdffI1HqdLz.09ufMJHpeafzpb5JKCAF.8VHFifa/xUd5K	ius5hsn75mc6y8zxi12q3w	user	0	\N	\N	\N	\N	\N	2024-04-25 13:45:59+00	\N	\N	2024-04-25 13:46:50+00	\N	t
270	mc BG	m07c05@gmail.com	\N	ajtxzd5jmjjkpibagbwqxc	user	0	\N	\N	\N	\N	\N	2024-03-19 18:57:31+00	\N	\N	2024-04-11 09:23:52+00	\N	t
280	Daniel B	da871bel@htwg-konstanz.de	$2b$10$sltZUbuPfDT.NNMW1aN1j.lQX95EaF9jwua/Xv9TTON.TNihkPuo6	fvdhdjzftede87jenflq5m	user	0	\N	\N	\N	\N	\N	2024-03-23 08:59:04+00	\N	\N	2024-04-25 14:09:23+00	\N	t
334	Davydenko Ivan	zaxidnani@gmail.com	$2b$10$33mAYJ0pOHrMUwBmyzBLv.Nq/qkTcoTuydXw/So3WdyRTMnjTNn9q	egh8qrn754jdkakz3qs54s	user	0	\N	\N	\N	\N	\N	2024-04-25 12:14:59+00	\N	\N	2024-04-29 06:44:35+00	\N	t
360	Christian Pauls	christian.pauls.2309@gmail.com	$2b$10$1pPlBY1f4N1NDQaP.A0g0OoKZ81Vn0PohoB0h66von3KoU9iajBHq	932231891961541441431619719610913911249101204242442542642234691412814819011713810240	user	0	\N	\N	\N	\N	\N	2024-06-15 10:26:16+00	\N	\N	\N	781871761616094166249337981411701942274981231011358218207128235122255134203149193124	f
278	Sarah Palmer	sarahp_01@gmx.de	$2b$10$sac0tx7HMVRSwJLCd2fX6OdKLzlMDkcWN2naQq3I1g9eWmhQNyR5W	2493utql17chcs0hr684nf	user	0	\N	\N	\N	\N	\N	2024-03-22 12:10:25+00	\N	\N	2024-04-29 08:23:21+00	\N	t
99	Michael Ott	michi.ott3@gmail.com	$2b$10$ylSW3nz8BqGV2so7Ta/hRuUAOQLhas5vt8E0dqsbbNv1ZXB5nRJRe	vssyf1ybdzd77url0ic57d	user	0	\N	https://fcm.googleapis.com/fcm/send/dW5FMteSOb8:APA91bFi6mqU4B9GboTeUsjwIzRAjSD1dLYactGYPzS5bDVP8nVK2pjF3zN6tPy2N9X02h-agrtp6PlJ8jfR-lWU096cf8wG7taCv9kfJ8mU7DvKwb5ApNBCmiZyh_rT7d0jpOn_TMm-	\N	BOnSWztmod5lC2tA_m0hp8c05RBSPRL8YrnsYBbap9G2yp-Eg-L0FJMqy7R_avmDEYVFCKlYsoKI6_bxITl7YzI	VakTONXFnHTNRAjpewfOaw	2023-11-20 14:14:27+00	\N	\N	2024-04-29 17:01:57+00	\N	t
77	Timon Ba	timonbartmann95@gmail.com	$2b$10$Bn3u4ieDwK24PkVNC.VsXeHY1p9AKvZeYbZfaXtNTB1sssyAuXlvW	2341867414822118917919524827102517322196672212471985983172211104901109164181143120114	user	0	\N	\N	\N	\N	\N	2023-11-20 13:01:44+00	\N	\N	2024-09-24 20:25:58+00	\N	t
281	Lisa Kuhn	lisa.kuhn99@gmx.de	$2b$10$KhaVv32BlUuU/ka1apzXPOpVS9BA0n7PXnQO36dDl57CrzDSAq9T2	mvqc0lpfgjqjkhwus9hfrn	user	0	\N	\N	\N	\N	\N	2024-03-24 12:01:40+00	\N	\N	2024-03-24 12:01:58+00	\N	t
282	Michael Rueß	ruess.michael04@gmail.com	$2b$10$WSO17hD3JASRQikeOzyrUOTlH2uBoNEXGQ2VVjHDUX.CmsLLWljCS	66hqq7m2m6gs32kzcugfe	user	0	\N	\N	\N	\N	\N	2024-03-24 12:03:55+00	\N	\N	2024-03-24 12:04:14+00	\N	t
277	Nicole Tolkatschew	tolkatschew.nicole@icloud.com	$2b$10$1KKS6IWlcSYS3TvN6eHUROzLYHPTLcQ0TXCOuOjYjHbRwvbOrPx2C	phjwmqp9ypevdrdk85pho	user	0	\N	\N	\N	\N	\N	2024-03-22 12:08:52+00	\N	\N	2024-04-07 21:20:39+00	\N	t
272	Luka Lili Dörfel	lukalili.doerfel@gmail.com	$2b$10$t9ovofKHvrIZP0DTBVCPg.8O9m3vRAIDSpQ4wEgdFMOEiDGQxSk7m	6bhqoz3sgtl70wn34bufa8	user	0	\N	\N	\N	\N	\N	2024-03-20 07:46:27+00	\N	\N	2024-04-15 10:00:04+00	\N	t
318	Jiang Lingying	jianglingying904@163.com	$2b$10$NJxZP7PZ9OJFav2tKbK8M.2Qsi1HRp4GdVlrUN9wbC3JjL3Yo66Z6	qx1416puhcbrrqnqu3f5w	user	0	\N	\N	\N	\N	\N	2024-04-18 11:59:02+00	\N	\N	2024-04-18 11:59:51+00	\N	t
309	Mark Reinholz	m38reinholz@gmail.com	$2b$10$TuE.UCdonvYh5IxT0HbH8Oc3pOLHrf6QN450to7vUkQOA8dIVNLYK	ueo8ywf6z09c2wnmru1ot	user	0	\N	\N	\N	\N	\N	2024-04-11 11:00:08+00	\N	\N	2024-05-06 10:06:27+00	\N	t
301	Matteo Beutel	matteo@beutel-kfz.de	$2b$10$37PJ84CyXrbTKVg5fxZg6OuKRLE0pZwJvj9g1kCIIs5DdMx8FQyF.	mwe5gm8k2sqciypor60t3d	user	0	\N	\N	\N	\N	\N	2024-04-05 20:10:30+00	\N	\N	2024-05-12 15:02:46+00	\N	t
324	Jakob Sommer	jakob.sommer@uni-konstanz.de	$2b$10$06jvHjgSgmIQSfNkYEaqr./1sVMAanUQmxUQzYAftTnns4QIOBa5a	xy2rc6jfroi261rtfg6riu	user	0	\N	\N	\N	\N	\N	2024-04-21 10:51:19+00	\N	\N	2024-04-21 10:52:01+00	\N	t
297	Marko Barnjak	marko.barnjak00@gmail.com	$2b$10$/7EaALml85BZPjyYXfP.e.2bnednb2jOB.1Ijys2Clmv/xKvsp43O	1148234252819323824713236102220112135821591342521311811515859389132787212586164163	user	0	\N	\N	\N	\N	\N	2024-04-04 11:48:37+00	\N	\N	2024-05-28 10:29:10+00	\N	t
290	Lea Haxhija	leahaxhija@gmail.com	$2b$10$lyl66XDk2EAuChj2/kftZeL.yDEiYGvLE3xcyv9qik02wWGEh2IVi	thmotdynwrkgixh53me316	user	0	\N	\N	\N	\N	\N	2024-04-01 11:02:37+00	\N	\N	2024-04-01 11:02:48+00	w3xtkvi2lkidcnxkieiqhi	f
373	Felix Mati	fe351mat@htwg-konstanz.de	$2b$10$RWJXHANFK5G1DvGleP0w.u29ipA/ezmmIw3n1zYqd/xQIIPjDGSb6	7636672466201456819222452210425425213013613818230637875319134813914111413636	user	0	\N	\N	\N	\N	\N	2024-07-08 13:13:09+00	\N	\N	\N	82082171031631602321481708318631941426414413410411149209143242167528119216010961126165	t
412	Eva Wehrle	e.m.wehrle@gmx.de	$2b$10$Pq3EYQb4pvVMMAbLOA6kgu5APsFr2TGiMA.9vowyDzkFzy0ZpxjYy	1320142191893525096112226114134777760169482203013542291891151231311537246247	user	0	\N	\N	\N	\N	\N	2024-09-29 09:21:42+00	\N	\N	\N	21016020856172271201116437233126151130102453413615095341723249233351291173114158155	t
273	Huijjn Ma	mahuijin610@outlook.com	$2b$10$igud4KAIvWBMUkcL792/GOJpYZxOOweiMkYvjBQJuHmOdpi9KIjk.	12621919161881712482291792211167103612284813059142651096965178142206163236192241	user	0	\N	\N	\N	\N	\N	2024-03-21 14:53:22+00	\N	\N	2024-10-06 15:07:26+00	\N	t
379	Hannah Memmel	hannahdorom@gmail.com	$2b$10$2boFE589K9Blz0n44pjYduC8JeC98mFj52CaN0hXXpKRL8oqbn9S2	1921851212721318284153147899153641492411051134242716222520311620376708911912285134	user	0	\N	\N	\N	\N	\N	2024-08-26 16:22:29+00	\N	\N	2024-10-02 21:39:53+00	24225335543520673368210722222115639169188899745561209420779644715413115878143	t
296	Franziska Deubel	frani@live.de	$2b$10$mwvlVXV5Xb4ehdSD8vuoi.tspnklYej3B7BiPyji9Ve8fsnl1QHGi	16217944822171508965702171971951311351022372059214936722541641781071422961188113170	user	0	\N	\N	\N	\N	\N	2024-04-04 10:11:46+00	\N	\N	2024-06-12 12:19:59+00	\N	t
338	Niklas Danner	nickdvomsee@gmail.com	$2b$10$PMr.aj3HFDUuDJt7I4..puwspamzx7ybxRU.hvhLzG2IWfA/6xZGa	9419122017713024782170198188130435424274115822815122226105252242223217103242153105247	user	0	\N	\N	\N	\N	\N	2024-05-02 08:57:49+00	\N	\N	2024-06-14 18:50:06+00	\N	t
173	maya dauner	daunermaya@gmail.com	$2b$10$VunoFIniHib4U5ona1VniesYz2ONxUGrP8XkFeOwXspwvoVFHz88C	18801871914012935182244166682132141308818518842122255819699211122468111013199120	user	0	\N	\N	\N	\N	\N	2023-12-03 19:36:48+00	\N	\N	2024-09-19 11:11:51+00	\N	t
300	Jana Gänsler	jgaensle@htwg-konstanz.de	$2b$10$1Kak.qXGPS06dWfHDx4Z6ep./qr.AGjh3rAHfa/4z0o5m8KAJHuIO	76wa0f2huqvk9lp8yiklso	user	0	\N	\N	\N	\N	\N	2024-04-05 06:33:54+00	\N	\N	2024-04-05 06:35:14+00	\N	t
13	Sofie Haag	sofie.haag@web.de	$2b$10$ry22moDjqBfq/s/ZVweFy.bSNjoAN/h7Ep7UUm7TVD11SfO06ASQ6	24413019917167283116420714613190522102331502181401860921451756172418118414069173107	admin	0	International Relations Manager	\N	\N	\N	\N	2023-11-16 18:39:21+00	\N	\N	2024-09-26 10:21:26+00	\N	t
337	Christopher Parsons	ch871par@htwg-konstanz.de	$2b$10$MVqbjeVE3iz5epZ.0hhsNeZfH.EcFGZzAoi2zsETyhtbuRQ9PzzXO	s0ov0vu5ypsc4444s7pmz7	user	0	\N	\N	\N	\N	\N	2024-05-02 06:17:24+00	\N	\N	2024-05-02 06:17:58+00	\N	t
308	Mia Noelle Tanner	miatanner50@gmail.com	$2b$10$0HIlud4//L/O5uRFx6nkKuvmG4K8meUmic8BtR6BTP6aQKq8RCQ32	r54xden2xtn18qdf28go3wh	user	0	\N	\N	\N	\N	\N	2024-04-11 10:46:11+00	\N	\N	2024-04-11 10:47:47+00	\N	t
307	Hannah Funk	hannah.funk@uni-konstanz.de	$2b$10$fWHMbKPxTfTSvevwfFSB1OigfKvMyulnStraIMAUbZtc/HP6Mmug2	2hskqtv04fq0qdha6cg8f6	user	0	\N	\N	\N	\N	\N	2024-04-10 23:20:42+00	\N	\N	2024-04-10 23:21:34+00	\N	t
319	Jul Lührs	j.lhrs@icloud.com	$2b$10$IOePZvRjzwfhnwFzrULMTe1lEGVYUs5hjsQIk.uz7tCZJwmY/1IQm	eii6efzd0gn2n353o3oxsh	user	0	\N	\N	\N	\N	\N	2024-04-18 13:58:24+00	\N	\N	2024-04-18 13:59:32+00	\N	t
302	Aurora Bytyqi	aurora.bytyqi@htwg-konstanz.de	$2b$10$ktxcSCe859AH4jdExLbAOuphOdWSjjN.Xnr/IdU5CS0pV8iKrAaoS	173319349123159152155218156152146112703516513314710723351124202446789394610190188	user	0	\N	\N	\N	\N	\N	2024-04-07 20:40:16+00	\N	\N	2024-10-11 09:15:06+00	\N	t
315	Mona Krenn	mona.krenn@uni-konstanz.de	$2b$10$MuKOGwHqcYJgL1QxSOpl3uCde2byzFqN1nIAaakS46nNX4BDz2qA2	1095412213072201231183162211177372901877260153206564920625031691812141581158026136	user	0	\N	\N	\N	\N	\N	2024-04-18 10:44:40+00	\N	\N	2024-10-14 10:58:04+00	\N	t
306	Vanessa Gehrer	vanessa.gehrer@gmail.com	$2b$10$IswHTyjQsgd.O099J82q9.3zbdPTP.du8D9et8H8Ne9eWD9d3EyCW	3mdqnejmdlkmhdk7wfdogf	user	0	\N	\N	\N	\N	\N	2024-04-10 18:06:50+00	\N	\N	2024-04-11 13:07:36+00	\N	t
265	Cynthia Hering	cynthiahering97@gmail.com	$2b$10$hDj.k9tvO0ew5bONlVO1z.DGe16twW63SE6U1My/pxqXhwu.F1jAu	bd5o6x5idxwgjmlpvvy7or	user	0	\N	https://fcm.googleapis.com/fcm/send/dzun8MSi-5M:APA91bHljwZ90UNbCXY4trLp-VHHyKk5ffBUtZ4CY48A5ShLUicxzUacpYc1gv0WdEAGdIPJKvbMdMT2a6EQCEdyAFVk_gfwv51i51idDThCcAMCQ8fWk9QD9PUDjnqAMDXcLL5meAoF	\N	BPSVixiDhdhI7O7bzKY-rMKQXBDMuUg6-WC8LgAI9Qi5TmApPXdbpe6W1xiH4O_IZnNVm0_LM9mmwq7sqPvClow	jLp32tN_oPqycoXhXpCrgQ	2024-03-14 09:53:26+00	\N	\N	2024-04-18 16:36:17+00	\N	t
24	Nina Thiele	nina@thiele-world.de	$2b$10$JexaKqt16eyVd9KwnnoOi.uiFoW04wPZhA3jgydaGg.k9ThfMqw/m	3aes7ogjmsis8s70jmcyd	user	0	\N	\N	\N	\N	\N	2023-11-18 16:08:39+00	\N	\N	2024-04-12 12:55:41+00	\N	t
320	Luis Enrique Morales	luisenriquegaming@gmail.com	$2b$10$cXEoLpjPnaes7Vf0jkLKAuxit7Qd5am1LqQ.cGdR4d/Z.cOh9.yoG	an4tjv2awzjagb1zt3p4lf	user	0	\N	\N	\N	\N	\N	2024-04-19 07:35:44+00	\N	\N	2024-04-19 07:36:06+00	\N	t
279	Nicholas Hinterwaldner	nicholas.hinterwaldner@outlook.it	$2b$10$anyhlChUpKi2Y5IMtq/id.gH1Mw.zxxAMHhhTUWgNxvy9tU/as5qi	ugawht2xuuzp0h9wpqiv	user	0	\N	https://fcm.googleapis.com/fcm/send/cgLTpZExpTQ:APA91bHekoPnBCQSHy_EOTqm9XGJFl65KyLCNGCTeD_O_0GG6Ihnsb-1Fsbbauc1WaPje7wPg8nfmwBVxJ8YZ4GyjVkDn41ujinK_TQwx-qxYClhNBPaLdD8U1V0uFjGgp_kye2r8ABc	\N	BPrbIlbAr9iLmZlGFoZwhgay-QhcL1KxENI9cCsBB-r5Y2bblfZte2-_Ov5vhjADD9AhK_KEYZqTuMQMj-XA_4o	Gcaih7a-Z-CMBxIxDf5KOg	2024-03-22 19:58:06+00	\N	\N	2024-04-13 06:45:11+00	\N	t
298	Silvana Holz	silvana.holz@web.de	$2b$10$j/jrXvkU/0mroyRED3wkPuCP6819OO5A2hwFOZLYnV42.6ItOhk4S	14014010919810337791261091082294918953162171312354114230991501531938124497223652423	user	0	\N	\N	\N	\N	\N	2024-04-04 12:52:51+00	\N	\N	2024-05-30 16:28:15+00	\N	t
311	Nils Dangelmaier	nidawa04@gmail.com	\N	ftwbq8ynzia2ybo7k73hm5	user	0	\N	\N	\N	\N	\N	2024-04-15 08:18:19+00	\N	\N	2024-04-15 08:18:19+00	\N	t
321	Julia Fischer	julia-fisc@hotmail.de	$2b$10$CvjPe76FwRTLrK7BGtL1wOu5VzGvaKFpj98GTu0mwRtGA5YnrYvaa	3l8fn3w9pd8eiggh23xy45	user	0	\N	\N	\N	\N	\N	2024-04-19 14:55:33+00	\N	\N	2024-04-19 16:47:13+00	\N	t
351	Lara Rosenfelder	lara.rosenfelder98@gmx.de	$2b$10$NirUcTEUBky1lh6XzXtveev9jMHdcOr2SvxIBgcUJzlR5PC1HCbM6	1191491281306411720372117014861494114518578541063213132183391311411861832525576	user	0	\N	\N	\N	\N	\N	2024-05-31 10:03:27+00	\N	\N	\N	12417348015828722421141206617715057130153250598215922017784225239164619111293248188	t
325	Anna Rankl	annasophie.rankl@gmail.com	\N	aky90k1fm7katfe50wua3g	user	0	\N	\N	\N	\N	\N	2024-04-22 13:13:46+00	\N	\N	2024-04-22 13:13:46+00	\N	t
294	Lukas Ilg	lukasilg.sol@gmail.com	$2b$10$PN07LOBgTfIDHJQExrN2ROK.lnt0yCgiacHTNjXbyS1jBlPZANz8.	134170226219142472479915923987212116984792975165165255399631522015315417824817921	user	0	\N	\N	\N	\N	\N	2024-04-03 16:26:57+00	\N	\N	2024-05-23 10:01:02+00	\N	t
328	Tobias Stähle	tobi.staehle@web.de	$2b$10$U1ZTjzMUopAvMrB58JWvBOO/QQOs2s27STIlbQUIcEMg7NvBhxRYi	bdpf9k829vee9p2i9j3wuc	user	0	\N	\N	\N	\N	\N	2024-04-24 10:16:11+00	\N	\N	2024-04-24 10:17:45+00	\N	t
380	Julia Glänzel	juliaglaenzel@icloud.com	$2b$10$flC0mm4o/SxuT1XUh/qIf.PijtXQSD4BaxQQOXMSXJ0FAJxPqpzGS	17311841831111851691964692809513610814822215621373575921713089282351191316241195111	user	0	\N	\N	\N	\N	\N	2024-09-03 15:48:04+00	\N	\N	2024-09-26 20:59:26+00	12242106172371941776416461165271553389198110177491315842157178659113311251228	t
374	Luca Heim	luca-71@gmx.de	$2b$10$U7sIutYJaAgl1NvnfXdkOuckMIH6zpOtFW8B8Lre8BWkDOxg4WwCO	217232122542232260197244161641969815671214681697014811122010192316213781431287280	user	0	\N	\N	\N	\N	\N	2024-07-08 14:56:53+00	\N	\N	\N	10317966351349016710839250569775253191251623823017816518214949212511416718171180149	t
406	Jana Kolter	kolter-jana@t-online.de	$2b$10$XyUUMKhi1qzNEnvvF/Jn4e0hiBX0Fsy64aUddmuRd3MOF75hIX6IG	67231218327118519222938511932302041451461931601234621417311522114411722417122195125216155	user	0	\N	\N	\N	\N	\N	2024-09-27 15:44:22+00	\N	\N	\N	11152521520198250153238132170791981654635402192947187177392491622225227758776246	t
97	Jasmin Alb	jasmin.alb99@gmail.com	$2b$10$N1uhxqj6rRNpBFE8dZIRmeNoW8GzFYO0AxJiJNb7z9nvHqDHOWQOi	1872315110585225206982424441204143154571263111917262165171351001251781542351568770	user	0	\N	\N	\N	\N	\N	2023-11-20 13:53:47+00	\N	\N	2024-09-28 09:10:55+00	\N	t
356	Alisa Helchenberg	alisa.helchenberg@gmail.com	\N	196182722919520511820067211186646228108471519201812541561571681181901171632912253159	user	0		\N	\N	\N	\N	2024-06-09 21:50:25+00	\N	\N	2024-09-28 23:20:08+00	3182102191601831314422753441232181031667127141186151071981901824254172648819413	f
137	Jennifer Heik	jennifer.heik@web.de	$2b$10$UPtOPDcDv8GmkJMNQCR3fuzpQTadYfbtc6ZauPBO3WxN7YOJBFdr.	212240165188207128144632441186689734225108427238203162311321913013892227510422131	user	0	\N	https://fcm.googleapis.com/fcm/send/ctcDgnBxjxY:APA91bES2x9tUy7HxVxzGGb2h2diic7hQCKaO4nv8q-pAGSrIBsBym0Glwh4QhZZI3H3HoPU4joLWMutSgQOIziokG5xzvjicGzkSdBvS_29TncBqPJWZktGwxPwHyeZXKDvUDc7t4KE	\N	BIIe4wez5QL933zDwYkQmeAD_4PEtAdZG43chs9_ovUwW0T7jzU5FbdhqFjLwe6dlQNX4ymxpy3TNvUS1nRUGYA	IPbmkBLmQY6DkK4G0kn5OQ	2023-11-23 23:10:02+00	\N	\N	2024-08-28 08:29:31+00	\N	t
339	Annalena Nuss	annalena.nuss@gmx.net	$2b$10$tZrBxEaSfg2IWk.V6i.AbO8AKovm.kMfGYARvGfmz9xx.0PPCLene	3tme2spu8i6va112z5lkdn	user	0	\N	\N	\N	\N	\N	2024-05-03 07:44:20+00	\N	\N	2024-05-03 07:44:42+00	\N	t
340	Dingwei Fan	dingweifan200215@gmail.com	\N	8p3oiijd684kggo0ho3ona	user	0	\N	\N	\N	\N	\N	2024-05-03 13:00:12+00	\N	\N	2024-05-03 13:00:12+00	\N	t
64	Philip Oesterlin	oesterlin@ugd.ai	$2b$10$1elpiXmMrcvCUQ9HntR8Fe9H3qxkM3O/dYXZe92QLI746/j5CUAkG	1541446615422910497162191116111126192103561392471223145566118152221197619422925	admin	0	\N	https://fcm.googleapis.com/fcm/send/fGrTZlaFetQ:APA91bGM05qh8nEhpUYvcyoX_tslJH5KM_pM8VZJ3IYoY3hjCbj3AzjQXE1qFLE7eSkIuPuc6mHkRK4zz6Mfnh1ZuXCbmEfl3Ut7n5NVSZ7lWBJooHat849V-g8HSlmZ8V6azAWdVVds	\N	BBggL3u_PO9n-KF2Ii6uh71qV5FWIu-Jq32UIkSr3SjudjICI-yV6kzDLB9uTXpNKtqqoMGUL0np1D_Esu9l5IQ	Kw0avK5qvRxdCYPl39Cknw	2023-11-20 10:46:26+00	\N	\N	2024-09-03 06:21:42+00	\N	t
136	Maja Peindl	maja.peindl@gmail.com	$2b$10$4nMsGIPI422cZnppDXBU/umHf6fjfnC.yXt6zbG3Mz1bPPZLB2OhS	241611644781991771421791474633721620725564232331142111471031542382321414816311546	user	0		\N	\N	\N	\N	2023-11-23 19:55:20+00	\N	\N	2024-10-06 07:29:23+00	\N	t
267	Luis-Frederik Matzke	luis-frederik.matzke@uni-konstanz.de	$2b$10$CYa8ZkfzSRqm/bcVO7aY..rE1qc.8YP0ULCM4fjDcK.qSoFxewXPy	137822819812948972222261111202179292371182531475090245190252122186139143164244105	user	0	\N	\N	\N	\N	\N	2024-03-17 12:44:48+00	\N	\N	2024-10-10 10:23:03+00	\N	t
100	David Danner	daviddanner@gmx.net	$2b$10$vbfYXuPHxoA46KW2rqO0t.sJpb5mmfVXWLZE8X2ilhbMNKMGAxlri	119182498714466170126243152199214131366606286154115212171222164187941471205417554	user	4	\N	https://fcm.googleapis.com/fcm/send/f6viC1Owz28:APA91bHVWZbLYt3OBIG-r_9Nl3E9uT6C99yr-6NoxAAOFx7Rs-PrDKMeaukzNNDgSvvHYa5B3R-9VyfND1SRUp8IsiIzmDNaElxsM8Z8PkYBQ0_HILbmyFRUnY2NVxubUxeajFAC7QUZ	\N	BPKY3OY-z9m1L_cIV4iASgz6nIZxcsj1LJQWSRPl9X7-p7iTfFFTTby5yWPiGyEoF8dcyOFYLmeB7iFlOu02YnY	_YjM9QpYhFfbTRLY4qj18g	2023-11-20 14:19:41+00	\N	\N	2024-07-23 08:47:31+00	\N	t
253	Maximilian Fink	maxi.fink@gmx.net	$2b$10$pVKcdwwxWyToj8gkHMmVse3URAWn/sIvJ0gCe5A/0BkUEfBqQZ0ee	1922103134122105214233252226101123113226251551895717921167161631863416614324226161	user	0	\N	\N	\N	\N	\N	2024-02-26 20:16:51+00	\N	\N	2024-10-14 10:31:57+00	\N	t
445	Jonas Hoppe	hoppe-jonas@gmx.de	$2b$10$RQ/8ybG/E8goEU8tXiRVDeUoStC5PR2hZ5Z8gPlcBXqnpELUvRCl.	796020470143127118317918155168157154241971621272291115712158199201146521620170141103	user	0	\N	\N	\N	\N	\N	2024-10-04 10:44:23+00	\N	\N	2024-10-14 10:34:20+00	1268319892151201169821751595820716421525215021915516219421143711932152351002517539283	t
329	Camila Vega ulecia	camilavu@hotmail.com	$2b$10$w2JYkpfNSP7RhycJhrILa.thw9jlZplwHKUYkdK/jYFMl5Kiss5K2	11249149140211176204921192553617647105148107354213116025421938177601991682052031971	user	0	\N	\N	\N	\N	\N	2024-04-24 15:42:55+00	\N	\N	2024-09-05 17:36:06+00	\N	t
413	Tessa Drossert	tessa.drossert@outlook.de	$2b$10$E/8/PZUtt99SbkfRRnw96eTgMvQjZQjWM0U8U.yO/bwtFCT7QF.N.	252244200196243112153123349315389817114170431364415284224321811921601932489821652	user	0	\N	\N	\N	\N	\N	2024-09-29 11:29:35+00	\N	\N	2024-10-03 12:07:44+00	8938871521686834227221662418749166201951403427531941902421561022220301761951428	t
385	skyviki L	sky.viki.x@googlemail.com	\N	15822210119084214971352307315544177214425868202561471482062121279206185143143219181232	user	0		\N	\N	\N	\N	2024-09-12 11:44:55+00	\N	\N	2024-09-12 11:44:55+00	2006617014816825236964213913357924463219187701431712245131244491182321301231897866	f
291	Lisa Riebelmann	lisamarie6041q@gmail.com	$2b$10$qd1if5H42OcxukfpCjVogu4a/DyeOxb4TNJmR7M/fSbdJjJT0o1ky	2542331321144017925882024013924415987382012258026199791631827324518421624216214052	user	0	\N	\N	\N	\N	\N	2024-04-01 12:53:28+00	\N	\N	2024-09-19 15:10:38+00	\N	t
343	Bingfeng Guo	bingfeng.guo@hotmail.com	$2b$10$/ipctONTNAGC7crN.B7vteIxSZrVLDvbKzUlrtpBxeZn8t89o9DUW	5c9q0c0h1gtt1jxu8btd4b	user	0	\N	\N	\N	\N	\N	2024-05-16 10:31:20+00	\N	\N	2024-05-16 23:10:18+00	\N	t
375	Moe Tobai	mo.altabaei@gmail.com	\N	20141932447322114847094201146104991188125112192742161109414168160244197113116172205	user	0		\N	\N	\N	\N	2024-07-16 12:59:35+00	\N	\N	2024-09-22 18:16:43+00	1364518023597180961705975242432141622211841552062031603195126192202596222841503998	f
347	Zarah Deglet	zarah.degler@web.de	$2b$10$kwkDmj0tWaJbmTKTh4vQx.DJ/FpbTUMHiKH1W.di9wRu8FbyMo.fO	1592322006013019742549835145555381069111342204332161137242120185842222061118180	user	0	\N	\N	\N	\N	\N	2024-05-27 18:23:45+00	\N	\N	2024-05-30 11:15:06+00	174169692551101369921822423511582442488133128512512441652305655126106301322081227	t
344	testing filename	philip.oesterlin+test@gmail.com	$2b$10$Iqurb2dURLSwlv787iVFresVJj.EtINcsoIQW6PEuXOeqW8S6NxJ2	\N	admin	0	\N	\N	\N	\N	\N	2024-05-18 16:20:10+00	\N	\N	2024-05-18 16:24:50+00	\N	t
96	Manuel Schäffer	manuel.schaeffer@uni-konstanz.de	$2b$10$e/Tfx0plVZdv1PS93yc/9ePP3nPtDfgdfhGm8mA6cqQBzxrQ8jUEi	4731304467812421478314848128213145801551612526359721082482437610811825424546108198	user	1	\N	https://fcm.googleapis.com/fcm/send/cmovF6KITqU:APA91bGTzq8z_EJPcj9YIWPEXtBLa4FcNc9dHhp-3AHZsF2BiDaYSY8UUbZ6lqWVRTyamRJJYHaEm4sFx_kwoJghqgk-qSQJi3yQhpmDEintzW-N4x6I2q_eVuydqrcvIOzPMnRuT1F8	\N	BEJReAzMN0c37tsDFIH1soNEVY3x8O1hu6N6vUF0bVgfvGQL1f9J9YOGlQcbigtgCDaO5-GuAw1hiIE9jZsIUGc	tszB6y-qWUTIPlvM4Mk0hA	2023-11-20 13:49:58+00	\N	\N	2024-06-02 18:53:48+00	\N	t
359	Lea Suppes	le.su1000@gmail.com	$2b$10$dz6eEKEMiih7fCg/hbEvheEWszZ1d.r0ox1dJxJpSwi8SAzlgnn.2	50357581241831485840554822424996207861935218242723035166206971777511818910050	user	0	\N	\N	\N	\N	\N	2024-06-14 08:12:16+00	\N	\N	2024-09-27 14:27:20+00	9522144137227113517729491611171942393116913714431101021731471956862165935485237232	t
32	Cosmas Mohr	cosmas.mohr@gmx.de	$2b$10$NlvXC6wShbmRpAbPR/mE9Om3rSuSLfxXRMG2SeXiHm/8BlDke.S5O	935220253251119521216948100220282361719933522415134147230841317122821270243251177	user	0	\N	\N	\N	\N	\N	2023-11-18 19:57:59+00	\N	\N	2024-10-04 12:50:40+00	\N	t
141	Julius	gra.julius@gmail.com	$2b$10$oFFsk2tRmpQq4xya9HCDs.zJ/nmDXDS194LVgY.qGJW5QMYBK0u9O	248147234120701721242311749151219182011221151361161481741015014136122104591422168214818	user	0	\N	\N	\N	\N	\N	2023-11-24 15:44:48+00	\N	\N	2024-10-05 13:01:53+00	\N	t
381	Sammy David Diaz Rodriguez	sammydiaz85@gmail.com	$2b$10$mcaeP0Ct3S2G2a43AAWQku6U1djle3V3WPbbEZuK1o27L/0oHglIC	1672001032042057814424716853841804517985171872220208315022819021108738020522038236	user	0	\N	\N	\N	\N	\N	2024-09-05 19:39:15+00	\N	\N	\N	2844176752311331856230150211003723616718719515652163189112507323914200252317940185	f
452	Maja Ullrich	majaullrich@icloud.com	$2b$10$tJqDrpGhcNWxG5ua7reg7.4d95K7B/0/xsBAL2caRqEcvAkAZIrTK	7719495236841402381602452411592281022129121411614336195211365231227168637925272119107	user	0	\N	\N	\N	\N	\N	2024-10-06 21:55:50+00	\N	\N	\N	2082363012937195271381021912901726321623281541249196814314920361159842237218218	t
40	Marcus Koch	marcus.koch@hotmail.de	$2b$10$Lw6YWJcIjOZcrcRhQbR4zum3.zV7hiGXTYSE3Es550ey//NEJ4xJS	87244188611201711281901103865692212082281941302436669164203571561409411390828023077	user	0	\N	https://fcm.googleapis.com/fcm/send/djqrqyto3Zw:APA91bFuct1xV8P_3UNtkfZxouS8uzCpNCIXICD9zHmYJkMMOTNf4CGaFZhSp_tvDX-9YtSYLJMImRBYwOeAGG_KSKpFn30PyhFiuKbMVL6OMThhPSuHKfTcfRolJb9yyKa-gWAO4PD_	\N	BFSv24w-pgNuJdKkwaq_o54BwaKcW5k6E91uQ6cSV5aYrp-RJIuX4-ewDh6oqRHfeMiLxGGbH2L0oCEDn6RdKz0	aZkdYsjUXHLX0ek_lTvy3w	2023-11-19 11:33:52+00	\N	\N	2024-10-07 16:54:17+00	\N	t
1	Philip Oesterlin	philip.oesterlin@gmail.com	$2b$10$k8YpjBM16taWmmg9BOZ9veG4I0nBR8POe09wKR9gUpa.fesairRiC	70832112461272175136252211190152220448918424719620515619066166191138101163861943239	super_admin	0	Super Admin \r\nSuper Philip	https://fcm.googleapis.com/fcm/send/fBdrwJC-B14:APA91bESDRDn9cGpAFCtSeZJuun58jJG3brpbX8rpDL-bjAHPnTbn1WBP6s0q5v1mMTqyOEv8YU0Z-vSNNCUmqRc3bWp9TEm9rtaGzWFefQLco79Ob9bWwUqNhFZ_9KkwjBWbmN-RtOz	\N	BO_tIFfjqSH6i3ALHPkjCACmWI2luoTV8D--Oz4ys1Ji9MKjgUHLQ_B0K-NT_0dbyZU2KOsvQCi_gOrs_a1hVrw	jRhecBubjhFomeQS3vfqbA	2023-11-04 14:24:46+00	\N	\N	2024-09-15 21:04:57+00	\N	t
364	Alina Redczus	alina.redczus@gmail.com	\N	13518254828771819225116710910247254105230171586011241360117117842361062218897148	user	0		\N	\N	\N	\N	2024-06-18 21:08:58+00	\N	\N	2024-06-18 21:09:09+00	213223748482210952327387874569367611339147180204160114589515112922290296209	f
407	Carolin Gößner	caroling090406@gmail.com	$2b$10$7q.oN56NoJaJLL7BsL/Oz.dSjgDfezXXSfLLSglEAVoUMct2S03eG	197971761362122074175132931821442232438931972125495981171821711691781127410916842	user	0	\N	\N	\N	\N	\N	2024-09-27 15:56:47+00	\N	\N	2024-09-30 10:34:30+00	232148221022291231722128922187711306425225101905293179229171732181642813434112122193	t
361	Jonathan Arnold	jonathan.arnold@uni-konstanz.de	$2b$10$l6Ef3wISzcQE5KA/Y7DPXOjJHk.uWLwhrWLpP82YVF9aIPWtESwiy	938614116315018055145742484510712215542352105119419579751247823915324223771101198	user	0	\N	\N	\N	\N	\N	2024-06-16 13:50:33+00	\N	\N	2024-06-16 13:53:04+00	92183294712821218815248133163501112917642121082482150230301102814658100187196115100	t
363	Niklas Bayha	niklas.bayha@gmx.de	$2b$10$wPchgfMesw7mzkw/8UG1ge1BUe.K1MnJglabkAZ2vjubNCIwFn.u.	1514136192193521316710981722028513414211614819122120240469229232111831971901403832	user	0	\N	\N	\N	\N	\N	2024-06-17 07:45:44+00	\N	\N	\N	2451412095138216248522472541101649101811542628108169119197397521158112998102255207	t
189	Katharina Gerhardt	anna-katharina.gerhardt@uni-konstanz.de	$2b$10$EWX39NYUqEEd4BnvMHdrIeW48JAKgIH43XV5abX7Kh7Q5dfGyjAVG	20114924316171305011012526644203406951221871091999050227201102219121625573142	user	0	\N	\N	\N	\N	\N	2023-12-10 18:06:07+00	\N	\N	2024-06-17 09:01:23+00	321288499873316325217425144157923611981191321461172211521185514262223238125239138	t
43	Marius Härterich	mariushaerterich@web.de	$2b$10$Z5jpHfaKRi69O.R/kVsIXuxyGJ7uJ6UrXGYFfQ07yDPgdtFh3Ymue	2421085923255261401617619433302171992181537522222253472573123719442471111664131	user	3	\N	https://fcm.googleapis.com/fcm/send/fgZQpEoNfAc:APA91bG4hpRT3fnXcbKetFr8s4prV26ExNuap9aSBJzilZ3jzWeG3U_mArZKZy-hW2tOTmeZjTxAUzMV4449NHcAckuPbXjJkLcMMaYxvdq0ZO93DATiSzwFZCl8ACOSArhTEid27RoR	\N	BFVjHiZOAN50QCa4W0kwHwRiYUlV1lPTMJf5-uL7lHeeCw5QdyJmTNDqGb-1RC8CHj--xt6ays5aRurLJlLh13U	LZd-EHI2hB6mTiFLwxXiEA	2023-11-19 13:12:47+00	\N	\N	2024-09-25 16:14:30+00	\N	t
408	Lara Wolf	lara_wolf@icloud.com	$2b$10$jXzXYiMSBYkT80JCki4N/.xdYWa1M1h1XMjRJMqwPQZuhZOtK9tkK	13215921012093141668925010971221233234161174220731772132372377095367915311249229163	user	0	\N	\N	\N	\N	\N	2024-09-27 16:26:28+00	\N	\N	\N	20474241871838945254981461822554720818416124451341971471721729625338237898096142155	t
18	Caro Weng	caro.xcv@gmail.com	\N	2012702125317164271986577184243209610614711165130415720791156156568216108037	user	0	\N	https://fcm.googleapis.com/fcm/send/dlxDiD9mQic:APA91bEIauCDUQZdXMrgYP-0M0gn4e5bl2Pg4aX-fYHIdyqI69YgRgOweN4Jkmz3unZbNJae8CwtqEAQDjYfzvJlROZ0k71LiLRimXhyh1THHBGtzvPrzdgmynPdCzICPoH0HIl-yxqD	\N	BBGvfqbZjJXOb7COMWhBDm_kipVXSkBqzRG8sYKyLueSyrwTusGI62H5ySB4_LYQp9kDHS-h04upHVCo1-Aat4c	jGZs7xBZADVZkBOQ1dBazQ	2023-11-17 12:07:44+00	\N	\N	2024-10-02 10:48:49+00	\N	t
357	David Horstmann	david.horstmann@gmx.net	$2b$10$nUPRCbkgsot9PU1vJzXxJeiohsx1u9eAcWw0NsV6hEj6xH5dQTkfe	15410226121241782378441632511821717474122136145642352372417520017974199167223204170	user	3	\N	\N	\N	\N	\N	2024-06-10 15:20:49+00	\N	\N	2024-10-10 10:10:30+00	206913211417146164139240811651135023824423978881574822550205217210023823882224925	t
376	Moe Tobi	mo7at.de@gmail.com	$2b$10$B2W0xlyZ9L1/x8ip3D89JOGemQYdmI.cAzh7HjDdzLtYjDh30XMzO	134112822711913475167128222202212157249253271031171755724152233147101112010322352114113	user	0	\N	\N	\N	\N	\N	2024-07-16 12:59:56+00	\N	\N	2024-07-17 12:30:15+00	191882206125314206243209251032221718010150152195135482139415653562410321878716071	t
372	shanice merz	shanice.merz@htwg-konstanz.de	$2b$10$yyxiIHs9at2dhvRacSEKp.YFe2ka/y/RT3JVMkgs/j7q9npnCVbY.	431903589241126170162141323110717024927213102502131042001544614721515383113238200220231	user	0	\N	\N	\N	\N	\N	2024-07-07 18:29:52+00	\N	\N	2024-10-12 11:14:45+00	7920463192552351172221511727617510894424018114322223437612924158227862232820212137	t
87	Markus Scholz	markus-scholz@web.de	$2b$10$lg.m16NhF/6NodKFqGrkwujQng0t8p4dNyyJcb1Phyg8HnaERMgxy	391549568108174128133415111223616622911124310525020618813312131125442222451731881769	user	0	\N	https://fcm.googleapis.com/fcm/send/fJNpT1-jptc:APA91bE8hPfXiXvXJbpQvJhznwnYBzTqIU2eZLDHxb9u5vRvHA1-0hD2ET0foG8GHdBuBrsQ8x-QaKYGIh2gTUXjwKu8EaxGpHIERyQyU4pPjkTo0bR4H0Pzx64ZdwbMo1-lHGI1cXs6	\N	BEHnZtiIhRpVC9dE0HGI5dIBqEvoSuOS5YsNQr-MR4ge8qM1TenxEi9sPx_MbQGnerahQafePW0iGKPWiKJHvlQ	QLLfCnWNSwwp2-FEkmS7pA	2023-11-20 13:17:08+00	\N	\N	2024-07-18 09:50:59+00	\N	t
367	Claudia Fuentes	cfvaldeolivas@gmail.com	$2b$10$.d5XgaFJL9Jx9eaBiiT8JeUfEuS4jnRgmWetcWcyolwuDixUcOAqG	23319610885228485124422914418885253245446462104144235121821718345325422145231194	user	0	\N	\N	\N	\N	\N	2024-07-02 08:26:57+00	\N	\N	2024-07-08 11:25:12+00	38236601977022223324011755212611914386126431034684261106817937185655623802350	t
200	Jonathan Koch	koch.jp@yahoo.com	$2b$10$6K.Ph7SP9SL2nVNIIgrL0e7zZ5vOTDs5AzPk/r3wmb272r7tryJ.y	254203233749395815109872214462391041022820523524133232205144235195210712729243188	user	0	\N	\N	\N	\N	\N	2023-12-14 12:47:48+00	\N	\N	2024-10-03 14:17:54+00	\N	t
365	Alejandro Aisa	alexaisa1999@gmail.com	$2b$10$KNMNAgyoe/L0FgOXzu.O.OX13.oUGq3xgxNBJjMHCrR6QAOrVTFYG	15316023033162147324419221107137582186721919570521471101621797815611112628128235220	user	0	\N	\N	\N	\N	\N	2024-06-20 19:27:09+00	\N	\N	\N	1715421519758150191132120949225314057135175352352551651971461491906712310325016845235124	t
31	Svenja Armbrust	svenja.armbrust@gmail.com	$2b$10$XGee/Yws5D42n4rmNjq1kuhB3T6OgTZlPQBB7ORFyiV5zUDrY0Oyi	2468369146225214531672471762214651671001101062942883125160691613225208170208	user	0	\N	\N	\N	\N	\N	2023-11-18 18:55:34+00	\N	\N	2024-09-26 20:04:56+00	\N	t
257	Clarice Zhang	claricezzz07@gmail.com	\N	01071231936988847410860105872124051362091121722292527917419119213955224766519962	user	0	Nicht typ - Anfänger Niveau	\N	\N	\N	\N	2024-02-29 21:32:50+00	\N	\N	2024-05-30 10:57:48+00	\N	t
22	Kai Dintner	dintner.kai@gmail.com	\N	10715282502161341562272571249138107196100914286622393813241309882142401404879226	user	0	\N	https://updates.push.services.mozilla.com/wpush/v2/gAAAAABmce8YQM554qUCy8umJfd0AyRkoNAjZN4Obg0McafQ81eqIEM5xs6Y6H9vTUrf_EO_7UGzwMOxswCKONL5uwnaP0PSUCtbkIABQuMHpT9pccUInpyQNFw69DHC5hlxzpzFRLJLkKdgz9VQ0Njc38KbwdggSpGcgGYGM4pfXAHx8k5kSqk	\N	BCN5u0q_NAILWv6tysPgSABHY8j_GY1pB-nnDbNKULv12gdenzY70O_Plv2GIRBRZowEr8maBusc0CcI54LhyVU	uqJyP4H5UzS83nAF2NIagQ	2023-11-18 12:00:36+00	\N	\N	2024-09-28 21:34:48+00	\N	t
28	Mara Kolk	mara.a@gmx.de	$2b$10$UWW14YCo6BPqpizn6A261eiqsCBsAcKin3XqETgG.0cyisNy7oahy	2051911245067311024012721514666249200954418631431181006224601206915731384534200	user	0	\N	\N	\N	\N	\N	2023-11-18 16:42:31+00	\N	\N	2024-06-03 06:47:26+00	\N	t
414	Konstantin Böttcher	kostik.b@gmx.de	$2b$10$M9K.xpKb2vwyRSrywoiY4exdmuXwbKKP8SLXuy2sLn5O6GJ.p1UTW	146184234237245161781232461790726077198812622621518644721922132307815723656147102212	user	0	\N	\N	\N	\N	\N	2024-09-29 15:55:38+00	\N	\N	\N	76169233452432482198241332071925151222107701371381741514096331078368193114313347	t
418	Paul Trompler	paul.trompler@gmail.com	$2b$10$BIzkHFZzWVQsxkGZDKXq3ehjPRCAmIfv4.KrzM4xSjFqxXZ5DYzHy	72248145792472012052406722219010611391935963109938121980151165184251851218036253203	user	0	\N	\N	\N	\N	\N	2024-09-30 08:28:19+00	\N	\N	\N	372124518047266313434149631112261355751214677248418612446815815221922820116511	t
362	Matze Beutel	matteo.beutel@gmail.com	$2b$10$CqKFIAPKz33DfHXRKmWyTO2R9crtfcaFBbswp/IL1.inxXUVw.62W	14221328113193163242107108106101442152592104991851735512231223236222107142912421052245	user	0	\N	\N	\N	\N	\N	2024-06-17 05:59:26+00	\N	\N	\N	23973243112198743498248149157216191922342161101932112352529912233389514321715419555	t
284	Sophia Lützow	sophia.schwimmen@gmx.de	$2b$10$Y3u296x9EJ92Zmng.F2CU.G1PyDUeW9Gcc5E/YzEnqBBeTSrIk9DS	81124817414711085921761771385514710818115398233198218192456819561773152631505321	user	0	\N	\N	\N	\N	\N	2024-03-24 16:57:03+00	\N	\N	2024-10-03 21:33:31+00	\N	t
352	Niklas Roth	niklas.roth@icloud.com	$2b$10$n9Cq7AyrWiktxiqVSoHpX.X31u8EX4jH1pgSNxq1KkUhQh3UdTYCC	1362061592122872471315478162421808613013610141238164010321917848512271838430190179	user	0	\N	\N	\N	\N	\N	2024-06-01 15:57:15+00	\N	\N	2024-10-04 07:21:51+00	2532111943215865682917223520555141491231255121702302165524450164881874813802163	t
46	Lara Lützow	lalueds@gmail.com	$2b$10$OdhVoyerYxnTe7q4Bh4.7OiHXjK.hJQW/M5ee/D8xzoQk2ztpnMu.	2461616787426157221193111812452229823219532321972559011719518622915410824123719168223	user	0	\N	\N	\N	\N	\N	2023-11-19 17:42:19+00	\N	\N	2024-10-09 10:09:26+00	\N	t
353	Thessa Schemken	thessasc@gmail.com	$2b$10$/vCQH8iFmXQoG0yXCt3ST.dThFUjb7UzcOIDDrJ8aNTv4twX8RGdC	21210231116710998871262031056615920617203103141817821218588202182329948658083205	user	0	\N	\N	\N	\N	\N	2024-06-03 07:56:46+00	\N	\N	2024-06-06 09:05:54+00	163821315125324103215723350144144181921091882301201981611234481573327321117816669	t
369	Aybars Yesilcimen	aybars.yesilcimen2005@gmail.com	$2b$10$ljMjHaUATyAPhn4JNT6r1uYdlqecq8b3j/NxgUs/mCq/S/p4Gqv7a	78724223220916520422577641842242281851951822174521177101247947813420911023522712416020	user	0	\N	\N	\N	\N	\N	2024-07-04 11:18:04+00	\N	\N	\N	197271712121822111571471187219328999012318232128597801321801191061271963520782227238	t
63	Carl Reich	carl.reich13@gmail.com	$2b$10$K00HJ9uXmyb0RdB5I8m4lO80NdJK9.LoIMFRIpe9I.UzUYTk9ZQI.	842462798211111769122140852122815557127412612266661672031324213510589216252101	user	1	\N	\N	\N	\N	\N	2023-11-20 10:00:14+00	\N	\N	2024-10-09 11:36:57+00	\N	t
144	Jule Baier	ju591bai@htwg-konstanz.de	$2b$10$Jd.0Zy1pIys6HUrMC9ll7ePmhW5Oe1H9b.Q8AlWo3nbHO.IykriBG	864918156801442311904224824914314316363161387675619797512179164481741684172156	user	0	\N	\N	\N	\N	\N	2023-11-25 07:41:27+00	\N	\N	2024-06-06 10:56:40+00	\N	t
371	Alina Jünemann	alina.j.1@web.de	$2b$10$tNf8r0PnqFScts3egK69/.4v.HXXxQR1y625MTZks8xdhovFJ/JB6	271212188311266128212343717334187131881291642177242472832882118815235304189	user	0	\N	\N	\N	\N	\N	2024-07-07 17:03:15+00	\N	\N	2024-10-11 09:56:18+00	8817613813710150489115822277231210113135901424223319413311164541864010602240128132	t
76	Lukas Müller	luukaas.172@gmail.com	$2b$10$g97sqPfjy.z/uzHtA0oDrOSAQqkJVAN5Ksv./h2KRIW.y6advu1Sm	50210921718575218349924616413092701051972202732281322468612462952027707419089	user	0	\N	\N	\N	\N	\N	2023-11-20 13:01:40+00	\N	\N	2024-06-12 14:18:35+00	\N	t
214	David Reiser	david_reiser@web.de	$2b$10$0XjoWg4ak87shElhY3yzOOv8XIeDERV5vk3JV5B/Jjc/OBc9jZhx2	211641871256517817923824622513334622824538188251764223540136295944124200204234156	user	0	\N	\N	\N	\N	\N	2024-01-07 18:51:02+00	\N	\N	2024-10-13 21:40:34+00	\N	t
252	Jakob Preiß	jakob.preiss.htwg@gmail.com	$2b$10$/9pEAuGB4brSJcu5cbJs.uPdHoLO/LjiV4WwLmPQMFHqRXmTGDGFC	273511221717110715814411137801444149281541741391256216914151230131342122225824230224	user	0	Lange Haare, komische Schlagtechnik aber gar nicht schlecht?	\N	\N	\N	\N	2024-02-26 13:28:25+00	\N	\N	2024-10-14 09:05:15+00	\N	t
70	Laura Fix	laurafix@aol.com	$2b$10$/BqXe8Unf3FPVOF5Z3aJYu3w8Gi6q22u.U7XLS/PlAZ.4.zReCyOK	2618816512319790810018255220226134184119176702452455230111198159128240984925413482211	user	1	\N	\N	\N	\N	\N	2023-11-20 13:00:08+00	\N	\N	2024-10-14 09:42:25+00	\N	t
383	Annette Haidle	annette.haidle@t-online.de	$2b$10$hvuqD7X4KtyyZhDA02aoc.92qiLTDlmZleUOW0ySyYzV41gAiuuDK	1311912402528511919201173207346177961817115151131232351902817011625117917622299132136	user	0	\N	\N	\N	\N	\N	2024-09-08 16:10:56+00	\N	\N	2024-10-14 12:44:17+00	236149733619237214841432448717172152952156312917214215116217253588341361846101	t
348	Mathea Brückner	mathea.brueckner@gmail.com	\N	4767798720422254142170102251892923824610927224237952787246211271117322414623353156	admin	0	Mathea 2	\N	\N	\N	\N	2024-05-28 09:19:19+00	\N	\N	2024-09-16 06:54:20+00	20125037236781312372401828525465108215102114117365221722082162265927217451917625575	t
409	Benjamin Schroer	benjamin.schroer@icloud.com	$2b$10$rrM4YfnQMOPTuw2.leyNTubY36FzQvuaVCojBMyVaAOCs1QPv1Vtu	1222718766118147193119190200200241271881801461204510593541491356311550181974750165109	user	0	\N	\N	\N	\N	\N	2024-09-28 15:18:55+00	\N	\N	\N	2101039583127951983543109514123289125102216251254158206621891541306814810815623555	t
384	Tabea Grohe	tabea@diegrohes.de	$2b$10$2m0/IZ8tphAMfweNgVWMv.mW2wj7dBqz7JL6oR6xmVKzs8N1PJZe.	732536835205228115921861361417442455238016020418412127433252162591120515946208	user	0	\N	\N	\N	\N	\N	2024-09-09 11:18:43+00	\N	\N	2024-10-06 15:03:01+00	59223549912510277194752315713724321817168418911891708081213981692316318124996166	t
102	Viktor Lang	langviktory@gmail.com	$2b$10$SV4dM1lPeDkWZCZ0hvAJaOaR3dm4hUvvoeOMAwGXa6nRDu2GTEecm	2532372362719651923582223619422155142179238622162613515622413224983166123745088	user	0	\N	\N	\N	\N	\N	2023-11-20 14:35:52+00	\N	\N	2024-10-07 08:43:32+00	\N	t
72	Laurenz Kling	laurenz.kling@web.de	$2b$10$vbADBztdHdbNBLfhDLM2LegrbFjsf2oO4nX4kXqFcz6g2grvVlMNq	228223515521758153209165891872023116418323711077451191692439209351182021977131175149	user	0		\N	\N	\N	\N	2023-11-20 13:00:44+00	\N	\N	2024-10-07 12:12:50+00	\N	t
354	Manu Schäffer	manuel-schaeffer@web.de	$2b$10$WbNQ37Zp..kfPrRpQod7LOCoedBAP0p9t.GTBZSUJyW4bAhg7k5eq	2411461420318916040425550914959168222199112231488524213917194163604621612871235194	user	0	\N	https://fcm.googleapis.com/fcm/send/cmovF6KITqU:APA91bGTzq8z_EJPcj9YIWPEXtBLa4FcNc9dHhp-3AHZsF2BiDaYSY8UUbZ6lqWVRTyamRJJYHaEm4sFx_kwoJghqgk-qSQJi3yQhpmDEintzW-N4x6I2q_eVuydqrcvIOzPMnRuT1F8	\N	BEJReAzMN0c37tsDFIH1soNEVY3x8O1hu6N6vUF0bVgfvGQL1f9J9YOGlQcbigtgCDaO5-GuAw1hiIE9jZsIUGc	tszB6y-qWUTIPlvM4Mk0hA	2024-06-03 10:05:55+00	\N	\N	2024-09-12 10:59:31+00	21036425029222137164106180107016649562052522042361941441026907977272477914333175	t
66	Timo Kraus	timomkraus@gmail.com	$2b$10$YT3ehgNrzY1y3e0Yq2obKO3sk9Vb3Omwionveo4yEGfHLGyzmhfuG	11947543211149180180208251481932487815324287123111996078361641932412481292442275676	user	0	\N	\N	\N	\N	\N	2023-11-20 11:25:41+00	\N	\N	2024-10-08 17:28:18+00	\N	t
386	Sebastian Roth	sebiroth2000@gmail.com	$2b$10$iPMuHso2/GxIaL9FLBW0gurzQr.KCeeXws9fWCSLFtrcnY7KEYD66	2201641951465615884391352031768821949174123183111241425447242771141041091339013675	user	0	\N	\N	\N	\N	\N	2024-09-12 19:25:55+00	\N	\N	\N	139411101982148502027111310915520333152257116821215912821799877112157191232861369	t
419	Miles Müller	miles.mueller@htwg-konstanz.de	$2b$10$1YR.5/pc8WbEAhv70V32yuiYylkXm4AcMQqHk0VQFGEW5d48y1SIu	86765138944716523919341851671661832428073194591911991271291416714917525561013917	user	0	\N	\N	\N	\N	\N	2024-09-30 16:13:17+00	\N	\N	\N	1133971210931021159521313312411710019679522072192365313013381210227971244128240239	t
420	Leonie Fauser	leonie.fauser@htwg-konstanz.de	$2b$10$nORGjOcXF1n5jUZKpWvW5.SEcxDX/PA/cLjD5q9Xmaezn9raXLQPS	1361023424218918534726811114216211722697216169941412546380233207811111504324097157	user	0	\N	\N	\N	\N	\N	2024-09-30 19:40:36+00	\N	\N	\N	21124422722713989519516813523348200122182421211132715624214531592232473126195208139	f
411	Konstantin Landes	konstantin.landes@outlook.de	$2b$10$s50sVGCdnrwxjxK9ZqJxx.c/TLJQmJwZptiXWkQEbCRaam3./FFam	951121811018818366108219173149195206196121865725511565186331281181382261796141711	user	0	\N	\N	\N	\N	\N	2024-09-28 17:33:19+00	\N	\N	2024-10-10 21:45:01+00	616224517218999361727593157511371838136167193210732282062484741201221117332179113	t
415	Lisa Frevel	lisa.frevel@web.de	$2b$10$2OhC8NHOXC8LuCnK5FVJcu8JpE.ccqegHe8PB12Cx8fL2JvQl5816	2369717849467821514394153116398721624695511614166208721531922533318271788269119	user	0	\N	\N	\N	\N	\N	2024-09-29 19:38:18+00	\N	\N	2024-10-14 12:25:59+00	181234173182163100405219654144655402431582071214099782525022130942382062542951180	t
389	Alexander von	studienberatung@hs-kempten.de	$2b$10$ryE0OxqAGr8pmgulbKAU3eka1UbAVvpqnJiO7eppksulO3EfE8rTu	205266116141624821461214302362182496247214190251105253516722894661901621791747425	user	0	\N	\N	\N	\N	\N	2024-09-14 20:32:35+00	\N	\N	\N	70116912149220157175148461132171872376262392321610610518624678191697518817596203105	f
388	Alexander Bär	inexishd@gmail.com	\N	35232135754275127781588778209972052717115320318323618124454141133168211118197175255148	user	0		\N	\N	\N	\N	2024-09-14 20:31:15+00	\N	\N	2024-09-14 20:37:12+00	1444821212148239234248222246189146401689156236518360181232232381310923996153100123214	f
423	Lars Knapp	lars.knapp@gmx.de	$2b$10$2SyXmsKE3ZUwhwSXtxFC1e8Eylm6YwQfaYSepuWZ6n3ZS7JW0OBGq	772422218111320183208135162182169225668168111385123250136178418416521324625046124	user	0	\N	\N	\N	\N	\N	2024-09-30 22:47:03+00	\N	\N	2024-10-01 08:26:47+00	11497130101301622402319015543250723821716211853672204740120253841792163143142106	t
387	Faisal Qaisari	qaisari.faisullah@gmail.com	$2b$10$I8s13qUEeLvA1bwg8k0/7uSL0Q8/Ur9ggSznmLr4PE0qDjQAI3gxO	8510217158201381512224023912314816714692214323712219224718344220183671172331063811102	user	0	\N	\N	\N	\N	\N	2024-09-14 13:45:35+00	\N	\N	2024-10-02 13:15:46+00	1295572261771581241419523319639310913155245231282118220419549196874118316351177221	t
213	ariana gottstein	ariana.gottstein@htwg-konstanz.de	$2b$10$WGfPYGtQzHAKALyg62NRLu0TIvjOr/9p3fVXvTq18727YYeNUYFDK	46143162155199981941112063835459811096113285160387823319947161336172423117831	user	0	\N	\N	\N	\N	\N	2024-01-07 13:37:24+00	\N	\N	2024-09-16 11:41:58+00	\N	t
93	Timo Bader	timobader94@gmail.com	\N	6898162250167204101178912442481746524199135244120661312301541392091012095622123241826	user	0	\N	\N	\N	\N	\N	2023-11-20 13:44:02+00	\N	\N	2024-10-03 10:41:30+00	\N	t
221	Aaron Krings	aaron.krings@uni-konstanz.de	$2b$10$8B57Uy2ij1.G3fNS40DUZ.EL8BY2xA7J2B0bRa5V/NsdlOZyLn6w2	8325231081628134152551301229198601601692421594616556166233871813924785164249922	user	0	Sehr an der grenze zu Aktiv Nivaeu. Ich (Jonah) hab ihm am 15.7.24 gesagt er muss sich Positionen auf dem Feld und Angriffssicherung mal anschauen wenn er bei den aktiven spielt.	\N	\N	\N	\N	2024-01-14 17:43:31+00	\N	\N	2024-09-16 16:42:48+00	\N	t
67	Lucca Vollbrecht	l.vollbrecht@icloud.com	$2b$10$dnV.Eg9c2CpNBsipoXOcFuJoTMoxe4Y5Cwbxm5gEfgxc80aGfyh8m	2542021616150250428918514729381989797254333937160921011931572133212822022467880	user	0	\N	https://web.push.apple.com/QACB5jSqBa0jFhXOzJCPNcqRXgmIVB2mi5BugRDtqwGj6GLUEmo3QNqs42c7jos91WXTYtTIKvcqBOdeaVOvAQgqr8bocmg3wVAzynTtVU4wogGTQugG5-lGvbaCtEFuAwAASAkrJq7rcXEO6Z61uh98LGRd2hBMzvcS06CUex8	\N	BDEVLCzW3M7FnAc01sWt6FD40lvZJHFI8ELqUgmNbNNeFzJIInxZchq23C2ijXDbrtufEQMQ9xxFZHNskAzdhAs	3GJFzC__F2mm6dYWZ0A-zw	2023-11-20 11:35:14+00	\N	\N	2024-09-16 19:18:35+00	\N	t
205	Franziska Breitschädel	f.breitschaedel@gmx.de	$2b$10$M87B.mcfQYwu.lWpugQKrubA.oy0EQDLN6fxjkAZzHCdRLKkee8f.	1894329221051971941172168611674228123176180116951572461941042421701468273247368233	user	0	\N	\N	\N	\N	\N	2023-12-18 11:54:28+00	\N	\N	2024-09-21 08:42:11+00	\N	t
390	Alexander Baer	alexspielt@sudern.de	$2b$10$cNELzPryN3yZRXBr75jZm.lN2b.Y.oFiNo93/lQuZHNOmysZw9JC.	85136731891971005621624613641245204161567817225228250223742201001502717718624711468245	user	0	\N	\N	\N	\N	\N	2024-09-14 20:42:37+00	\N	\N	2024-09-21 09:19:20+00	13178239151179234155301561534445191573519842011813338864060322324779198813194	t
396	Anton Fröhler	antonfroehler@gmail.com	$2b$10$9lXjkgxeh4.qo6XloiMCIucVWC6X5.SRCnrUdvpfIVujMa6puPht6	5516613218640911002062137325171253426237178199568072248331722598114503178513	user	0	\N	\N	\N	\N	\N	2024-09-24 09:32:17+00	\N	\N	\N	2065821207145382321911412668147823019515814066241176812491581311331107016746953	t
391	Florian Alzner	florian.alzner@gmail.com	$2b$10$PjWENFrlU5E/YI8E26LkoelEE8zEH/1WPhtOAtns6DhFMtJ1KbzHG	1821811242269220520617021811866183162552551631451515812715420793121226129625029246209	user	0	\N	\N	\N	\N	\N	2024-09-16 17:30:38+00	\N	\N	2024-10-07 12:21:34+00	223129221207610824421359210431665122038931411761631231781281487619522110315611618419164	t
397	Manuel Meurer	manuel.meurer@o2mail.de	$2b$10$BOSc81R2C/bnq2LiIipG9.GW74LsyuLu4XX5do1SGVnyZNt.jepNm	5114883624312313014593741575232142158142251141233176381191211015117819914915286150230	user	0	\N	\N	\N	\N	\N	2024-09-24 18:40:18+00	\N	\N	\N	1962120621599887914423766731331551185797874818319876138223251189151219242190952145	t
399	Fabio Summ	fabio.summ@gmail.com	$2b$10$OLQuN2E7nJxBGxdXomMd6eiE3T5EyYqutNzw9KytSvIsBa12ZP1Um	108109551402312541761150512620421947253961407769184551263233591241582351811561350	user	0	\N	https://fcm.googleapis.com/fcm/send/fSK6dWgRTvM:APA91bHmAFpsbs-O8zWyBhZnluo2Qx7XfmXJpHaaTIBgfNPJiF6T-_IR0tUqOFsey2xgaWS6ttyDfOPiQobemrmFm1j7niJcNwrtNhkNF-RJ-vQuIZ9UuDmDc00Nr8uhK9erd3Sb45mI	\N	BK8tFcU-k6YXaZK6Y-5O1H_fTaD5O-8pWQwbsVYX_7bN-hyA_O183mG6vXjE_Zh1y9lyG11mp6UvA4I_9oignMw	BcNyjR5h78FefAARbHDZAg	2024-09-25 15:48:44+00	\N	\N	2024-09-27 20:08:41+00	192586115587684113420429186356234722077911681645247172352001111811201374595	t
393	Matthias Meier	matthias.meier.lb@gmx.de	$2b$10$6Gdp4nf3b2dY1jR/Y1gJy.5fxn/t.0qKTEkP6DQwXxrT59n.vHKl.	23819686173249190321461114417888539324313659255191166281457414063111334883193216	user	0	\N	\N	\N	\N	\N	2024-09-18 11:24:40+00	\N	\N	2024-10-10 09:59:42+00	178738022773158196541821978510116352171811471112452147297618250158166157720178112	t
398	Timo Arzt	timofarzt@gmail.com	$2b$10$/t69HO2yOnkg2qGcUBMS7usj2VGJ6u/6DzAfO6E2e0eavvGjca7Ma	25087130140832031861611611017317015311316510515411534831991043897641154753515323290	user	0	\N	\N	\N	\N	\N	2024-09-25 10:57:35+00	\N	\N	\N	1912023449312292292499823192181897216123422070135176599818318196180211686122211179	t
453	Patrick Neher	patrick-neher@t-online.de	$2b$10$H7PuIML.d1b7JUikb8sZS./hy2As/VcIVkL1fm3W5SeTUYUHNmvu2	16130217271441781023416318751712029792683524820625043441711702458120021413718222	user	0	\N	\N	\N	\N	\N	2024-10-07 12:36:17+00	\N	\N	\N	150585910882158215122147155241301562451581751862256919414640101204140190661887177213131	t
446	Konstantinos Pitarakis	pitarakiskonstantinos@gmail.com	\N	391502011931677247184783615821823292166117844702234453155861025918614212202248	user	0		\N	\N	\N	\N	2024-10-04 13:58:08+00	\N	\N	2024-10-07 13:35:22+00	9017920724968941141591151841251791332462232891180771174113974247472181427810195172174	t
400	Alea Troll	alea.troll@uni-konstanz.de	$2b$10$be4LyerUfrwb0irHzsOdnu6Y78zLqRhyimFyzdGf1.lv3yortP.Za	13420621318920889108623122813220121110238103195161129252612522071301532523086539188194	user	0	\N	\N	\N	\N	\N	2024-09-26 12:02:22+00	\N	\N	\N	1581165191181481269140917810918022188187122271461067132107394824235119252165184230	t
394	Paul Richtmann	paul.richtmann@uni-konstanz.de	$2b$10$1izM4A9SoQ82L6jBH38lEemUwhg/1qOTmF4yZHoUWD1U6IFeShBTC	42203107192452144822558120232162143222252372101523516022417811524795138141555312651115	user	0	\N	\N	\N	\N	\N	2024-09-23 09:34:58+00	\N	\N	2024-09-30 09:37:57+00	198801514287201882686166247177601149179138851111552101572051125952178719893219175	t
392	Julietta Gaus	juliettagaus@gmail.com	$2b$10$C9.T8gkpSt2FCKdcb5no5.zXZs5FPMJMHC9hFzXheJ5SOjcOIZAoS	2910870481387822972142491183917620716325219443216155101729219617771889217635246	user	0	\N	\N	\N	\N	\N	2024-09-17 15:33:07+00	\N	\N	2024-10-08 05:17:43+00	177252394420100241912479255225325137961802101110217714576164145183216133159128230	t
425	Jakob Fischer	jakob.fischer@htwg-konstanz.de	$2b$10$BNXVCO3saYXDQdkCJEhzn.rTzQd87KnXsbE4mvZSkqjLA1AfS.Wx.	20587861672511692102471361621081151917994115313524414054222451651351362922547616439	user	0	\N	\N	\N	\N	\N	2024-10-01 06:45:28+00	\N	\N	\N	140601291571872001612688392392111472551659247249782624317611841491942382831652149	t
405	Durim Goxhufi	durim.g@live.de	$2b$10$rWXkpZ4AGZ.rJTqHVGs9p.GN4h6bg1lu4Y0CV4t9NcCoZm0I6sfjG	555824324317594255203468844451691418832477819211347482111461581467118722116930168	user	0	\N	\N	\N	\N	\N	2024-09-27 11:51:13+00	\N	\N	2024-10-08 16:33:24+00	1052811223245148849845022262207911016456815030528713317097144221972161314583	t
421	Paul Dahncke	paul.dahncke@htwg-konstanz.de	$2b$10$iPnx0ZJl5omslUmBSzFI0uYJk0IafNNKc0keWIGAk8XkvdhynPyTu	90231211244159321131627570205349136227102301139524898214133181324747202573130	user	0	\N	\N	\N	\N	\N	2024-09-30 20:47:12+00	\N	\N	\N	195751481324109141541431491985759180321452252171801431821061137623721132229174210	t
395	Moritz Loch	loch.moritz@gmail.com	$2b$10$MdnB49Um5FT/8XvVcjcGX.OPFO9cjiVjGZVlZ8sXLpVehtRzEO9XG	139104731521161147966217230382613901001492118621721091461931821813222313147212253251	user	0	\N	\N	\N	\N	\N	2024-09-23 16:39:49+00	\N	\N	2024-10-09 21:13:21+00	240220194123268481194484134100131215291981231347912624624736111105412788248234182141	t
84	Chantal Kesting	chantal.kesting@uni-konstanz.de	$2b$10$zoon/FTauLfeCTa8sUKD0.xZc69K0Vs3BkR.2NbNbMknlhDpHez/u	25209244012018716824441253226224144194422421871751955183292108418716818720623041224	user	0	\N	\N	\N	\N	\N	2023-11-20 13:11:40+00	\N	\N	2024-10-01 14:21:17+00	\N	t
410	Tarek Havel	t.havel@outlook.de	$2b$10$CEut73hIipVA0n03OLeVKOkgzPrSXw/JFGyJ0LuTavwn1XO7140qK	1382528013320490321691352162081122381781681161431297567116517918133621613623923223813	user	0	\N	\N	\N	\N	\N	2024-09-28 17:12:25+00	\N	\N	2024-10-10 21:39:57+00	1147239128206182741921515685881911361028494831152471982720861122212012313817012120	t
59	Thomas Amann	thomasamann25@gmail.com	$2b$10$gQmF.yoeuoLvIwoSsvuse.R/TTMJIxvjs4y/HtH5ztgBsa.E4WDiC	161115792421653545128103820316191100219331511268721718911611716721411812012274193	admin	0	Orga - GOAT	https://fcm.googleapis.com/fcm/send/fQpiH7_wqCQ:APA91bHIVZMvbbhWtC_oj8OSxez7nTTtC9LhTVsZ8lWsAMXnfCZXVwDw1PuT0m1yn5N9Lk8TcVh6kMc7q-NUEfojaO-mxUg_wZhOxk7pmZhJDCB18RazqinPTnYM28O4bDChHqfCx7AM	\N	BCJOlSb5jjWNd5YyIsb1lqyIleKzkQycT3IPYneZ8XRxa5CrUTJ6EaCNb0F14AHcsimTsfZrRptCz9E0_hI5kjM	TmjsvVPNj96n2AtjJw7z9A	2023-11-20 08:59:15+00	\N	\N	2024-10-14 07:34:31+00	\N	t
264	Hannah SChütz	hannah.schuetz@htwg-konstanz.de	$2b$10$apzY4SooTJWSsZWAtziBZuudaiV8sDrh5BLUKO8Aw6qi8rCTaauVW	8723365752481445616268251237861539213612017013860255187161122162223904018153159	user	0	\N	\N	\N	\N	\N	2024-03-13 16:04:17+00	\N	\N	2024-10-14 07:59:49+00	\N	t
416	Alisa Helchenberg  II	alisa.helchenberg@hs-augsburg.de	$2b$10$iI7T0FaM86Lf4iyNk09XK.qzjoJQxWLsc2z044m8as2dRMSt0p1tu	261092091901591368862228205811215220342482072401951984224322516006723750183141144252	user	0	\N	\N	\N	\N	\N	2024-09-29 20:08:02+00	\N	\N	2024-10-14 09:04:42+00	70572362261108521731171164180152383415113217721623373141552551711606823824152123737	t
447	Nils Krellner	n.krellner@gmail.com	$2b$10$kZqx.fbjbWVgquM0w8I7OOivZjSQlKWehSBUyZaonzWI45Nv2Mv8m	543911020524223010720919616016418520023125419413119022331235115143109220601215815611412109	user	0	\N	\N	\N	\N	\N	2024-10-04 19:45:11+00	\N	\N	\N	381058781149434697105331941991292411523123417316054116170918145745512714077151120	t
454	Elia Link	elia.link2004@gmail.com	\N	24141547121741161032158734511611742421039172224109200158666150183166538179132103	user	0		\N	\N	\N	\N	2024-10-07 12:38:15+00	\N	\N	2024-10-07 12:48:58+00	2271404922022512514118122138711538310614921401852511362051801231397623778740255238212	t
457	Lena Alisha Buck	lena.buck@web.de	$2b$10$GoRJQC56Cn42Vx76V55rueeyL4GHEfqfUDK8x.qcOJSvWQhvM0HWa	2442081961252161141663011116249966121741031832363822815753205149247139201739416415071	user	0	\N	\N	\N	\N	\N	2024-10-08 07:39:30+00	\N	\N	\N	11319662026215547682041922341246743187189710441255217245188181592619728231197	f
462	aybears_	aybarsyesilcimen2005@gmail.com	\N	19820911618114411715212122646137127132146164101137292146618719619419421821719518421616820203	user	0		\N	\N	\N	\N	2024-10-08 12:32:14+00	\N	\N	2024-10-08 12:32:47+00	81110135244242892322221751341421251781181672501262410169811982332452161542132475018147145	f
422	Theo Burtscher	burtscher.theo04@gmail.com	$2b$10$XyIJ1B7x0Jnr3oX6JHfk6uBnQQBCSWHcE8E/nxX2BR40bfn3ooaHi	2411971771371017174297022914417415221406715922044250491562554035234354114021864167	user	0	\N	https://fcm.googleapis.com/fcm/send/d22kh-7cIzA:APA91bExI9H8DvFTcftnMcGqjXV20w8UWv5R534XrEmBjxSBpBnCkV-dXh861EUfOZZ-lSWdqvgL0llw3Az4bAURSeanxNwCwFWTM0eEuqotZiHlGHLA1d5N6eZH0UmUYRZuW_Wla2mJ	\N	BOT1WmpWeoJniRK-6E6dhJek_XrdqjOwD2wYypEIWrUZIUE2b5csd0RRgFbnOlbGMO4DEGevjmmQRRSJaW4rKrI	gKOFTYJAcOdebbVXnBakTA	2024-09-30 21:59:05+00	\N	\N	2024-10-08 15:09:00+00	271929869732512010229188155514192402241652261911202062415237154881731242351722	t
85	Daniel Vieira Cordeiro	daniel.bragavr@gmail.com	$2b$10$l3kPGgqtB9vZ4w0qOMtkG..sgKHh3tRp1eTEb.hqpDbgR3mM9N6n2	19715016524116020117120221115301233114824412214305435213177173183167131422122623814128	user	0	\N	https://web.push.apple.com/QEGdI3sssPfF6rZjP5CY4tk6MFIFugojNefZOeY419OUFgWPt-R6hLAM67ELVteGziTurB4rAcKgy3CyxvxPh5liVIKjvIjmRGSGKBSviAuQTUrNliuS6Mf7a9uJNwjKpzgaPHbOZ1EmNcrKuvfqhrJA2Uh3TMPR7XTQXvlTcfQ	\N	BKDl8ZktrKK9Dtv15b5wKvmAMv9UaF17bgSvojCPtu7AjrmQFQ14VJLlTW16rM5pjSyExb5ZBX28QMhyamJVLwk	QLc7OhV7hlBgap7cwOuuoQ	2023-11-20 13:13:40+00	\N	\N	2024-10-09 19:03:46+00	\N	t
467	Urs Zink	urs.zink@web.de	$2b$10$sCpRSUwRDrdDboPCSsipmOixwQXzmC2GN50NLgQ3MLOfMNYNOL8We	10522213081136352264125283781908712318413612016615224694172052081634321016416516229190	user	0	\N	\N	\N	\N	\N	2024-10-10 09:34:46+00	\N	\N	\N	2222512192042522148311820675156122223191701802225522541651692132017041168239160117144	t
403	alberto cabello	alber.cabello08@gmail.com	$2b$10$dTN6UazUX6zueZIu6Tj7NuVXG.r78zCCnSoKl/1Vk.ZABM7ukXbPC	731347557517391323717741588823163109752432351971591201288610346165551222129179	user	0	\N	\N	\N	\N	\N	2024-09-26 13:59:13+00	\N	\N	2024-10-11 12:45:25+00	185191393920286162164126102204721942223825317010916525179184229522321761872174913392163	t
475	Samuel Kostelac	s_kostelac@gmx.de	$2b$10$AbZdJ9GKXM8r8H6bj.unKuXcfKBiGVyvGyEucA2Xw6k2CRGHIwpjK	231122921642298812815373133985910925217816046217912261181331832364025125113462024219	user	0	\N	\N	\N	\N	\N	2024-10-11 18:02:59+00	\N	\N	\N	31544117916622523566163149904917718527911081474710911122228153402514593125	t
481	Raphael B.	rbuchmueller@googlemail.com	\N	292421441533034153222101195131110924618111494118932472622520814722672319618321221465	user	0		\N	\N	\N	\N	2024-10-14 10:57:34+00	\N	\N	2024-10-14 10:57:34+00	2291201894612316067224141162181591920321393248101811081801311998412223120225455248213	f
483	Leonie Kolb	leonie.kolb@uni-konstanz.de	$2b$10$TWP7rXAXVQZ4gL5s3T0D3ubFujvF30fmwNBsYi.YaOPTYwbml/uJ2	21213924818829112618225322712371622721639892142032382151412121327817221522615210398	user	0	\N	\N	\N	\N	\N	2024-10-14 10:59:35+00	\N	\N	\N	18723156223171252226781821915423636169221222152441491391783320955023810311517920069228	t
427	Liv Kühlmann	livi04@outlook.de	$2b$10$pigmLHQMCJH/uh/7c4Ym2ONiMafw5s54jOo2KjRK2SvKUoyasSFp2	211236141220169212139197229461758544235570171131215194152421441861311362912410939100224	user	0	\N	\N	\N	\N	\N	2024-10-01 08:47:26+00	\N	\N	\N	154163247125228231220167114941168108186217802111601277211141892443911119366102119155201	t
448	Rosa Gaia Cerone	rosagaiacerone@gmail.com	\N	25033822492001615564571882549437254701728916221221098172042511445132167194223219205	user	0		\N	\N	\N	\N	2024-10-05 10:15:04+00	\N	\N	2024-10-05 11:01:27+00	182992481471094419314412620525217157565711419921591611228585220461071614322532575	t
458	Lukas Bürk	lukasbuerk@icloud.com	$2b$10$qiWOuehn.iyJkMbmP5Ag9Om9cwCIxKpCG6kVtTBlMl4.P1fXmBU0m	2617510089189602018839371281081579322335237132716324016611258178104126103213143138	user	0	\N	\N	\N	\N	\N	2024-10-08 07:46:31+00	\N	\N	\N	1232217556957108218185678502521262210312182249253144153122196169648596419252113	t
455	Tim Böttger	timerics05@gmail.com	$2b$10$Wi.cOe34l92hPH/O0vW41.Lc5XwO2i5t8RtTbmWB.vBKljxMbOfoi	243148158197237136194184871492402271733213249134017923313319146200214197121225721857243	user	0	\N	\N	\N	\N	\N	2024-10-07 13:33:03+00	\N	\N	2024-10-07 13:59:34+00	2922758236183220171149617059217511422042710012851151472481881011457410311418342240230	t
382	Lisa-Soraya Ruf	l-s.ruf@t-online.de	$2b$10$kChbws4nK72Y9cSrjw12/.vWu14ybkHMS07x6Jc8gp4WdtPuNJmrm	164163118174561024012219196217991102041040102211502045013735416413931809613518468	user	0	\N	https://fcm.googleapis.com/fcm/send/eygi5r2SeYY:APA91bEN2e5h9fvhv27usboEzfezegfd-vOmD4mlALB7TgYyuX4kBRDBkXIJ_bUc8qmSs_cz-wriyxLqLM5cqSEbavSw6upt-c5zj21nsdd4TrxYaun2-aAh7taxrce0hjUSi8EXAIgI	\N	BAJ7WjXeJIYhWwa61uVqXP2SlIB9g78nPirFNWR7m03X_ntLooMLZTkrzKZT94uZLJCFtX--UJ51Q2-861aOGqU	2fhhEsGlRzPx_IMKrWrBiA	2024-09-06 19:21:32+00	\N	\N	2024-10-07 16:01:20+00	401642211692135815114229198164122201381257187200392622337122204147591201161168197254	t
459	RiickLiima	henriquea.delima@gmail.com	\N	1571031931541113216183197248128164250232846017761769113121151803014317831284220853	user	0		\N	\N	\N	\N	2024-10-08 07:51:58+00	\N	\N	2024-10-08 07:51:58+00	1565093723514041462710199520338201114931973324527271841134840197783233101223	f
169	Henrique de lima	henrique.lima.cardoso@outlook.com	$2b$10$CPq21.YUwWyl3yOkp6uThur69jh6XA5ng9/vm8sgbS7MdtuTbdW/u	132401022291117393172491841301301791581558422422237233012320422723011016258214183858	user	0	\N	\N	\N	\N	\N	2023-12-01 18:59:17+00	\N	\N	2024-10-08 08:07:43+00	\N	t
440	Daniel Sauer	daniel.sauer.sha@gmail.com	$2b$10$kV3RtbPCm80OCNraoAhbBudp0BuLxTiNXhEM2rxxjCBnQwUyYB/N2	1991592271951601269617120211410913923810612494180801975319057219148220281218710332127255	user	0	\N	https://fcm.googleapis.com/fcm/send/du2XQ399bnE:APA91bEwPI9W-NuFYXNgPY7eIIDx8a8zLF3RSzBGhO_VHCPfd_11MJZ8TZ_KyzfI1CYF1ccmOkMRWgy8hkhpFLsSJnFHxHiH4-zbt5fzKU97nsEOalAyg_3S2tyVHTB2NCW16AWnN6D6	\N	BLDbKP4gloyqJlWinTEIZlbTljwzL43QnMCB6M5OdmCcKIaetkfKm6D5bxGBYGv1voh5MU8Lg2UANASd1oSqf6Q	HPu9BG7UwUN5DIZQEd_psQ	2024-10-03 10:21:48+00	\N	\N	2024-10-03 10:28:40+00	11311532177938232187159274511725312591172215154611661681775045885524815120229222	t
464	Lukas Eberle	lukas.eberle@outlook.de	$2b$10$P3g9z8Lm31lIKbJ3/rnheeYYZRiwICGgfJxoy8x/bho4qz.ojOxsO	9483133255107922311732391261852241142392442141712204524575122957206921534011514320980	user	0	\N	\N	\N	\N	\N	2024-10-09 10:14:49+00	\N	\N	2024-10-10 09:59:00+00	31159472022544118124156221532361896119993769612310387111195164209228195153136642295	t
436	Jule Theiss	jule-theiss@web.de	$2b$10$oP74Nr9zbE15D3PaQqfsleYIGiyEuIl46jehgau7P3OT7/MqCU9ci	1762491201581611651196117537402085593178891141681882094912221585170568411423034172	user	0	\N	\N	\N	\N	\N	2024-10-01 19:06:59+00	\N	\N	2024-10-10 10:46:13+00	985219623425020559299410697207218252461191807220710429024414212220211945224360170	t
469	Artjom Stele	steleartjom@gmail.com	$2b$10$MCOuYuOnTcXMoIdywQHZEupRv4r2AwX/R2gxpOgLySKMKYJcyEiqK	346920918324720941371198129239109253124648459126791631387974180133310678218187	user	0	\N	\N	\N	\N	\N	2024-10-10 12:30:30+00	\N	\N	\N	69155215212151164245115159418712721825486130637912512213129221183331092412283382211	t
424	Lara Wenzel	lara.wenzel@htwg-konstanz.de	$2b$10$WyBninCDSR0OI/LiIk04EuEAz7QSsPF4pIlG/GI6tfOxGo.uypvhG	17017885222156201365117512313425029424181631922421499721529125134102127925256196	user	0	\N	\N	\N	\N	\N	2024-10-01 06:39:42+00	\N	\N	2024-10-01 06:50:03+00	75101112704825124482163291502620424117913222722397174188170160354893129198226171248138	t
470	Chiara von Roden	chiaravoro@gmail.com	\N	1202552419915811950929213234902044346168131216236395753183234191134198831771715	user	0		\N	\N	\N	\N	2024-10-10 22:28:24+00	\N	\N	2024-10-10 22:28:24+00	59102162172372221691368232221211123137167932141424613919812575159661422167913438224143	f
426	Sophia Kulcsar	sophiakulcsar1@gmail.com	$2b$10$QDexncTWbahJI2S1Smw.8emD9KTqA18D6fOdOlWqjviEPfAZF7FPy	2110928661251302221621671121531692339848567154164100243145249249401022311924100129184	user	0	\N	\N	\N	\N	\N	2024-10-01 07:21:08+00	\N	\N	2024-10-11 17:58:11+00	228110199181426844125117442017425016310818378574016830272201751791978201019620463	t
471	Chiara voro	chiaravoro22@gmail.com	$2b$10$lR13SAPiQVq7zxmDlhosLeyKId55.89dexTYP8wzt1pmFxUDWTRVW	11012716423815312911438920124669190115591912064418717912112921212721522816817321823395	user	0	\N	\N	\N	\N	\N	2024-10-10 22:44:34+00	\N	\N	2024-10-14 08:47:54+00	15119216652801771725511416220097891271049624224953173118129147623318858190202365314	t
473	Miriam mester	miriam.mester@web.de	$2b$10$fv8I4Tp4RCDpMWATGsWfE.Jp.nTopXgPlrOIi6uJJbEhCusuR81s2	13723572091301416257422141582084846610214379194124913118254219252714020220200167	user	0	\N	\N	\N	\N	\N	2024-10-11 13:40:35+00	\N	\N	2024-10-11 13:41:12+00	20010116710010821523868192216982977641806210611334961931627417110120159412586129236	t
404	Aike Brandstetter	aike.brandstetter@htwg-konstanz.de	$2b$10$BrT2E1/r6JsUXf9OsJXJdOwWQHzso4LOClygDz6lbz4Esme0MqLZO	431922372061242924716223728100671021420512352436118612422137210191178191211155155124134	user	0	\N	\N	\N	\N	\N	2024-09-26 15:56:47+00	\N	\N	2024-10-14 12:36:47+00	91691452919172636159245221341536588132501611089615919118312713625219775342005185	t
476	Christian Süss	christian.suess@htwg-konstanz.de	$2b$10$H5DgXq2q2CXjIFuUvwr.DuA.rgw8jbD.CeR7.eFWBvEpHWuP4CjxO	761761841371157455281781480276919992714122414151421921711477124320316210637224242	user	0	\N	\N	\N	\N	\N	2024-10-13 19:17:16+00	\N	\N	\N	27472201711123272121194178224142138514131341921211662242249801355620016448179116102	t
478	Arda Süslü	ar451sue@htwg-konstanz.de	$2b$10$0DNmff/a7GAl7B5ROSkeMeMkiVZk/OvvlNOZZ3UD8Fy46UnuhU4GS	142256543213244102145191255188100209112111281162192231381922225455166348223216112520557	user	0	\N	\N	\N	\N	\N	2024-10-14 09:59:44+00	\N	\N	\N	194228128240133101181779497139187261101421332212212222620548992928602162464254134185	f
479	Lea Schwendemann	lea-schwendemann@t-online.de	$2b$10$Whr6IUz4mj6gsRwKKEzdB.r.qzue9q1irNEqfSJFUBBiIG4fMDuqO	17223714291137333513243891311738123389591221971991301809204411765143481721924334	user	0	\N	\N	\N	\N	\N	2024-10-14 10:31:39+00	\N	\N	\N	2082031248240814611023225121231742062461711723319053231101462611419120111862169121135	t
468	Marcel Bosch	mrclbsch.7@gmail.com	$2b$10$sXSHQWYTcInD.507BDlpseAGxub74uUVjBjHQh26.MCcV47RsCaIq	45771263719722779189518250531997824787167961152122668147200123235612025145124129	user	0	\N	\N	\N	\N	\N	2024-10-10 12:22:25+00	\N	\N	\N	4723446023813813211226932421966114442138913916216718821620138021216218514323363	t
428	Zoe Burmeister	zoe.burmeister@gmx.de	$2b$10$Gkn4wHZPvswU2Ap/8HnTge5zXZW1AcjYje9EanKHMQNFIov3610hm	1734922190107243442099250414721248254187562302814587185972081602031214223150189176	user	0	\N	https://web.push.apple.com/QBEILoQ6ErZyWEzingzL4-qKyRnPgaUR6_q6TfDka7zFgHwpo4O-OXaryjsG7ovuaNKYFcerxYl3n1BPm1ZtmFgYF1JXSzlsD7Hvgq2P4rbDaAecMAz_P03_tgxd_I6n_EsK7nAR7lPNMoAUt3tHG6z87qe3COMF-GE-vTr-lnA	\N	BH2iF87t1HlgiVS7BIvZPR1VXp7KWSZ-0mSHAxHeZZsB10_oJan2JPn-sOHk8k6l5NEZ8tKcNQW48UqHqaJVJmM	EhUwoAmTo8kJZUetdDDM1w	2024-10-01 09:38:09+00	\N	\N	\N	31122202291171831340130192415449155532226751124346112242156194213301501301338854	t
439	Helen Beck	hln.5214@gmail.com	$2b$10$rAvpI3ypgQRj1yMEA4z0Q.v4XcSU2uVm4iWlnfy3hSKYetSPiN8Lm	6157961713141236781162491282425430301972922518921743391949497176220183374015990	user	0	\N	\N	\N	\N	\N	2024-10-02 16:40:53+00	\N	\N	\N	183237141401651862134080741891636115546137109681961711731161321031102391977120990148	t
429	felix haaga	haagafelix@gmail.com	$2b$10$pePXZFKYcc0yVwFqcHnOBOEqMG5OfNL4uot/yJFxBW9bgUIm9FhEG	75167620268179121568414023312959643404616188194149781091251361842181052429820688	user	0	\N	\N	\N	\N	\N	2024-10-01 11:59:51+00	\N	\N	\N	79181132211244734885167410510014252305914721219026254204741931763228232171175	t
433	Dorothee Hanko	dorothee.hanko@htwg-konstanz.de	$2b$10$Uahnq0v7SJN9JzdvXIKe6uRHJa6Bea8dhoAC.LUPRKQdfYRvVdfcq	44621802225711124217310781207381111881191100861152021501939242233851674221632784	user	0	\N	\N	\N	\N	\N	2024-10-01 16:55:04+00	\N	\N	2024-10-04 10:25:10+00	959913225479718010993245156154172242487510192154725510419420619228188632471709668	t
449	Rosa Gaia Cerone	r.cerone@campus.unimib.it	\N	15423225017222636525113433171124182193251111851955311132197158208153235212111161158253159	user	0		\N	\N	\N	\N	2024-10-05 10:57:03+00	\N	\N	2024-10-05 10:57:03+00	1498610810125512024119310519451233228165248791431482163148212098962012421956323414239	f
431	twinwin	jakob.fiehn@t-online.de	\N	87184181106103161174940290119820216454174772094223512215993165142241109181237194108	user	0		\N	\N	\N	\N	2024-10-01 12:28:23+00	\N	\N	2024-10-01 12:28:23+00	39962434126611759153241144142464725151179249163169161501302362115814620317516885158	f
432	Nicolas Ganzleben	nicolasganzleben@gmx.de	$2b$10$HrToLZAyYkjuAYHx278.fefjR5MZ70LYXmlopSS.9Ap.HKlQ9MVba	11614324888152591301241241221112453351638819025050214200473131391481701092106183186	user	0	\N	\N	\N	\N	\N	2024-10-01 12:31:55+00	\N	\N	2024-10-03 17:02:02+00	972311612126211824922020422117288124325011722521919332512052311357721561771729673	t
456	Arne Roth	arneroth27@gmail.com	\N	6913562113880143132101285570163805013060158293150182214249436291114105135204	user	0		\N	\N	\N	\N	2024-10-07 15:38:03+00	\N	\N	2024-10-07 15:38:23+00	2318221715515213120218244115147157222035232774069190263243119108772252081752432856	f
435	Felix Zimmermann	felix.z.privat@gmail.com	$2b$10$lVhCWOj83qePt03Q.fZ2oe7YN77qqXbCcKmFW8H/fIB06R7sXEb9i	17680202377745752112523523720118717913216136303615713365156121473797101951768154	user	0	\N	\N	\N	\N	\N	2024-10-01 17:17:37+00	\N	\N	\N	22711218298102201571802223511718029171467115416868655867228202150602032624523213412	t
401	Soňa Ciklaminiová	ciklaminiovasona@gmail.com	$2b$10$fPP0540l3XCEFRnbdC9TkOIfhXau7FaNzS.Qgto48c9sdxGIXjGf.	489419525375227518896216967715324811615742145120925521714216524765112137229132241223	user	0	\N	\N	\N	\N	\N	2024-09-26 13:52:20+00	\N	\N	2024-10-01 21:20:58+00	2393910488161210901142091011917155191152921151042422668167141126131102157129205133180244	t
437	Magnus Schmid	magnus.schmid@htwg-konstanz.de	$2b$10$k/q3tK6xx62qm31qYzdY0uHfy17MTnEmMr7oLJYgjbvnd6LypuKpC	51917918655942171062411781612091951771292091994779197131188174719364699212825315	user	0	\N	\N	\N	\N	\N	2024-10-02 10:49:13+00	\N	\N	\N	5216811561812216239192205214235521052249529391191292251891729110210657142198116118155	t
438	Manuel Bacolla	manubacolla@gmail.com	$2b$10$NllA1MSw/t4kCtiomwViYunbjKuTBXOZJsGqFyEY/48eY2jNedr1m	2271422854134223571986322039181235412361582232512211543323017224214984532312061272790	user	0	\N	\N	\N	\N	\N	2024-10-02 12:53:38+00	\N	\N	\N	871341811761952251492361443510383218317536120474916071271996724261141531123316740	t
460	Theo Prinz	theo.prinz20@gmail.com	\N	212721551112131812111991202012259622822910613118889941871791172161341324286172113250	user	0		\N	\N	\N	\N	2024-10-08 08:57:04+00	\N	\N	2024-10-08 08:57:04+00	15224839310020664193796911424115011119541632542021201418663191967611818319341046	f
47	Thomas Bantle	thomas-bantle@web.de	$2b$10$K.OXHnC8DgS9Gus4NIS6veFkxXOnjcmyrjVjAqq3oX832LkTXmaT2	1331271811939217819775712824325225371592161175524331521719511710421218714618379212176	user	0	\N	https://web.push.apple.com/QO6ZudjLPWRXiwQL1DhmtU9I-EdG7gnPw3pke9RPiHHDKuWK09PLoYBSgz514KeRKrIFWWzNs0lAbxvXEmqWrW-WBNTXkYtAsQQhiuS6e5-zhuvRieic-m2M-8_dqKD-ZfPWCJ7Rm6OApNLyY_hNHK3m7BDkN7R0TX6Q2TwZ-6Q	\N	BG5H2_tQP6sqgUcXKoslKT5DEXfpkHeDBWj64AytfdMT5ECcHlp9otgF9dDmTVyR5QvGjLvBtWmsHHTYmZS0z_0	1oxtQCqCafocbuiPfQuzqQ	2023-11-19 20:14:13+00	\N	\N	2024-10-14 13:13:26+00	\N	t
368	Clemens Brosch	clemensbrosch@t-online.de	$2b$10$J/Jsv1SP79UC/V0fEB9ouu8TzPBjkntJG1KDmfZFpZlrU0JKrbHEe	2120522918344202719157160248192444121217638875112243169191081781622068592162154255	user	0	\N	https://web.push.apple.com/QH2_5cAOSSENgt8opYNy_8MpKGwBE4VPoTSg001YvHScwzvyOxsAN9wSOlMTS9DG3s8feTLjqbvQoo-u2-c4BOGwOa-wBqvNmPAq44mt6U8cScB723tZSlgXlE0YgGesQQm1dTWs05Z3LuUw0iuAoQiFfX6ahcjndDFqKi65QA4	\N	BJAxk7chpZ91oAbmAH9-VcypWf0pZg2_PjWxNdc4r4wLeDkruWxAHNDJ5w583Szfeq6hqXW3T2HmwELNi_xxg2I	kv-yi_s9xj2jgUdtvakCUA	2024-07-03 10:10:41+00	\N	\N	2024-10-03 10:16:21+00	1331739416215212147168168331812151891869921841015999242228152782419916277342353725	t
430	Luis Klimas	luisklimas3@gmail.com	$2b$10$9Yx42ZEOKxvgv/OKvins3umHdr8TlTW7IqC63ovwOt6uAcK8QnB8i	178401687410220768193141109143248169725313020716020431161128180121255722382322481832135	user	0	\N	\N	\N	\N	\N	2024-10-01 12:24:16+00	\N	\N	2024-10-14 10:49:57+00	15220716222476134483982012957141203103551951351314112017817901411303925215012813193	t
434	Maurice Schoch	maurice.schoch12@gmail.com	$2b$10$TEfDbvSamf7e3irSLNo5lOaYD7hqRJLkw9QVR7Fub.c79tuRywQLm	1002751153123214199951291531325322621986289774121243695142224415233538174176	user	0	\N	\N	\N	\N	\N	2024-10-01 17:01:48+00	\N	\N	\N	6382299930142841293621772143319782168145217190239132118140160612477719026130149235	t
358	Feline Bluthardt	feline.bluthardt@gmail.com	$2b$10$l9Fz8Nm6cVbAkIm4HCnb5.PTvnc7MwKM8GQ9NPV6PB4eVIIEb0Fl6	115124617826132382402392431996961992331131131981782229248140936321929362843110	user	0	\N	\N	\N	\N	\N	2024-06-13 16:46:42+00	\N	\N	2024-10-03 11:49:03+00	78168177130834251235362199207129713910621655246248831801791492254150156224243180186	t
441	Selina Barthel	selina.barthel1@gmail.com	$2b$10$IDpmxEIO5WVUQlDyMpa8COXWhDejzI7pFQmSIJDV2lnco3kznNl1y	2416317917324518323524458811975467101528423111911811341196235108245222244441514	user	0	\N	\N	\N	\N	\N	2024-10-03 13:45:27+00	\N	\N	\N	129166238609121322419198859631171981369418529251210149112633811742216791457324249	t
463	Luis Ruch	luisruch35@gmail.com	$2b$10$zsEzzlmgHMMcDozvWUaVtOcxE/lBiDB7vWSWnf38fJ2lTI9Ci7wZW	542502251951491501622248851163218227893222514117913636721311682613110139451611816878	user	0	\N	\N	\N	\N	\N	2024-10-09 06:35:43+00	\N	\N	2024-10-10 10:30:21+00	1701786323470166923193165301772011642152419814216961217425119421111297201553822493	t
450	Katharina Lavendel	kathi.lvd@outlook.com	$2b$10$8MLDCCWx.T.MGnOYoqJryOxQaWAFGfv6o.Tg4J.DQbmpLnuhOQzvi	10120023164641822019181502221621151701310923195212441039620324747124197222235191214	user	0	\N	\N	\N	\N	\N	2024-10-06 08:28:43+00	\N	\N	\N	144316622112819215521311214497203208191451122141362148274818721513974367210576219	t
472	Noemi Grandpre	noemi.grandpre@web.de	$2b$10$KmeiO7zhxF6z.N5APlb6j.EjMG0X2M7QgfgXh4ODaxOtWS/hCBgsm	692310415723825025222866175107121147198139106227244231227103381201931621317723441202112228	user	0	\N	\N	\N	\N	\N	2024-10-11 10:33:26+00	\N	\N	\N	1201452491953214138237230158195207144963794871824919293272461681413619151658022168	t
465	Rike Mehlberg	rike.mehlberg@htwg-konstanz.de	$2b$10$r5uO3wjoKyhCMQOEYq1rceTg3.6GtRTE0RTsiE1GIBUjtKjNWt55a	1651381582031164016814217221982362052452136023417031361815492475618976971370245	user	0	\N	\N	\N	\N	\N	2024-10-10 07:41:29+00	\N	\N	\N	149194153187242148971078618213421820821324014420014157185161541032321721821202501185223868	t
466	Anne Sexauer	anne.sexauer@htwg-konstanz.de	$2b$10$dgbrych5Zne/WxambGASYOmKhsnYWeioglNN4ZyWzcbp.AuHIaWqS	75851175074284775471083951201452431818963154351102341288324299293187183185109	user	0	\N	\N	\N	\N	\N	2024-10-10 07:42:41+00	\N	\N	\N	23167124816709324619825117242772162332921722717221413182133399616910241078462155	t
474	Mathilda Dettling	mathilda.dettling@icloud.com	$2b$10$dsTZinC3pBEZ2qbFNn44COCd/Tue/2SsVeiigwAClwAnI94K3CjKi	90204621054185246221442177347186112205104542157812811861123612346920323213114714139	user	0	\N	\N	\N	\N	\N	2024-10-11 15:45:33+00	\N	\N	\N	15516648178311941272045570421934298159122202915122420715620414261138217101150197170189	t
12	Jonah Wonerow	j.wonerow@gmail.com	$2b$10$wtj2XhQnanOoOzZM0J7F9eQE3wX.n5s9NV4uDmOtWvIhBzR.nmUkm	2364112519510913202186821991361572211462720110424718419819525013980932133412721453355	admin	0	Turniersieger #2 2023	https://fcm.googleapis.com/fcm/send/euSHJ-cw5yc:APA91bEo71UaeySakicHKD8Fg91L3MVOAy-FkzGTpHDORXofdTmheMya7b5bTDBD6b8GOsQi4GLKsGwQnOOjVK4ysbk1trJd6cSoPop_x-npKH9L8y8I5vNBsbpa7lpSrNsm2lX7hqcw	\N	BKWYn23DeTbYnSU48DHauAWAqViZuasFK6s5RS3DGuuyTMPw4__2Q96XxQqjAiMo7mTafWy0lloGOYLHaq6l6ks	X-SYD8nut-KthYxwdT7Rpg	2023-11-16 18:28:12+00	\N	\N	2024-10-13 19:57:23+00	\N	t
477	Veronica Borgobello	veronica.borgobello@gmail.com	$2b$10$sS6bhMQNlfYrf0FESdIQ7uphbwpar7nWyAkOQ.Ss3PBmqXDvlkghG	1122168324916616536172106621021015073821918721244304624818425523319811518421473115217	user	0	\N	\N	\N	\N	\N	2024-10-13 20:03:08+00	\N	\N	\N	1738173215164109702476521623011319812649244239233191235421242402501433579202551996927	t
461	Theodor Prinz	theo-prinz@web.de	$2b$10$hNfz1yO9.NOeaRMKSVQ3aOjcglk/jLMbfv4IpLxVwYBipw72pv5z6	166205216116180722625318119913207188142722217216939171447333508882724119123195	user	0	\N	\N	\N	\N	\N	2024-10-08 08:58:34+00	\N	\N	2024-10-14 08:08:52+00	763924746234321887816245232272294589885820224317023278155117170212178228616719212	t
260	Arian Braun	arian.braun@htwg-konstanz.de	$2b$10$Hd3mQXDaRGMaCThvLXO40etDlCClhe7e1lJx43Qe4WaK3/52ERrJu	77241311297522204418819012321065179200146961338892129179255132104665710112521842	user	0	\N	https://fcm.googleapis.com/fcm/send/eFydDx6zOqk:APA91bEx4IuJvg2L0HOLB7_rHxtg6uah10O_3cYZTpTaf2YUPiCj8Ai4A-37UUUuJAXCTv-SatI32erN7PtGTeZRTd9ng_t-0ac_MfAf-cfWWgiYrWx9C04GhnXhIjU-cQilfDCZDT9K	\N	BBZqvVBaVKLnYrd-uYNmb3d4xK2_FImCXbLCsNlz2RrsG0M2m7X0Z9_Z2sEtDo9g2s01TU5w5z_Ojzmg_VPSngM	JjQ7kWW5RsHqUQqM3xL2cw	2024-03-11 13:16:07+00	\N	\N	2024-10-14 09:59:09+00	\N	t
480	Celine Grimon	ce741gri@htwg-konstanz.de	$2b$10$VtEnGqxIEwvfjqiPYiC4Hektkl5tdhEIv9J4YnAQGiyOvRUeaUzW2	1392073096772041601232111443685203167631311051842723418161617511411114698496312515	user	0	\N	\N	\N	\N	\N	2024-10-14 10:50:01+00	\N	\N	2024-10-14 10:50:31+00	8415016121759210221153125412717114921619134288913425218024424822810919919015218672240189	t
482	Raphael  Buchmueller	raphael.buchmueller@uni-konstanz.de	$2b$10$88dFa7hfyIGvuc4bFQLc4.Yh2/ueoh0tAVN230F/.IP6Qkz48wR3W	41391994617517781379923011915712765159351172012613841234177521800132010423735173	user	0	\N	\N	\N	\N	\N	2024-10-14 10:58:02+00	\N	\N	\N	253388867201911619014711922548801976812992233805011360104966018321105625147100	t
\.


--
-- Data for Name: course_spots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_spots (course_id, user_id, created_at) FROM stdin;
56	58	2023-12-07 11:06:36+00
41	113	2023-11-22 08:47:35+00
46	23	2023-11-22 09:39:11+00
44	23	2023-11-22 09:39:27+00
41	102	2023-11-22 10:32:02+00
108	59	2024-04-16 07:12:43+00
40	1	2023-11-16 16:40:01+00
41	34	2023-11-22 10:46:42+00
78	59	2024-01-23 11:56:53+00
46	14	2023-11-22 15:50:38+00
40	41	2023-11-22 16:09:53+00
78	23	2024-01-23 22:23:01+00
55	76	2023-12-07 11:06:48+00
56	37	2023-12-07 11:07:13+00
57	37	2023-12-07 11:07:18+00
54	56	2023-12-07 11:07:45+00
39	14	2023-11-16 20:38:35+00
40	14	2023-11-16 20:38:45+00
77	23	2024-01-23 22:23:07+00
57	39	2023-12-07 11:10:54+00
55	179	2023-12-07 11:18:23+00
39	17	2023-11-17 06:01:48+00
40	17	2023-11-17 06:01:57+00
41	116	2023-11-22 20:18:29+00
53	108	2023-12-07 11:23:26+00
41	119	2023-11-23 03:29:30+00
40	21	2023-11-18 11:54:28+00
78	17	2024-01-24 05:56:36+00
56	107	2023-12-07 11:26:57+00
40	22	2023-11-18 12:00:50+00
53	107	2023-12-07 11:27:02+00
54	72	2023-12-07 11:30:49+00
55	93	2023-12-07 11:42:41+00
39	23	2023-11-18 12:02:00+00
55	181	2023-12-07 11:49:46+00
55	47	2023-12-07 11:52:22+00
39	1	2023-11-18 12:54:18+00
77	17	2024-01-24 05:56:41+00
38	24	2023-11-18 16:09:14+00
109	59	2024-04-16 07:12:47+00
39	26	2023-11-18 16:12:13+00
40	26	2023-11-18 16:12:22+00
39	30	2023-11-18 18:52:52+00
54	137	2023-12-07 11:55:05+00
44	1	2023-11-23 10:20:41+00
40	30	2023-11-18 18:52:59+00
44	40	2023-11-23 11:00:04+00
39	32	2023-11-18 19:59:04+00
44	96	2023-11-23 11:00:06+00
38	35	2023-11-19 07:12:52+00
46	73	2023-11-23 11:00:06+00
38	29	2023-11-19 10:31:47+00
46	40	2023-11-23 11:00:08+00
46	39	2023-11-23 11:00:10+00
78	12	2024-01-24 11:05:31+00
39	38	2023-11-19 11:26:52+00
40	38	2023-11-19 11:27:10+00
39	39	2023-11-19 11:31:15+00
40	39	2023-11-19 11:31:22+00
39	40	2023-11-19 11:34:53+00
40	40	2023-11-19 11:35:04+00
44	31	2023-11-23 11:00:52+00
39	41	2023-11-19 13:02:32+00
38	42	2023-11-19 13:04:38+00
39	43	2023-11-19 13:13:15+00
40	43	2023-11-19 13:13:19+00
40	44	2023-11-19 14:16:51+00
38	45	2023-11-19 17:00:09+00
39	46	2023-11-19 17:43:57+00
40	46	2023-11-19 17:44:14+00
38	47	2023-11-19 20:15:09+00
38	34	2023-11-19 22:08:51+00
54	80	2023-12-07 12:03:40+00
43	76	2023-11-23 11:01:03+00
40	49	2023-11-19 22:40:58+00
79	12	2024-01-24 11:26:37+00
39	49	2023-11-19 22:44:03+00
44	22	2023-11-23 11:01:26+00
37	55	2023-11-20 08:40:45+00
37	56	2023-11-20 08:41:00+00
40	54	2023-11-20 08:41:13+00
54	97	2023-12-07 12:08:54+00
39	58	2023-11-20 08:57:32+00
40	58	2023-11-20 08:57:37+00
54	128	2023-12-07 12:35:05+00
54	88	2023-12-07 12:39:10+00
40	23	2023-11-20 09:02:57+00
54	126	2023-12-07 12:41:44+00
40	59	2023-11-20 09:10:00+00
41	59	2023-11-20 09:10:48+00
38	60	2023-11-20 09:20:59+00
37	61	2023-11-20 09:44:45+00
37	62	2023-11-20 09:47:27+00
38	63	2023-11-20 10:01:28+00
44	110	2023-11-23 11:07:23+00
44	87	2023-11-23 11:12:09+00
44	85	2023-11-23 11:14:17+00
46	85	2023-11-23 11:14:24+00
40	31	2023-11-20 10:59:55+00
41	31	2023-11-20 11:00:36+00
41	58	2023-11-20 11:00:41+00
41	57	2023-11-20 11:26:56+00
41	67	2023-11-20 11:37:55+00
41	32	2023-11-23 11:14:46+00
41	68	2023-11-20 12:01:15+00
41	12	2023-11-20 12:40:02+00
46	21	2023-11-23 11:18:31+00
41	66	2023-11-20 12:45:13+00
41	71	2023-11-20 13:01:13+00
37	72	2023-11-20 13:01:31+00
38	76	2023-11-20 13:01:58+00
41	40	2023-11-20 13:02:04+00
43	47	2023-11-23 11:32:11+00
38	70	2023-11-20 13:02:12+00
38	74	2023-11-20 13:02:19+00
42	72	2023-11-23 11:34:19+00
40	77	2023-11-20 13:02:51+00
37	80	2023-11-20 13:04:59+00
43	94	2023-11-23 11:37:43+00
41	49	2023-11-20 13:07:51+00
41	30	2023-11-20 13:09:35+00
38	83	2023-11-20 13:09:40+00
38	85	2023-11-20 13:14:04+00
40	85	2023-11-20 13:14:13+00
41	85	2023-11-20 13:14:18+00
37	88	2023-11-20 13:20:47+00
43	122	2023-11-23 11:43:45+00
39	90	2023-11-20 13:26:48+00
40	90	2023-11-20 13:26:55+00
41	90	2023-11-20 13:27:01+00
44	93	2023-11-23 11:47:31+00
37	89	2023-11-20 13:43:50+00
38	93	2023-11-20 13:44:07+00
41	92	2023-11-20 13:44:20+00
41	93	2023-11-20 13:44:22+00
37	94	2023-11-20 13:48:15+00
37	95	2023-11-20 13:50:21+00
39	96	2023-11-20 13:50:30+00
37	97	2023-11-20 13:54:16+00
37	91	2023-11-20 13:56:22+00
44	44	2023-11-23 11:49:19+00
46	44	2023-11-23 11:49:26+00
40	100	2023-11-20 14:21:35+00
38	102	2023-11-20 14:36:22+00
37	103	2023-11-20 14:47:59+00
41	23	2023-11-20 15:10:08+00
38	99	2023-11-20 15:40:31+00
41	17	2023-11-20 16:19:34+00
41	46	2023-11-20 16:45:49+00
41	108	2023-11-20 17:57:15+00
43	120	2023-11-23 11:52:20+00
43	74	2023-11-23 11:53:37+00
39	85	2023-11-20 19:31:29+00
41	29	2023-11-20 19:41:23+00
41	47	2023-11-21 06:45:47+00
41	110	2023-11-21 07:57:45+00
41	51	2023-11-21 12:28:57+00
44	17	2023-11-21 15:41:05+00
46	17	2023-11-21 15:41:14+00
43	46	2023-11-23 12:00:08+00
42	97	2023-11-23 12:00:49+00
44	12	2023-11-21 23:01:11+00
46	12	2023-11-21 23:01:17+00
42	56	2023-11-23 12:00:59+00
43	83	2023-11-23 12:01:03+00
42	55	2023-11-23 12:05:49+00
42	80	2023-11-23 12:07:49+00
43	123	2023-11-23 12:13:11+00
44	38	2023-11-23 12:24:26+00
46	38	2023-11-23 12:24:34+00
42	125	2023-11-23 12:31:21+00
42	89	2023-11-23 12:37:33+00
42	126	2023-11-23 12:37:50+00
42	127	2023-11-23 12:53:56+00
42	52	2023-11-23 13:01:50+00
43	24	2023-11-23 13:04:17+00
46	49	2023-11-23 13:17:27+00
43	49	2023-11-23 13:17:34+00
43	27	2023-11-23 13:19:23+00
43	20	2023-11-23 13:21:27+00
42	88	2023-11-23 13:51:11+00
42	128	2023-11-23 14:11:28+00
43	102	2023-11-23 14:50:20+00
79	68	2024-01-24 11:33:59+00
42	129	2023-11-23 15:17:44+00
43	130	2023-11-23 16:42:34+00
43	134	2023-11-23 17:10:02+00
42	62	2023-11-23 17:52:23+00
55	191	2023-12-11 09:08:10+00
43	63	2023-11-23 18:25:41+00
43	29	2023-11-23 18:58:31+00
55	192	2023-12-11 09:11:25+00
42	136	2023-11-23 19:55:30+00
46	121	2023-11-23 20:18:03+00
42	95	2023-11-23 21:14:11+00
55	193	2023-12-11 10:39:59+00
44	60	2023-11-23 21:24:20+00
109	17	2024-04-16 07:40:16+00
44	26	2023-11-23 21:46:53+00
46	26	2023-11-23 21:47:02+00
41	26	2023-11-23 21:47:08+00
55	146	2023-12-11 11:51:29+00
43	69	2023-11-23 22:59:04+00
42	137	2023-11-23 23:10:29+00
46	77	2023-11-23 23:31:03+00
42	138	2023-11-24 02:45:32+00
44	54	2023-11-24 06:00:17+00
43	91	2023-11-24 07:42:27+00
42	139	2023-11-24 07:59:18+00
44	58	2023-11-24 08:12:40+00
57	146	2023-12-11 11:51:37+00
58	59	2023-12-12 07:45:43+00
108	17	2024-04-16 07:40:21+00
42	111	2023-11-24 08:58:33+00
42	141	2023-11-24 15:44:57+00
42	143	2023-11-24 21:09:01+00
44	41	2023-11-24 23:01:02+00
79	66	2024-01-24 11:34:49+00
44	145	2023-11-25 07:50:57+00
46	145	2023-11-25 07:51:01+00
44	107	2023-11-25 07:51:03+00
79	31	2024-01-24 11:37:39+00
43	148	2023-11-26 11:20:47+00
43	149	2023-11-26 11:38:07+00
42	144	2023-11-26 16:01:16+00
43	144	2023-11-26 16:01:36+00
43	151	2023-11-26 18:00:01+00
44	146	2023-11-27 12:58:29+00
43	152	2023-11-27 13:47:53+00
109	13	2024-04-16 09:27:29+00
44	68	2023-11-27 15:34:37+00
43	68	2023-11-27 15:34:52+00
79	58	2024-01-24 11:42:58+00
46	156	2023-11-28 14:48:57+00
79	41	2024-01-24 11:45:23+00
49	59	2023-11-29 19:46:39+00
57	110	2023-12-13 14:29:02+00
52	59	2023-11-29 19:50:59+00
49	1	2023-11-30 08:54:19+00
59	159	2023-12-14 11:00:09+00
49	96	2023-11-30 11:00:18+00
48	46	2023-11-30 11:00:18+00
59	96	2023-12-14 11:00:13+00
59	58	2023-12-14 11:00:32+00
52	26	2023-11-30 11:00:32+00
49	37	2023-11-30 11:00:32+00
49	39	2023-11-30 11:00:37+00
49	26	2023-11-30 11:00:38+00
58	26	2023-12-14 11:00:54+00
59	12	2023-12-14 11:00:55+00
59	136	2023-12-14 11:01:02+00
58	30	2023-12-14 11:05:21+00
48	76	2023-11-30 11:00:49+00
47	136	2023-11-30 11:00:53+00
49	85	2023-11-30 11:01:39+00
52	85	2023-11-30 11:01:58+00
52	49	2023-11-30 11:04:53+00
61	17	2023-12-14 11:18:55+00
47	161	2023-11-30 11:11:54+00
52	102	2023-11-30 11:12:01+00
61	39	2023-12-14 11:19:08+00
49	22	2023-11-30 11:14:31+00
61	40	2023-12-14 11:21:25+00
49	23	2023-11-30 11:17:15+00
52	57	2023-11-30 11:19:17+00
52	67	2023-11-30 11:27:04+00
48	83	2023-11-30 11:30:15+00
47	72	2023-11-30 11:39:43+00
52	100	2023-11-30 11:43:17+00
49	100	2023-11-30 11:43:26+00
61	59	2023-12-14 11:26:54+00
48	93	2023-11-30 11:53:01+00
61	22	2023-12-14 11:27:53+00
49	44	2023-11-30 11:56:22+00
48	28	2023-11-30 11:56:46+00
61	83	2023-12-14 11:46:13+00
47	55	2023-11-30 12:00:18+00
47	97	2023-11-30 12:00:32+00
49	38	2023-11-30 12:00:58+00
58	34	2023-12-14 11:46:31+00
58	193	2023-12-14 11:46:35+00
61	193	2023-12-14 11:46:48+00
48	49	2023-11-30 12:10:30+00
52	147	2023-11-30 12:13:37+00
48	35	2023-11-30 12:25:17+00
49	12	2023-11-30 12:30:46+00
47	88	2023-11-30 12:34:09+00
47	89	2023-11-30 12:46:18+00
47	143	2023-11-30 12:52:06+00
52	143	2023-11-30 12:52:18+00
47	163	2023-11-30 12:53:58+00
52	163	2023-11-30 12:54:10+00
47	127	2023-11-30 12:54:30+00
47	128	2023-11-30 12:55:47+00
47	62	2023-11-30 13:09:46+00
47	95	2023-11-30 13:43:48+00
52	12	2023-11-30 13:44:38+00
48	112	2023-11-30 14:03:11+00
47	126	2023-11-30 15:08:47+00
52	63	2023-11-30 15:41:37+00
47	52	2023-11-30 15:45:49+00
49	165	2023-11-30 16:21:27+00
48	94	2023-11-30 16:46:11+00
48	122	2023-11-30 16:47:28+00
48	123	2023-11-30 16:48:45+00
52	60	2023-11-30 20:48:02+00
48	60	2023-11-30 20:48:11+00
47	164	2023-11-30 20:56:03+00
52	51	2023-11-30 22:08:55+00
48	47	2023-11-30 22:29:33+00
48	69	2023-11-30 23:21:26+00
52	54	2023-12-01 08:39:22+00
47	138	2023-12-01 08:51:28+00
52	58	2023-12-01 11:32:32+00
49	58	2023-12-01 11:32:42+00
49	68	2023-12-01 11:48:39+00
52	104	2023-12-01 16:51:07+00
48	63	2023-12-01 18:39:55+00
52	169	2023-12-01 19:00:45+00
52	170	2023-12-01 22:16:48+00
52	71	2023-12-02 10:34:59+00
48	70	2023-12-02 13:49:29+00
47	141	2023-12-02 14:42:59+00
48	149	2023-12-04 00:38:42+00
47	172	2023-12-04 09:42:58+00
48	176	2023-12-04 14:08:09+00
48	66	2023-12-04 16:47:05+00
49	86	2023-12-04 17:53:50+00
53	14	2023-12-06 10:32:57+00
53	70	2023-12-06 11:28:08+00
53	178	2023-12-06 11:32:55+00
53	54	2023-12-06 12:15:05+00
53	58	2023-12-06 14:13:21+00
53	159	2023-12-06 15:56:22+00
53	60	2023-12-06 16:12:20+00
56	23	2023-12-07 09:49:30+00
57	23	2023-12-07 09:49:39+00
57	1	2023-12-07 10:40:02+00
56	1	2023-12-07 10:40:06+00
53	85	2023-12-07 10:47:57+00
57	12	2023-12-07 10:55:02+00
53	46	2023-12-07 10:59:02+00
53	68	2023-12-07 11:00:05+00
56	73	2023-12-07 11:00:07+00
56	96	2023-12-07 11:00:08+00
54	136	2023-12-07 11:00:08+00
56	68	2023-12-07 11:00:12+00
56	38	2023-12-07 11:00:13+00
57	38	2023-12-07 11:00:20+00
56	26	2023-12-07 11:00:26+00
57	40	2023-12-07 11:00:26+00
57	26	2023-12-07 11:00:30+00
56	22	2023-12-07 11:01:02+00
56	21	2023-12-07 11:01:05+00
56	43	2023-12-07 11:01:13+00
57	43	2023-12-07 11:01:18+00
56	49	2023-12-07 11:01:32+00
56	121	2023-12-07 11:01:36+00
57	46	2023-12-07 11:01:42+00
56	30	2023-12-07 11:02:04+00
53	30	2023-12-07 11:02:10+00
54	55	2023-12-07 11:02:21+00
55	99	2023-12-07 12:53:58+00
53	71	2023-12-07 12:56:41+00
54	143	2023-12-07 13:06:15+00
53	143	2023-12-07 13:06:19+00
53	105	2023-12-07 13:09:16+00
79	57	2024-01-24 11:49:53+00
53	102	2023-12-07 13:14:21+00
57	159	2023-12-07 13:41:56+00
54	127	2023-12-07 13:48:35+00
53	63	2023-12-07 13:55:37+00
55	63	2023-12-07 13:55:49+00
54	161	2023-12-07 13:56:59+00
55	149	2023-12-07 14:11:55+00
55	148	2023-12-07 14:12:17+00
79	170	2024-01-24 11:51:21+00
54	129	2023-12-07 15:36:21+00
55	130	2023-12-07 15:40:26+00
55	154	2023-12-07 15:42:59+00
55	134	2023-12-07 15:43:09+00
55	28	2023-12-07 16:15:07+00
55	182	2023-12-07 16:23:33+00
55	85	2023-12-07 16:46:19+00
57	85	2023-12-07 16:46:25+00
108	13	2024-04-16 09:27:37+00
54	183	2023-12-07 16:48:31+00
55	60	2023-12-07 17:06:53+00
57	60	2023-12-07 17:06:59+00
108	49	2024-04-18 10:00:06+00
53	29	2023-12-07 18:39:39+00
54	141	2023-12-07 19:56:46+00
54	185	2023-12-07 20:21:28+00
53	185	2023-12-07 20:21:42+00
55	69	2023-12-07 21:23:33+00
55	83	2023-12-07 22:55:00+00
55	120	2023-12-08 01:15:46+00
56	17	2023-12-08 06:14:49+00
57	17	2023-12-08 06:14:55+00
55	45	2023-12-08 08:46:35+00
54	95	2023-12-09 19:32:03+00
54	70	2023-12-10 16:52:59+00
55	70	2023-12-10 16:53:08+00
57	54	2023-12-11 15:36:26+00
56	110	2023-12-11 17:02:07+00
59	72	2023-12-14 11:04:33+00
58	102	2023-12-14 11:12:54+00
59	102	2023-12-14 11:13:04+00
58	36	2023-12-14 11:15:51+00
59	23	2023-12-14 11:16:49+00
61	12	2023-12-14 11:16:54+00
61	37	2023-12-14 11:16:59+00
61	23	2023-12-14 11:17:43+00
61	196	2023-12-14 11:17:51+00
61	197	2023-12-14 11:18:18+00
61	41	2023-12-14 11:49:06+00
59	199	2023-12-14 11:52:45+00
61	44	2023-12-14 11:57:44+00
61	28	2023-12-14 11:58:30+00
59	80	2023-12-14 12:01:34+00
59	52	2023-12-14 12:13:17+00
59	128	2023-12-14 12:16:38+00
59	126	2023-12-14 12:18:01+00
59	99	2023-12-14 12:19:35+00
59	143	2023-12-14 12:37:08+00
58	143	2023-12-14 12:37:14+00
61	63	2023-12-14 12:59:18+00
58	63	2023-12-14 12:59:22+00
61	66	2023-12-14 13:00:49+00
59	127	2023-12-14 14:04:45+00
59	137	2023-12-14 16:31:15+00
58	137	2023-12-14 16:32:34+00
59	183	2023-12-14 16:42:13+00
61	70	2023-12-14 18:09:05+00
58	201	2023-12-14 18:22:04+00
59	123	2023-12-14 18:45:03+00
59	20	2023-12-14 19:04:47+00
58	147	2023-12-14 20:38:15+00
61	60	2023-12-15 07:54:26+00
61	46	2023-12-15 15:37:33+00
61	26	2023-12-16 08:47:53+00
61	57	2023-12-16 09:18:26+00
61	43	2023-12-16 09:20:58+00
59	141	2023-12-16 14:57:04+00
61	58	2023-12-17 09:00:24+00
61	203	2023-12-17 16:24:43+00
61	93	2023-12-18 06:40:22+00
61	49	2023-12-18 07:55:36+00
59	205	2023-12-18 11:55:27+00
59	174	2023-12-18 13:37:46+00
59	206	2023-12-18 15:39:33+00
61	102	2023-12-18 17:37:38+00
61	1	2023-12-18 18:02:24+00
61	96	2023-12-18 18:17:51+00
65	17	2024-01-03 08:32:14+00
64	17	2024-01-03 08:32:20+00
64	23	2024-01-03 16:29:49+00
65	23	2024-01-03 16:29:57+00
64	59	2024-01-03 17:52:15+00
64	14	2024-01-03 21:42:35+00
64	12	2024-01-04 10:02:59+00
65	12	2024-01-04 10:03:07+00
64	40	2024-01-04 11:00:25+00
64	26	2024-01-04 11:00:26+00
65	40	2024-01-04 11:00:30+00
65	26	2024-01-04 11:00:30+00
64	38	2024-01-04 11:00:35+00
65	38	2024-01-04 11:00:41+00
64	39	2024-01-04 11:01:00+00
65	39	2024-01-04 11:01:06+00
64	31	2024-01-04 11:01:09+00
65	31	2024-01-04 11:01:15+00
62	55	2024-01-04 11:02:27+00
64	96	2024-01-04 11:05:22+00
62	72	2024-01-04 11:10:51+00
64	22	2024-01-04 11:12:18+00
64	43	2024-01-04 11:14:51+00
65	43	2024-01-04 11:14:56+00
65	59	2024-01-04 11:18:14+00
64	37	2024-01-04 11:21:15+00
65	37	2024-01-04 11:21:20+00
64	77	2024-01-04 11:27:12+00
65	159	2024-01-04 11:33:20+00
64	49	2024-01-04 11:35:43+00
65	49	2024-01-04 11:35:49+00
62	88	2024-01-04 11:36:50+00
64	44	2024-01-04 11:37:37+00
63	193	2024-01-04 11:38:52+00
65	121	2024-01-04 11:57:58+00
62	97	2024-01-04 12:02:25+00
62	137	2024-01-04 12:02:47+00
62	210	2024-01-04 12:09:47+00
62	52	2024-01-04 12:12:40+00
62	126	2024-01-04 12:22:49+00
62	89	2024-01-04 12:59:10+00
63	45	2024-01-04 13:20:39+00
62	36	2024-01-04 13:28:26+00
62	34	2024-01-04 13:28:55+00
63	63	2024-01-04 13:28:56+00
63	69	2024-01-04 13:30:13+00
64	110	2024-01-04 14:34:52+00
64	100	2024-01-04 14:47:08+00
65	46	2024-01-04 15:44:07+00
63	46	2024-01-04 15:44:10+00
62	141	2024-01-04 16:17:38+00
62	128	2024-01-04 19:52:44+00
62	143	2024-01-04 21:06:07+00
63	102	2024-01-05 07:40:32+00
63	79	2024-01-05 11:21:33+00
63	99	2024-01-05 14:56:22+00
63	57	2024-01-05 16:09:43+00
63	67	2024-01-05 16:14:53+00
64	203	2024-01-05 20:04:47+00
65	203	2024-01-05 20:05:01+00
63	191	2024-01-06 08:43:33+00
63	181	2024-01-06 11:22:23+00
65	58	2024-01-06 12:08:16+00
62	95	2024-01-06 15:40:27+00
64	41	2024-01-06 18:39:22+00
64	30	2024-01-06 19:56:56+00
65	30	2024-01-06 19:57:22+00
63	213	2024-01-07 13:38:21+00
63	66	2024-01-07 15:53:12+00
63	214	2024-01-07 18:51:56+00
62	183	2024-01-07 21:41:44+00
62	56	2024-01-08 09:01:46+00
63	215	2024-01-08 15:50:28+00
64	216	2024-01-08 16:48:08+00
65	104	2024-01-09 11:27:27+00
69	23	2024-01-10 09:30:34+00
68	23	2024-01-10 09:30:40+00
69	17	2024-01-10 10:18:38+00
68	17	2024-01-10 10:18:43+00
65	146	2024-01-10 16:14:18+00
68	1	2024-01-11 09:17:41+00
69	1	2024-01-11 09:17:44+00
68	12	2024-01-11 10:40:52+00
69	12	2024-01-11 10:40:59+00
68	96	2024-01-11 11:00:13+00
68	39	2024-01-11 11:00:21+00
68	40	2024-01-11 11:00:23+00
69	39	2024-01-11 11:00:26+00
69	40	2024-01-11 11:00:27+00
68	46	2024-01-11 11:00:37+00
66	72	2024-01-11 11:00:38+00
69	38	2024-01-11 11:00:39+00
66	136	2024-01-11 11:00:43+00
79	137	2024-01-24 11:55:39+00
67	68	2024-01-11 11:00:53+00
79	23	2024-01-24 13:40:45+00
79	211	2024-01-24 15:38:22+00
79	67	2024-01-24 15:42:04+00
79	54	2024-01-24 17:04:38+00
68	22	2024-01-11 11:01:46+00
69	22	2024-01-11 11:01:50+00
69	37	2024-01-11 11:04:31+00
79	34	2024-01-24 17:21:01+00
79	17	2024-01-25 10:40:00+00
66	88	2024-01-11 11:15:34+00
68	49	2024-01-11 11:15:37+00
69	49	2024-01-11 11:15:42+00
77	26	2024-01-25 11:00:05+00
68	26	2024-01-11 11:26:36+00
69	26	2024-01-11 11:26:40+00
77	38	2024-01-25 11:00:07+00
69	79	2024-01-11 11:51:52+00
67	79	2024-01-11 11:52:00+00
67	213	2024-01-11 11:52:15+00
78	39	2024-01-25 11:00:08+00
68	41	2024-01-11 11:56:25+00
69	41	2024-01-11 11:56:30+00
66	52	2024-01-11 12:01:34+00
66	80	2024-01-11 12:02:07+00
66	97	2024-01-11 12:04:51+00
67	20	2024-01-11 12:18:39+00
67	123	2024-01-11 12:19:58+00
78	26	2024-01-25 11:00:09+00
77	40	2024-01-25 11:00:12+00
68	63	2024-01-11 12:26:40+00
78	38	2024-01-25 11:00:12+00
66	128	2024-01-11 12:28:44+00
68	100	2024-01-11 12:31:07+00
78	40	2024-01-25 11:00:16+00
66	143	2024-01-11 12:34:58+00
67	94	2024-01-11 12:39:29+00
66	126	2024-01-11 12:49:22+00
66	212	2024-01-11 12:53:03+00
67	99	2024-01-11 13:16:02+00
75	136	2024-01-25 11:00:25+00
67	217	2024-01-11 13:44:09+00
67	181	2024-01-11 14:06:23+00
68	44	2024-01-11 14:42:36+00
77	140	2024-01-29 14:18:35+00
67	102	2024-01-11 15:26:37+00
66	191	2024-01-11 15:45:46+00
76	66	2024-01-29 15:16:26+00
67	83	2024-01-11 15:59:49+00
66	78	2024-01-11 16:08:10+00
66	173	2024-01-11 16:29:44+00
77	227	2024-01-29 16:40:52+00
67	35	2024-01-11 16:45:41+00
77	77	2024-01-29 17:03:02+00
67	149	2024-01-11 19:47:09+00
67	148	2024-01-11 22:04:03+00
66	127	2024-01-11 22:09:04+00
78	140	2024-01-29 18:49:59+00
82	22	2024-02-01 11:08:31+00
66	70	2024-01-11 22:41:19+00
81	45	2024-02-01 11:45:26+00
81	47	2024-02-01 11:45:41+00
68	57	2024-01-12 08:53:31+00
67	57	2024-01-12 08:53:38+00
69	203	2024-01-12 11:17:19+00
80	55	2024-02-01 11:45:45+00
67	219	2024-01-12 11:47:45+00
67	66	2024-01-12 16:02:44+00
80	97	2024-02-01 12:00:46+00
80	52	2024-02-01 12:01:01+00
68	110	2024-01-12 18:43:34+00
81	181	2024-02-02 09:17:37+00
68	43	2024-01-13 09:12:31+00
80	78	2024-02-05 14:18:54+00
80	56	2024-02-05 14:31:26+00
66	214	2024-01-14 09:59:11+00
67	214	2024-01-14 09:59:20+00
80	128	2024-02-05 14:39:33+00
80	66	2024-02-05 14:51:21+00
67	221	2024-01-14 17:44:11+00
68	140	2024-01-15 13:28:39+00
66	75	2024-01-15 14:20:45+00
67	215	2024-01-15 14:26:26+00
68	193	2024-01-15 17:42:36+00
82	140	2024-02-05 18:09:51+00
69	115	2024-01-15 18:18:26+00
73	59	2024-01-17 07:58:04+00
72	17	2024-01-17 09:47:27+00
72	12	2024-01-17 12:05:48+00
73	12	2024-01-17 12:05:50+00
72	23	2024-01-17 12:52:17+00
73	23	2024-01-17 12:52:24+00
69	140	2024-01-17 16:53:04+00
73	1	2024-01-17 18:29:52+00
72	1	2024-01-17 18:29:58+00
74	26	2024-01-18 11:00:04+00
72	26	2024-01-18 11:00:07+00
72	37	2024-01-18 11:00:09+00
72	38	2024-01-18 11:00:11+00
73	26	2024-01-18 11:00:11+00
73	37	2024-01-18 11:00:13+00
73	40	2024-01-18 11:00:14+00
73	38	2024-01-18 11:00:17+00
72	68	2024-01-18 11:00:21+00
70	136	2024-01-18 11:00:40+00
74	68	2024-01-18 11:00:42+00
70	56	2024-01-18 11:00:46+00
72	21	2024-01-18 11:00:47+00
74	12	2024-01-18 11:01:07+00
74	36	2024-01-18 11:01:37+00
70	36	2024-01-18 11:01:43+00
74	58	2024-01-18 11:02:49+00
72	58	2024-01-18 11:02:55+00
73	58	2024-01-18 11:02:59+00
72	49	2024-01-18 11:03:19+00
73	49	2024-01-18 11:03:25+00
74	49	2024-01-18 11:03:31+00
74	193	2024-01-18 11:04:46+00
72	193	2024-01-18 11:04:50+00
72	22	2024-01-18 11:05:16+00
74	63	2024-01-18 11:05:22+00
72	30	2024-01-18 11:05:26+00
72	63	2024-01-18 11:05:31+00
73	63	2024-01-18 11:05:45+00
71	123	2024-01-18 11:11:20+00
71	94	2024-01-18 11:14:36+00
70	72	2024-01-18 11:21:40+00
71	83	2024-01-18 11:26:11+00
71	20	2024-01-18 11:29:25+00
74	23	2024-01-18 11:33:19+00
71	47	2024-01-18 11:35:22+00
71	99	2024-01-18 11:36:14+00
72	100	2024-01-18 11:40:30+00
73	100	2024-01-18 11:40:38+00
73	39	2024-01-18 11:44:49+00
74	79	2024-01-18 11:44:50+00
71	79	2024-01-18 11:44:57+00
71	213	2024-01-18 11:45:36+00
71	221	2024-01-18 11:47:01+00
74	213	2024-01-18 11:47:06+00
70	137	2024-01-18 11:54:44+00
73	44	2024-01-18 11:57:09+00
71	93	2024-01-18 11:58:01+00
71	149	2024-01-18 11:58:53+00
70	97	2024-01-18 12:02:42+00
73	41	2024-01-18 12:06:27+00
71	41	2024-01-18 12:06:34+00
71	224	2024-01-18 12:07:43+00
74	34	2024-01-18 12:14:28+00
70	34	2024-01-18 12:14:39+00
71	181	2024-01-18 12:16:42+00
71	148	2024-01-18 12:19:58+00
71	182	2024-01-18 12:28:43+00
70	89	2024-01-18 12:30:12+00
70	127	2024-01-18 12:33:01+00
70	143	2024-01-18 12:41:07+00
70	128	2024-01-18 12:41:22+00
70	88	2024-01-18 13:25:02+00
74	159	2024-01-18 13:28:34+00
71	102	2024-01-18 13:30:14+00
72	43	2024-01-18 14:45:45+00
73	43	2024-01-18 14:45:49+00
74	110	2024-01-18 16:07:33+00
72	110	2024-01-18 16:07:42+00
70	75	2024-01-18 16:25:06+00
71	226	2024-01-18 16:38:13+00
74	221	2024-01-18 16:39:05+00
74	226	2024-01-18 16:39:06+00
70	55	2024-01-18 19:37:13+00
70	129	2024-01-18 19:45:24+00
71	217	2024-01-18 21:07:02+00
70	183	2024-01-19 00:00:13+00
74	71	2024-01-19 06:05:35+00
70	78	2024-01-19 09:57:56+00
74	30	2024-01-19 14:22:16+00
74	198	2024-01-19 14:22:56+00
74	227	2024-01-19 14:33:52+00
72	227	2024-01-19 14:34:00+00
73	227	2024-01-19 14:34:12+00
74	211	2024-01-19 15:37:17+00
108	23	2024-04-17 09:26:17+00
74	140	2024-01-19 18:30:07+00
74	228	2024-01-20 08:33:49+00
74	60	2024-01-20 08:56:37+00
74	67	2024-01-20 10:53:34+00
72	147	2024-01-20 18:31:50+00
72	57	2024-01-21 10:53:26+00
71	57	2024-01-21 10:53:37+00
70	173	2024-01-21 15:49:08+00
71	45	2024-01-22 06:34:50+00
71	214	2024-01-22 08:32:20+00
72	93	2024-01-22 09:45:19+00
70	231	2024-01-22 10:00:37+00
79	26	2024-01-24 11:56:19+00
73	193	2024-01-24 12:05:58+00
79	193	2024-01-24 12:06:03+00
79	63	2024-01-24 12:06:42+00
109	23	2024-04-17 09:26:22+00
173	453	2024-10-07 12:37:12+00
75	82	2024-01-25 11:00:23+00
108	275	2024-04-18 10:00:15+00
77	22	2024-01-25 11:00:35+00
108	85	2024-04-18 10:00:16+00
75	233	2024-01-25 11:00:56+00
109	57	2024-04-18 10:00:17+00
173	454	2024-10-07 13:01:39+00
77	41	2024-01-25 11:04:37+00
175	169	2024-10-08 09:01:57+00
77	87	2024-01-25 11:05:03+00
76	20	2024-01-25 11:06:17+00
77	43	2024-01-25 11:08:24+00
180	23	2024-10-09 11:56:05+00
175	430	2024-10-09 11:57:58+00
77	49	2024-01-25 11:13:47+00
78	49	2024-01-25 11:13:53+00
77	193	2024-01-25 11:14:13+00
78	193	2024-01-25 11:14:17+00
75	72	2024-01-25 11:15:10+00
77	63	2024-01-25 11:15:13+00
78	63	2024-01-25 11:15:23+00
106	136	2024-04-18 10:01:56+00
108	39	2024-04-18 10:03:41+00
109	39	2024-04-18 10:03:46+00
76	70	2024-01-25 11:19:03+00
76	93	2024-01-25 11:23:06+00
76	47	2024-01-25 11:30:17+00
77	58	2024-01-25 11:37:35+00
78	58	2024-01-25 11:37:42+00
180	275	2024-10-10 11:51:54+00
76	75	2024-01-25 11:38:48+00
77	57	2024-01-25 11:44:55+00
78	104	2024-01-25 11:46:37+00
75	137	2024-01-25 11:50:47+00
107	89	2024-04-18 10:04:44+00
180	276	2024-10-10 11:52:19+00
176	410	2024-10-10 11:59:09+00
178	264	2024-10-10 12:00:41+00
75	97	2024-01-25 12:02:48+00
177	468	2024-10-10 12:24:06+00
76	123	2024-01-25 12:06:43+00
177	182	2024-10-10 12:25:00+00
75	89	2024-01-25 12:52:12+00
76	68	2024-01-25 12:54:46+00
78	68	2024-01-25 12:54:50+00
76	149	2024-01-25 13:22:37+00
76	224	2024-01-25 13:31:52+00
76	181	2024-01-25 14:18:28+00
75	128	2024-01-25 14:56:19+00
75	232	2024-01-25 15:09:05+00
75	36	2024-01-25 15:24:35+00
78	227	2024-01-25 16:38:58+00
79	227	2024-01-25 16:39:10+00
76	83	2024-01-25 17:07:58+00
75	127	2024-01-25 17:56:07+00
76	148	2024-01-25 19:07:16+00
76	182	2024-01-26 06:07:24+00
76	219	2024-01-26 09:22:58+00
75	52	2024-01-26 09:34:31+00
77	44	2024-01-26 12:55:13+00
78	44	2024-01-26 12:55:21+00
79	72	2024-01-26 15:58:25+00
79	147	2024-01-26 20:50:50+00
77	147	2024-01-26 20:50:59+00
76	147	2024-01-26 20:51:12+00
79	77	2024-01-27 08:19:30+00
75	95	2024-01-27 09:09:40+00
76	214	2024-01-27 15:27:08+00
76	35	2024-01-27 17:42:51+00
75	35	2024-01-27 17:43:18+00
82	59	2024-01-31 16:33:28+00
82	37	2024-02-01 11:00:05+00
82	30	2024-02-01 11:00:11+00
82	96	2024-02-01 11:00:13+00
82	40	2024-02-01 11:00:15+00
82	26	2024-02-01 11:00:21+00
82	49	2024-02-01 11:00:26+00
82	58	2024-02-01 11:00:29+00
82	38	2024-02-01 11:00:33+00
82	193	2024-02-01 11:00:37+00
80	137	2024-02-01 11:00:54+00
81	46	2024-02-01 11:01:52+00
82	39	2024-02-01 11:02:22+00
81	82	2024-02-01 11:06:41+00
80	89	2024-02-01 12:12:10+00
81	63	2024-02-01 12:20:56+00
82	63	2024-02-01 12:21:10+00
81	70	2024-02-01 12:34:28+00
81	112	2024-02-01 13:23:51+00
80	143	2024-02-01 13:30:16+00
82	23	2024-02-01 13:51:16+00
81	234	2024-02-01 14:08:06+00
80	127	2024-02-01 15:12:45+00
81	99	2024-02-01 15:56:50+00
80	126	2024-02-01 16:14:22+00
81	182	2024-02-01 17:43:03+00
82	41	2024-02-01 17:53:02+00
82	12	2024-02-01 18:02:47+00
82	17	2024-02-01 18:34:49+00
82	44	2024-02-01 18:46:40+00
81	149	2024-02-01 22:31:13+00
81	148	2024-02-01 22:31:44+00
81	214	2024-02-02 09:41:21+00
82	227	2024-02-02 11:04:45+00
80	61	2024-02-02 14:59:11+00
80	95	2024-02-02 15:04:07+00
80	185	2024-02-02 15:06:16+00
81	27	2024-02-02 18:06:00+00
82	27	2024-02-02 18:06:03+00
81	35	2024-02-03 08:13:27+00
82	68	2024-02-04 19:55:06+00
81	37	2024-02-05 17:03:56+00
86	17	2024-02-14 15:59:47+00
86	23	2024-02-14 18:13:45+00
86	12	2024-02-14 19:49:06+00
86	59	2024-02-15 07:53:38+00
89	59	2024-02-15 07:54:52+00
86	31	2024-02-15 11:00:12+00
86	22	2024-02-15 11:00:17+00
89	31	2024-02-15 11:00:22+00
89	22	2024-02-15 11:01:07+00
89	23	2024-02-15 11:04:04+00
89	68	2024-02-15 11:06:14+00
86	44	2024-02-15 11:13:56+00
85	75	2024-02-15 11:14:03+00
84	72	2024-02-15 11:15:45+00
89	72	2024-02-15 11:15:57+00
86	27	2024-02-15 11:44:57+00
86	41	2024-02-15 11:59:23+00
84	97	2024-02-15 12:00:50+00
86	240	2024-02-15 12:04:25+00
86	121	2024-02-15 12:04:30+00
84	56	2024-02-15 12:13:54+00
84	127	2024-02-15 12:28:44+00
86	85	2024-02-15 12:45:09+00
89	85	2024-02-15 12:45:17+00
89	17	2024-02-15 13:09:27+00
86	46	2024-02-15 13:16:24+00
89	60	2024-02-15 15:33:16+00
85	60	2024-02-15 15:33:24+00
89	41	2024-02-15 15:34:22+00
89	12	2024-02-15 16:55:18+00
84	55	2024-02-15 19:24:37+00
84	45	2024-02-15 19:24:45+00
86	147	2024-02-15 21:45:28+00
85	66	2024-02-15 22:03:57+00
86	38	2024-02-15 22:31:24+00
86	37	2024-02-15 23:03:24+00
86	57	2024-02-16 13:08:49+00
89	57	2024-02-16 13:09:05+00
89	102	2024-02-16 16:10:44+00
89	211	2024-02-16 16:30:08+00
85	214	2024-02-17 00:10:57+00
89	70	2024-02-17 11:55:42+00
85	70	2024-02-17 11:56:10+00
173	455	2024-10-07 13:35:55+00
89	29	2024-02-18 10:05:11+00
108	57	2024-04-18 10:00:12+00
84	137	2024-02-18 13:16:49+00
85	243	2024-02-18 15:17:49+00
109	276	2024-04-18 10:00:17+00
108	21	2024-04-18 10:00:19+00
86	26	2024-02-18 20:00:15+00
86	140	2024-02-19 09:04:55+00
109	275	2024-04-18 10:00:20+00
175	398	2024-10-08 09:57:52+00
85	45	2024-02-19 14:13:48+00
85	26	2024-02-19 17:26:47+00
89	51	2024-02-20 11:30:49+00
108	276	2024-04-18 10:00:22+00
89	54	2024-02-20 14:13:54+00
93	17	2024-02-21 09:06:53+00
92	17	2024-02-21 09:06:57+00
93	13	2024-02-21 09:08:38+00
93	1	2024-02-22 07:45:09+00
92	23	2024-02-22 10:57:39+00
93	23	2024-02-22 10:57:49+00
92	49	2024-02-22 11:00:06+00
92	26	2024-02-22 11:00:06+00
92	40	2024-02-22 11:00:09+00
93	49	2024-02-22 11:00:12+00
93	40	2024-02-22 11:00:13+00
92	12	2024-02-22 11:00:16+00
92	22	2024-02-22 11:00:18+00
93	12	2024-02-22 11:00:19+00
93	22	2024-02-22 11:00:23+00
91	75	2024-02-22 11:00:26+00
92	31	2024-02-22 11:00:29+00
92	38	2024-02-22 11:00:30+00
93	38	2024-02-22 11:00:37+00
93	39	2024-02-22 11:00:55+00
93	100	2024-02-22 11:00:57+00
93	104	2024-02-22 11:01:46+00
93	197	2024-02-22 11:02:11+00
90	56	2024-02-22 11:02:51+00
92	44	2024-02-22 11:03:23+00
93	44	2024-02-22 11:03:30+00
92	68	2024-02-22 11:04:06+00
92	27	2024-02-22 11:16:02+00
90	52	2024-02-22 12:00:56+00
89	245	2024-02-22 12:09:25+00
93	18	2024-02-22 12:28:26+00
93	114	2024-02-22 12:29:29+00
92	41	2024-02-22 12:37:22+00
93	41	2024-02-22 12:37:32+00
90	127	2024-02-22 16:25:59+00
92	59	2024-02-22 17:59:03+00
93	59	2024-02-22 17:59:09+00
90	137	2024-02-22 19:22:19+00
90	55	2024-02-23 01:13:05+00
90	45	2024-02-23 01:13:09+00
91	45	2024-02-23 01:13:12+00
92	58	2024-02-23 10:18:19+00
89	58	2024-02-23 10:18:24+00
91	214	2024-02-23 11:36:46+00
89	66	2024-02-23 11:45:54+00
91	47	2024-02-23 15:36:44+00
89	205	2024-02-23 18:53:12+00
89	115	2024-02-23 22:33:35+00
89	246	2024-02-24 00:50:54+00
89	67	2024-02-24 08:38:23+00
91	247	2024-02-24 09:16:33+00
90	88	2024-02-24 09:19:32+00
89	27	2024-02-24 09:42:40+00
91	147	2024-02-24 13:23:26+00
93	43	2024-02-24 16:49:50+00
91	70	2024-02-24 16:53:28+00
91	248	2024-02-24 21:13:06+00
91	249	2024-02-24 21:31:34+00
92	85	2024-02-25 00:00:18+00
93	85	2024-02-25 00:00:26+00
90	251	2024-02-25 09:54:16+00
90	151	2024-02-25 18:55:58+00
92	140	2024-02-25 20:49:42+00
90	126	2024-02-26 08:58:49+00
90	72	2024-02-26 09:04:38+00
93	77	2024-02-26 13:35:47+00
90	252	2024-02-26 13:49:18+00
91	252	2024-02-26 13:49:26+00
90	182	2024-02-26 14:20:43+00
91	182	2024-02-26 14:20:47+00
92	146	2024-02-26 14:30:37+00
91	41	2024-02-26 17:29:53+00
96	59	2024-03-14 09:48:05+00
97	59	2024-03-14 09:48:09+00
97	1	2024-03-14 09:50:17+00
96	1	2024-03-14 09:50:22+00
97	17	2024-03-14 09:50:33+00
96	17	2024-03-14 09:50:38+00
94	136	2024-03-14 11:00:06+00
96	58	2024-03-14 11:00:06+00
96	26	2024-03-14 11:00:08+00
97	58	2024-03-14 11:00:10+00
97	37	2024-03-14 11:00:13+00
94	151	2024-03-14 11:00:17+00
96	40	2024-03-14 11:00:18+00
97	40	2024-03-14 11:00:21+00
96	38	2024-03-14 11:00:43+00
94	97	2024-03-14 11:00:44+00
94	56	2024-03-14 11:00:45+00
97	38	2024-03-14 11:00:48+00
96	21	2024-03-14 11:01:00+00
96	63	2024-03-14 11:05:13+00
97	63	2024-03-14 11:05:19+00
97	41	2024-03-14 11:07:28+00
96	77	2024-03-14 11:08:23+00
96	46	2024-03-14 11:09:29+00
97	46	2024-03-14 11:09:33+00
96	22	2024-03-14 11:11:25+00
96	31	2024-03-14 11:12:31+00
97	247	2024-03-14 11:14:28+00
97	18	2024-03-14 11:15:38+00
95	264	2024-03-14 11:21:33+00
95	102	2024-03-14 11:24:39+00
95	83	2024-03-14 11:26:57+00
96	43	2024-03-14 11:33:46+00
96	121	2024-03-14 11:45:00+00
94	55	2024-03-14 11:46:34+00
95	93	2024-03-14 11:51:05+00
96	68	2024-03-14 11:51:06+00
97	68	2024-03-14 11:51:12+00
95	260	2024-03-14 11:56:56+00
94	89	2024-03-14 12:01:20+00
97	100	2024-03-14 12:10:41+00
95	35	2024-03-14 12:23:54+00
95	181	2024-03-14 12:30:50+00
94	252	2024-03-14 13:15:36+00
97	159	2024-03-14 13:27:09+00
94	52	2024-03-14 13:34:17+00
95	70	2024-03-14 18:37:46+00
95	149	2024-03-14 20:04:33+00
95	85	2024-03-14 23:28:32+00
97	85	2024-03-14 23:28:42+00
95	99	2024-03-15 10:56:37+00
95	141	2024-03-15 15:08:51+00
95	45	2024-03-15 15:15:00+00
94	45	2024-03-15 15:15:07+00
95	47	2024-03-15 22:13:52+00
95	143	2024-03-17 07:44:15+00
94	127	2024-03-17 10:37:30+00
94	251	2024-03-17 15:01:19+00
94	101	2024-03-17 18:59:40+00
95	148	2024-03-17 20:22:09+00
96	110	2024-03-18 11:39:09+00
96	34	2024-03-18 11:41:06+00
95	34	2024-03-18 11:41:40+00
95	66	2024-03-18 13:43:03+00
96	193	2024-03-18 18:03:39+00
97	22	2024-03-20 18:38:30+00
97	23	2024-03-20 19:20:32+00
101	59	2024-03-27 12:29:10+00
100	59	2024-03-27 12:29:13+00
100	17	2024-03-28 08:03:59+00
101	17	2024-03-28 08:04:03+00
100	13	2024-03-31 12:38:43+00
101	1	2024-04-02 06:42:40+00
100	23	2024-04-03 23:32:53+00
99	46	2024-04-04 10:00:08+00
100	26	2024-04-04 10:00:09+00
101	26	2024-04-04 10:00:14+00
101	46	2024-04-04 10:00:17+00
101	294	2024-04-04 10:00:35+00
100	12	2024-04-04 10:00:36+00
100	49	2024-04-04 10:01:22+00
101	49	2024-04-04 10:01:27+00
98	136	2024-04-04 10:01:36+00
100	85	2024-04-04 10:01:44+00
101	85	2024-04-04 10:01:50+00
100	58	2024-04-04 10:02:13+00
101	58	2024-04-04 10:02:17+00
99	284	2024-04-04 10:02:29+00
100	260	2024-04-04 10:02:53+00
109	21	2024-04-18 10:00:26+00
101	260	2024-04-04 10:03:00+00
101	37	2024-04-04 10:03:58+00
99	93	2024-04-04 10:04:04+00
109	294	2024-04-18 10:00:35+00
98	89	2024-04-04 10:09:34+00
107	93	2024-04-18 10:00:44+00
101	39	2024-04-04 10:18:10+00
100	40	2024-04-04 10:18:53+00
108	26	2024-04-18 10:00:57+00
100	22	2024-04-04 10:20:27+00
108	44	2024-04-18 11:38:58+00
100	18	2024-04-04 10:24:18+00
101	18	2024-04-04 10:24:23+00
109	44	2024-04-18 11:39:03+00
173	264	2024-10-07 14:11:33+00
98	72	2024-04-04 10:53:50+00
106	273	2024-04-18 11:45:53+00
99	275	2024-04-04 10:54:53+00
98	127	2024-04-04 10:59:00+00
99	141	2024-04-04 11:05:11+00
98	97	2024-04-04 11:08:38+00
107	317	2024-04-18 11:51:16+00
99	182	2024-04-04 11:33:24+00
107	221	2024-04-18 11:58:09+00
99	297	2024-04-04 11:48:58+00
99	63	2024-04-04 11:49:03+00
101	63	2024-04-04 11:49:20+00
100	41	2024-04-04 12:30:49+00
101	41	2024-04-04 12:30:55+00
98	55	2024-04-04 12:34:37+00
106	318	2024-04-18 12:00:00+00
98	298	2024-04-04 12:53:30+00
98	172	2024-04-04 13:09:43+00
98	295	2024-04-04 13:45:53+00
175	425	2024-10-09 14:04:11+00
177	72	2024-10-10 12:57:03+00
98	137	2024-04-04 16:44:29+00
101	159	2024-04-04 17:31:42+00
100	77	2024-04-04 17:40:08+00
177	291	2024-10-10 13:06:33+00
99	128	2024-04-04 17:55:16+00
107	284	2024-04-18 12:54:10+00
178	260	2024-10-10 13:08:40+00
99	147	2024-04-04 19:56:24+00
180	260	2024-10-10 13:08:44+00
180	18	2024-10-10 13:20:54+00
107	319	2024-04-18 13:59:44+00
107	128	2024-04-18 14:22:00+00
107	70	2024-04-18 14:37:58+00
178	416	2024-10-10 13:25:08+00
177	82	2024-10-10 13:27:35+00
107	35	2024-04-18 15:34:34+00
107	265	2024-04-18 16:36:25+00
106	251	2024-04-18 16:43:32+00
107	251	2024-04-18 16:43:39+00
106	291	2024-04-18 17:46:10+00
177	432	2024-10-10 21:17:48+00
178	39	2024-10-11 04:34:07+00
180	39	2024-10-11 04:34:16+00
180	51	2024-10-11 04:37:21+00
106	127	2024-04-19 07:51:27+00
106	143	2024-04-19 07:56:58+00
107	143	2024-04-19 07:57:08+00
107	214	2024-04-19 08:06:11+00
178	51	2024-10-11 04:37:44+00
106	173	2024-04-19 10:03:05+00
108	22	2024-04-20 07:19:12+00
178	371	2024-10-11 09:57:28+00
107	324	2024-04-21 10:52:09+00
107	287	2024-04-21 11:35:52+00
108	140	2024-04-21 12:54:25+00
109	140	2024-04-21 12:54:35+00
180	371	2024-10-11 09:57:44+00
107	303	2024-04-21 17:18:17+00
177	472	2024-10-11 10:34:21+00
109	68	2024-04-22 05:37:36+00
176	127	2024-10-12 13:54:01+00
176	479	2024-10-14 10:32:16+00
109	254	2024-04-24 15:49:43+00
112	13	2024-04-25 07:26:26+00
112	39	2024-04-25 10:00:05+00
112	260	2024-04-25 10:00:06+00
111	254	2024-04-25 10:00:07+00
112	275	2024-04-25 10:00:08+00
110	257	2024-04-25 10:00:11+00
112	21	2024-04-25 10:00:25+00
112	276	2024-04-25 10:00:27+00
111	302	2024-04-25 10:00:29+00
111	83	2024-04-25 13:07:27+00
111	20	2024-04-25 13:34:36+00
111	214	2024-04-25 13:42:37+00
110	336	2024-04-25 13:46:56+00
111	99	2024-04-25 14:03:30+00
111	182	2024-04-25 16:57:26+00
112	140	2024-04-26 05:40:44+00
112	41	2024-04-26 06:29:41+00
111	147	2024-04-26 17:35:23+00
110	183	2024-04-26 20:12:28+00
111	301	2024-04-26 21:24:34+00
110	55	2024-04-27 09:17:39+00
112	31	2024-04-27 13:36:57+00
111	32	2024-04-28 09:51:45+00
112	68	2024-04-28 18:51:17+00
110	298	2024-04-29 08:07:18+00
112	255	2024-04-29 18:36:44+00
115	17	2024-04-30 07:49:09+00
115	23	2024-04-30 10:04:11+00
115	13	2024-05-01 08:02:35+00
115	1	2024-05-02 07:36:11+00
115	44	2024-05-02 10:00:05+00
115	26	2024-05-02 10:00:11+00
115	85	2024-05-02 10:00:14+00
114	255	2024-05-02 10:00:19+00
116	85	2024-05-02 10:00:20+00
116	26	2024-05-02 10:00:22+00
115	57	2024-05-02 10:00:26+00
115	58	2024-05-02 10:00:30+00
114	128	2024-05-02 10:00:32+00
114	284	2024-05-02 10:00:33+00
115	196	2024-05-02 10:00:44+00
114	257	2024-05-02 10:00:58+00
113	136	2024-05-02 10:01:28+00
114	303	2024-05-02 10:02:33+00
115	46	2024-05-02 10:03:06+00
114	267	2024-05-02 10:04:34+00
115	260	2024-05-02 10:05:37+00
115	107	2024-05-02 10:05:58+00
115	39	2024-05-02 10:10:55+00
116	49	2024-05-02 10:12:39+00
115	49	2024-05-02 10:12:44+00
114	173	2024-05-02 10:13:43+00
114	82	2024-05-02 10:37:31+00
115	22	2024-05-02 10:43:53+00
114	258	2024-05-02 10:51:14+00
113	200	2024-05-02 10:54:11+00
113	338	2024-05-02 10:54:51+00
114	254	2024-05-02 10:55:14+00
116	254	2024-05-02 10:55:22+00
115	315	2024-05-02 10:57:07+00
113	295	2024-05-02 11:01:14+00
113	127	2024-05-02 11:06:50+00
114	102	2024-05-02 11:22:50+00
113	88	2024-05-02 11:23:13+00
115	193	2024-05-02 12:36:49+00
114	319	2024-05-02 12:36:58+00
115	145	2024-05-02 14:00:16+00
116	145	2024-05-02 14:01:19+00
113	143	2024-05-02 17:08:25+00
114	143	2024-05-02 17:08:30+00
115	63	2024-05-02 17:17:03+00
114	182	2024-05-02 18:05:08+00
113	310	2024-05-02 18:07:33+00
114	287	2024-05-02 18:31:15+00
114	147	2024-05-02 20:05:26+00
114	144	2024-05-02 21:41:53+00
113	273	2024-05-02 22:08:41+00
113	340	2024-05-03 13:00:19+00
115	77	2024-05-03 13:53:23+00
116	77	2024-05-03 13:53:29+00
116	14	2024-05-03 13:58:25+00
99	258	2024-04-04 20:20:44+00
99	102	2024-04-04 20:37:08+00
98	35	2024-04-05 06:35:02+00
98	300	2024-04-05 06:35:25+00
107	302	2024-04-18 10:09:21+00
98	251	2024-04-05 11:10:53+00
108	37	2024-04-18 10:09:57+00
99	148	2024-04-05 17:12:32+00
98	183	2024-04-05 19:33:04+00
98	301	2024-04-05 20:11:46+00
99	301	2024-04-05 20:12:07+00
98	279	2024-04-06 11:24:20+00
100	68	2024-04-06 13:34:51+00
108	40	2024-04-18 10:11:09+00
99	280	2024-04-06 18:04:32+00
99	32	2024-04-07 12:34:51+00
99	270	2024-04-07 13:08:04+00
99	302	2024-04-07 20:42:45+00
99	277	2024-04-07 21:21:30+00
98	143	2024-04-07 23:32:30+00
99	143	2024-04-07 23:32:36+00
99	155	2024-04-08 06:11:14+00
109	40	2024-04-18 10:11:15+00
98	128	2024-04-08 10:00:28+00
106	88	2024-04-18 10:13:28+00
100	100	2024-04-08 11:09:40+00
108	58	2024-04-18 10:15:46+00
99	214	2024-04-08 12:48:21+00
180	411	2024-10-10 21:45:06+00
99	23	2024-04-08 18:22:52+00
176	421	2024-10-10 22:08:53+00
107	72	2024-04-18 10:17:50+00
180	424	2024-10-10 22:09:18+00
104	13	2024-04-10 09:12:15+00
105	13	2024-04-10 09:16:23+00
101	305	2024-04-10 09:21:23+00
177	35	2024-10-11 06:09:28+00
101	193	2024-04-10 16:55:54+00
105	14	2024-04-10 18:02:09+00
104	14	2024-04-10 18:02:25+00
176	448	2024-10-11 11:32:09+00
104	17	2024-04-11 06:16:19+00
104	59	2024-04-11 07:31:51+00
105	59	2024-04-11 07:31:57+00
104	39	2024-04-11 10:00:05+00
104	260	2024-04-11 10:00:05+00
104	26	2024-04-11 10:00:09+00
105	260	2024-04-11 10:00:09+00
104	49	2024-04-11 10:00:11+00
105	26	2024-04-11 10:00:13+00
104	37	2024-04-11 10:00:14+00
104	44	2024-04-11 10:00:16+00
105	49	2024-04-11 10:00:16+00
177	476	2024-10-13 19:18:10+00
108	63	2024-04-18 10:20:21+00
104	275	2024-04-11 10:00:19+00
105	44	2024-04-11 10:00:22+00
176	476	2024-10-13 19:18:30+00
104	21	2024-04-11 10:00:25+00
176	358	2024-10-14 08:22:38+00
104	43	2024-04-11 10:00:30+00
104	31	2024-04-11 10:00:30+00
176	480	2024-10-14 10:51:45+00
105	21	2024-04-11 10:00:33+00
105	31	2024-04-11 10:00:34+00
103	89	2024-04-11 10:00:34+00
105	43	2024-04-11 10:00:35+00
180	482	2024-10-14 11:00:59+00
107	315	2024-04-18 10:45:32+00
177	482	2024-10-14 11:01:43+00
107	182	2024-04-18 10:45:34+00
108	315	2024-04-18 10:45:42+00
102	137	2024-04-11 10:04:41+00
108	254	2024-04-18 10:51:39+00
107	254	2024-04-18 10:51:42+00
104	58	2024-04-11 10:06:28+00
104	107	2024-04-11 10:06:31+00
105	58	2024-04-11 10:06:32+00
105	107	2024-04-11 10:06:40+00
103	83	2024-04-11 10:33:43+00
107	257	2024-04-18 10:51:55+00
107	83	2024-04-18 10:53:04+00
105	22	2024-04-11 10:37:22+00
107	60	2024-04-18 10:58:32+00
107	255	2024-04-18 11:00:04+00
103	303	2024-04-11 10:50:23+00
102	136	2024-04-11 10:53:42+00
103	284	2024-04-11 10:53:49+00
103	93	2024-04-11 10:56:26+00
103	47	2024-04-11 11:00:02+00
103	309	2024-04-11 11:01:30+00
103	258	2024-04-11 11:02:20+00
103	299	2024-04-11 11:04:12+00
107	141	2024-04-18 11:01:33+00
102	97	2024-04-11 11:20:07+00
103	262	2024-04-11 11:54:09+00
103	141	2024-04-11 11:54:35+00
103	128	2024-04-11 12:46:30+00
108	43	2024-04-18 11:12:18+00
103	291	2024-04-11 12:53:06+00
102	272	2024-04-11 12:59:20+00
102	306	2024-04-11 13:07:44+00
103	102	2024-04-11 13:15:12+00
102	298	2024-04-11 13:19:03+00
102	295	2024-04-11 14:59:07+00
104	193	2024-04-11 15:45:24+00
105	193	2024-04-11 15:45:29+00
105	23	2024-04-11 16:29:39+00
106	295	2024-04-18 11:13:11+00
103	254	2024-04-11 16:39:18+00
107	102	2024-04-18 11:16:10+00
103	181	2024-04-11 18:05:40+00
106	97	2024-04-18 11:17:15+00
107	99	2024-04-18 11:24:51+00
102	251	2024-04-11 19:16:18+00
103	182	2024-04-11 21:24:37+00
107	322	2024-04-20 19:56:33+00
105	85	2024-04-11 23:41:43+00
107	301	2024-04-22 16:11:26+00
102	183	2024-04-12 08:11:52+00
103	147	2024-04-12 08:47:59+00
103	302	2024-04-12 09:38:33+00
102	55	2024-04-12 15:29:31+00
102	70	2024-04-12 20:27:09+00
112	23	2024-04-24 18:16:26+00
102	278	2024-04-13 22:25:30+00
102	172	2024-04-14 14:28:25+00
102	143	2024-04-14 18:26:43+00
103	143	2024-04-14 18:26:53+00
104	63	2024-04-14 19:05:43+00
105	280	2024-04-15 09:41:10+00
104	79	2024-04-15 09:50:32+00
103	82	2024-04-15 10:53:33+00
104	57	2024-04-15 10:53:39+00
103	57	2024-04-15 10:53:44+00
103	193	2024-04-15 11:36:58+00
103	63	2024-04-15 15:27:45+00
105	57	2024-04-15 19:43:40+00
109	317	2024-04-24 18:19:10+00
109	255	2024-04-24 18:23:52+00
111	257	2024-04-25 10:00:14+00
110	136	2024-04-25 10:00:19+00
112	57	2024-04-25 10:00:54+00
112	87	2024-04-25 10:01:38+00
112	58	2024-04-25 10:02:16+00
111	255	2024-04-25 10:02:28+00
112	37	2024-04-25 10:05:01+00
112	107	2024-04-25 10:05:46+00
111	303	2024-04-25 10:06:03+00
112	85	2024-04-25 10:07:23+00
111	128	2024-04-25 10:07:44+00
112	22	2024-04-25 10:11:56+00
110	273	2024-04-25 10:27:35+00
111	284	2024-04-25 10:31:03+00
110	323	2024-04-25 10:37:36+00
110	331	2024-04-25 10:38:40+00
110	330	2024-04-25 10:38:40+00
110	88	2024-04-25 10:42:26+00
111	141	2024-04-25 10:42:54+00
111	143	2024-04-25 10:43:16+00
110	143	2024-04-25 10:43:21+00
110	332	2024-04-25 10:43:31+00
112	315	2024-04-25 10:56:47+00
110	173	2024-04-25 10:58:27+00
110	78	2024-04-25 10:59:31+00
110	310	2024-04-25 11:00:35+00
111	258	2024-04-25 11:03:01+00
112	193	2024-04-25 11:19:53+00
110	333	2024-04-25 11:40:16+00
111	291	2024-04-25 12:01:05+00
110	335	2024-04-25 12:35:22+00
112	100	2024-04-25 12:58:08+00
110	267	2024-04-25 13:05:35+00
173	70	2024-10-07 16:20:31+00
175	40	2024-10-07 16:54:31+00
116	38	2024-05-04 06:37:39+00
173	41	2024-10-07 17:03:31+00
180	393	2024-10-10 10:00:09+00
178	85	2024-10-10 10:00:12+00
178	368	2024-10-10 10:00:17+00
178	40	2024-10-10 10:00:21+00
177	302	2024-10-10 10:00:30+00
177	395	2024-10-10 10:04:48+00
180	357	2024-10-10 10:09:14+00
180	398	2024-10-10 10:21:19+00
176	445	2024-10-10 10:26:10+00
176	253	2024-10-11 07:40:39+00
178	41	2024-10-11 13:43:30+00
180	41	2024-10-11 13:43:37+00
177	399	2024-10-11 13:44:57+00
176	372	2024-10-12 11:14:49+00
178	43	2024-10-13 19:35:42+00
180	43	2024-10-13 19:35:50+00
176	477	2024-10-13 20:04:35+00
176	438	2024-10-13 20:09:19+00
180	84	2024-10-14 09:01:25+00
180	315	2024-10-14 10:58:23+00
180	483	2024-10-14 11:00:14+00
113	72	2024-05-04 21:16:03+00
113	183	2024-05-05 17:32:45+00
178	13	2024-10-09 07:49:05+00
114	214	2024-05-05 19:44:38+00
114	302	2024-05-05 20:53:00+00
115	21	2024-05-05 21:31:03+00
180	85	2024-10-10 10:00:16+00
113	253	2024-05-06 09:19:00+00
180	368	2024-10-10 10:00:21+00
115	140	2024-05-06 12:09:57+00
180	40	2024-10-10 10:00:26+00
180	37	2024-10-10 10:00:35+00
113	257	2024-05-06 15:11:49+00
177	434	2024-10-10 10:00:57+00
115	257	2024-05-06 18:38:54+00
115	255	2024-05-06 18:39:31+00
177	173	2024-10-10 10:03:41+00
178	21	2024-10-10 10:05:32+00
116	96	2024-05-08 05:58:03+00
119	13	2024-05-08 06:22:22+00
116	1	2024-05-08 06:48:26+00
178	357	2024-10-10 10:08:58+00
120	14	2024-05-08 07:07:30+00
116	41	2024-05-08 13:53:08+00
119	17	2024-05-09 08:35:28+00
119	26	2024-05-09 10:00:08+00
119	58	2024-05-09 10:00:09+00
119	85	2024-05-09 10:00:13+00
120	26	2024-05-09 10:00:14+00
177	267	2024-10-10 10:23:06+00
119	31	2024-05-09 10:00:21+00
177	467	2024-10-10 10:23:35+00
120	31	2024-05-09 10:00:24+00
177	464	2024-10-10 10:24:09+00
120	39	2024-05-09 10:00:28+00
119	40	2024-05-09 10:00:29+00
120	40	2024-05-09 10:00:32+00
117	136	2024-05-09 10:00:40+00
118	128	2024-05-09 10:01:07+00
118	284	2024-05-09 10:01:13+00
119	22	2024-05-09 10:01:14+00
178	401	2024-10-10 10:37:21+00
178	22	2024-10-10 10:46:03+00
176	436	2024-10-10 10:46:31+00
120	49	2024-05-09 10:03:17+00
119	196	2024-05-09 10:05:33+00
176	444	2024-10-10 23:49:02+00
118	173	2024-05-09 10:06:01+00
119	107	2024-05-09 10:06:06+00
178	461	2024-10-11 09:06:42+00
119	21	2024-05-09 10:07:58+00
180	461	2024-10-11 09:07:08+00
118	341	2024-05-09 10:15:04+00
119	254	2024-05-09 10:17:06+00
120	254	2024-05-09 10:17:09+00
119	257	2024-05-09 10:21:51+00
119	313	2024-05-09 10:22:52+00
120	313	2024-05-09 10:24:29+00
117	137	2024-05-09 10:31:19+00
118	82	2024-05-09 10:32:06+00
118	141	2024-05-09 10:40:31+00
118	78	2024-05-09 10:41:13+00
118	89	2024-05-09 10:44:54+00
117	88	2024-05-09 10:57:27+00
117	310	2024-05-09 11:05:23+00
118	149	2024-05-09 11:46:05+00
118	148	2024-05-09 11:47:09+00
119	255	2024-05-09 12:05:43+00
119	57	2024-05-09 12:16:23+00
118	143	2024-05-09 12:40:29+00
118	102	2024-05-09 12:54:01+00
118	83	2024-05-09 13:06:00+00
177	383	2024-10-11 16:21:29+00
118	258	2024-05-09 14:19:12+00
117	200	2024-05-09 14:59:36+00
178	430	2024-10-12 12:26:43+00
120	77	2024-05-09 18:04:17+00
119	145	2024-05-09 18:05:59+00
180	430	2024-10-12 12:26:49+00
118	144	2024-05-09 19:52:54+00
117	253	2024-05-09 21:55:13+00
118	302	2024-05-09 22:09:35+00
117	295	2024-05-10 07:57:44+00
119	41	2024-05-10 09:24:07+00
120	41	2024-05-10 09:24:16+00
117	55	2024-05-10 15:53:08+00
117	251	2024-05-11 10:36:12+00
177	214	2024-10-13 21:40:43+00
119	23	2024-05-11 14:43:41+00
176	214	2024-10-13 21:40:58+00
118	214	2024-05-12 14:49:44+00
180	68	2024-10-14 09:52:06+00
117	183	2024-05-12 15:01:27+00
118	301	2024-05-12 15:02:52+00
120	37	2024-05-13 19:26:15+00
120	140	2024-05-15 17:48:11+00
131	13	2024-05-28 09:18:24+00
131	1	2024-05-28 17:14:27+00
132	348	2024-05-29 09:16:47+00
131	348	2024-05-29 09:17:11+00
131	23	2024-05-29 17:33:34+00
131	26	2024-05-30 10:00:04+00
130	72	2024-05-30 10:00:08+00
131	87	2024-05-30 10:00:31+00
131	40	2024-05-30 10:00:42+00
130	267	2024-05-30 10:00:55+00
129	136	2024-05-30 10:01:19+00
131	49	2024-05-30 10:01:36+00
130	173	2024-05-30 10:02:04+00
131	22	2024-05-30 10:03:53+00
129	137	2024-05-30 10:12:03+00
129	88	2024-05-30 10:12:23+00
131	37	2024-05-30 10:15:06+00
132	37	2024-05-30 10:15:10+00
130	82	2024-05-30 10:20:59+00
130	128	2024-05-30 10:29:09+00
130	141	2024-05-30 10:40:20+00
131	260	2024-05-30 10:43:01+00
130	221	2024-05-30 10:53:40+00
129	97	2024-05-30 11:09:35+00
132	347	2024-05-30 11:15:17+00
130	287	2024-05-30 11:16:20+00
130	102	2024-05-30 12:51:24+00
130	226	2024-05-30 13:51:03+00
132	275	2024-05-30 14:11:46+00
131	58	2024-05-30 15:14:27+00
131	193	2024-05-30 15:46:44+00
129	298	2024-05-30 16:28:40+00
132	77	2024-05-30 17:29:39+00
129	55	2024-05-30 18:29:18+00
131	350	2024-05-31 07:52:47+00
132	350	2024-05-31 07:52:54+00
130	83	2024-05-31 07:56:03+00
131	43	2024-05-31 08:21:37+00
132	43	2024-05-31 08:21:43+00
130	284	2024-05-31 09:03:19+00
129	351	2024-05-31 10:04:04+00
129	251	2024-05-31 12:14:29+00
129	127	2024-05-31 13:18:12+00
131	63	2024-05-31 19:02:23+00
129	253	2024-06-01 06:07:41+00
129	352	2024-06-01 16:07:30+00
129	183	2024-06-01 18:11:46+00
130	214	2024-06-02 10:13:39+00
129	45	2024-06-02 13:31:31+00
132	354	2024-06-03 10:06:25+00
131	355	2024-06-03 12:11:01+00
130	143	2024-06-03 13:32:59+00
130	182	2024-06-03 14:47:07+00
130	264	2024-06-03 15:24:24+00
129	252	2024-06-03 15:31:38+00
132	276	2024-06-05 06:28:16+00
137	13	2024-06-06 10:07:53+00
134	137	2024-06-06 10:10:15+00
136	128	2024-06-06 10:10:42+00
137	275	2024-06-06 10:11:48+00
137	276	2024-06-06 10:11:51+00
137	17	2024-06-06 10:19:47+00
137	354	2024-06-06 10:22:01+00
137	58	2024-06-06 10:27:17+00
134	88	2024-06-06 10:31:13+00
136	144	2024-06-06 10:56:47+00
137	41	2024-06-06 10:59:47+00
136	221	2024-06-06 11:19:26+00
134	338	2024-06-06 11:42:36+00
134	200	2024-06-06 11:43:12+00
136	102	2024-06-06 11:52:39+00
136	226	2024-06-06 12:05:21+00
137	22	2024-06-06 12:07:15+00
137	21	2024-06-06 12:49:56+00
136	264	2024-06-06 15:56:35+00
136	189	2024-06-06 17:12:41+00
134	352	2024-06-06 19:28:48+00
136	143	2024-06-06 21:25:58+00
134	45	2024-06-06 21:52:43+00
134	55	2024-06-06 21:52:47+00
136	287	2024-06-06 22:19:08+00
134	253	2024-06-08 11:17:37+00
136	72	2024-06-08 13:37:01+00
178	12	2024-10-07 18:44:10+00
180	12	2024-10-07 18:44:16+00
134	252	2024-06-09 09:45:25+00
137	252	2024-06-09 09:45:59+00
137	37	2024-06-09 10:04:49+00
134	251	2024-06-09 21:23:08+00
136	181	2024-06-10 06:07:47+00
136	357	2024-06-10 15:21:40+00
141	13	2024-06-12 06:06:39+00
141	1	2024-06-12 07:43:46+00
141	49	2024-06-13 10:00:06+00
141	354	2024-06-13 10:00:11+00
141	85	2024-06-13 10:00:14+00
141	21	2024-06-13 10:00:17+00
141	275	2024-06-13 10:01:32+00
141	276	2024-06-13 10:01:32+00
140	128	2024-06-13 10:04:25+00
140	137	2024-06-13 10:05:57+00
141	26	2024-06-13 10:08:18+00
141	37	2024-06-13 10:28:08+00
141	22	2024-06-13 10:44:51+00
140	287	2024-06-13 12:01:55+00
141	23	2024-06-13 12:02:16+00
139	88	2024-06-13 12:32:16+00
139	253	2024-06-13 13:17:20+00
141	57	2024-06-13 13:19:12+00
140	102	2024-06-13 13:41:14+00
140	143	2024-06-13 14:06:29+00
139	192	2024-06-13 16:46:49+00
139	358	2024-06-13 16:47:19+00
139	76	2024-06-13 17:01:20+00
139	296	2024-06-13 17:09:28+00
141	38	2024-06-13 19:15:18+00
140	359	2024-06-14 08:19:55+00
139	251	2024-06-14 17:08:48+00
139	200	2024-06-14 18:49:10+00
139	55	2024-06-14 23:20:35+00
139	352	2024-06-15 06:45:54+00
139	136	2024-06-15 10:42:00+00
139	252	2024-06-15 11:11:30+00
139	45	2024-06-16 00:08:05+00
140	267	2024-06-16 08:43:11+00
141	357	2024-06-16 12:40:47+00
140	357	2024-06-16 12:40:53+00
139	226	2024-06-16 13:51:36+00
139	361	2024-06-16 13:51:59+00
140	141	2024-06-16 14:31:53+00
140	362	2024-06-17 06:00:23+00
141	140	2024-06-17 06:57:01+00
141	147	2024-06-17 07:01:33+00
140	147	2024-06-17 07:01:39+00
141	43	2024-06-17 07:05:20+00
140	252	2024-06-17 13:52:22+00
139	127	2024-06-17 14:10:25+00
145	1	2024-06-19 14:40:47+00
145	12	2024-06-20 07:24:28+00
146	12	2024-06-20 07:24:32+00
146	348	2024-06-20 08:29:39+00
145	348	2024-06-20 08:29:55+00
145	17	2024-06-20 09:55:17+00
145	31	2024-06-20 10:00:10+00
145	21	2024-06-20 10:00:12+00
146	31	2024-06-20 10:00:14+00
145	49	2024-06-20 10:00:17+00
145	13	2024-06-20 10:00:18+00
145	85	2024-06-20 10:00:19+00
146	49	2024-06-20 10:00:22+00
146	85	2024-06-20 10:00:22+00
145	26	2024-06-20 10:00:35+00
146	26	2024-06-20 10:00:39+00
145	354	2024-06-20 10:00:41+00
145	276	2024-06-20 10:00:42+00
145	275	2024-06-20 10:00:45+00
146	354	2024-06-20 10:00:47+00
146	275	2024-06-20 10:01:10+00
146	276	2024-06-20 10:01:12+00
144	72	2024-06-20 10:04:54+00
144	137	2024-06-20 10:06:09+00
146	1	2024-06-20 10:10:55+00
144	173	2024-06-20 10:11:54+00
145	22	2024-06-20 10:16:51+00
146	22	2024-06-20 10:16:54+00
144	128	2024-06-20 10:24:18+00
145	267	2024-06-20 10:47:01+00
144	267	2024-06-20 10:47:05+00
143	88	2024-06-20 10:47:29+00
144	102	2024-06-20 11:00:30+00
143	97	2024-06-20 11:02:06+00
146	17	2024-06-20 11:04:35+00
143	338	2024-06-20 11:14:29+00
146	57	2024-06-20 11:17:12+00
144	287	2024-06-20 11:47:56+00
145	23	2024-06-20 11:58:42+00
143	200	2024-06-20 12:04:40+00
145	43	2024-06-20 12:05:10+00
146	43	2024-06-20 12:05:14+00
143	253	2024-06-20 12:32:17+00
145	37	2024-06-20 13:30:05+00
146	37	2024-06-20 13:30:13+00
146	13	2024-06-20 15:35:07+00
143	352	2024-06-20 16:18:18+00
144	329	2024-06-20 19:24:47+00
144	264	2024-06-20 19:25:44+00
145	264	2024-06-20 19:25:50+00
145	365	2024-06-20 19:28:22+00
144	365	2024-06-20 19:28:37+00
143	192	2024-06-20 20:18:03+00
143	358	2024-06-20 20:19:05+00
144	46	2024-06-20 21:17:35+00
146	46	2024-06-20 21:17:39+00
146	77	2024-06-20 22:31:40+00
144	144	2024-06-21 06:01:56+00
145	41	2024-06-21 06:20:31+00
146	41	2024-06-21 06:20:39+00
145	38	2024-06-21 06:58:18+00
144	226	2024-06-21 09:13:20+00
145	252	2024-06-21 09:49:00+00
144	143	2024-06-21 14:02:11+00
143	45	2024-06-21 16:22:53+00
143	55	2024-06-21 16:27:32+00
143	127	2024-06-21 16:29:38+00
144	78	2024-06-21 18:18:45+00
143	251	2024-06-22 07:17:18+00
144	70	2024-06-22 07:21:11+00
143	296	2024-06-22 13:14:45+00
143	76	2024-06-22 13:14:51+00
144	60	2024-06-22 13:53:43+00
144	359	2024-06-22 15:04:00+00
146	70	2024-06-22 21:38:37+00
149	13	2024-07-03 06:45:36+00
149	1	2024-07-03 15:55:58+00
149	12	2024-07-04 10:00:06+00
149	31	2024-07-04 10:00:19+00
148	267	2024-07-04 10:00:44+00
148	173	2024-07-04 10:02:56+00
149	58	2024-07-04 10:07:04+00
149	46	2024-07-04 10:07:23+00
148	287	2024-07-04 11:02:33+00
147	88	2024-07-04 11:11:49+00
149	23	2024-07-04 11:25:08+00
148	137	2024-07-04 11:45:17+00
149	22	2024-07-04 12:05:31+00
147	192	2024-07-04 12:11:06+00
148	264	2024-07-04 13:02:19+00
147	251	2024-07-04 13:11:50+00
147	136	2024-07-04 13:30:00+00
147	358	2024-07-04 13:54:16+00
147	127	2024-07-04 14:09:21+00
147	253	2024-07-04 15:44:52+00
148	128	2024-07-04 17:53:33+00
148	70	2024-07-04 18:02:01+00
147	70	2024-07-04 18:02:06+00
148	72	2024-07-04 18:36:04+00
149	17	2024-07-05 07:47:34+00
148	357	2024-07-05 07:51:39+00
147	352	2024-07-05 15:25:29+00
148	214	2024-07-06 08:52:02+00
147	200	2024-07-06 11:54:10+00
148	147	2024-07-06 19:25:52+00
148	221	2024-07-07 07:49:01+00
148	252	2024-07-07 12:06:51+00
147	252	2024-07-07 12:08:45+00
149	43	2024-07-07 12:25:38+00
149	371	2024-07-07 17:04:24+00
147	372	2024-07-07 18:30:18+00
149	60	2024-07-07 19:28:55+00
149	284	2024-07-08 05:56:39+00
149	367	2024-07-08 11:27:03+00
148	226	2024-07-08 11:28:07+00
148	373	2024-07-08 13:13:52+00
147	243	2024-07-08 14:29:07+00
148	374	2024-07-08 14:59:46+00
149	170	2024-07-08 16:46:22+00
153	1	2024-07-10 16:16:59+00
153	12	2024-07-11 09:57:15+00
154	12	2024-07-11 09:57:19+00
153	37	2024-07-11 10:00:10+00
153	354	2024-07-11 10:00:10+00
175	440	2024-10-07 19:41:32+00
154	354	2024-07-11 10:00:16+00
177	102	2024-10-10 10:53:01+00
176	268	2024-10-10 10:58:29+00
152	267	2024-07-11 10:00:23+00
152	72	2024-07-11 10:03:07+00
153	22	2024-07-11 10:14:26+00
154	22	2024-07-11 10:14:29+00
151	136	2024-07-11 10:24:30+00
152	287	2024-07-11 10:30:22+00
153	21	2024-07-11 10:45:07+00
153	170	2024-07-11 10:49:17+00
153	46	2024-07-11 10:51:50+00
152	252	2024-07-11 11:06:37+00
153	23	2024-07-11 11:22:23+00
153	371	2024-07-11 11:54:10+00
153	17	2024-07-11 14:02:32+00
154	17	2024-07-11 14:02:35+00
152	102	2024-07-11 14:18:57+00
154	368	2024-07-11 15:16:34+00
151	253	2024-07-11 15:41:58+00
151	127	2024-07-11 17:03:16+00
152	137	2024-07-11 18:25:26+00
153	357	2024-07-11 20:09:14+00
152	357	2024-07-11 20:09:19+00
152	173	2024-07-11 20:32:24+00
151	372	2024-07-12 07:25:11+00
151	358	2024-07-12 07:26:43+00
152	128	2024-07-12 14:37:14+00
152	70	2024-07-13 09:21:38+00
151	88	2024-07-13 12:53:45+00
152	147	2024-07-13 20:24:36+00
153	284	2024-07-14 08:14:20+00
151	352	2024-07-14 17:10:15+00
151	251	2024-07-14 17:30:53+00
152	243	2024-07-14 21:20:47+00
153	221	2024-07-15 08:04:10+00
154	23	2024-07-15 14:02:44+00
152	373	2024-07-15 14:58:47+00
153	252	2024-07-15 15:24:30+00
152	82	2024-07-15 16:30:12+00
157	13	2024-07-17 06:43:48+00
158	13	2024-07-17 06:43:52+00
158	17	2024-07-17 07:46:05+00
157	17	2024-07-17 07:46:09+00
154	21	2024-07-17 09:30:49+00
157	12	2024-07-17 11:53:08+00
154	371	2024-07-17 12:55:32+00
157	23	2024-07-17 13:28:40+00
158	23	2024-07-17 13:28:45+00
158	59	2024-07-17 13:49:53+00
157	1	2024-07-18 07:44:24+00
158	1	2024-07-18 07:44:27+00
158	348	2024-07-18 08:31:33+00
158	39	2024-07-18 10:00:04+00
157	354	2024-07-18 10:00:15+00
156	267	2024-07-18 10:00:15+00
156	173	2024-07-18 10:00:25+00
158	49	2024-07-18 10:00:25+00
158	26	2024-07-18 10:00:28+00
158	18	2024-07-18 10:00:34+00
158	236	2024-07-18 10:00:45+00
157	368	2024-07-18 10:00:53+00
158	368	2024-07-18 10:00:58+00
157	57	2024-07-18 10:01:35+00
158	57	2024-07-18 10:01:39+00
157	371	2024-07-18 10:02:03+00
158	371	2024-07-18 10:02:11+00
157	58	2024-07-18 10:02:24+00
158	58	2024-07-18 10:02:27+00
158	40	2024-07-18 10:04:41+00
158	22	2024-07-18 10:06:06+00
157	22	2024-07-18 10:06:09+00
158	44	2024-07-18 10:07:41+00
155	136	2024-07-18 10:12:52+00
158	275	2024-07-18 10:13:43+00
157	46	2024-07-18 10:14:33+00
158	46	2024-07-18 10:14:37+00
156	137	2024-07-18 10:20:43+00
156	147	2024-07-18 10:45:00+00
158	284	2024-07-18 11:22:29+00
155	127	2024-07-18 11:22:45+00
156	287	2024-07-18 11:24:26+00
158	276	2024-07-18 12:20:31+00
156	128	2024-07-18 12:38:44+00
156	264	2024-07-18 12:44:12+00
155	192	2024-07-18 13:58:36+00
155	372	2024-07-18 14:04:49+00
155	358	2024-07-18 14:07:39+00
155	88	2024-07-18 15:02:09+00
158	159	2024-07-18 16:35:15+00
157	221	2024-07-18 17:22:16+00
156	70	2024-07-19 06:08:53+00
157	85	2024-07-19 10:00:42+00
158	85	2024-07-19 10:00:48+00
156	357	2024-07-19 14:12:25+00
156	72	2024-07-19 16:54:25+00
155	352	2024-07-21 16:08:10+00
156	252	2024-07-21 22:56:19+00
155	252	2024-07-21 22:56:22+00
158	121	2024-07-22 07:14:48+00
157	284	2024-07-22 07:42:37+00
157	264	2024-07-22 09:19:56+00
155	137	2024-07-22 14:04:04+00
156	78	2024-07-22 14:35:21+00
157	66	2024-07-22 14:37:03+00
156	141	2024-07-22 14:44:18+00
155	70	2024-07-22 15:13:14+00
157	357	2024-07-22 16:33:00+00
158	100	2024-07-23 08:47:37+00
158	377	2024-07-24 08:04:48+00
162	17	2024-09-12 10:26:50+00
163	17	2024-09-12 10:26:53+00
162	39	2024-09-12 10:31:06+00
163	39	2024-09-12 10:31:11+00
162	368	2024-09-12 10:33:59+00
163	368	2024-09-12 10:34:06+00
161	93	2024-09-12 10:40:08+00
162	59	2024-09-12 10:52:58+00
162	37	2024-09-12 10:58:50+00
162	85	2024-09-12 10:58:54+00
163	85	2024-09-12 10:58:58+00
162	43	2024-09-12 10:59:17+00
162	77	2024-09-12 10:59:21+00
161	128	2024-09-12 10:59:22+00
161	267	2024-09-12 10:59:22+00
163	43	2024-09-12 10:59:25+00
162	14	2024-09-12 10:59:26+00
160	97	2024-09-12 10:59:27+00
161	137	2024-09-12 11:10:13+00
162	22	2024-09-12 11:10:54+00
163	22	2024-09-12 11:10:58+00
162	23	2024-09-12 11:12:59+00
163	23	2024-09-12 11:13:03+00
160	233	2024-09-12 11:13:20+00
161	252	2024-09-12 11:14:16+00
162	51	2024-09-12 11:17:01+00
162	31	2024-09-12 11:18:18+00
162	371	2024-09-12 11:44:05+00
162	21	2024-09-12 11:50:38+00
161	35	2024-09-12 11:59:43+00
162	221	2024-09-12 12:25:20+00
162	12	2024-09-12 12:26:30+00
161	141	2024-09-12 12:58:54+00
160	127	2024-09-12 15:20:23+00
160	88	2024-09-12 15:44:22+00
162	110	2024-09-13 16:25:39+00
160	387	2024-09-14 13:47:08+00
161	205	2024-09-14 20:36:32+00
161	390	2024-09-14 20:43:23+00
161	149	2024-09-16 06:52:26+00
160	252	2024-09-16 06:57:46+00
161	148	2024-09-16 07:02:10+00
161	214	2024-09-16 07:13:57+00
160	329	2024-09-16 08:08:25+00
160	137	2024-09-16 11:19:28+00
160	82	2024-09-16 12:50:51+00
161	221	2024-09-16 16:42:58+00
163	371	2024-09-17 09:36:19+00
163	66	2024-09-17 18:00:38+00
163	51	2024-09-17 19:55:22+00
163	203	2024-09-18 13:35:44+00
167	14	2024-09-19 07:07:35+00
166	40	2024-09-19 10:00:13+00
166	85	2024-09-19 10:00:16+00
167	40	2024-09-19 10:00:16+00
165	267	2024-09-19 10:00:17+00
167	85	2024-09-19 10:00:21+00
165	35	2024-09-19 10:00:28+00
166	368	2024-09-19 10:00:47+00
167	368	2024-09-19 10:00:51+00
166	22	2024-09-19 10:01:24+00
166	44	2024-09-19 10:02:37+00
167	44	2024-09-19 10:02:44+00
166	39	2024-09-19 10:56:32+00
167	39	2024-09-19 10:56:38+00
165	173	2024-09-19 11:11:55+00
164	291	2024-09-19 15:11:00+00
166	37	2024-09-19 15:12:17+00
178	17	2024-10-07 21:28:23+00
165	78	2024-09-19 20:46:28+00
180	17	2024-10-07 21:28:35+00
165	128	2024-09-19 22:57:01+00
177	382	2024-10-10 11:05:49+00
165	102	2024-09-20 05:39:42+00
165	252	2024-09-20 06:58:47+00
166	17	2024-09-20 07:33:49+00
180	236	2024-10-10 11:13:41+00
166	371	2024-09-20 07:35:51+00
176	136	2024-10-10 11:30:37+00
176	88	2024-10-11 04:15:49+00
177	397	2024-10-11 09:45:04+00
166	21	2024-09-20 18:24:08+00
165	141	2024-09-21 05:15:01+00
177	32	2024-10-11 09:51:16+00
166	23	2024-09-21 10:53:48+00
176	426	2024-10-11 17:58:16+00
164	127	2024-09-21 17:06:41+00
165	149	2024-09-21 19:54:27+00
166	51	2024-09-22 12:04:21+00
165	72	2024-09-22 14:06:19+00
165	291	2024-09-22 17:51:34+00
166	128	2024-09-22 19:47:31+00
165	393	2024-09-22 19:55:55+00
166	67	2024-09-23 08:49:41+00
164	394	2024-09-23 10:17:49+00
165	70	2024-09-23 12:32:20+00
167	68	2024-09-23 13:12:48+00
177	266	2024-10-12 13:30:01+00
177	78	2024-10-14 09:53:42+00
176	415	2024-10-14 12:26:25+00
165	329	2024-09-23 15:48:51+00
167	86	2024-09-23 16:22:53+00
166	110	2024-09-23 17:47:44+00
167	393	2024-09-23 19:53:08+00
167	12	2024-09-23 20:28:11+00
167	77	2024-09-24 20:26:02+00
167	398	2024-09-25 10:58:12+00
167	84	2024-09-25 12:58:41+00
167	34	2024-09-25 15:26:23+00
167	59	2024-09-25 18:09:48+00
171	46	2024-09-26 10:00:11+00
170	46	2024-09-26 10:00:15+00
170	40	2024-09-26 10:00:15+00
171	40	2024-09-26 10:00:19+00
170	39	2024-09-26 10:00:38+00
171	39	2024-09-26 10:00:44+00
170	85	2024-09-26 10:01:04+00
170	22	2024-09-26 10:03:31+00
170	18	2024-09-26 10:09:09+00
171	18	2024-09-26 10:09:40+00
169	399	2024-09-26 10:19:45+00
169	379	2024-09-26 11:17:20+00
168	253	2024-09-26 11:32:55+00
169	400	2024-09-26 12:03:07+00
169	291	2024-09-26 12:10:40+00
170	17	2024-09-26 12:11:32+00
171	17	2024-09-26 12:11:35+00
170	401	2024-09-26 13:54:55+00
169	404	2024-09-26 16:30:02+00
170	31	2024-09-26 19:25:08+00
171	31	2024-09-26 19:25:13+00
170	12	2024-09-26 20:04:47+00
171	12	2024-09-26 20:04:50+00
170	21	2024-09-26 20:21:36+00
171	403	2024-09-26 21:06:19+00
169	32	2024-09-27 07:14:34+00
169	72	2024-09-27 07:46:27+00
170	23	2024-09-27 08:17:57+00
170	140	2024-09-27 08:35:42+00
169	405	2024-09-27 11:55:09+00
171	236	2024-09-27 13:19:50+00
168	387	2024-09-27 13:47:38+00
169	387	2024-09-27 13:48:19+00
171	387	2024-09-27 13:49:27+00
171	393	2024-09-27 15:29:13+00
168	380	2024-09-27 15:44:45+00
168	406	2024-09-27 15:45:02+00
168	407	2024-09-27 15:58:52+00
170	59	2024-09-27 19:53:47+00
171	59	2024-09-27 19:56:32+00
168	55	2024-09-28 08:32:22+00
170	393	2024-09-28 11:34:21+00
168	410	2024-09-28 17:13:44+00
170	411	2024-09-28 17:38:32+00
169	148	2024-09-28 22:09:58+00
170	60	2024-09-29 07:41:00+00
169	149	2024-09-29 08:13:11+00
169	252	2024-09-29 12:40:40+00
171	371	2024-09-29 15:55:39+00
169	414	2024-09-29 15:56:21+00
171	51	2024-09-29 17:49:04+00
168	413	2024-09-29 19:10:47+00
168	45	2024-09-29 20:24:28+00
168	97	2024-09-30 11:19:21+00
168	88	2024-09-30 11:19:22+00
168	182	2024-09-30 14:10:13+00
170	110	2024-09-30 14:35:01+00
169	419	2024-09-30 16:13:57+00
171	84	2024-09-30 16:54:29+00
171	430	2024-10-01 12:25:21+00
171	433	2024-10-01 16:56:13+00
171	398	2024-10-01 17:16:42+00
171	197	2024-10-02 13:03:24+00
174	17	2024-10-03 07:45:07+00
174	37	2024-10-03 10:00:18+00
175	37	2024-10-03 10:00:22+00
174	85	2024-10-03 10:00:23+00
175	85	2024-10-03 10:00:28+00
174	21	2024-10-03 10:00:53+00
173	267	2024-10-03 10:01:11+00
174	264	2024-10-03 10:03:04+00
172	410	2024-10-03 10:09:57+00
174	13	2024-10-03 10:11:52+00
174	22	2024-10-03 10:15:10+00
174	368	2024-10-03 10:16:33+00
172	88	2024-10-03 10:16:38+00
175	368	2024-10-03 10:16:55+00
174	260	2024-10-03 10:47:29+00
175	260	2024-10-03 10:47:35+00
173	382	2024-10-03 10:54:31+00
173	434	2024-10-03 10:59:06+00
175	382	2024-10-03 11:23:56+00
174	252	2024-10-03 11:40:51+00
172	426	2024-10-03 11:43:47+00
172	413	2024-10-03 12:08:10+00
174	424	2024-10-03 13:06:19+00
175	424	2024-10-03 13:07:56+00
172	415	2024-10-03 13:10:11+00
174	425	2024-10-03 13:12:05+00
173	379	2024-10-03 13:48:30+00
174	200	2024-10-03 14:17:58+00
174	39	2024-10-03 15:11:26+00
174	416	2024-10-03 15:37:38+00
172	421	2024-10-03 16:14:44+00
172	444	2024-10-03 16:15:10+00
174	63	2024-10-03 16:52:58+00
173	432	2024-10-03 17:02:23+00
174	193	2024-10-03 17:29:35+00
174	357	2024-10-03 17:38:00+00
173	357	2024-10-03 17:38:08+00
174	59	2024-10-03 17:38:41+00
175	59	2024-10-03 17:40:08+00
174	43	2024-10-03 19:28:55+00
173	404	2024-10-04 06:19:23+00
175	236	2024-10-04 07:01:08+00
172	352	2024-10-04 07:21:57+00
172	253	2024-10-04 07:22:38+00
172	445	2024-10-04 10:47:06+00
173	32	2024-10-04 12:50:44+00
173	446	2024-10-04 14:04:01+00
175	411	2024-10-04 17:32:19+00
172	55	2024-10-05 02:33:39+00
175	12	2024-10-05 06:45:32+00
174	12	2024-10-05 06:59:50+00
172	438	2024-10-05 07:50:49+00
175	393	2024-10-05 10:56:12+00
172	448	2024-10-05 11:03:19+00
173	182	2024-10-05 19:13:22+00
172	136	2024-10-06 07:29:27+00
173	136	2024-10-06 07:29:36+00
173	451	2024-10-06 13:39:38+00
172	127	2024-10-06 16:45:50+00
172	45	2024-10-06 17:45:19+00
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id, name, date, publish_on, max_participants, location, "time", created_at, updated_at, notification_sent) FROM stdin;
49	Actives	2023-12-04 00:00:00+00	2023-11-30 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2023-11-29 19:46:32+00	2023-11-29 19:46:32+00	f
52	Free Game	2023-12-02 00:00:00+00	2023-11-30 11:00:00+00	36	Petershausener Sporthalle	12:00	2023-11-29 19:50:52+00	2023-11-29 19:50:52+00	f
47	Beginner	2023-12-04 00:00:00+00	2023-11-30 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2023-11-29 19:46:18+00	2023-12-04 10:30:13+00	t
48	Advanced	2023-12-04 00:00:00+00	2023-11-30 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2023-11-29 19:46:24+00	2023-12-04 12:00:28+00	t
41	Free Game	2023-11-25 00:00:00+00	2023-11-20 11:00:00+00	36	Petershausener Sporthalle	12:00	2023-11-20 09:10:43+00	2023-11-20 09:10:43+00	f
37	Beginner	2023-11-20 00:00:00+00	2023-11-16 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2023-11-16 16:39:20+00	2023-11-20 10:31:22+00	t
38	Advanced	2023-11-20 00:00:00+00	2023-11-16 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2023-11-16 16:39:31+00	2023-11-20 12:00:22+00	t
39	Actives	2023-11-20 00:00:00+00	2023-11-16 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2023-11-16 16:39:43+00	2023-11-20 13:31:27+00	t
44	Actives	2023-11-27 00:00:00+00	2023-11-23 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2023-11-21 13:51:50+00	2023-11-21 13:51:50+00	f
46	Actives - 5:1 System	2023-11-29 00:00:00+00	2023-11-23 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2023-11-21 13:52:28+00	2023-11-21 13:52:28+00	f
40	Actives - 5:1 System	2023-11-22 00:00:00+00	2023-11-16 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2023-11-16 16:39:54+00	2023-11-22 13:31:02+00	t
42	Beginner	2023-11-27 00:00:00+00	2023-11-23 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2023-11-21 13:51:33+00	2023-11-27 10:30:58+00	t
43	Advanced	2023-11-27 00:00:00+00	2023-11-23 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2023-11-21 13:51:42+00	2023-11-27 12:00:59+00	t
53	Free Game	2023-12-09 00:00:00+00	2023-12-06 11:00:00+00	36	Petershausener Sporthalle	12:00	2023-12-06 07:52:42+00	2023-12-06 07:52:42+00	f
56	Actives	2023-12-11 00:00:00+00	2023-12-07 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2023-12-07 09:48:57+00	2023-12-07 09:48:57+00	f
57	Actives - 5:1 System	2023-12-13 00:00:00+00	2023-12-07 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2023-12-07 09:49:21+00	2023-12-07 09:49:21+00	f
54	Beginner	2023-12-11 00:00:00+00	2023-12-07 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2023-12-07 09:48:29+00	2023-12-11 10:31:47+00	t
55	Advanced	2023-12-11 00:00:00+00	2023-12-07 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2023-12-07 09:48:43+00	2023-12-11 12:00:01+00	t
58	Free Game	2023-12-16 00:00:00+00	2023-12-14 11:00:00+00	30	Petershausener Sporthalle	12:00	2023-12-12 07:45:32+00	2023-12-12 07:45:32+00	f
59	Christmas Special🎄	2023-12-18 00:00:00+00	2023-12-14 11:00:00+00	30	Ellenrieder Gymnasium	17:30	2023-12-12 13:32:13+00	2023-12-12 13:32:13+00	f
61	Christmas Special🎄	2023-12-18 00:00:00+00	2023-12-14 11:16:00+00	30	Ellenrieder Gymnasium	20:00	2023-12-14 11:16:26+00	2023-12-14 11:16:26+00	f
62	Beginner	2024-01-08 00:00:00+00	2024-01-04 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-01-03 08:31:28+00	2024-01-03 08:31:28+00	f
63	Advanced	2024-01-08 00:00:00+00	2024-01-04 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-01-03 08:31:36+00	2024-01-03 08:31:36+00	f
64	Actives	2024-01-08 00:00:00+00	2024-01-04 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-01-03 08:31:45+00	2024-01-03 08:31:45+00	f
65	Actives - 5:1 System	2024-01-10 00:00:00+00	2024-01-04 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-01-03 08:31:54+00	2024-01-03 08:31:54+00	f
68	Actives	2024-01-15 00:00:00+00	2024-01-11 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-01-10 09:29:08+00	2024-01-10 09:29:08+00	f
69	Actives - 5:1 System	2024-01-17 00:00:00+00	2024-01-11 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-01-10 09:29:16+00	2024-01-10 09:29:16+00	f
66	Beginner	2024-01-15 00:00:00+00	2024-01-11 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-01-10 09:28:58+00	2024-01-15 13:03:17+00	t
67	Advanced	2024-01-15 00:00:00+00	2024-01-11 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-01-10 09:29:04+00	2024-01-15 13:03:29+00	t
71	Advanced	2024-01-22 00:00:00+00	2024-01-18 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-01-17 07:53:50+00	2024-01-17 07:53:50+00	f
72	Actives	2024-01-22 00:00:00+00	2024-01-18 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-01-17 07:53:55+00	2024-01-17 07:53:55+00	f
73	Actives - 5:1 System	2024-01-24 00:00:00+00	2024-01-18 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-01-17 07:54:08+00	2024-01-17 07:54:08+00	f
74	Free Game	2024-01-20 00:00:00+00	2024-01-18 11:00:00+00	36	Petershausener Sporthalle	12:00	2024-01-17 15:03:13+00	2024-01-17 15:03:13+00	f
70	Beginner	2024-01-22 00:00:00+00	2024-01-18 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-01-17 07:53:45+00	2024-01-22 10:30:25+00	t
77	Actives	2024-01-29 00:00:00+00	2024-01-25 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-01-23 11:46:11+00	2024-01-23 11:46:11+00	f
78	Actives - 5:1 System	2024-01-31 00:00:00+00	2024-01-25 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-01-23 11:46:31+00	2024-01-23 11:46:31+00	f
79	Free Game	2024-01-27 00:00:00+00	2024-01-24 11:00:00+00	36	Petershausener Sporthalle	11:00	2024-01-24 11:17:43+00	2024-01-24 11:17:43+00	f
75	Beginner	2024-01-29 00:00:00+00	2024-01-25 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-01-23 11:45:58+00	2024-01-29 10:31:15+00	t
76	Advanced	2024-01-29 00:00:00+00	2024-01-25 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-01-23 11:46:06+00	2024-01-29 12:01:23+00	t
82	Actives	2024-02-05 00:00:00+00	2024-02-01 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-01-31 15:01:00+00	2024-01-31 15:01:00+00	f
80	Beginner	2024-02-05 00:00:00+00	2024-02-01 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-01-31 15:00:52+00	2024-02-05 10:31:40+00	t
81	Advanced	2024-02-05 00:00:00+00	2024-02-01 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-01-31 15:00:56+00	2024-02-05 12:11:48+00	t
84	Beginner	2024-02-19 00:00:00+00	2024-02-15 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-02-14 14:24:38+00	2024-02-14 14:24:38+00	f
85	Advanced	2024-02-19 00:00:00+00	2024-02-15 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-02-14 14:24:42+00	2024-02-14 14:24:42+00	f
86	Actives	2024-02-19 00:00:00+00	2024-02-15 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-02-14 14:24:48+00	2024-02-14 14:24:48+00	f
89	Free Game	2024-02-24 00:00:00+00	2024-02-15 11:00:00+00	30	Petershausener Sporthalle	11:00	2024-02-15 07:54:44+00	2024-02-15 07:54:44+00	f
90	Beginner	2024-02-26 00:00:00+00	2024-02-22 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-02-21 09:06:01+00	2024-02-21 09:06:01+00	f
91	Advanced	2024-02-26 00:00:00+00	2024-02-22 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-02-21 09:06:11+00	2024-02-21 09:06:11+00	f
92	Actives	2024-02-26 00:00:00+00	2024-02-22 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-02-21 09:06:22+00	2024-02-21 09:06:22+00	f
93	Actives - 5:1 System	2024-02-28 00:00:00+00	2024-02-22 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-02-21 09:06:37+00	2024-02-21 09:06:37+00	f
95	Advanced	2024-03-18 00:00:00+00	2024-03-14 11:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-03-14 09:47:26+00	2024-03-14 09:47:26+00	f
96	Actives	2024-03-18 00:00:00+00	2024-03-14 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-03-14 09:47:38+00	2024-03-14 09:47:38+00	f
97	Actives - 5:1 System	2024-03-20 00:00:00+00	2024-03-14 11:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-03-14 09:47:53+00	2024-03-14 09:47:53+00	f
94	Beginner	2024-03-18 00:00:00+00	2024-03-14 11:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-03-14 09:47:14+00	2024-03-18 10:30:49+00	t
98	Beginner	2024-04-08 00:00:00+00	2024-04-04 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-03-27 12:28:07+00	2024-03-27 12:28:07+00	f
99	Advanced	2024-04-08 00:00:00+00	2024-04-04 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-03-27 12:28:29+00	2024-03-27 12:28:29+00	f
100	Actives	2024-04-08 00:00:00+00	2024-04-04 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-03-27 12:28:47+00	2024-03-27 12:28:47+00	f
101	Actives - 5:1 System	2024-04-10 00:00:00+00	2024-04-04 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-03-27 12:29:05+00	2024-03-27 12:29:05+00	f
103	Advanced	2024-04-15 00:00:00+00	2024-04-11 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-04-10 07:46:31+00	2024-04-10 07:46:31+00	f
104	Actives	2024-04-15 00:00:00+00	2024-04-11 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-04-10 07:46:42+00	2024-04-10 07:46:42+00	f
105	Actives - 5:1 System	2024-04-17 00:00:00+00	2024-04-11 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-04-10 07:46:53+00	2024-04-10 07:46:53+00	f
102	Beginner	2024-04-15 00:00:00+00	2024-04-11 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-04-10 07:46:22+00	2024-04-15 10:31:46+00	t
107	Advanced	2024-04-22 00:00:00+00	2024-04-18 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-04-16 07:12:00+00	2024-04-16 07:12:00+00	f
108	Actives	2024-04-22 00:00:00+00	2024-04-18 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-04-16 07:12:07+00	2024-04-16 07:12:07+00	f
106	Beginner	2024-04-22 00:00:00+00	2024-04-18 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-04-16 07:11:55+00	2024-04-22 10:31:04+00	t
109	Actives - 5:1 System	2024-04-24 00:00:00+00	2024-04-18 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-04-16 07:12:32+00	2024-04-24 17:14:09+00	t
112	Actives	2024-04-29 00:00:00+00	2024-04-25 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-04-24 18:16:18+00	2024-04-24 18:16:18+00	f
110	Beginner	2024-04-29 00:00:00+00	2024-04-25 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-04-24 18:15:59+00	2024-04-29 16:23:49+00	t
111	Advanced	2024-04-29 00:00:00+00	2024-04-25 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-04-24 18:16:06+00	2024-04-29 17:01:57+00	t
115	Actives	2024-05-06 00:00:00+00	2024-05-02 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-04-30 07:48:46+00	2024-04-30 07:48:46+00	f
116	Actives - 5:1 System	2024-05-08 00:00:00+00	2024-05-02 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-04-30 07:49:02+00	2024-04-30 07:49:02+00	f
113	Beginner	2024-05-06 00:00:00+00	2024-05-02 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-04-30 07:48:26+00	2024-05-06 10:30:42+00	t
114	Advanced	2024-05-06 00:00:00+00	2024-05-02 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-04-30 07:48:34+00	2024-05-06 12:50:51+00	t
119	Actives	2024-05-13 00:00:00+00	2024-05-09 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-05-08 06:22:05+00	2024-05-08 06:22:05+00	f
117	Beginner	2024-05-13 00:00:00+00	2024-05-09 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-05-08 06:21:47+00	2024-05-13 17:45:39+00	t
118	Advanced	2024-05-13 00:00:00+00	2024-05-09 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-05-08 06:21:57+00	2024-05-13 17:45:45+00	t
120	Actives - 5:1 System	2024-05-15 00:00:00+00	2024-05-09 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-05-08 06:22:18+00	2024-05-15 13:30:32+00	t
139	Beginner	2024-06-17 00:00:00+00	2024-06-13 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-06-12 06:06:05+00	2024-06-12 06:06:05+00	t
140	Advanced	2024-06-17 00:00:00+00	2024-06-13 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-06-12 06:06:14+00	2024-06-12 06:06:14+00	t
129	Beginner	2024-06-03 00:00:00+00	2024-05-30 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-05-28 09:18:05+00	2024-05-28 09:18:05+00	t
130	Advanced	2024-06-03 00:00:00+00	2024-05-30 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-05-28 09:18:10+00	2024-05-28 09:18:10+00	t
131	Actives	2024-06-03 00:00:00+00	2024-05-30 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-05-28 09:18:14+00	2024-05-28 09:18:14+00	t
132	Actives - 5:1 System	2024-06-05 00:00:00+00	2024-05-30 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-05-28 09:18:20+00	2024-05-28 09:18:20+00	t
134	Beginner	2024-06-10 00:00:00+00	2024-06-06 10:10:00+00	18	Ellenrieder Sporthalle	17:30	2024-06-06 10:06:36+00	2024-06-06 10:06:36+00	t
136	Advanced	2024-06-10 00:00:00+00	2024-06-06 10:10:00+00	18	Ellenrieder Sporthalle	19:00	2024-06-06 10:06:58+00	2024-06-06 10:06:58+00	t
137	Actives	2024-06-10 00:00:00+00	2024-06-06 10:10:00+00	18	Ellenrieder Sporthalle	20:30	2024-06-06 10:07:15+00	2024-06-06 10:07:15+00	t
141	Actives	2024-06-17 00:00:00+00	2024-06-13 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-06-12 06:06:23+00	2024-06-12 06:06:23+00	t
143	Beginner	2024-06-24 00:00:00+00	2024-06-20 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-06-19 13:33:53+00	2024-06-19 13:33:53+00	f
144	Advanced	2024-06-24 00:00:00+00	2024-06-20 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-06-19 13:33:59+00	2024-06-19 13:33:59+00	f
145	Actives	2024-06-24 00:00:00+00	2024-06-20 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-06-19 13:34:04+00	2024-06-19 13:34:04+00	f
146	Actives - 5:1 System	2024-06-26 00:00:00+00	2024-06-20 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-06-19 13:34:12+00	2024-06-19 13:34:12+00	f
147	Beginner	2024-07-08 00:00:00+00	2024-07-04 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-07-03 06:38:40+00	2024-07-03 06:38:40+00	t
148	Advanced	2024-07-08 00:00:00+00	2024-07-04 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-07-03 06:38:43+00	2024-07-03 06:38:43+00	t
149	Actives	2024-07-08 00:00:00+00	2024-07-04 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-07-03 06:38:47+00	2024-07-03 06:38:47+00	t
151	Beginner	2024-07-15 00:00:00+00	2024-07-11 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-07-10 07:25:21+00	2024-07-10 07:25:21+00	t
152	Advanced	2024-07-15 00:00:00+00	2024-07-11 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-07-10 07:25:26+00	2024-07-10 07:25:26+00	t
153	Actives	2024-07-15 00:00:00+00	2024-07-11 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-07-10 07:25:32+00	2024-07-10 07:25:32+00	t
154	Actives - 5:1 System	2024-07-17 00:00:00+00	2024-07-11 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-07-10 07:25:38+00	2024-07-10 07:25:38+00	t
155	Beginner	2024-07-22 00:00:00+00	2024-07-18 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-07-17 06:42:36+00	2024-07-17 06:42:36+00	t
156	Advanced	2024-07-22 00:00:00+00	2024-07-18 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-07-17 06:42:46+00	2024-07-17 06:42:46+00	t
157	Actives	2024-07-22 00:00:00+00	2024-07-18 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-07-17 06:42:52+00	2024-07-17 06:42:52+00	t
158	Actives - 5:1 System	2024-07-24 00:00:00+00	2024-07-18 10:00:00+00	24	Ellenrieder Sporthalle	19:00	2024-07-17 06:43:37+00	2024-07-17 06:43:37+00	t
160	Beginner	2024-09-16 00:00:00+00	2024-09-12 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-09-12 10:25:30+00	2024-09-12 10:25:30+00	t
161	Advanced	2024-09-16 00:00:00+00	2024-09-12 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-09-12 10:26:09+00	2024-09-12 10:26:09+00	t
162	Actives	2024-09-16 00:00:00+00	2024-09-12 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-09-12 10:26:30+00	2024-09-12 10:26:30+00	t
163	Actives - 5:1 System	2024-09-18 00:00:00+00	2024-09-12 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-09-12 10:26:45+00	2024-09-12 10:26:45+00	t
164	Beginner	2024-09-23 00:00:00+00	2024-09-19 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-09-19 07:06:48+00	2024-09-19 07:06:48+00	t
165	Advanced	2024-09-23 00:00:00+00	2024-09-19 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-09-19 07:07:01+00	2024-09-19 07:07:01+00	t
166	Actives	2024-09-23 00:00:00+00	2024-09-19 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-09-19 07:07:14+00	2024-09-19 07:07:14+00	t
167	Actives - 5:1 System	2024-09-25 00:00:00+00	2024-09-19 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-09-19 07:07:29+00	2024-09-19 07:07:29+00	t
168	Beginner	2024-09-30 00:00:00+00	2024-09-26 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-09-26 04:11:36+00	2024-09-26 04:11:36+00	t
169	Advanced	2024-09-30 00:00:00+00	2024-09-26 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-09-26 04:11:50+00	2024-09-26 04:11:50+00	t
170	Actives	2024-09-30 00:00:00+00	2024-09-26 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-09-26 04:12:02+00	2024-09-26 04:12:02+00	t
171	Actives - 5:1 System	2024-10-02 00:00:00+00	2024-09-26 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-09-26 04:12:15+00	2024-09-26 04:12:15+00	t
172	Beginner	2024-10-07 00:00:00+00	2024-10-03 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-10-03 07:44:10+00	2024-10-03 07:44:10+00	t
173	Advanced	2024-10-07 00:00:00+00	2024-10-03 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-10-03 07:44:25+00	2024-10-03 07:44:25+00	t
174	Actives	2024-10-07 00:00:00+00	2024-10-03 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-10-03 07:44:38+00	2024-10-03 07:44:38+00	t
178	Actives	2024-10-14 00:00:00+00	2024-10-10 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-10-07 18:43:34+00	2024-10-07 18:43:34+00	f
180	Actives - 5:1 System	2024-10-16 00:00:00+00	2024-10-10 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-10-07 18:44:03+00	2024-10-07 18:44:03+00	f
176	Beginner	2024-10-14 00:00:00+00	2024-10-10 10:00:00+00	18	Ellenrieder Sporthalle	17:30	2024-10-07 18:43:23+00	2024-10-07 18:43:23+00	t
177	Advanced	2024-10-14 00:00:00+00	2024-10-10 10:00:00+00	18	Ellenrieder Sporthalle	19:00	2024-10-07 18:43:29+00	2024-10-07 18:43:29+00	t
175	Actives - 5:1 System	2024-10-09 00:00:00+00	2024-10-03 10:00:00+00	18	Ellenrieder Sporthalle	20:30	2024-10-03 07:45:00+00	2024-10-03 07:45:00+00	t
\.


--
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20231023213206	2023-10-23 23:05:48.220985+00
2	Migration20231104124520	2023-11-04 13:20:36.225284+00
3	Migration20231104134212	2023-11-04 14:24:45.896266+00
4	Migration20231104154445	2023-11-04 16:09:21.817602+00
5	Migration20231104161536	2023-11-04 16:19:46.088832+00
6	Migration20231104161638	2023-11-04 16:19:46.088832+00
7	Migration20231104163338	2023-11-04 16:39:32.45735+00
8	Migration20231104211514	2023-11-04 21:28:14.29957+00
9	Migration20231104213436	2023-11-04 21:37:55.901143+00
40	Migration20231106095304	2023-11-06 12:23:21.233816+00
41	Migration20231106120143	2023-11-06 12:23:21.233816+00
42	Migration20231111152800	2023-11-11 16:04:19.716018+00
43	Migration20231122173745	2023-11-22 18:04:43.646801+00
44	Migration20231122183742	2023-11-22 18:42:22.93858+00
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_id_seq', 483, true);


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_id_seq', 180, true);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 44, true);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: course_spots course_spots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_spots
    ADD CONSTRAINT course_spots_pkey PRIMARY KEY (user_id, course_id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- Name: accounts_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_email_index ON public.accounts USING btree (email);


--
-- Name: accounts_session_token_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_session_token_index ON public.accounts USING btree (session_token);


--
-- Name: accounts_username_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_username_index ON public.accounts USING btree (username);


--
-- Name: courses_name_date_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX courses_name_date_index ON public.courses USING btree (name, date);


--
-- Name: course_spots course_spots_course_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_spots
    ADD CONSTRAINT course_spots_course_id_foreign FOREIGN KEY (course_id) REFERENCES public.courses(id) ON UPDATE CASCADE;


--
-- Name: course_spots course_spots_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_spots
    ADD CONSTRAINT course_spots_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.accounts(id) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

