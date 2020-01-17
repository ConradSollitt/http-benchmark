--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 11.5

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

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO postgres;

--
-- Name: computable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.computable (
    id bigint NOT NULL,
    runnable_id bigint,
    metric_id bigint,
    value double precision
);


ALTER TABLE public.computable OWNER TO postgres;

--
-- Name: computable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.computable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.computable_id_seq OWNER TO postgres;

--
-- Name: computable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.computable_id_seq OWNED BY public.computable.id;


--
-- Name: engines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.engines (
    id bigint NOT NULL,
    label character varying
);


ALTER TABLE public.engines OWNER TO postgres;

--
-- Name: engines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.engines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.engines_id_seq OWNER TO postgres;

--
-- Name: engines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.engines_id_seq OWNED BY public.engines.id;


--
-- Name: frameworks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.frameworks (
    id bigint NOT NULL,
    label character varying
);


ALTER TABLE public.frameworks OWNER TO postgres;

--
-- Name: frameworks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.frameworks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.frameworks_id_seq OWNER TO postgres;

--
-- Name: frameworks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.frameworks_id_seq OWNED BY public.frameworks.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.languages (
    id bigint NOT NULL,
    label character varying
);


ALTER TABLE public.languages OWNER TO postgres;

--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.languages_id_seq OWNER TO postgres;

--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;


--
-- Name: metrics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metrics (
    id bigint NOT NULL,
    label character varying
);


ALTER TABLE public.metrics OWNER TO postgres;

--
-- Name: metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.metrics_id_seq OWNER TO postgres;

--
-- Name: metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metrics_id_seq OWNED BY public.metrics.id;


--
-- Name: runnable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.runnable (
    id bigint NOT NULL,
    engine_id bigint,
    writable_id bigint
);


ALTER TABLE public.runnable OWNER TO postgres;

--
-- Name: runnable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.runnable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.runnable_id_seq OWNER TO postgres;

--
-- Name: runnable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.runnable_id_seq OWNED BY public.runnable.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: writable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.writable (
    id bigint NOT NULL,
    framework_id bigint,
    language_id bigint
);


ALTER TABLE public.writable OWNER TO postgres;

--
-- Name: writable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.writable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.writable_id_seq OWNER TO postgres;

--
-- Name: writable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.writable_id_seq OWNED BY public.writable.id;


--
-- Name: computable id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computable ALTER COLUMN id SET DEFAULT nextval('public.computable_id_seq'::regclass);


--
-- Name: engines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engines ALTER COLUMN id SET DEFAULT nextval('public.engines_id_seq'::regclass);


--
-- Name: frameworks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.frameworks ALTER COLUMN id SET DEFAULT nextval('public.frameworks_id_seq'::regclass);


--
-- Name: languages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages ALTER COLUMN id SET DEFAULT nextval('public.languages_id_seq'::regclass);


--
-- Name: metrics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metrics ALTER COLUMN id SET DEFAULT nextval('public.metrics_id_seq'::regclass);


--
-- Name: runnable id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.runnable ALTER COLUMN id SET DEFAULT nextval('public.runnable_id_seq'::regclass);


--
-- Name: writable id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writable ALTER COLUMN id SET DEFAULT nextval('public.writable_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: computable computable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.computable
    ADD CONSTRAINT computable_pkey PRIMARY KEY (id);


--
-- Name: engines engines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engines
    ADD CONSTRAINT engines_pkey PRIMARY KEY (id);


--
-- Name: frameworks frameworks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.frameworks
    ADD CONSTRAINT frameworks_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: metrics metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_pkey PRIMARY KEY (id);


--
-- Name: runnable runnable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.runnable
    ADD CONSTRAINT runnable_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: writable writable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.writable
    ADD CONSTRAINT writable_pkey PRIMARY KEY (id);


--
-- Name: index_computable_on_metric_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_computable_on_metric_id ON public.computable USING btree (metric_id);


--
-- Name: index_computable_on_runnable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_computable_on_runnable_id ON public.computable USING btree (runnable_id);


--
-- Name: index_engines_on_label; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_engines_on_label ON public.engines USING btree (label);


--
-- Name: index_frameworks_on_label; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_frameworks_on_label ON public.frameworks USING btree (label);


--
-- Name: index_languages_on_label; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_languages_on_label ON public.languages USING btree (label);


--
-- Name: index_metrics_on_label; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_metrics_on_label ON public.metrics USING btree (label);


--
-- Name: index_runnable_on_engine_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_runnable_on_engine_id ON public.runnable USING btree (engine_id);


--
-- Name: index_runnable_on_engine_id_and_writable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_runnable_on_engine_id_and_writable_id ON public.runnable USING btree (engine_id, writable_id);


--
-- Name: index_runnable_on_writable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_runnable_on_writable_id ON public.runnable USING btree (writable_id);


--
-- Name: index_writable_on_framework_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_writable_on_framework_id ON public.writable USING btree (framework_id);


--
-- Name: index_writable_on_framework_id_and_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX index_writable_on_framework_id_and_language_id ON public.writable USING btree (framework_id, language_id);


--
-- Name: index_writable_on_language_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_writable_on_language_id ON public.writable USING btree (language_id);


--
-- PostgreSQL database dump complete
--

