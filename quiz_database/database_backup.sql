--
-- PostgreSQL database dump
--

\restrict F7Mw8Ff4eHWqrh0NcArCUXpp9YjQKXCkRhE1ojU7PCHIDAiqqdVM4Eh16EyV7L5

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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

DROP DATABASE IF EXISTS myapp;
--
-- Name: myapp; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE myapp WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE myapp OWNER TO postgres;

\unrestrict F7Mw8Ff4eHWqrh0NcArCUXpp9YjQKXCkRhE1ojU7PCHIDAiqqdVM4Eh16EyV7L5
\connect myapp
\restrict F7Mw8Ff4eHWqrh0NcArCUXpp9YjQKXCkRhE1ojU7PCHIDAiqqdVM4Eh16EyV7L5

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

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: appuser
--

CREATE TYPE public.user_role AS ENUM (
    'user',
    'admin'
);


ALTER TYPE public.user_role OWNER TO appuser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: answers; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.answers (
    attempt_id integer NOT NULL,
    question_id integer NOT NULL,
    selected_option integer NOT NULL,
    is_correct boolean NOT NULL
);


ALTER TABLE public.answers OWNER TO appuser;

--
-- Name: attempts; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.attempts (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    quiz_id integer NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    submitted_at timestamp with time zone,
    score numeric
);


ALTER TABLE public.attempts OWNER TO appuser;

--
-- Name: attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: appuser
--

CREATE SEQUENCE public.attempts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attempts_id_seq OWNER TO appuser;

--
-- Name: attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: appuser
--

ALTER SEQUENCE public.attempts_id_seq OWNED BY public.attempts.id;


--
-- Name: leaderboard; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.leaderboard (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    total_score numeric DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.leaderboard OWNER TO appuser;

--
-- Name: leaderboard_id_seq; Type: SEQUENCE; Schema: public; Owner: appuser
--

CREATE SEQUENCE public.leaderboard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leaderboard_id_seq OWNER TO appuser;

--
-- Name: leaderboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: appuser
--

ALTER SEQUENCE public.leaderboard_id_seq OWNED BY public.leaderboard.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.profiles (
    user_id uuid NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL
);


ALTER TABLE public.profiles OWNER TO appuser;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    prompt text NOT NULL,
    options jsonb NOT NULL,
    correct_option integer NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT questions_correct_option_nonneg CHECK ((correct_option >= 0))
);


ALTER TABLE public.questions OWNER TO appuser;

--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: appuser
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.questions_id_seq OWNER TO appuser;

--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: appuser
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: quiz_questions; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.quiz_questions (
    quiz_id integer NOT NULL,
    question_id integer NOT NULL,
    "position" integer NOT NULL
);


ALTER TABLE public.quiz_questions OWNER TO appuser;

--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.quizzes (
    id integer NOT NULL,
    title text NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.quizzes OWNER TO appuser;

--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: appuser
--

CREATE SEQUENCE public.quizzes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quizzes_id_seq OWNER TO appuser;

--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: appuser
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    display_name text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO appuser;

--
-- Name: attempts id; Type: DEFAULT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.attempts ALTER COLUMN id SET DEFAULT nextval('public.attempts_id_seq'::regclass);


--
-- Name: leaderboard id; Type: DEFAULT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.leaderboard ALTER COLUMN id SET DEFAULT nextval('public.leaderboard_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.answers (attempt_id, question_id, selected_option, is_correct) FROM stdin;
\.


--
-- Data for Name: attempts; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.attempts (id, user_id, quiz_id, started_at, submitted_at, score) FROM stdin;
\.


--
-- Data for Name: leaderboard; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.leaderboard (id, user_id, total_score, last_updated) FROM stdin;
1	00000000-0000-0000-0000-000000000001	10	2026-01-06 07:21:33.246112+00
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.profiles (user_id, role) FROM stdin;
00000000-0000-0000-0000-000000000001	admin
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.questions (id, prompt, options, correct_option, created_by, created_at) FROM stdin;
1	What is 2 + 2?	[3, 4, 5, 22]	1	00000000-0000-0000-0000-000000000001	2026-01-06 07:21:12.520064+00
2	Which planet is known as the Red Planet?	["Earth", "Mars", "Jupiter", "Venus"]	1	00000000-0000-0000-0000-000000000001	2026-01-06 07:21:17.650456+00
3	What does JSON stand for?	["Java Source Object Notation", "JavaScript Object Notation", "Just Simple Object Notation", "Joined String Output Name"]	1	00000000-0000-0000-0000-000000000001	2026-01-06 07:21:21.257756+00
\.


--
-- Data for Name: quiz_questions; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.quiz_questions (quiz_id, question_id, "position") FROM stdin;
1	1	1
1	2	2
1	3	3
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.quizzes (id, title, description, is_active, created_at) FROM stdin;
1	Sample Quiz	A short sample quiz to verify schema + seed data.	t	2026-01-06 07:21:06.889551+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.users (id, email, display_name, created_at) FROM stdin;
00000000-0000-0000-0000-000000000001	admin@example.com	Admin	2026-01-06 07:21:01.685533+00
\.


--
-- Name: attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: appuser
--

SELECT pg_catalog.setval('public.attempts_id_seq', 1, false);


--
-- Name: leaderboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: appuser
--

SELECT pg_catalog.setval('public.leaderboard_id_seq', 1, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: appuser
--

SELECT pg_catalog.setval('public.questions_id_seq', 3, true);


--
-- Name: quizzes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: appuser
--

SELECT pg_catalog.setval('public.quizzes_id_seq', 1, true);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (attempt_id, question_id);


--
-- Name: attempts attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_pkey PRIMARY KEY (id);


--
-- Name: leaderboard leaderboard_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.leaderboard
    ADD CONSTRAINT leaderboard_pkey PRIMARY KEY (id);


--
-- Name: leaderboard leaderboard_user_id_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.leaderboard
    ADD CONSTRAINT leaderboard_user_id_key UNIQUE (user_id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (user_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_questions quiz_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_pkey PRIMARY KEY (quiz_id, question_id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_answers_attempt_id; Type: INDEX; Schema: public; Owner: appuser
--

CREATE INDEX idx_answers_attempt_id ON public.answers USING btree (attempt_id);


--
-- Name: idx_attempts_user_quiz; Type: INDEX; Schema: public; Owner: appuser
--

CREATE INDEX idx_attempts_user_quiz ON public.attempts USING btree (user_id, quiz_id);


--
-- Name: idx_leaderboard_total_score_desc; Type: INDEX; Schema: public; Owner: appuser
--

CREATE INDEX idx_leaderboard_total_score_desc ON public.leaderboard USING btree (total_score DESC);


--
-- Name: answers answers_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES public.attempts(id) ON DELETE CASCADE;


--
-- Name: answers answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: attempts attempts_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: attempts attempts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.attempts
    ADD CONSTRAINT attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: leaderboard leaderboard_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.leaderboard
    ADD CONSTRAINT leaderboard_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: questions questions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: quiz_questions quiz_questions_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: quiz_questions quiz_questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: DATABASE myapp; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE myapp TO appuser;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO appuser;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.armor(bytea) TO appuser;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.armor(bytea, text[], text[]) TO appuser;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.crypt(text, text) TO appuser;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.dearmor(text) TO appuser;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.decrypt(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.decrypt_iv(bytea, bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.digest(bytea, text) TO appuser;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.digest(text, text) TO appuser;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.encrypt(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.encrypt_iv(bytea, bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_random_bytes(integer) TO appuser;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_random_uuid() TO appuser;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_salt(text) TO appuser;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_salt(text, integer) TO appuser;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hmac(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hmac(text, text, text) TO appuser;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_armor_headers(text, OUT key text, OUT value text) TO appuser;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_key_id(bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text, text) TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TYPES TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO appuser;


--
-- PostgreSQL database dump complete
--

\unrestrict F7Mw8Ff4eHWqrh0NcArCUXpp9YjQKXCkRhE1ojU7PCHIDAiqqdVM4Eh16EyV7L5

