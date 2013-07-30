--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: folders; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA folders;


ALTER SCHEMA folders OWNER TO postgres;

--
-- Name: mediawiki; Type: SCHEMA; Schema: -; Owner: talkbox
--

CREATE SCHEMA mediawiki;


ALTER SCHEMA mediawiki OWNER TO talkbox;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = mediawiki, pg_catalog;

--
-- Name: add_interwiki(text, integer, smallint); Type: FUNCTION; Schema: mediawiki; Owner: talkbox
--

CREATE FUNCTION add_interwiki(text, integer, smallint) RETURNS integer
    LANGUAGE sql
    AS $_$
 INSERT INTO interwiki (iw_prefix, iw_url, iw_local) VALUES ($1,$2,$3);
 SELECT 1;
 $_$;


ALTER FUNCTION mediawiki.add_interwiki(text, integer, smallint) OWNER TO talkbox;

--
-- Name: page_deleted(); Type: FUNCTION; Schema: mediawiki; Owner: talkbox
--

CREATE FUNCTION page_deleted() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 DELETE FROM recentchanges WHERE rc_namespace = OLD.page_namespace AND rc_title = OLD.page_title;
 RETURN NULL;
 END;
 $$;


ALTER FUNCTION mediawiki.page_deleted() OWNER TO talkbox;

--
-- Name: ts2_page_text(); Type: FUNCTION; Schema: mediawiki; Owner: talkbox
--

CREATE FUNCTION ts2_page_text() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 IF TG_OP = 'INSERT' THEN
 NEW.textvector = to_tsvector(NEW.old_text);
 ELSIF NEW.old_text != OLD.old_text THEN
 NEW.textvector := to_tsvector(NEW.old_text);
 END IF;
 RETURN NEW;
 END;
 $$;


ALTER FUNCTION mediawiki.ts2_page_text() OWNER TO talkbox;

--
-- Name: ts2_page_title(); Type: FUNCTION; Schema: mediawiki; Owner: talkbox
--

CREATE FUNCTION ts2_page_title() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 IF TG_OP = 'INSERT' THEN
 NEW.titlevector = to_tsvector(REPLACE(NEW.page_title,'/',' '));
 ELSIF NEW.page_title != OLD.page_title THEN
 NEW.titlevector := to_tsvector(REPLACE(NEW.page_title,'/',' '));
 END IF;
 RETURN NEW;
 END;
 $$;


ALTER FUNCTION mediawiki.ts2_page_title() OWNER TO talkbox;

SET search_path = folders, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: folders; Type: TABLE; Schema: folders; Owner: postgres; Tablespace: 
--

CREATE TABLE folders (
    folderid integer NOT NULL,
    orderno integer,
    parentid integer,
    title text,
    name text,
    url text,
    isopen boolean,
    img text,
    pane text,
    type text
);


ALTER TABLE folders.folders OWNER TO postgres;

--
-- Name: folders_folderid_seq; Type: SEQUENCE; Schema: folders; Owner: postgres
--

CREATE SEQUENCE folders_folderid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE folders.folders_folderid_seq OWNER TO postgres;

--
-- Name: folders_folderid_seq; Type: SEQUENCE OWNED BY; Schema: folders; Owner: postgres
--

ALTER SEQUENCE folders_folderid_seq OWNED BY folders.folderid;


--
-- Name: folders_folderid_seq; Type: SEQUENCE SET; Schema: folders; Owner: postgres
--

SELECT pg_catalog.setval('folders_folderid_seq', 1, true);


SET search_path = mediawiki, pg_catalog;

--
-- Name: archive; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE archive (
    ar_namespace smallint NOT NULL,
    ar_title text NOT NULL,
    ar_text text,
    ar_page_id integer,
    ar_parent_id integer,
    ar_comment text,
    ar_user integer,
    ar_user_text text NOT NULL,
    ar_timestamp timestamp with time zone NOT NULL,
    ar_minor_edit smallint DEFAULT 0 NOT NULL,
    ar_flags text,
    ar_rev_id integer,
    ar_text_id integer,
    ar_deleted smallint DEFAULT 0 NOT NULL,
    ar_len integer
);


ALTER TABLE mediawiki.archive OWNER TO talkbox;

--
-- Name: category_cat_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE category_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.category_cat_id_seq OWNER TO talkbox;

--
-- Name: category_cat_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('category_cat_id_seq', 1, false);


--
-- Name: category; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE category (
    cat_id integer DEFAULT nextval('category_cat_id_seq'::regclass) NOT NULL,
    cat_title text NOT NULL,
    cat_pages integer DEFAULT 0 NOT NULL,
    cat_subcats integer DEFAULT 0 NOT NULL,
    cat_files integer DEFAULT 0 NOT NULL,
    cat_hidden smallint DEFAULT 0 NOT NULL
);


ALTER TABLE mediawiki.category OWNER TO talkbox;

--
-- Name: categorylinks; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE categorylinks (
    cl_from integer NOT NULL,
    cl_to text NOT NULL,
    cl_sortkey text,
    cl_timestamp timestamp with time zone NOT NULL,
    cl_sortkey_prefix text DEFAULT ''::text NOT NULL,
    cl_collation text DEFAULT 0 NOT NULL,
    cl_type text DEFAULT 'page'::text NOT NULL
);


ALTER TABLE mediawiki.categorylinks OWNER TO talkbox;

--
-- Name: change_tag; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE change_tag (
    ct_rc_id integer,
    ct_log_id integer,
    ct_rev_id integer,
    ct_tag text NOT NULL,
    ct_params text
);


ALTER TABLE mediawiki.change_tag OWNER TO talkbox;

--
-- Name: external_user; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE external_user (
    eu_local_id integer NOT NULL,
    eu_external_id text
);


ALTER TABLE mediawiki.external_user OWNER TO talkbox;

--
-- Name: externallinks; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE externallinks (
    el_from integer NOT NULL,
    el_to text NOT NULL,
    el_index text NOT NULL
);


ALTER TABLE mediawiki.externallinks OWNER TO talkbox;

--
-- Name: filearchive_fa_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE filearchive_fa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.filearchive_fa_id_seq OWNER TO talkbox;

--
-- Name: filearchive_fa_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('filearchive_fa_id_seq', 1, false);


--
-- Name: filearchive; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE filearchive (
    fa_id integer DEFAULT nextval('filearchive_fa_id_seq'::regclass) NOT NULL,
    fa_name text NOT NULL,
    fa_archive_name text,
    fa_storage_group text,
    fa_storage_key text,
    fa_deleted_user integer,
    fa_deleted_timestamp timestamp with time zone NOT NULL,
    fa_deleted_reason text,
    fa_size integer NOT NULL,
    fa_width integer NOT NULL,
    fa_height integer NOT NULL,
    fa_metadata bytea DEFAULT '\x'::bytea NOT NULL,
    fa_bits smallint,
    fa_media_type text,
    fa_major_mime text DEFAULT 'unknown'::text,
    fa_minor_mime text DEFAULT 'unknown'::text,
    fa_description text NOT NULL,
    fa_user integer,
    fa_user_text text NOT NULL,
    fa_timestamp timestamp with time zone,
    fa_deleted smallint DEFAULT 0 NOT NULL
);


ALTER TABLE mediawiki.filearchive OWNER TO talkbox;

--
-- Name: hitcounter; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE hitcounter (
    hc_id bigint NOT NULL
);


ALTER TABLE mediawiki.hitcounter OWNER TO talkbox;

--
-- Name: image; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE image (
    img_name text NOT NULL,
    img_size integer NOT NULL,
    img_width integer NOT NULL,
    img_height integer NOT NULL,
    img_metadata bytea DEFAULT '\x'::bytea NOT NULL,
    img_bits smallint,
    img_media_type text,
    img_major_mime text DEFAULT 'unknown'::text,
    img_minor_mime text DEFAULT 'unknown'::text,
    img_description text NOT NULL,
    img_user integer,
    img_user_text text NOT NULL,
    img_timestamp timestamp with time zone,
    img_sha1 text DEFAULT ''::text NOT NULL
);


ALTER TABLE mediawiki.image OWNER TO talkbox;

--
-- Name: imagelinks; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE imagelinks (
    il_from integer NOT NULL,
    il_to text NOT NULL
);


ALTER TABLE mediawiki.imagelinks OWNER TO talkbox;

--
-- Name: interwiki; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE interwiki (
    iw_prefix text NOT NULL,
    iw_url text NOT NULL,
    iw_local smallint NOT NULL,
    iw_trans smallint DEFAULT 0 NOT NULL,
    iw_api text DEFAULT ''::text NOT NULL,
    iw_wikiid text DEFAULT ''::text NOT NULL
);


ALTER TABLE mediawiki.interwiki OWNER TO talkbox;

--
-- Name: ipblocks_ipb_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE ipblocks_ipb_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.ipblocks_ipb_id_seq OWNER TO talkbox;

--
-- Name: ipblocks_ipb_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('ipblocks_ipb_id_seq', 1, false);


--
-- Name: ipblocks; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE ipblocks (
    ipb_id integer DEFAULT nextval('ipblocks_ipb_id_seq'::regclass) NOT NULL,
    ipb_address text,
    ipb_user integer,
    ipb_by integer NOT NULL,
    ipb_by_text text DEFAULT ''::text NOT NULL,
    ipb_reason text NOT NULL,
    ipb_timestamp timestamp with time zone NOT NULL,
    ipb_auto smallint DEFAULT 0 NOT NULL,
    ipb_anon_only smallint DEFAULT 0 NOT NULL,
    ipb_create_account smallint DEFAULT 1 NOT NULL,
    ipb_enable_autoblock smallint DEFAULT 1 NOT NULL,
    ipb_expiry timestamp with time zone NOT NULL,
    ipb_range_start text,
    ipb_range_end text,
    ipb_deleted smallint DEFAULT 0 NOT NULL,
    ipb_block_email smallint DEFAULT 0 NOT NULL,
    ipb_allow_usertalk smallint DEFAULT 0 NOT NULL
);


ALTER TABLE mediawiki.ipblocks OWNER TO talkbox;

--
-- Name: iwlinks; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE iwlinks (
    iwl_from integer DEFAULT 0 NOT NULL,
    iwl_prefix text DEFAULT ''::text NOT NULL,
    iwl_title text DEFAULT ''::text NOT NULL
);


ALTER TABLE mediawiki.iwlinks OWNER TO talkbox;

--
-- Name: job_job_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE job_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.job_job_id_seq OWNER TO talkbox;

--
-- Name: job_job_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('job_job_id_seq', 1, false);


--
-- Name: job; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE job (
    job_id integer DEFAULT nextval('job_job_id_seq'::regclass) NOT NULL,
    job_cmd text NOT NULL,
    job_namespace smallint NOT NULL,
    job_title text NOT NULL,
    job_params text NOT NULL
);


ALTER TABLE mediawiki.job OWNER TO talkbox;

--
-- Name: l10n_cache; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE l10n_cache (
    lc_lang text NOT NULL,
    lc_key text NOT NULL,
    lc_value text NOT NULL
);


ALTER TABLE mediawiki.l10n_cache OWNER TO talkbox;

--
-- Name: langlinks; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE langlinks (
    ll_from integer NOT NULL,
    ll_lang text,
    ll_title text
);


ALTER TABLE mediawiki.langlinks OWNER TO talkbox;

--
-- Name: log_search; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE log_search (
    ls_field text NOT NULL,
    ls_value text NOT NULL,
    ls_log_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE mediawiki.log_search OWNER TO talkbox;

--
-- Name: logging_log_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE logging_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.logging_log_id_seq OWNER TO talkbox;

--
-- Name: logging_log_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('logging_log_id_seq', 1, false);


--
-- Name: logging; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE logging (
    log_id integer DEFAULT nextval('logging_log_id_seq'::regclass) NOT NULL,
    log_type text NOT NULL,
    log_action text NOT NULL,
    log_timestamp timestamp with time zone NOT NULL,
    log_user integer,
    log_namespace smallint NOT NULL,
    log_title text NOT NULL,
    log_comment text,
    log_params text,
    log_deleted smallint DEFAULT 0 NOT NULL,
    log_user_text text DEFAULT ''::text NOT NULL,
    log_page integer
);


ALTER TABLE mediawiki.logging OWNER TO talkbox;

--
-- Name: math; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE math (
    math_inputhash bytea NOT NULL,
    math_outputhash bytea NOT NULL,
    math_html_conservativeness smallint NOT NULL,
    math_html text,
    math_mathml text
);


ALTER TABLE mediawiki.math OWNER TO talkbox;

--
-- Name: module_deps; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE module_deps (
    md_module text NOT NULL,
    md_skin text NOT NULL,
    md_deps text NOT NULL
);


ALTER TABLE mediawiki.module_deps OWNER TO talkbox;

--
-- Name: msg_resource; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE msg_resource (
    mr_resource text NOT NULL,
    mr_lang text NOT NULL,
    mr_blob text NOT NULL,
    mr_timestamp timestamp with time zone NOT NULL
);


ALTER TABLE mediawiki.msg_resource OWNER TO talkbox;

--
-- Name: msg_resource_links; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE msg_resource_links (
    mrl_resource text NOT NULL,
    mrl_message text NOT NULL
);


ALTER TABLE mediawiki.msg_resource_links OWNER TO talkbox;

--
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE user_user_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.user_user_id_seq OWNER TO talkbox;

--
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('user_user_id_seq', 1, true);


--
-- Name: mwuser; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE mwuser (
    user_id integer DEFAULT nextval('user_user_id_seq'::regclass) NOT NULL,
    user_name text NOT NULL,
    user_real_name text,
    user_password text,
    user_newpassword text,
    user_newpass_time timestamp with time zone,
    user_token text,
    user_email text,
    user_email_token text,
    user_email_token_expires timestamp with time zone,
    user_email_authenticated timestamp with time zone,
    user_options text,
    user_touched timestamp with time zone,
    user_registration timestamp with time zone,
    user_editcount integer
);


ALTER TABLE mediawiki.mwuser OWNER TO talkbox;

--
-- Name: objectcache; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE objectcache (
    keyname text,
    value bytea DEFAULT '\x'::bytea NOT NULL,
    exptime timestamp with time zone NOT NULL
);


ALTER TABLE mediawiki.objectcache OWNER TO talkbox;

--
-- Name: oldimage; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE oldimage (
    oi_name text NOT NULL,
    oi_archive_name text NOT NULL,
    oi_size integer NOT NULL,
    oi_width integer NOT NULL,
    oi_height integer NOT NULL,
    oi_bits smallint,
    oi_description text,
    oi_user integer,
    oi_user_text text NOT NULL,
    oi_timestamp timestamp with time zone,
    oi_metadata bytea DEFAULT '\x'::bytea NOT NULL,
    oi_media_type text,
    oi_major_mime text DEFAULT 'unknown'::text,
    oi_minor_mime text DEFAULT 'unknown'::text,
    oi_deleted smallint DEFAULT 0 NOT NULL,
    oi_sha1 text DEFAULT ''::text NOT NULL
);


ALTER TABLE mediawiki.oldimage OWNER TO talkbox;

--
-- Name: page_page_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE page_page_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.page_page_id_seq OWNER TO talkbox;

--
-- Name: page_page_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('page_page_id_seq', 1, true);


--
-- Name: page; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE page (
    page_id integer DEFAULT nextval('page_page_id_seq'::regclass) NOT NULL,
    page_namespace smallint NOT NULL,
    page_title text NOT NULL,
    page_restrictions text,
    page_counter bigint DEFAULT 0 NOT NULL,
    page_is_redirect smallint DEFAULT 0 NOT NULL,
    page_is_new smallint DEFAULT 0 NOT NULL,
    page_random numeric(15,14) DEFAULT random() NOT NULL,
    page_touched timestamp with time zone,
    page_latest integer NOT NULL,
    page_len integer NOT NULL,
    titlevector tsvector
);


ALTER TABLE mediawiki.page OWNER TO talkbox;

--
-- Name: page_props; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE page_props (
    pp_page integer NOT NULL,
    pp_propname text NOT NULL,
    pp_value text NOT NULL
);


ALTER TABLE mediawiki.page_props OWNER TO talkbox;

--
-- Name: page_restrictions_pr_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE page_restrictions_pr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.page_restrictions_pr_id_seq OWNER TO talkbox;

--
-- Name: page_restrictions_pr_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('page_restrictions_pr_id_seq', 1, false);


--
-- Name: page_restrictions; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE page_restrictions (
    pr_id integer DEFAULT nextval('page_restrictions_pr_id_seq'::regclass) NOT NULL,
    pr_page integer NOT NULL,
    pr_type text NOT NULL,
    pr_level text NOT NULL,
    pr_cascade smallint NOT NULL,
    pr_user integer,
    pr_expiry timestamp with time zone
);


ALTER TABLE mediawiki.page_restrictions OWNER TO talkbox;

--
-- Name: text_old_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE text_old_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.text_old_id_seq OWNER TO talkbox;

--
-- Name: text_old_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('text_old_id_seq', 1, true);


--
-- Name: pagecontent; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE pagecontent (
    old_id integer DEFAULT nextval('text_old_id_seq'::regclass) NOT NULL,
    old_text text,
    old_flags text,
    textvector tsvector
);


ALTER TABLE mediawiki.pagecontent OWNER TO talkbox;

--
-- Name: pagelinks; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE pagelinks (
    pl_from integer NOT NULL,
    pl_namespace smallint NOT NULL,
    pl_title text NOT NULL
);


ALTER TABLE mediawiki.pagelinks OWNER TO talkbox;

--
-- Name: profiling; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE profiling (
    pf_count integer DEFAULT 0 NOT NULL,
    pf_time numeric(18,10) DEFAULT 0 NOT NULL,
    pf_memory numeric(18,10) DEFAULT 0 NOT NULL,
    pf_name text NOT NULL,
    pf_server text
);


ALTER TABLE mediawiki.profiling OWNER TO talkbox;

--
-- Name: protected_titles; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE protected_titles (
    pt_namespace smallint NOT NULL,
    pt_title text NOT NULL,
    pt_user integer,
    pt_reason text,
    pt_timestamp timestamp with time zone NOT NULL,
    pt_expiry timestamp with time zone,
    pt_create_perm text DEFAULT ''::text NOT NULL
);


ALTER TABLE mediawiki.protected_titles OWNER TO talkbox;

--
-- Name: querycache; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE querycache (
    qc_type text NOT NULL,
    qc_value integer NOT NULL,
    qc_namespace smallint NOT NULL,
    qc_title text NOT NULL
);


ALTER TABLE mediawiki.querycache OWNER TO talkbox;

--
-- Name: querycache_info; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE querycache_info (
    qci_type text,
    qci_timestamp timestamp with time zone
);


ALTER TABLE mediawiki.querycache_info OWNER TO talkbox;

--
-- Name: querycachetwo; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE querycachetwo (
    qcc_type text NOT NULL,
    qcc_value integer DEFAULT 0 NOT NULL,
    qcc_namespace integer DEFAULT 0 NOT NULL,
    qcc_title text DEFAULT ''::text NOT NULL,
    qcc_namespacetwo integer DEFAULT 0 NOT NULL,
    qcc_titletwo text DEFAULT ''::text NOT NULL
);


ALTER TABLE mediawiki.querycachetwo OWNER TO talkbox;

--
-- Name: recentchanges_rc_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE recentchanges_rc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.recentchanges_rc_id_seq OWNER TO talkbox;

--
-- Name: recentchanges_rc_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('recentchanges_rc_id_seq', 1, true);


--
-- Name: recentchanges; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE recentchanges (
    rc_id integer DEFAULT nextval('recentchanges_rc_id_seq'::regclass) NOT NULL,
    rc_timestamp timestamp with time zone NOT NULL,
    rc_cur_time timestamp with time zone NOT NULL,
    rc_user integer,
    rc_user_text text NOT NULL,
    rc_namespace smallint NOT NULL,
    rc_title text NOT NULL,
    rc_comment text,
    rc_minor smallint DEFAULT 0 NOT NULL,
    rc_bot smallint DEFAULT 0 NOT NULL,
    rc_new smallint DEFAULT 0 NOT NULL,
    rc_cur_id integer,
    rc_this_oldid integer NOT NULL,
    rc_last_oldid integer NOT NULL,
    rc_type smallint DEFAULT 0 NOT NULL,
    rc_moved_to_ns smallint,
    rc_moved_to_title text,
    rc_patrolled smallint DEFAULT 0 NOT NULL,
    rc_ip cidr,
    rc_old_len integer,
    rc_new_len integer,
    rc_deleted smallint DEFAULT 0 NOT NULL,
    rc_logid integer DEFAULT 0 NOT NULL,
    rc_log_type text,
    rc_log_action text,
    rc_params text
);


ALTER TABLE mediawiki.recentchanges OWNER TO talkbox;

--
-- Name: redirect; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE redirect (
    rd_from integer NOT NULL,
    rd_namespace smallint NOT NULL,
    rd_title text NOT NULL,
    rd_interwiki text,
    rd_fragment text
);


ALTER TABLE mediawiki.redirect OWNER TO talkbox;

--
-- Name: revision_rev_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE revision_rev_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.revision_rev_id_seq OWNER TO talkbox;

--
-- Name: revision_rev_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('revision_rev_id_seq', 1, true);


--
-- Name: revision; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE revision (
    rev_id integer DEFAULT nextval('revision_rev_id_seq'::regclass) NOT NULL,
    rev_page integer,
    rev_text_id integer,
    rev_comment text,
    rev_user integer NOT NULL,
    rev_user_text text NOT NULL,
    rev_timestamp timestamp with time zone NOT NULL,
    rev_minor_edit smallint DEFAULT 0 NOT NULL,
    rev_deleted smallint DEFAULT 0 NOT NULL,
    rev_len integer,
    rev_parent_id integer
);


ALTER TABLE mediawiki.revision OWNER TO talkbox;

--
-- Name: site_stats; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE site_stats (
    ss_row_id integer NOT NULL,
    ss_total_views integer DEFAULT 0,
    ss_total_edits integer DEFAULT 0,
    ss_good_articles integer DEFAULT 0,
    ss_total_pages integer DEFAULT (-1),
    ss_users integer DEFAULT (-1),
    ss_active_users integer DEFAULT (-1),
    ss_admins integer DEFAULT (-1),
    ss_images integer DEFAULT 0
);


ALTER TABLE mediawiki.site_stats OWNER TO talkbox;

--
-- Name: tag_summary; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE tag_summary (
    ts_rc_id integer,
    ts_log_id integer,
    ts_rev_id integer,
    ts_tags text NOT NULL
);


ALTER TABLE mediawiki.tag_summary OWNER TO talkbox;

--
-- Name: templatelinks; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE templatelinks (
    tl_from integer NOT NULL,
    tl_namespace smallint NOT NULL,
    tl_title text NOT NULL
);


ALTER TABLE mediawiki.templatelinks OWNER TO talkbox;

--
-- Name: trackbacks_tb_id_seq; Type: SEQUENCE; Schema: mediawiki; Owner: talkbox
--

CREATE SEQUENCE trackbacks_tb_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mediawiki.trackbacks_tb_id_seq OWNER TO talkbox;

--
-- Name: trackbacks_tb_id_seq; Type: SEQUENCE SET; Schema: mediawiki; Owner: talkbox
--

SELECT pg_catalog.setval('trackbacks_tb_id_seq', 1, false);


--
-- Name: trackbacks; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE trackbacks (
    tb_id integer DEFAULT nextval('trackbacks_tb_id_seq'::regclass) NOT NULL,
    tb_page integer,
    tb_title text NOT NULL,
    tb_url text NOT NULL,
    tb_ex text,
    tb_name text
);


ALTER TABLE mediawiki.trackbacks OWNER TO talkbox;

--
-- Name: transcache; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE transcache (
    tc_url text NOT NULL,
    tc_contents text NOT NULL,
    tc_time timestamp with time zone NOT NULL
);


ALTER TABLE mediawiki.transcache OWNER TO talkbox;

--
-- Name: updatelog; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE updatelog (
    ul_key text NOT NULL,
    ul_value text
);


ALTER TABLE mediawiki.updatelog OWNER TO talkbox;

--
-- Name: user_groups; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE user_groups (
    ug_user integer,
    ug_group text NOT NULL
);


ALTER TABLE mediawiki.user_groups OWNER TO talkbox;

--
-- Name: user_newtalk; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE user_newtalk (
    user_id integer NOT NULL,
    user_ip text,
    user_last_timestamp timestamp with time zone
);


ALTER TABLE mediawiki.user_newtalk OWNER TO talkbox;

--
-- Name: user_properties; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE user_properties (
    up_user integer,
    up_property text NOT NULL,
    up_value text
);


ALTER TABLE mediawiki.user_properties OWNER TO talkbox;

--
-- Name: valid_tag; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE valid_tag (
    vt_tag text NOT NULL
);


ALTER TABLE mediawiki.valid_tag OWNER TO talkbox;

--
-- Name: watchlist; Type: TABLE; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE TABLE watchlist (
    wl_user integer NOT NULL,
    wl_namespace smallint DEFAULT 0 NOT NULL,
    wl_title text NOT NULL,
    wl_notificationtimestamp timestamp with time zone
);


ALTER TABLE mediawiki.watchlist OWNER TO talkbox;

SET search_path = public, pg_catalog;

SET default_with_oids = true;

--
-- Name: boards; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE boards (
    id integer NOT NULL,
    name text NOT NULL,
    fid integer NOT NULL,
    created date,
    modified date
);


ALTER TABLE public.boards OWNER TO postgres;

--
-- Name: boards_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE boards_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boards_fid_seq OWNER TO postgres;

--
-- Name: boards_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE boards_fid_seq OWNED BY boards.fid;


--
-- Name: boards_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('boards_fid_seq', 1, false);


--
-- Name: boards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE boards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boards_id_seq OWNER TO postgres;

--
-- Name: boards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE boards_id_seq OWNED BY boards.id;


--
-- Name: boards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('boards_id_seq', 20, true);


--
-- Name: boards_name_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE boards_name_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boards_name_seq OWNER TO postgres;

--
-- Name: boards_name_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE boards_name_seq OWNED BY boards.name;


--
-- Name: boards_name_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('boards_name_seq', 1, false);


SET default_with_oids = false;

--
-- Name: config; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE config (
    id integer NOT NULL,
    key text,
    value text
);


ALTER TABLE public.config OWNER TO postgres;

--
-- Name: config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.config_id_seq OWNER TO postgres;

--
-- Name: config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE config_id_seq OWNED BY config.id;


--
-- Name: config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('config_id_seq', 7, true);


--
-- Name: folders; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE folders (
    folderid integer NOT NULL,
    orderno integer,
    parentid integer,
    title text,
    name text,
    url text,
    img text,
    pane text,
    type text,
    isopen text
);


ALTER TABLE public.folders OWNER TO postgres;

--
-- Name: folders_folderid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE folders_folderid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.folders_folderid_seq OWNER TO postgres;

--
-- Name: folders_folderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE folders_folderid_seq OWNED BY folders.folderid;


--
-- Name: folders_folderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('folders_folderid_seq', 17, true);


--
-- Name: history; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE history (
    id integer NOT NULL,
    phase text,
    "time" timestamp without time zone,
    type text
);


ALTER TABLE public.history OWNER TO postgres;

--
-- Name: history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.history_id_seq OWNER TO postgres;

--
-- Name: history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE history_id_seq OWNED BY history.id;


--
-- Name: history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('history_id_seq', 1336, true);


--
-- Name: phases; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE phases (
    phases character varying(255),
    pic character varying(255),
    id integer NOT NULL,
    size integer,
    modified timestamp with time zone,
    created timestamp with time zone,
    filename text,
    paraphase character varying(255),
    boards_id integer
);


ALTER TABLE public.phases OWNER TO postgres;

--
-- Name: phases_board_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE phases_board_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phases_board_seq OWNER TO postgres;

--
-- Name: phases_board_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE phases_board_seq OWNED BY phases.boards_id;


--
-- Name: phases_board_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('phases_board_seq', 6, true);


--
-- Name: phases_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE phases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phases_id_seq OWNER TO postgres;

--
-- Name: phases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE phases_id_seq OWNED BY phases.id;


--
-- Name: phases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('phases_id_seq', 83, true);


SET default_with_oids = true;

--
-- Name: storyboard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE storyboard (
    id integer NOT NULL,
    orderno integer NOT NULL,
    phase text,
    "time" timestamp without time zone,
    series integer,
    status text
);


ALTER TABLE public.storyboard OWNER TO postgres;

--
-- Name: storyboard_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE storyboard_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.storyboard_id_seq OWNER TO postgres;

--
-- Name: storyboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE storyboard_id_seq OWNED BY storyboard.id;


--
-- Name: storyboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('storyboard_id_seq', 247, true);


SET search_path = folders, pg_catalog;

--
-- Name: folderid; Type: DEFAULT; Schema: folders; Owner: postgres
--

ALTER TABLE ONLY folders ALTER COLUMN folderid SET DEFAULT nextval('folders_folderid_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY boards ALTER COLUMN id SET DEFAULT nextval('boards_id_seq'::regclass);


--
-- Name: name; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY boards ALTER COLUMN name SET DEFAULT nextval('boards_name_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY boards ALTER COLUMN fid SET DEFAULT nextval('boards_fid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY config ALTER COLUMN id SET DEFAULT nextval('config_id_seq'::regclass);


--
-- Name: folderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY folders ALTER COLUMN folderid SET DEFAULT nextval('folders_folderid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY history ALTER COLUMN id SET DEFAULT nextval('history_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY phases ALTER COLUMN id SET DEFAULT nextval('phases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY storyboard ALTER COLUMN id SET DEFAULT nextval('storyboard_id_seq'::regclass);


SET search_path = folders, pg_catalog;

--
-- Data for Name: folders; Type: TABLE DATA; Schema: folders; Owner: postgres
--

COPY folders (folderid, orderno, parentid, title, name, url, isopen, img, pane, type) FROM stdin;
1	0	0	test	test	/test.html	\N		north	norm
\.


SET search_path = mediawiki, pg_catalog;

--
-- Data for Name: archive; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY archive (ar_namespace, ar_title, ar_text, ar_page_id, ar_parent_id, ar_comment, ar_user, ar_user_text, ar_timestamp, ar_minor_edit, ar_flags, ar_rev_id, ar_text_id, ar_deleted, ar_len) FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY category (cat_id, cat_title, cat_pages, cat_subcats, cat_files, cat_hidden) FROM stdin;
\.


--
-- Data for Name: categorylinks; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY categorylinks (cl_from, cl_to, cl_sortkey, cl_timestamp, cl_sortkey_prefix, cl_collation, cl_type) FROM stdin;
\.


--
-- Data for Name: change_tag; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY change_tag (ct_rc_id, ct_log_id, ct_rev_id, ct_tag, ct_params) FROM stdin;
\.


--
-- Data for Name: external_user; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY external_user (eu_local_id, eu_external_id) FROM stdin;
\.


--
-- Data for Name: externallinks; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY externallinks (el_from, el_to, el_index) FROM stdin;
1	http://meta.wikimedia.org/wiki/Help:Contents	http://org.wikimedia.meta./wiki/Help:Contents
1	http://www.mediawiki.org/wiki/Manual:Configuration_settings	http://org.mediawiki.www./wiki/Manual:Configuration_settings
1	http://www.mediawiki.org/wiki/Manual:FAQ	http://org.mediawiki.www./wiki/Manual:FAQ
1	https://lists.wikimedia.org/mailman/listinfo/mediawiki-announce	https://org.wikimedia.lists./mailman/listinfo/mediawiki-announce
\.


--
-- Data for Name: filearchive; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY filearchive (fa_id, fa_name, fa_archive_name, fa_storage_group, fa_storage_key, fa_deleted_user, fa_deleted_timestamp, fa_deleted_reason, fa_size, fa_width, fa_height, fa_metadata, fa_bits, fa_media_type, fa_major_mime, fa_minor_mime, fa_description, fa_user, fa_user_text, fa_timestamp, fa_deleted) FROM stdin;
\.


--
-- Data for Name: hitcounter; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY hitcounter (hc_id) FROM stdin;
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY image (img_name, img_size, img_width, img_height, img_metadata, img_bits, img_media_type, img_major_mime, img_minor_mime, img_description, img_user, img_user_text, img_timestamp, img_sha1) FROM stdin;
\.


--
-- Data for Name: imagelinks; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY imagelinks (il_from, il_to) FROM stdin;
\.


--
-- Data for Name: interwiki; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY interwiki (iw_prefix, iw_url, iw_local, iw_trans, iw_api, iw_wikiid) FROM stdin;
acronym	http://www.acronymfinder.com/af-query.asp?String=exact&Acronym=$1	0	0		
advogato	http://www.advogato.org/$1	0	0		
annotationwiki	http://www.seedwiki.com/page.cfm?wikiid=368&doc=$1	0	0		
arxiv	http://www.arxiv.org/abs/$1	0	0		
c2find	http://c2.com/cgi/wiki?FindPage&value=$1	0	0		
cache	http://www.google.com/search?q=cache:$1	0	0		
commons	http://commons.wikimedia.org/wiki/$1	0	0		
corpknowpedia	http://corpknowpedia.org/wiki/index.php/$1	0	0		
dictionary	http://www.dict.org/bin/Dict?Database=*&Form=Dict1&Strategy=*&Query=$1	0	0		
disinfopedia	http://www.disinfopedia.org/wiki.phtml?title=$1	0	0		
docbook	http://wiki.docbook.org/topic/$1	0	0		
doi	http://dx.doi.org/$1	0	0		
drumcorpswiki	http://www.drumcorpswiki.com/index.php/$1	0	0		
dwjwiki	http://www.suberic.net/cgi-bin/dwj/wiki.cgi?$1	0	0		
emacswiki	http://www.emacswiki.org/cgi-bin/wiki.pl?$1	0	0		
elibre	http://enciclopedia.us.es/index.php/$1	0	0		
foldoc	http://foldoc.org/?$1	0	0		
foxwiki	http://fox.wikis.com/wc.dll?Wiki~$1	0	0		
freebsdman	http://www.FreeBSD.org/cgi/man.cgi?apropos=1&query=$1	0	0		
gej	http://www.esperanto.de/cgi-bin/aktivikio/wiki.pl?$1	0	0		
gentoo-wiki	http://gentoo-wiki.com/$1	0	0		
google	http://www.google.com/search?q=$1	0	0		
googlegroups	http://groups.google.com/groups?q=$1	0	0		
hammondwiki	http://www.dairiki.org/HammondWiki/$1	0	0		
hewikisource	http://he.wikisource.org/wiki/$1	1	0		
hrwiki	http://www.hrwiki.org/index.php/$1	0	0		
imdb	http://us.imdb.com/Title?$1	0	0		
jargonfile	http://sunir.org/apps/meta.pl?wiki=JargonFile&redirect=$1	0	0		
jspwiki	http://www.jspwiki.org/wiki/$1	0	0		
keiki	http://kei.ki/en/$1	0	0		
kmwiki	http://kmwiki.wikispaces.com/$1	0	0		
linuxwiki	http://linuxwiki.de/$1	0	0		
lojban	http://www.lojban.org/tiki/tiki-index.php?page=$1	0	0		
lqwiki	http://wiki.linuxquestions.org/wiki/$1	0	0		
lugkr	http://lug-kr.sourceforge.net/cgi-bin/lugwiki.pl?$1	0	0		
mathsongswiki	http://SeedWiki.com/page.cfm?wikiid=237&doc=$1	0	0		
meatball	http://www.usemod.com/cgi-bin/mb.pl?$1	0	0		
mediazilla	https://bugzilla.wikimedia.org/$1	1	0		
mediawikiwiki	http://www.mediawiki.org/wiki/$1	0	0		
memoryalpha	http://www.memory-alpha.org/en/index.php/$1	0	0		
metawiki	http://sunir.org/apps/meta.pl?$1	0	0		
metawikipedia	http://meta.wikimedia.org/wiki/$1	0	0		
moinmoin	http://purl.net/wiki/moin/$1	0	0		
mozillawiki	http://wiki.mozilla.org/index.php/$1	0	0		
mw	http://www.mediawiki.org/wiki/$1	0	0		
oeis	http://www.research.att.com/cgi-bin/access.cgi/as/njas/sequences/eisA.cgi?Anum=$1	0	0		
openfacts	http://openfacts.berlios.de/index.phtml?title=$1	0	0		
openwiki	http://openwiki.com/?$1	0	0		
pmeg	http://www.bertilow.com/pmeg/$1.php	0	0		
ppr	http://c2.com/cgi/wiki?$1	0	0		
pythoninfo	http://wiki.python.org/moin/$1	0	0		
rfc	http://www.rfc-editor.org/rfc/rfc$1.txt	0	0		
s23wiki	http://is-root.de/wiki/index.php/$1	0	0		
seattlewiki	http://seattle.wikia.com/wiki/$1	0	0		
seattlewireless	http://seattlewireless.net/?$1	0	0		
senseislibrary	http://senseis.xmp.net/?$1	0	0		
sourceforge	http://sourceforge.net/$1	0	0		
squeak	http://wiki.squeak.org/squeak/$1	0	0		
susning	http://www.susning.nu/$1	0	0		
svgwiki	http://wiki.svg.org/$1	0	0		
tavi	http://tavi.sourceforge.net/$1	0	0		
tejo	http://www.tejo.org/vikio/$1	0	0		
tmbw	http://www.tmbw.net/wiki/$1	0	0		
tmnet	http://www.technomanifestos.net/?$1	0	0		
tmwiki	http://www.EasyTopicMaps.com/?page=$1	0	0		
theopedia	http://www.theopedia.com/$1	0	0		
twiki	http://twiki.org/cgi-bin/view/$1	0	0		
uea	http://www.tejo.org/uea/$1	0	0		
unreal	http://wiki.beyondunreal.com/wiki/$1	0	0		
usemod	http://www.usemod.com/cgi-bin/wiki.pl?$1	0	0	:	
vinismo	http://vinismo.com/en/$1	0	0		
webseitzwiki	http://webseitz.fluxent.com/wiki/$1	0	0		
why	http://clublet.com/c/c/why?$1	0	0		
wiki	http://c2.com/cgi/wiki?$1	0	0		
wikia	http://www.wikia.com/wiki/$1	0	0		
wikibooks	http://en.wikibooks.org/wiki/$1	1	0		
wikicities	http://www.wikia.com/wiki/$1	0	0		
wikif1	http://www.wikif1.org/$1	0	0		
wikihow	http://www.wikihow.com/$1	0	0		
wikinfo	http://www.wikinfo.org/index.php/$1	0	0		
wikimedia	http://wikimediafoundation.org/wiki/$1	0	0		
wikinews	http://en.wikinews.org/wiki/$1	1	0		
wikiquote	http://en.wikiquote.org/wiki/$1	1	0		
wikipedia	http://en.wikipedia.org/wiki/$1	1	0		
wikisource	http://wikisource.org/wiki/$1	1	0		
wikispecies	http://species.wikimedia.org/wiki/$1	1	0		
wikitravel	http://wikitravel.org/en/$1	0	0		
wikiversity	http://en.wikiversity.org/wiki/$1	1	0		
wikt	http://en.wiktionary.org/wiki/$1	1	0		
wiktionary	http://en.wiktionary.org/wiki/$1	1	0		
wlug	http://www.wlug.org.nz/$1	0	0		
zwiki	http://zwiki.org/$1	0	0		
zzz wiki	http://wiki.zzz.ee/index.php/$1	0	0		
\.


--
-- Data for Name: ipblocks; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY ipblocks (ipb_id, ipb_address, ipb_user, ipb_by, ipb_by_text, ipb_reason, ipb_timestamp, ipb_auto, ipb_anon_only, ipb_create_account, ipb_enable_autoblock, ipb_expiry, ipb_range_start, ipb_range_end, ipb_deleted, ipb_block_email, ipb_allow_usertalk) FROM stdin;
\.


--
-- Data for Name: iwlinks; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY iwlinks (iwl_from, iwl_prefix, iwl_title) FROM stdin;
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY job (job_id, job_cmd, job_namespace, job_title, job_params) FROM stdin;
\.


--
-- Data for Name: l10n_cache; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY l10n_cache (lc_lang, lc_key, lc_value) FROM stdin;
en	fallback	b:0;
en	namespaceNames	a:17:{i:-2;s:5:"Media";i:-1;s:7:"Special";i:0;s:0:"";i:1;s:4:"Talk";i:2;s:4:"User";i:3;s:9:"User_talk";i:5;s:7:"$1_talk";i:6;s:4:"File";i:7;s:9:"File_talk";i:8;s:9:"MediaWiki";i:9;s:14:"MediaWiki_talk";i:10;s:8:"Template";i:11;s:13:"Template_talk";i:12;s:4:"Help";i:13;s:9:"Help_talk";i:14;s:8:"Category";i:15;s:13:"Category_talk";}
en	mathNames	a:6:{i:0;s:11:"mw_math_png";i:1;s:14:"mw_math_simple";i:2;s:12:"mw_math_html";i:3;s:14:"mw_math_source";i:4;s:14:"mw_math_modern";i:5;s:14:"mw_math_mathml";}
en	bookstoreList	a:4:{s:6:"AddALL";s:56:"http://www.addall.com/New/Partner.cgi?query=$1&type=ISBN";s:9:"PriceSCAN";s:53:"http://www.pricescan.com/books/bookDetail.asp?isbn=$1";s:14:"Barnes & Noble";s:67:"http://search.barnesandnoble.com/bookSearch/isbnInquiry.asp?isbn=$1";s:10:"Amazon.com";s:41:"http://www.amazon.com/exec/obidos/ISBN=$1";}
en	magicWords	a:148:{s:8:"redirect";a:2:{i:0;i:0;i:1;s:9:"#REDIRECT";}s:5:"notoc";a:2:{i:0;i:0;i:1;s:9:"__NOTOC__";}s:9:"nogallery";a:2:{i:0;i:0;i:1;s:13:"__NOGALLERY__";}s:8:"forcetoc";a:2:{i:0;i:0;i:1;s:12:"__FORCETOC__";}s:3:"toc";a:2:{i:0;i:0;i:1;s:7:"__TOC__";}s:13:"noeditsection";a:2:{i:0;i:0;i:1;s:17:"__NOEDITSECTION__";}s:8:"noheader";a:2:{i:0;i:0;i:1;s:12:"__NOHEADER__";}s:12:"currentmonth";a:3:{i:0;i:1;i:1;s:12:"CURRENTMONTH";i:2;s:13:"CURRENTMONTH2";}s:13:"currentmonth1";a:2:{i:0;i:1;i:1;s:13:"CURRENTMONTH1";}s:16:"currentmonthname";a:2:{i:0;i:1;i:1;s:16:"CURRENTMONTHNAME";}s:19:"currentmonthnamegen";a:2:{i:0;i:1;i:1;s:19:"CURRENTMONTHNAMEGEN";}s:18:"currentmonthabbrev";a:2:{i:0;i:1;i:1;s:18:"CURRENTMONTHABBREV";}s:10:"currentday";a:2:{i:0;i:1;i:1;s:10:"CURRENTDAY";}s:11:"currentday2";a:2:{i:0;i:1;i:1;s:11:"CURRENTDAY2";}s:14:"currentdayname";a:2:{i:0;i:1;i:1;s:14:"CURRENTDAYNAME";}s:11:"currentyear";a:2:{i:0;i:1;i:1;s:11:"CURRENTYEAR";}s:11:"currenttime";a:2:{i:0;i:1;i:1;s:11:"CURRENTTIME";}s:11:"currenthour";a:2:{i:0;i:1;i:1;s:11:"CURRENTHOUR";}s:10:"localmonth";a:3:{i:0;i:1;i:1;s:10:"LOCALMONTH";i:2;s:11:"LOCALMONTH2";}s:11:"localmonth1";a:2:{i:0;i:1;i:1;s:11:"LOCALMONTH1";}s:14:"localmonthname";a:2:{i:0;i:1;i:1;s:14:"LOCALMONTHNAME";}s:17:"localmonthnamegen";a:2:{i:0;i:1;i:1;s:17:"LOCALMONTHNAMEGEN";}s:16:"localmonthabbrev";a:2:{i:0;i:1;i:1;s:16:"LOCALMONTHABBREV";}s:8:"localday";a:2:{i:0;i:1;i:1;s:8:"LOCALDAY";}s:9:"localday2";a:2:{i:0;i:1;i:1;s:9:"LOCALDAY2";}s:12:"localdayname";a:2:{i:0;i:1;i:1;s:12:"LOCALDAYNAME";}s:9:"localyear";a:2:{i:0;i:1;i:1;s:9:"LOCALYEAR";}s:9:"localtime";a:2:{i:0;i:1;i:1;s:9:"LOCALTIME";}s:9:"localhour";a:2:{i:0;i:1;i:1;s:9:"LOCALHOUR";}s:13:"numberofpages";a:2:{i:0;i:1;i:1;s:13:"NUMBEROFPAGES";}s:16:"numberofarticles";a:2:{i:0;i:1;i:1;s:16:"NUMBEROFARTICLES";}s:13:"numberoffiles";a:2:{i:0;i:1;i:1;s:13:"NUMBEROFFILES";}s:13:"numberofusers";a:2:{i:0;i:1;i:1;s:13:"NUMBEROFUSERS";}s:19:"numberofactiveusers";a:2:{i:0;i:1;i:1;s:19:"NUMBEROFACTIVEUSERS";}s:13:"numberofedits";a:2:{i:0;i:1;i:1;s:13:"NUMBEROFEDITS";}s:13:"numberofviews";a:2:{i:0;i:1;i:1;s:13:"NUMBEROFVIEWS";}s:8:"pagename";a:2:{i:0;i:1;i:1;s:8:"PAGENAME";}s:9:"pagenamee";a:2:{i:0;i:1;i:1;s:9:"PAGENAMEE";}s:9:"namespace";a:2:{i:0;i:1;i:1;s:9:"NAMESPACE";}s:10:"namespacee";a:2:{i:0;i:1;i:1;s:10:"NAMESPACEE";}s:9:"talkspace";a:2:{i:0;i:1;i:1;s:9:"TALKSPACE";}s:10:"talkspacee";a:2:{i:0;i:1;i:1;s:10:"TALKSPACEE";}s:12:"subjectspace";a:3:{i:0;i:1;i:1;s:12:"SUBJECTSPACE";i:2;s:12:"ARTICLESPACE";}s:13:"subjectspacee";a:3:{i:0;i:1;i:1;s:13:"SUBJECTSPACEE";i:2;s:13:"ARTICLESPACEE";}s:12:"fullpagename";a:2:{i:0;i:1;i:1;s:12:"FULLPAGENAME";}s:13:"fullpagenamee";a:2:{i:0;i:1;i:1;s:13:"FULLPAGENAMEE";}s:11:"subpagename";a:2:{i:0;i:1;i:1;s:11:"SUBPAGENAME";}s:12:"subpagenamee";a:2:{i:0;i:1;i:1;s:12:"SUBPAGENAMEE";}s:12:"basepagename";a:2:{i:0;i:1;i:1;s:12:"BASEPAGENAME";}s:13:"basepagenamee";a:2:{i:0;i:1;i:1;s:13:"BASEPAGENAMEE";}s:12:"talkpagename";a:2:{i:0;i:1;i:1;s:12:"TALKPAGENAME";}s:13:"talkpagenamee";a:2:{i:0;i:1;i:1;s:13:"TALKPAGENAMEE";}s:15:"subjectpagename";a:3:{i:0;i:1;i:1;s:15:"SUBJECTPAGENAME";i:2;s:15:"ARTICLEPAGENAME";}s:16:"subjectpagenamee";a:3:{i:0;i:1;i:1;s:16:"SUBJECTPAGENAMEE";i:2;s:16:"ARTICLEPAGENAMEE";}s:3:"msg";a:2:{i:0;i:0;i:1;s:4:"MSG:";}s:5:"subst";a:2:{i:0;i:0;i:1;s:6:"SUBST:";}s:9:"safesubst";a:2:{i:0;i:0;i:1;s:10:"SAFESUBST:";}s:5:"msgnw";a:2:{i:0;i:0;i:1;s:6:"MSGNW:";}s:13:"img_thumbnail";a:3:{i:0;i:1;i:1;s:9:"thumbnail";i:2;s:5:"thumb";}s:15:"img_manualthumb";a:3:{i:0;i:1;i:1;s:12:"thumbnail=$1";i:2;s:8:"thumb=$1";}s:9:"img_right";a:2:{i:0;i:1;i:1;s:5:"right";}s:8:"img_left";a:2:{i:0;i:1;i:1;s:4:"left";}s:8:"img_none";a:2:{i:0;i:1;i:1;s:4:"none";}s:9:"img_width";a:2:{i:0;i:1;i:1;s:4:"$1px";}s:10:"img_center";a:3:{i:0;i:1;i:1;s:6:"center";i:2;s:6:"centre";}s:10:"img_framed";a:4:{i:0;i:1;i:1;s:6:"framed";i:2;s:8:"enframed";i:3;s:5:"frame";}s:13:"img_frameless";a:2:{i:0;i:1;i:1;s:9:"frameless";}s:8:"img_page";a:3:{i:0;i:1;i:1;s:7:"page=$1";i:2;s:7:"page $1";}s:11:"img_upright";a:4:{i:0;i:1;i:1;s:7:"upright";i:2;s:10:"upright=$1";i:3;s:10:"upright $1";}s:10:"img_border";a:2:{i:0;i:1;i:1;s:6:"border";}s:12:"img_baseline";a:2:{i:0;i:1;i:1;s:8:"baseline";}s:7:"img_sub";a:2:{i:0;i:1;i:1;s:3:"sub";}s:9:"img_super";a:3:{i:0;i:1;i:1;s:5:"super";i:2;s:3:"sup";}s:7:"img_top";a:2:{i:0;i:1;i:1;s:3:"top";}s:12:"img_text_top";a:2:{i:0;i:1;i:1;s:8:"text-top";}s:10:"img_middle";a:2:{i:0;i:1;i:1;s:6:"middle";}s:10:"img_bottom";a:2:{i:0;i:1;i:1;s:6:"bottom";}s:15:"img_text_bottom";a:2:{i:0;i:1;i:1;s:11:"text-bottom";}s:8:"img_link";a:2:{i:0;i:1;i:1;s:7:"link=$1";}s:7:"img_alt";a:2:{i:0;i:1;i:1;s:6:"alt=$1";}s:3:"int";a:2:{i:0;i:0;i:1;s:4:"INT:";}s:8:"sitename";a:2:{i:0;i:1;i:1;s:8:"SITENAME";}s:2:"ns";a:2:{i:0;i:0;i:1;s:3:"NS:";}s:3:"nse";a:2:{i:0;i:0;i:1;s:4:"NSE:";}s:8:"localurl";a:2:{i:0;i:0;i:1;s:9:"LOCALURL:";}s:9:"localurle";a:2:{i:0;i:0;i:1;s:10:"LOCALURLE:";}s:11:"articlepath";a:2:{i:0;i:0;i:1;s:11:"ARTICLEPATH";}s:6:"server";a:2:{i:0;i:0;i:1;s:6:"SERVER";}s:10:"servername";a:2:{i:0;i:0;i:1;s:10:"SERVERNAME";}s:10:"scriptpath";a:2:{i:0;i:0;i:1;s:10:"SCRIPTPATH";}s:9:"stylepath";a:2:{i:0;i:0;i:1;s:9:"STYLEPATH";}s:7:"grammar";a:2:{i:0;i:0;i:1;s:8:"GRAMMAR:";}s:6:"gender";a:2:{i:0;i:0;i:1;s:7:"GENDER:";}s:14:"notitleconvert";a:3:{i:0;i:0;i:1;s:18:"__NOTITLECONVERT__";i:2;s:8:"__NOTC__";}s:16:"nocontentconvert";a:3:{i:0;i:0;i:1;s:20:"__NOCONTENTCONVERT__";i:2;s:8:"__NOCC__";}s:11:"currentweek";a:2:{i:0;i:1;i:1;s:11:"CURRENTWEEK";}s:10:"currentdow";a:2:{i:0;i:1;i:1;s:10:"CURRENTDOW";}s:9:"localweek";a:2:{i:0;i:1;i:1;s:9:"LOCALWEEK";}s:8:"localdow";a:2:{i:0;i:1;i:1;s:8:"LOCALDOW";}s:10:"revisionid";a:2:{i:0;i:1;i:1;s:10:"REVISIONID";}s:11:"revisionday";a:2:{i:0;i:1;i:1;s:11:"REVISIONDAY";}s:12:"revisionday2";a:2:{i:0;i:1;i:1;s:12:"REVISIONDAY2";}s:13:"revisionmonth";a:2:{i:0;i:1;i:1;s:13:"REVISIONMONTH";}s:14:"revisionmonth1";a:2:{i:0;i:1;i:1;s:14:"REVISIONMONTH1";}s:12:"revisionyear";a:2:{i:0;i:1;i:1;s:12:"REVISIONYEAR";}s:17:"revisiontimestamp";a:2:{i:0;i:1;i:1;s:17:"REVISIONTIMESTAMP";}s:12:"revisionuser";a:2:{i:0;i:1;i:1;s:12:"REVISIONUSER";}s:6:"plural";a:2:{i:0;i:0;i:1;s:7:"PLURAL:";}s:7:"fullurl";a:2:{i:0;i:0;i:1;s:8:"FULLURL:";}s:8:"fullurle";a:2:{i:0;i:0;i:1;s:9:"FULLURLE:";}s:7:"lcfirst";a:2:{i:0;i:0;i:1;s:8:"LCFIRST:";}s:7:"ucfirst";a:2:{i:0;i:0;i:1;s:8:"UCFIRST:";}s:2:"lc";a:2:{i:0;i:0;i:1;s:3:"LC:";}s:2:"uc";a:2:{i:0;i:0;i:1;s:3:"UC:";}s:3:"raw";a:2:{i:0;i:0;i:1;s:4:"RAW:";}s:12:"displaytitle";a:2:{i:0;i:1;i:1;s:12:"DISPLAYTITLE";}s:9:"rawsuffix";a:2:{i:0;i:1;i:1;s:1:"R";}s:14:"newsectionlink";a:2:{i:0;i:1;i:1;s:18:"__NEWSECTIONLINK__";}s:16:"nonewsectionlink";a:2:{i:0;i:1;i:1;s:20:"__NONEWSECTIONLINK__";}s:14:"currentversion";a:2:{i:0;i:1;i:1;s:14:"CURRENTVERSION";}s:9:"urlencode";a:2:{i:0;i:0;i:1;s:10:"URLENCODE:";}s:12:"anchorencode";a:2:{i:0;i:0;i:1;s:12:"ANCHORENCODE";}s:16:"currenttimestamp";a:2:{i:0;i:1;i:1;s:16:"CURRENTTIMESTAMP";}s:14:"localtimestamp";a:2:{i:0;i:1;i:1;s:14:"LOCALTIMESTAMP";}s:13:"directionmark";a:3:{i:0;i:1;i:1;s:13:"DIRECTIONMARK";i:2;s:7:"DIRMARK";}s:8:"language";a:2:{i:0;i:0;i:1;s:10:"#LANGUAGE:";}s:15:"contentlanguage";a:3:{i:0;i:1;i:1;s:15:"CONTENTLANGUAGE";i:2;s:11:"CONTENTLANG";}s:16:"pagesinnamespace";a:3:{i:0;i:1;i:1;s:17:"PAGESINNAMESPACE:";i:2;s:10:"PAGESINNS:";}s:14:"numberofadmins";a:2:{i:0;i:1;i:1;s:14:"NUMBEROFADMINS";}s:9:"formatnum";a:2:{i:0;i:0;i:1;s:9:"FORMATNUM";}s:7:"padleft";a:2:{i:0;i:0;i:1;s:7:"PADLEFT";}s:8:"padright";a:2:{i:0;i:0;i:1;s:8:"PADRIGHT";}s:7:"special";a:2:{i:0;i:0;i:1;s:7:"special";}s:11:"defaultsort";a:4:{i:0;i:1;i:1;s:12:"DEFAULTSORT:";i:2;s:15:"DEFAULTSORTKEY:";i:3;s:20:"DEFAULTCATEGORYSORT:";}s:8:"filepath";a:2:{i:0;i:0;i:1;s:9:"FILEPATH:";}s:3:"tag";a:2:{i:0;i:0;i:1;s:3:"tag";}s:9:"hiddencat";a:2:{i:0;i:1;i:1;s:13:"__HIDDENCAT__";}s:15:"pagesincategory";a:3:{i:0;i:1;i:1;s:15:"PAGESINCATEGORY";i:2;s:10:"PAGESINCAT";}s:8:"pagesize";a:2:{i:0;i:1;i:1;s:8:"PAGESIZE";}s:5:"index";a:2:{i:0;i:1;i:1;s:9:"__INDEX__";}s:7:"noindex";a:2:{i:0;i:1;i:1;s:11:"__NOINDEX__";}s:13:"numberingroup";a:3:{i:0;i:1;i:1;s:13:"NUMBERINGROUP";i:2;s:10:"NUMINGROUP";}s:14:"staticredirect";a:2:{i:0;i:1;i:1;s:18:"__STATICREDIRECT__";}s:15:"protectionlevel";a:2:{i:0;i:1;i:1;s:15:"PROTECTIONLEVEL";}s:10:"formatdate";a:3:{i:0;i:0;i:1;s:10:"formatdate";i:2;s:10:"dateformat";}s:8:"url_path";a:2:{i:0;i:0;i:1;s:4:"PATH";}s:8:"url_wiki";a:2:{i:0;i:0;i:1;s:4:"WIKI";}s:9:"url_query";a:2:{i:0;i:0;i:1;s:5:"QUERY";}}
en	messages:sidebar	s:214:"\n* navigation\n** mainpage|mainpage-description\n** portal-url|portal\n** currentevents-url|currentevents\n** recentchanges-url|recentchanges\n** randompage-url|randompage\n** helppage|help\n* SEARCH\n* TOOLBOX\n* LANGUAGES";
en	messages:tog-underline	s:17:"Link underlining:";
en	messages:tog-highlightbroken	s:114:"Format broken links <a href="" class="new">like this</a> (alternative: like this<a href="" class="internal">?</a>)";
en	messages:tog-justify	s:18:"Justify paragraphs";
en	messages:tog-hideminor	s:34:"Hide minor edits in recent changes";
en	messages:tog-hidepatrolled	s:38:"Hide patrolled edits in recent changes";
en	messages:tog-newpageshidepatrolled	s:39:"Hide patrolled pages from new page list";
en	messages:tog-extendwatchlist	s:62:"Expand watchlist to show all changes, not just the most recent";
en	messages:tog-usenewrc	s:49:"Use enhanced recent changes (requires JavaScript)";
en	messages:tog-numberheadings	s:20:"Auto-number headings";
en	messages:tog-showtoolbar	s:39:"Show edit toolbar (requires JavaScript)";
en	messages:tog-editondblclick	s:48:"Edit pages on double click (requires JavaScript)";
en	messages:tog-editsection	s:39:"Enable section editing via [edit] links";
en	messages:tog-editsectiononrightclick	s:80:"Enable section editing by right clicking on section titles (requires JavaScript)";
en	messages:tog-showtoc	s:60:"Show table of contents (for pages with more than 3 headings)";
en	messages:tog-rememberpassword	s:78:"Remember my login on this browser (for a maximum of $1 {{PLURAL:$1|day|days}})";
en	messages:tog-watchcreations	s:34:"Add pages I create to my watchlist";
en	messages:tog-watchdefault	s:32:"Add pages I edit to my watchlist";
en	messages:tog-watchmoves	s:32:"Add pages I move to my watchlist";
en	messages:tog-watchdeletion	s:34:"Add pages I delete to my watchlist";
en	messages:tog-minordefault	s:31:"Mark all edits minor by default";
en	messages:tog-previewontop	s:28:"Show preview before edit box";
en	messages:tog-previewonfirst	s:26:"Show preview on first edit";
en	messages:tog-nocache	s:28:"Disable browser page caching";
en	messages:tog-enotifwatchlistpages	s:48:"E-mail me when a page on my watchlist is changed";
en	messages:tog-enotifusertalkpages	s:43:"E-mail me when my user talk page is changed";
en	messages:tog-enotifminoredits	s:39:"E-mail me also for minor edits of pages";
en	messages:tog-enotifrevealaddr	s:48:"Reveal my e-mail address in notification e-mails";
en	messages:tog-shownumberswatching	s:33:"Show the number of watching users";
en	messages:tog-oldsig	s:30:"Preview of existing signature:";
en	messages:tog-fancysig	s:55:"Treat signature as wikitext (without an automatic link)";
en	messages:tog-externaleditor	s:165:"Use external editor by default (for experts only, needs special settings on your computer. [http://www.mediawiki.org/wiki/Manual:External_editors More information.])";
en	messages:tog-externaldiff	s:163:"Use external diff by default (for experts only, needs special settings on your computer. [http://www.mediawiki.org/wiki/Manual:External_editors More information.])";
en	messages:tog-showjumplinks	s:36:"Enable "jump to" accessibility links";
en	messages:tog-uselivepreview	s:53:"Use live preview (requires JavaScript) (experimental)";
en	messages:tog-forceeditsummary	s:44:"Prompt me when entering a blank edit summary";
en	messages:tog-watchlisthideown	s:32:"Hide my edits from the watchlist";
en	messages:tog-watchlisthidebots	s:33:"Hide bot edits from the watchlist";
en	messages:tog-watchlisthideminor	s:35:"Hide minor edits from the watchlist";
en	messages:tog-watchlisthideliu	s:48:"Hide edits by logged in users from the watchlist";
en	messages:tog-watchlisthideanons	s:48:"Hide edits by anonymous users from the watchlist";
en	messages:tog-watchlisthidepatrolled	s:39:"Hide patrolled edits from the watchlist";
en	messages:tog-nolangconversion	s:27:"Disable variants conversion";
en	messages:tog-ccmeonemails	s:47:"Send me copies of e-mails I send to other users";
en	messages:tog-diffonly	s:36:"Do not show page content below diffs";
en	messages:tog-showhiddencats	s:22:"Show hidden categories";
en	messages:tog-noconvertlink	s:29:"Disable link title conversion";
en	messages:tog-norollbackdiff	s:37:"Omit diff after performing a rollback";
en	messages:underline-always	s:6:"Always";
en	messages:underline-never	s:5:"Never";
en	messages:underline-default	s:15:"Browser default";
en	messages:editfont-style	s:21:"Edit area font style:";
en	messages:editfont-default	s:15:"Browser default";
en	messages:editfont-monospace	s:15:"Monospaced font";
en	messages:editfont-sansserif	s:15:"Sans-serif font";
en	messages:editfont-serif	s:10:"Serif font";
en	messages:sunday	s:6:"Sunday";
en	messages:monday	s:6:"Monday";
en	messages:tuesday	s:7:"Tuesday";
en	messages:wednesday	s:9:"Wednesday";
en	messages:thursday	s:8:"Thursday";
en	messages:friday	s:6:"Friday";
en	messages:saturday	s:8:"Saturday";
en	messages:sun	s:3:"Sun";
en	messages:mon	s:3:"Mon";
en	messages:tue	s:3:"Tue";
en	messages:wed	s:3:"Wed";
en	messages:thu	s:3:"Thu";
en	messages:fri	s:3:"Fri";
en	messages:sat	s:3:"Sat";
en	messages:january	s:7:"January";
en	messages:february	s:8:"February";
en	messages:march	s:5:"March";
en	messages:april	s:5:"April";
en	messages:may_long	s:3:"May";
en	messages:june	s:4:"June";
en	messages:july	s:4:"July";
en	messages:august	s:6:"August";
en	messages:september	s:9:"September";
en	messages:october	s:7:"October";
en	messages:november	s:8:"November";
en	messages:december	s:8:"December";
en	messages:january-gen	s:7:"January";
en	messages:february-gen	s:8:"February";
en	messages:march-gen	s:5:"March";
en	messages:april-gen	s:5:"April";
en	messages:may-gen	s:3:"May";
en	messages:june-gen	s:4:"June";
en	messages:july-gen	s:4:"July";
en	messages:august-gen	s:6:"August";
en	messages:september-gen	s:9:"September";
en	messages:october-gen	s:7:"October";
en	messages:november-gen	s:8:"November";
en	messages:december-gen	s:8:"December";
en	messages:jan	s:3:"Jan";
en	messages:feb	s:3:"Feb";
en	messages:mar	s:3:"Mar";
en	messages:apr	s:3:"Apr";
en	messages:may	s:3:"May";
en	messages:jun	s:3:"Jun";
en	messages:jul	s:3:"Jul";
en	messages:aug	s:3:"Aug";
en	messages:sep	s:3:"Sep";
en	messages:oct	s:3:"Oct";
en	messages:nov	s:3:"Nov";
en	messages:dec	s:3:"Dec";
en	messages:pagecategories	s:33:"{{PLURAL:$1|Category|Categories}}";
en	messages:pagecategorieslink	s:18:"Special:Categories";
en	messages:category_header	s:22:"Pages in category "$1"";
en	messages:subcategories	s:13:"Subcategories";
en	messages:category-media-header	s:22:"Media in category "$1"";
en	messages:category-empty	s:55:"''This category currently contains no pages or media.''";
en	messages:hidden-categories	s:47:"{{PLURAL:$1|Hidden category|Hidden categories}}";
en	messages:hidden-category-category	s:17:"Hidden categories";
en	messages:category-subcat-count	s:156:"{{PLURAL:$2|This category has only the following subcategory.|This category has the following {{PLURAL:$1|subcategory|$1 subcategories}}, out of $2 total.}}";
en	messages:category-subcat-count-limited	s:75:"This category has the following {{PLURAL:$1|subcategory|$1 subcategories}}.";
en	messages:category-article-count	s:145:"{{PLURAL:$2|This category contains only the following page.|The following {{PLURAL:$1|page is|$1 pages are}} in this category, out of $2 total.}}";
en	messages:category-article-count-limited	s:73:"The following {{PLURAL:$1|page is|$1 pages are}} in the current category.";
en	messages:category-file-count	s:145:"{{PLURAL:$2|This category contains only the following file.|The following {{PLURAL:$1|file is|$1 files are}} in this category, out of $2 total.}}";
en	messages:category-file-count-limited	s:73:"The following {{PLURAL:$1|file is|$1 files are}} in the current category.";
en	messages:listingcontinuesabbrev	s:5:"cont.";
en	messages:index-category	s:13:"Indexed pages";
en	messages:noindex-category	s:15:"Noindexed pages";
en	messages:linkprefix	s:31:"/^(.*?)([a-zA-Z\\x80-\\xff]+)$/sD";
en	messages:mainpagetext	s:48:"'''MediaWiki has been successfully installed.'''";
en	messages:mainpagedocfooter	s:388:"Consult the [http://meta.wikimedia.org/wiki/Help:Contents User's Guide] for information on using the wiki software.\n\n== Getting started ==\n* [http://www.mediawiki.org/wiki/Manual:Configuration_settings Configuration settings list]\n* [http://www.mediawiki.org/wiki/Manual:FAQ MediaWiki FAQ]\n* [https://lists.wikimedia.org/mailman/listinfo/mediawiki-announce MediaWiki release mailing list]";
en	messages:about	s:5:"About";
en	messages:article	s:12:"Content page";
en	messages:newwindow	s:21:"(opens in new window)";
en	messages:cancel	s:6:"Cancel";
en	messages:moredotdotdot	s:7:"More...";
en	messages:mypage	s:7:"My page";
en	messages:mytalk	s:7:"My talk";
en	messages:anontalk	s:24:"Talk for this IP address";
en	messages:navigation	s:10:"Navigation";
en	messages:and	s:8:"&#32;and";
en	messages:qbfind	s:4:"Find";
en	messages:qbbrowse	s:6:"Browse";
en	messages:qbedit	s:4:"Edit";
en	messages:qbpageoptions	s:9:"This page";
en	messages:qbpageinfo	s:7:"Context";
en	messages:qbmyoptions	s:8:"My pages";
en	messages:qbspecialpages	s:13:"Special pages";
en	messages:faq	s:3:"FAQ";
en	messages:faqpage	s:11:"Project:FAQ";
en	messages:sitetitle	s:12:"{{SITENAME}}";
en	messages:sitesubtitle	s:0:"";
en	messages:vector-action-addsection	s:9:"Add topic";
en	messages:vector-action-delete	s:6:"Delete";
en	messages:vector-action-move	s:4:"Move";
en	messages:vector-action-protect	s:7:"Protect";
en	messages:vector-action-undelete	s:8:"Undelete";
en	messages:vector-action-unprotect	s:9:"Unprotect";
en	messages:vector-simplesearch-preference	s:53:"Enable enhanced search suggestions (Vector skin only)";
en	messages:vector-view-create	s:6:"Create";
en	messages:vector-view-edit	s:4:"Edit";
en	messages:vector-view-history	s:12:"View history";
en	messages:vector-view-view	s:4:"Read";
en	messages:vector-view-viewsource	s:11:"View source";
en	messages:actions	s:7:"Actions";
en	messages:namespaces	s:10:"Namespaces";
en	messages:variants	s:8:"Variants";
en	messages:errorpagetitle	s:5:"Error";
en	messages:returnto	s:13:"Return to $1.";
en	messages:tagline	s:17:"From {{SITENAME}}";
en	messages:help	s:4:"Help";
en	messages:search	s:6:"Search";
en	messages:searchbutton	s:6:"Search";
en	messages:go	s:2:"Go";
en	messages:searcharticle	s:2:"Go";
en	messages:history	s:12:"Page history";
en	messages:history_short	s:7:"History";
en	messages:updatedmarker	s:27:"updated since my last visit";
en	messages:info_short	s:11:"Information";
en	messages:printableversion	s:17:"Printable version";
en	messages:permalink	s:14:"Permanent link";
en	messages:print	s:5:"Print";
en	messages:edit	s:4:"Edit";
en	messages:create	s:6:"Create";
en	messages:editthispage	s:14:"Edit this page";
en	messages:create-this-page	s:16:"Create this page";
en	messages:delete	s:6:"Delete";
en	messages:deletethispage	s:16:"Delete this page";
en	messages:undelete_short	s:40:"Undelete {{PLURAL:$1|one edit|$1 edits}}";
en	messages:protect	s:7:"Protect";
en	messages:protect_change	s:6:"change";
en	messages:protectthispage	s:17:"Protect this page";
en	messages:unprotect	s:9:"Unprotect";
en	messages:unprotectthispage	s:19:"Unprotect this page";
en	messages:newpage	s:8:"New page";
en	messages:talkpage	s:17:"Discuss this page";
en	messages:talkpagelinktext	s:4:"Talk";
en	messages:specialpage	s:12:"Special page";
en	messages:personaltools	s:14:"Personal tools";
en	messages:postcomment	s:11:"New section";
en	messages:addsection	s:1:"+";
en	messages:articlepage	s:17:"View content page";
en	messages:talk	s:10:"Discussion";
en	messages:views	s:5:"Views";
en	messages:toolbox	s:7:"Toolbox";
en	messages:userpage	s:14:"View user page";
en	messages:projectpage	s:17:"View project page";
en	messages:imagepage	s:14:"View file page";
en	messages:mediawikipage	s:17:"View message page";
en	messages:templatepage	s:18:"View template page";
en	messages:viewhelppage	s:14:"View help page";
en	messages:categorypage	s:18:"View category page";
en	messages:viewtalkpage	s:15:"View discussion";
en	messages:otherlanguages	s:18:"In other languages";
en	messages:redirectedfrom	s:20:"(Redirected from $1)";
en	messages:redirectpagesub	s:13:"Redirect page";
en	messages:talkpageheader	s:1:"-";
en	messages:lastmodifiedat	s:41:"This page was last modified on $1, at $2.";
en	messages:viewcount	s:56:"This page has been accessed {{PLURAL:$1|once|$1 times}}.";
en	messages:protectedpage	s:14:"Protected page";
en	messages:jumpto	s:8:"Jump to:";
en	messages:jumptonavigation	s:10:"navigation";
en	messages:jumptosearch	s:6:"search";
en	messages:view-pool-error	s:159:"Sorry, the servers are overloaded at the moment.\nToo many users are trying to view this page.\nPlease wait a while before you try to access this page again.\n\n$1";
en	messages:pool-timeout	s:28:"Timeout waiting for the lock";
en	messages:pool-queuefull	s:18:"Pool queue is full";
en	messages:pool-errorunknown	s:13:"Unknown error";
en	messages:aboutsite	s:18:"About {{SITENAME}}";
en	messages:aboutpage	s:13:"Project:About";
en	messages:copyright	s:30:"Content is available under $1.";
en	messages:copyrightpage	s:25:"{{ns:project}}:Copyrights";
en	messages:currentevents	s:14:"Current events";
en	messages:currentevents-url	s:22:"Project:Current events";
en	messages:disclaimers	s:11:"Disclaimers";
en	messages:disclaimerpage	s:26:"Project:General disclaimer";
en	messages:edithelp	s:12:"Editing help";
en	messages:edithelppage	s:12:"Help:Editing";
en	messages:helppage	s:13:"Help:Contents";
en	messages:mainpage	s:9:"Main Page";
en	messages:mainpage-description	s:9:"Main page";
en	messages:policy-url	s:14:"Project:Policy";
en	messages:portal	s:16:"Community portal";
en	messages:portal-url	s:24:"Project:Community portal";
en	messages:privacy	s:14:"Privacy policy";
en	messages:privacypage	s:22:"Project:Privacy policy";
en	messages:badaccess	s:16:"Permission error";
en	messages:badaccess-group0	s:61:"You are not allowed to execute the action you have requested.";
en	messages:badaccess-groups	s:99:"The action you have requested is limited to users in {{PLURAL:$2|the group|one of the groups}}: $1.";
en	messages:versionrequired	s:32:"Version $1 of MediaWiki required";
en	messages:versionrequiredtext	s:91:"Version $1 of MediaWiki is required to use this page.\nSee [[Special:Version|version page]].";
en	messages:ok	s:2:"OK";
en	messages:pagetitle	s:17:"$1 - {{SITENAME}}";
en	messages:pagetitle-view-mainpage	s:12:"{{SITENAME}}";
en	messages:retrievedfrom	s:19:"Retrieved from "$1"";
en	messages:youhavenewmessages	s:17:"You have $1 ($2).";
en	messages:newmessageslink	s:12:"new messages";
en	messages:newmessagesdifflink	s:11:"last change";
en	messages:youhavenewmessagesmulti	s:27:"You have new messages on $1";
en	messages:newtalkseparator	s:6:",&#32;";
en	messages:editsection	s:4:"edit";
en	messages:editsection-brackets	s:4:"[$1]";
en	messages:editold	s:4:"edit";
en	messages:viewsourceold	s:11:"view source";
en	messages:editlink	s:4:"edit";
en	messages:viewsourcelink	s:11:"view source";
en	messages:editsectionhint	s:16:"Edit section: $1";
en	messages:toc	s:8:"Contents";
en	messages:showtoc	s:4:"show";
en	messages:hidetoc	s:4:"hide";
en	messages:thisisdeleted	s:19:"View or restore $1?";
en	messages:viewdeleted	s:8:"View $1?";
en	messages:restorelink	s:47:"{{PLURAL:$1|one deleted edit|$1 deleted edits}}";
en	messages:feedlinks	s:5:"Feed:";
en	messages:feed-invalid	s:31:"Invalid subscription feed type.";
en	messages:feed-unavailable	s:35:"Syndication feeds are not available";
en	messages:site-rss-feed	s:11:"$1 RSS feed";
en	messages:site-atom-feed	s:12:"$1 Atom feed";
en	messages:page-rss-feed	s:13:""$1" RSS feed";
en	messages:page-atom-feed	s:14:""$1" Atom feed";
en	messages:feed-atom	s:4:"Atom";
en	messages:feed-rss	s:3:"RSS";
en	messages:sitenotice	s:1:"-";
en	messages:anonnotice	s:1:"-";
en	messages:newsectionheaderdefaultlevel	s:8:"== $1 ==";
en	messages:red-link-title	s:24:"$1 (page does not exist)";
en	messages:nstab-main	s:4:"Page";
en	messages:nstab-user	s:9:"User page";
en	messages:nstab-media	s:10:"Media page";
en	messages:nstab-special	s:12:"Special page";
en	messages:nstab-project	s:12:"Project page";
en	messages:nstab-image	s:4:"File";
en	messages:nstab-mediawiki	s:7:"Message";
en	messages:nstab-template	s:8:"Template";
en	messages:nstab-help	s:9:"Help page";
en	messages:nstab-category	s:8:"Category";
en	messages:nosuchaction	s:14:"No such action";
en	messages:nosuchactiontext	s:176:"The action specified by the URL is invalid.\nYou might have mistyped the URL, or followed an incorrect link.\nThis might also indicate a bug in the software used by {{SITENAME}}.";
en	messages:nosuchspecialpage	s:20:"No such special page";
en	messages:nospecialpagetext	s:154:"<strong>You have requested an invalid special page.</strong>\n\nA list of valid special pages can be found at [[Special:SpecialPages|{{int:specialpages}}]].";
en	messages:error	s:5:"Error";
en	messages:databaseerror	s:14:"Database error";
en	messages:dberrortext	s:239:"A database query syntax error has occurred.\nThis may indicate a bug in the software.\nThe last attempted database query was:\n<blockquote><tt>$1</tt></blockquote>\nfrom within function "<tt>$2</tt>".\nDatabase returned error "<tt>$3: $4</tt>".";
en	messages:dberrortextcl	s:147:"A database query syntax error has occurred.\nThe last attempted database query was:\n"$1"\nfrom within function "$2".\nDatabase returned error "$3: $4"";
en	messages:laggedslavemode	s:51:"'''Warning:''' Page may not contain recent updates.";
en	messages:readonly	s:15:"Database locked";
en	messages:enterlockreason	s:84:"Enter a reason for the lock, including an estimate of when the lock will be released";
en	messages:readonlytext	s:216:"The database is currently locked to new entries and other modifications, probably for routine database maintenance, after which it will be back to normal.\n\nThe administrator who locked it offered this explanation: $1";
en	messages:missing-article	s:349:"The database did not find the text of a page that it should have found, named "$1" $2.\n\nThis is usually caused by following an outdated diff or history link to a page that has been deleted.\n\nIf this is not the case, you may have found a bug in the software.\nPlease report this to an [[Special:ListUsers/sysop|administrator]], making note of the URL.";
en	messages:missingarticle-rev	s:15:"(revision#: $1)";
en	messages:missingarticle-diff	s:14:"(Diff: $1, $2)";
en	messages:readonly_lag	s:98:"The database has been automatically locked while the slave database servers catch up to the master";
en	messages:internalerror	s:14:"Internal error";
en	messages:internalerror_info	s:18:"Internal error: $1";
en	messages:fileappenderrorread	s:34:"Could not read "$1" during append.";
en	messages:fileappenderror	s:30:"Could not append "$1" to "$2".";
en	messages:filecopyerror	s:33:"Could not copy file "$1" to "$2".";
en	messages:filerenameerror	s:35:"Could not rename file "$1" to "$2".";
en	messages:filedeleteerror	s:27:"Could not delete file "$1".";
en	messages:directorycreateerror	s:32:"Could not create directory "$1".";
en	messages:filenotfound	s:25:"Could not find file "$1".";
en	messages:fileexistserror	s:41:"Unable to write to file "$1": file exists";
en	messages:unexpected	s:28:"Unexpected value: "$1"="$2".";
en	messages:formerror	s:28:"Error: could not submit form";
en	messages:badarticleerror	s:45:"This action cannot be performed on this page.";
en	messages:cannotdelete	s:93:"The page or file "$1" could not be deleted.\nIt may have already been deleted by someone else.";
en	messages:badtitle	s:9:"Bad title";
en	messages:badtitletext	s:175:"The requested page title was invalid, empty, or an incorrectly linked inter-language or inter-wiki title.\nIt may contain one or more characters which cannot be used in titles.";
en	messages:perfcached	s:55:"The following data is cached and may not be up to date.";
en	messages:perfcachedts	s:54:"The following data is cached, and was last updated $1.";
en	messages:querypage-no-updates	s:88:"Updates for this page are currently disabled.\nData here will not presently be refreshed.";
en	messages:wrong_wfQuery_params	s:68:"Incorrect parameters to wfQuery()<br />\nFunction: $1<br />\nQuery: $2";
en	messages:viewsource	s:11:"View source";
en	messages:viewsourcefor	s:6:"for $1";
en	messages:actionthrottled	s:16:"Action throttled";
en	messages:actionthrottledtext	s:178:"As an anti-spam measure, you are limited from performing this action too many times in a short space of time, and you have exceeded this limit.\nPlease try again in a few minutes.";
en	messages:protectedpagetext	s:48:"This page has been protected to prevent editing.";
en	messages:viewsourcetext	s:46:"You can view and copy the source of this page:";
en	messages:protectedinterface	s:86:"This page provides interface text for the software, and is protected to prevent abuse.";
en	messages:editinginterface	s:330:"'''Warning:''' You are editing a page which is used to provide interface text for the software.\nChanges to this page will affect the appearance of the user interface for other users.\nFor translations, please consider using [http://translatewiki.net/wiki/Main_Page?setlang=en translatewiki.net], the MediaWiki localisation project.";
en	messages:sqlhidden	s:18:"(SQL query hidden)";
en	messages:editconflict	s:17:"Edit conflict: $1";
en	messages:mergehistory-submit	s:15:"Merge revisions";
en	messages:cascadeprotected	s:180:"This page has been protected from editing, because it is included in the following {{PLURAL:$1|page, which is|pages, which are}} protected with the "cascading" option turned on:\n$2";
en	messages:namespaceprotected	s:67:"You do not have permission to edit pages in the '''$1''' namespace.";
en	messages:customcssjsprotected	s:99:"You do not have permission to edit this page, because it contains another user's personal settings.";
en	messages:ns-specialprotected	s:31:"Special pages cannot be edited.";
en	messages:titleprotected	s:92:"This title has been protected from creation by [[User:$1|$1]].\nThe reason given is "''$2''".";
en	messages:virus-badscanner	s:48:"Bad configuration: unknown virus scanner: ''$1''";
en	messages:virus-scanfailed	s:21:"scan failed (code $1)";
en	messages:virus-unknownscanner	s:18:"unknown antivirus:";
en	messages:logouttext	s:280:"'''You are now logged out.'''\n\nYou can continue to use {{SITENAME}} anonymously, or you can [[Special:UserLogin|log in again]] as the same or as a different user.\nNote that some pages may continue to be displayed as if you were still logged in, until you clear your browser cache.";
en	messages:welcomecreation	s:128:"== Welcome, $1! ==\nYour account has been created.\nDo not forget to change your [[Special:Preferences|{{SITENAME}} preferences]].";
en	messages:yourname	s:9:"Username:";
en	messages:yourpassword	s:9:"Password:";
en	messages:yourpasswordagain	s:16:"Retype password:";
en	messages:remembermypassword	s:78:"Remember my login on this browser (for a maximum of $1 {{PLURAL:$1|day|days}})";
en	messages:securelogin-stick-https	s:35:"Stay connected to HTTPS after login";
en	messages:yourdomainname	s:12:"Your domain:";
en	messages:externaldberror	s:105:"There was either an authentication database error or you are not allowed to update your external account.";
en	messages:login	s:6:"Log in";
en	messages:nav-login-createaccount	s:23:"Log in / create account";
en	messages:loginprompt	s:56:"You must have cookies enabled to log in to {{SITENAME}}.";
en	messages:userlogin	s:23:"Log in / create account";
en	messages:userloginnocreate	s:6:"Log in";
en	messages:logout	s:7:"Log out";
en	messages:userlogout	s:7:"Log out";
en	messages:notloggedin	s:13:"Not logged in";
en	messages:nologin	s:26:"Don't have an account? $1.";
en	messages:nologinlink	s:17:"Create an account";
en	messages:createaccount	s:14:"Create account";
en	messages:gotaccount	s:28:"Already have an account? $1.";
en	messages:gotaccountlink	s:6:"Log in";
en	messages:createaccountmail	s:9:"By e-mail";
en	messages:createaccountreason	s:7:"Reason:";
en	messages:badretype	s:39:"The passwords you entered do not match.";
en	messages:userexists	s:64:"Username entered already in use.\nPlease choose a different name.";
en	messages:loginerror	s:11:"Login error";
en	messages:createaccounterror	s:28:"Could not create account: $1";
en	messages:nocookiesnew	s:195:"The user account was created, but you are not logged in.\n{{SITENAME}} uses cookies to log in users.\nYou have cookies disabled.\nPlease enable them, then log in with your new username and password.";
en	messages:nocookieslogin	s:103:"{{SITENAME}} uses cookies to log in users.\nYou have cookies disabled.\nPlease enable them and try again.";
en	messages:noname	s:40:"You have not specified a valid username.";
en	messages:loginsuccesstitle	s:16:"Login successful";
en	messages:loginsuccess	s:52:"'''You are now logged in to {{SITENAME}} as "$1".'''";
en	messages:nosuchuser	s:139:"There is no user by the name "$1".\nUsernames are case sensitive.\nCheck your spelling, or [[Special:UserLogin/signup|create a new account]].";
en	messages:nosuchusershort	s:72:"There is no user by the name "<nowiki>$1</nowiki>".\nCheck your spelling.";
en	messages:nouserspecified	s:31:"You have to specify a username.";
en	messages:login-userblocked	s:40:"This user is blocked. Login not allowed.";
en	messages:wrongpassword	s:45:"Incorrect password entered.\nPlease try again.";
en	messages:wrongpasswordempty	s:45:"Password entered was blank.\nPlease try again.";
en	messages:passwordtooshort	s:67:"Passwords must be at least {{PLURAL:$1|1 character|$1 characters}}.";
en	messages:password-name-match	s:51:"Your password must be different from your username.";
en	messages:password-login-forbidden	s:57:"The use of this username and password has been forbidden.";
en	messages:mailmypassword	s:19:"E-mail new password";
en	messages:passwordremindertitle	s:39:"New temporary password for {{SITENAME}}";
en	messages:passwordremindertext	s:493:"Someone (probably you, from IP address $1) requested a new\npassword for {{SITENAME}} ($4). A temporary password for user\n"$2" has been created and was set to "$3". If this was your\nintent, you will need to log in and choose a new password now.\nYour temporary password will expire in {{PLURAL:$5|one day|$5 days}}.\n\nIf someone else made this request, or if you have remembered your password,\nand you no longer wish to change it, you may ignore this message and\ncontinue using your old password.";
en	messages:noemail	s:50:"There is no e-mail address recorded for user "$1".";
en	messages:noemailcreate	s:42:"You need to provide a valid e-mail address";
en	messages:passwordsent	s:113:"A new password has been sent to the e-mail address registered for "$1".\nPlease log in again after you receive it.";
en	messages:blocked-mailpassword	s:118:"Your IP address is blocked from editing, and so is not allowed to use the password recovery function to prevent abuse.";
en	messages:updated	s:9:"(Updated)";
en	messages:note	s:11:"'''Note:'''";
en	messages:eauthentsent	s:219:"A confirmation e-mail has been sent to the nominated e-mail address.\nBefore any other e-mail is sent to the account, you will have to follow the instructions in the e-mail, to confirm that the account is actually yours.";
en	messages:throttled-mailpassword	s:178:"A password reminder has already been sent, within the last {{PLURAL:$1|hour|$1 hours}}.\nTo prevent abuse, only one password reminder will be sent per {{PLURAL:$1|hour|$1 hours}}.";
en	messages:loginstart	s:0:"";
en	messages:loginend	s:0:"";
en	messages:signupstart	s:18:"{{int:loginstart}}";
en	messages:signupend	s:16:"{{int:loginend}}";
en	messages:mailerror	s:22:"Error sending mail: $1";
en	messages:acct_creation_throttle_hit	s:250:"Visitors to this wiki using your IP address have created {{PLURAL:$1|1 account|$1 accounts}} in the last day, which is the maximum allowed in this time period.\nAs a result, visitors using this IP address cannot create any more accounts at the moment.";
en	messages:emailauthenticated	s:50:"Your e-mail address was authenticated on $2 at $3.";
en	messages:emailnotauthenticated	s:103:"Your e-mail address is not yet authenticated.\nNo e-mail will be sent for any of the following features.";
en	messages:noemailprefs	s:73:"Specify an e-mail address in your preferences for these features to work.";
en	messages:emailconfirmlink	s:27:"Confirm your e-mail address";
en	messages:invalidemailaddress	s:137:"The e-mail address cannot be accepted as it appears to have an invalid format.\nPlease enter a well-formatted address or empty that field.";
en	messages:accountcreated	s:15:"Account created";
en	messages:accountcreatedtext	s:41:"The user account for $1 has been created.";
en	messages:createaccount-title	s:33:"Account creation for {{SITENAME}}";
en	messages:createaccount-text	s:219:"Someone created an account for your e-mail address on {{SITENAME}} ($4) named "$2", with password "$3".\nYou should log in and change your password now.\n\nYou may ignore this message, if this account was created in error.";
en	messages:usernamehasherror	s:39:"Username cannot contain hash characters";
en	messages:login-throttled	s:78:"You have made too many recent login attempts.\nPlease wait before trying again.";
en	messages:loginlanguagelabel	s:12:"Language: $1";
en	messages:loginlanguagelinks	s:99:"* Deutsch|de\n* English|en\n* Esperanto|eo\n* Français|fr\n* Español|es\n* Italiano|it\n* Nederlands|nl";
en	messages:suspicious-userlogout	s:106:"Your request to log out was denied because it looks like it was sent by a broken browser or caching proxy.";
en	messages:pear-mail-error	s:2:"$1";
en	messages:php-mail-error	s:2:"$1";
en	messages:php-mail-error-unknown	s:38:"Unknown error in PHP's mail() function";
en	messages:resetpass	s:15:"Change password";
en	messages:resetpass_announce	s:101:"You logged in with a temporary e-mailed code.\nTo finish logging in, you must set a new password here:";
en	messages:resetpass_text	s:22:"<!-- Add text here -->";
en	messages:resetpass_header	s:23:"Change account password";
en	messages:oldpassword	s:13:"Old password:";
en	messages:newpassword	s:13:"New password:";
en	messages:retypenew	s:20:"Retype new password:";
en	messages:resetpass_submit	s:23:"Set password and log in";
en	messages:resetpass_success	s:66:"Your password has been changed successfully!\nNow logging you in...";
en	messages:resetpass_forbidden	s:27:"Passwords cannot be changed";
en	messages:resetpass-no-info	s:51:"You must be logged in to access this page directly.";
en	messages:resetpass-submit-loggedin	s:15:"Change password";
en	messages:resetpass-submit-cancel	s:6:"Cancel";
en	messages:resetpass-wrong-oldpass	s:133:"Invalid temporary or current password.\nYou may have already successfully changed your password or requested a new temporary password.";
en	messages:resetpass-temp-password	s:19:"Temporary password:";
en	messages:bold_sample	s:9:"Bold text";
en	messages:bold_tip	s:9:"Bold text";
en	messages:italic_sample	s:11:"Italic text";
en	messages:italic_tip	s:11:"Italic text";
en	messages:link_sample	s:10:"Link title";
en	messages:link_tip	s:13:"Internal link";
en	messages:extlink_sample	s:33:"http://www.example.com link title";
en	messages:extlink_tip	s:39:"External link (remember http:// prefix)";
en	messages:headline_sample	s:13:"Headline text";
en	messages:headline_tip	s:16:"Level 2 headline";
en	messages:math_sample	s:19:"Insert formula here";
en	messages:math_tip	s:28:"Mathematical formula (LaTeX)";
en	messages:nowiki_sample	s:30:"Insert non-formatted text here";
en	messages:nowiki_tip	s:22:"Ignore wiki formatting";
en	messages:image_sample	s:11:"Example.jpg";
en	messages:image_tip	s:13:"Embedded file";
en	messages:media_sample	s:11:"Example.ogg";
en	messages:media_tip	s:9:"File link";
en	messages:sig_tip	s:29:"Your signature with timestamp";
en	messages:hr_tip	s:31:"Horizontal line (use sparingly)";
en	messages:summary	s:8:"Summary:";
en	messages:subject	s:17:"Subject/headline:";
en	messages:minoredit	s:20:"This is a minor edit";
en	messages:watchthis	s:15:"Watch this page";
en	messages:savearticle	s:9:"Save page";
en	messages:preview	s:7:"Preview";
en	messages:showpreview	s:12:"Show preview";
en	messages:showlivepreview	s:12:"Live preview";
en	messages:showdiff	s:12:"Show changes";
en	messages:anoneditwarning	s:99:"'''Warning:''' You are not logged in.\nYour IP address will be recorded in this page's edit history.";
en	messages:anonpreviewwarning	s:90:"''You are not logged in. Saving will record your IP address in this page's edit history.''";
en	messages:missingsummary	s:133:"'''Reminder:''' You have not provided an edit summary.\nIf you click "{{int:savearticle}}" again, your edit will be saved without one.";
en	messages:missingcommenttext	s:29:"Please enter a comment below.";
en	messages:missingcommentheader	s:153:"'''Reminder:''' You have not provided a subject/headline for this comment.\nIf you click "{{int:savearticle}}" again, your edit will be saved without one.";
en	messages:summary-preview	s:16:"Summary preview:";
en	messages:subject-preview	s:25:"Subject/headline preview:";
en	messages:blockedtitle	s:15:"User is blocked";
en	messages:token_suffix_mismatch	s:259:"'''Your edit has been rejected because your client mangled the punctuation characters in the edit token.'''\nThe edit has been rejected to prevent corruption of the page text.\nThis sometimes happens when you are using a buggy web-based anonymous proxy service.";
en	messages:editing	s:10:"Editing $1";
en	messages:editingsection	s:20:"Editing $1 (section)";
en	messages:editingcomment	s:24:"Editing $1 (new section)";
en	messages:blockedtext	s:574:"'''Your username or IP address has been blocked.'''\n\nThe block was made by $1.\nThe reason given is ''$2''.\n\n* Start of block: $8\n* Expiry of block: $6\n* Intended blockee: $7\n\nYou can contact $1 or another [[{{MediaWiki:Grouppage-sysop}}|administrator]] to discuss the block.\nYou cannot use the 'e-mail this user' feature unless a valid e-mail address is specified in your [[Special:Preferences|account preferences]] and you have not been blocked from using it.\nYour current IP address is $3, and the block ID is #$5.\nPlease include all above details in any queries you make.";
en	messages:autoblockedtext	s:636:"Your IP address has been automatically blocked because it was used by another user, who was blocked by $1.\nThe reason given is this:\n\n:''$2''\n\n* Start of block: $8\n* Expiry of block: $6\n* Intended blockee: $7\n\nYou may contact $1 or one of the other [[{{MediaWiki:Grouppage-sysop}}|administrators]] to discuss the block.\n\nNote that you may not use the "e-mail this user" feature unless you have a valid e-mail address registered in your [[Special:Preferences|user preferences]] and you have not been blocked from using it.\n\nYour current IP address is $3, and the block ID is #$5.\nPlease include all above details in any queries you make.";
en	messages:blockednoreason	s:15:"no reason given";
en	messages:blockedoriginalsource	s:38:"The source of '''$1''' is shown below:";
en	messages:blockededitsource	s:56:"The text of '''your edits''' to '''$1''' is shown below:";
en	messages:whitelistedittitle	s:22:"Login required to edit";
en	messages:whitelistedittext	s:29:"You have to $1 to edit pages.";
en	messages:confirmedittext	s:157:"You must confirm your e-mail address before editing pages.\nPlease set and validate your e-mail address through your [[Special:Preferences|user preferences]].";
en	messages:nosuchsectiontitle	s:19:"Cannot find section";
en	messages:nosuchsectiontext	s:115:"You tried to edit a section that does not exist.\nIt may have been moved or deleted while you were viewing the page.";
en	messages:loginreqtitle	s:14:"Login required";
en	messages:loginreqlink	s:6:"log in";
en	messages:loginreqpagetext	s:32:"You must $1 to view other pages.";
en	messages:accmailtitle	s:14:"Password sent.";
en	messages:accmailtext	s:200:"A randomly generated password for [[User talk:$1|$1]] has been sent to $2.\n\nThe password for this new account can be changed on the ''[[Special:ChangePassword|change password]]'' page upon logging in.";
en	messages:newarticle	s:5:"(New)";
en	messages:newarticletext	s:239:"You have followed a link to a page that does not exist yet.\nTo create the page, start typing in the box below (see the [[{{MediaWiki:Helppage}}|help page]] for more info).\nIf you are here by mistake, click your browser's '''back''' button.";
en	messages:newarticletextanon	s:22:"{{int:newarticletext}}";
en	messages:talkpagetext	s:31:"<!-- MediaWiki:talkpagetext -->";
en	messages:anontalkpagetext	s:469:"----''This is the discussion page for an anonymous user who has not created an account yet, or who does not use it.\nWe therefore have to use the numerical IP address to identify him/her.\nSuch an IP address can be shared by several users.\nIf you are an anonymous user and feel that irrelevant comments have been directed at you, please [[Special:UserLogin/signup|create an account]] or [[Special:UserLogin|log in]] to avoid future confusion with other anonymous users.''";
en	messages:noarticletext	s:296:"There is currently no text in this page.\nYou can [[Special:Search/{{PAGENAME}}|search for this page title]] in other pages,\n<span class="plainlinks">[{{fullurl:{{#Special:Log}}|page={{FULLPAGENAMEE}}}} search the related logs],\nor [{{fullurl:{{FULLPAGENAME}}|action=edit}} edit this page]</span>.";
en	messages:noarticletext-nopermission	s:237:"There is currently no text in this page.\nYou can [[Special:Search/{{PAGENAME}}|search for this page title]] in other pages,\nor <span class="plainlinks">[{{fullurl:{{#Special:Log}}|page={{FULLPAGENAMEE}}}} search the related logs]</span>.";
en	messages:noarticletextanon	s:21:"{{int:noarticletext}}";
en	messages:userpage-userdoesnotexist	s:87:"User account "$1" is not registered.\nPlease check if you want to create/edit this page.";
en	messages:userpage-userdoesnotexist-view	s:36:"User account "$1" is not registered.";
en	messages:blocked-notice-logextract	s:91:"This user is currently blocked.\nThe latest block log entry is provided below for reference:";
en	messages:clearyourcache	s:438:"'''Note: After saving, you may have to bypass your browser's cache to see the changes.'''\n'''Mozilla / Firefox / Safari:''' hold ''Shift'' while clicking ''Reload'', or press either ''Ctrl-F5'' or ''Ctrl-R'' (''Command-R'' on a Macintosh);\n'''Konqueror: '''click ''Reload'' or press ''F5'';\n'''Opera:''' clear the cache in ''Tools → Preferences'';\n'''Internet Explorer:''' hold ''Ctrl'' while clicking ''Refresh,'' or press ''Ctrl-F5''.";
en	messages:usercssyoucanpreview	s:83:"'''Tip:''' Use the "{{int:showpreview}}" button to test your new CSS before saving.";
en	messages:userjsyoucanpreview	s:90:"'''Tip:''' Use the "{{int:showpreview}}" button to test your new JavaScript before saving.";
en	messages:usercsspreview	s:91:"'''Remember that you are only previewing your user CSS.'''\n'''It has not yet been saved!'''";
en	messages:userjspreview	s:106:"'''Remember that you are only testing/previewing your user JavaScript.'''\n'''It has not yet been saved!'''";
en	messages:sitecsspreview	s:86:"'''Remember that you are only previewing this CSS.'''\n'''It has not yet been saved!'''";
en	messages:sitejspreview	s:98:"'''Remember that you are only previewing this JavaScript code.'''\n'''It has not yet been saved!'''";
en	messages:userinvalidcssjstitle	s:160:"'''Warning:''' There is no skin "$1".\nCustom .css and .js pages use a lowercase title, e.g. {{ns:user}}:Foo/vector.css as opposed to {{ns:user}}:Foo/Vector.css.";
en	messages:previewnote	s:81:"'''Remember that this is only a preview.'''\nYour changes have not yet been saved!";
en	messages:previewconflict	s:102:"This preview reflects the text in the upper text editing area as it will appear if you choose to save.";
en	messages:session_fail_preview	s:179:"'''Sorry! We could not process your edit due to a loss of session data.'''\nPlease try again.\nIf it still does not work, try [[Special:UserLogout|logging out]] and logging back in.";
en	messages:session_fail_preview_html	s:338:"'''Sorry! We could not process your edit due to a loss of session data.'''\n\n''Because {{SITENAME}} has raw HTML enabled, the preview is hidden as a precaution against JavaScript attacks.''\n\n'''If this is a legitimate edit attempt, please try again.'''\nIf it still does not work, try [[Special:UserLogout|logging out]] and logging back in.";
en	messages:explainconflict	s:333:"Someone else has changed this page since you started editing it.\nThe upper text area contains the page text as it currently exists.\nYour changes are shown in the lower text area.\nYou will have to merge your changes into the existing text.\n'''Only''' the text in the upper text area will be saved when you press "{{int:savearticle}}".";
en	messages:yourtext	s:9:"Your text";
en	messages:storedversion	s:15:"Stored revision";
en	messages:nonunicodebrowser	s:184:"'''Warning: Your browser is not unicode compliant.'''\nA workaround is in place to allow you to safely edit pages: non-ASCII characters will appear in the edit box as hexadecimal codes.";
en	messages:editingold	s:135:"'''Warning: You are editing an out-of-date revision of this page.'''\nIf you save it, any changes made since this revision will be lost.";
en	messages:yourdiff	s:11:"Differences";
en	messages:copyrightwarning	s:406:"Please note that all contributions to {{SITENAME}} are considered to be released under the $2 (see $1 for details).\nIf you do not want your writing to be edited mercilessly and redistributed at will, then do not submit it here.<br />\nYou are also promising us that you wrote this yourself, or copied it from a public domain or similar free resource.\n'''Do not submit copyrighted work without permission!'''";
en	messages:copyrightwarning2	s:394:"Please note that all contributions to {{SITENAME}} may be edited, altered, or removed by other contributors.\nIf you do not want your writing to be edited mercilessly, then do not submit it here.<br />\nYou are also promising us that you wrote this yourself, or copied it from a public domain or similar free resource (see $1 for details).\n'''Do not submit copyrighted work without permission!'''";
en	messages:editpage-tos-summary	s:1:"-";
en	messages:longpage-hint	s:1:"-";
en	messages:longpageerror	s:132:"'''Error: The text you have submitted is $1 kilobytes long, which is longer than the maximum of $2 kilobytes.'''\nIt cannot be saved.";
en	messages:readonlywarning	s:253:"'''Warning: The database has been locked for maintenance, so you will not be able to save your edits right now.'''\nYou may wish to cut-n-paste the text into a text file and save it for later.\n\nThe administrator who locked it offered this explanation: $1";
en	messages:protectedpagewarning	s:159:"'''Warning: This page has been protected so that only users with administrator privileges can edit it.'''\nThe latest log entry is provided below for reference:";
en	messages:semiprotectedpagewarning	s:137:"'''Note:''' This page has been protected so that only registered users can edit it.\nThe latest log entry is provided below for reference:";
en	messages:cascadeprotectedwarning	s:189:"'''Warning:''' This page has been protected so that only users with administrator privileges can edit it, because it is included in the following cascade-protected {{PLURAL:$1|page|pages}}:";
en	messages:titleprotectedwarning	s:174:"'''Warning: This page has been protected so that [[Special:ListGroupRights|specific rights]] are needed to create it.'''\nThe latest log entry is provided below for reference:";
en	messages:templatesused	s:51:"{{PLURAL:$1|Template|Templates}} used on this page:";
en	messages:templatesusedpreview	s:54:"{{PLURAL:$1|Template|Templates}} used in this preview:";
en	messages:templatesusedsection	s:54:"{{PLURAL:$1|Template|Templates}} used in this section:";
en	messages:template-protected	s:11:"(protected)";
en	messages:template-semiprotected	s:16:"(semi-protected)";
en	messages:hiddencategories	s:78:"This page is a member of {{PLURAL:$1|1 hidden category|$1 hidden categories}}:";
en	messages:edittools	s:61:"<!-- Text here will be shown below edit and upload forms. -->";
en	messages:nocreatetitle	s:21:"Page creation limited";
en	messages:nocreatetext	s:157:"{{SITENAME}} has restricted the ability to create new pages.\nYou can go back and edit an existing page, or [[Special:UserLogin|log in or create an account]].";
en	messages:nocreate-loggedin	s:47:"You do not have permission to create new pages.";
en	messages:sectioneditnotsupported-title	s:29:"Section editing not supported";
en	messages:sectioneditnotsupported-text	s:46:"Section editing is not supported in this page.";
en	messages:permissionserrors	s:18:"Permissions errors";
en	messages:permissionserrorstext	s:86:"You do not have permission to do that, for the following {{PLURAL:$1|reason|reasons}}:";
en	messages:permissionserrorstext-withaction	s:81:"You do not have permission to $2, for the following {{PLURAL:$1|reason|reasons}}:";
en	messages:recreate-moveddeleted-warn	s:222:"'''Warning: You are recreating a page that was previously deleted.'''\n\nYou should consider whether it is appropriate to continue editing this page.\nThe deletion and move log for this page are provided here for convenience:";
en	messages:moveddeleted-notice	s:100:"This page has been deleted.\nThe deletion and move log for the page are provided below for reference.";
en	messages:log-fulllog	s:13:"View full log";
en	messages:edit-hook-aborted	s:45:"Edit aborted by hook.\nIt gave no explanation.";
en	messages:edit-gone-missing	s:59:"Could not update the page.\nIt appears to have been deleted.";
en	messages:edit-conflict	s:14:"Edit conflict.";
en	messages:edit-no-change	s:62:"Your edit was ignored, because no change was made to the text.";
en	messages:edit-already-exists	s:47:"Could not create a new page.\nIt already exists.";
en	messages:addsection-preload	s:0:"";
en	messages:addsection-editintro	s:0:"";
en	messages:expensive-parserfunction-warning	s:183:"'''Warning:''' This page contains too many expensive parser function calls.\n\nIt should have less than $2 {{PLURAL:$2|call|calls}}, there {{PLURAL:$1|is now $1 call|are now $1 calls}}.";
en	messages:expensive-parserfunction-category	s:51:"Pages with too many expensive parser function calls";
en	messages:post-expand-template-inclusion-warning	s:87:"'''Warning:''' Template include size is too large.\nSome templates will not be included.";
en	messages:post-expand-template-inclusion-category	s:45:"Pages where template include size is exceeded";
en	messages:post-expand-template-argument-warning	s:137:"'''Warning:''' This page contains at least one template argument which has a too large expansion size.\nThese arguments have been omitted.";
en	messages:post-expand-template-argument-category	s:43:"Pages containing omitted template arguments";
en	messages:parser-template-loop-warning	s:30:"Template loop detected: [[$1]]";
en	messages:parser-template-recursion-depth-warning	s:44:"Template recursion depth limit exceeded ($1)";
en	messages:language-converter-depth-warning	s:44:"Language converter depth limit exceeded ($1)";
en	messages:undo-success	s:161:"The edit can be undone.\nPlease check the comparison below to verify that this is what you want to do, and then save the changes below to finish undoing the edit.";
en	messages:undo-failure	s:67:"The edit could not be undone due to conflicting intermediate edits.";
en	messages:undo-norev	s:70:"The edit could not be undone because it does not exist or was deleted.";
en	messages:undo-summary	s:75:"Undo revision $1 by [[Special:Contributions/$2|$2]] ([[User talk:$2|talk]])";
en	messages:cantcreateaccounttitle	s:21:"Cannot create account";
en	messages:cantcreateaccount-text	s:118:"Account creation from this IP address ('''$1''') has been blocked by [[User:$3|$3]].\n\nThe reason given by $3 is ''$2''";
en	messages:viewpagelogs	s:23:"View logs for this page";
en	messages:nohistory	s:39:"There is no edit history for this page.";
en	messages:currentrev	s:15:"Latest revision";
en	messages:currentrev-asof	s:24:"Latest revision as of $1";
en	messages:revisionasof	s:17:"Revision as of $1";
en	messages:revision-info	s:23:"Revision as of $1 by $2";
en	messages:revision-info-current	s:1:"-";
en	messages:revision-nav	s:65:"($1) $2{{int:pipe-separator}}$3 ($4){{int:pipe-separator}}$5 ($6)";
en	messages:previousrevision	s:18:"← Older revision";
en	messages:nextrevision	s:18:"Newer revision →";
en	messages:currentrevisionlink	s:15:"Latest revision";
en	messages:cur	s:3:"cur";
en	messages:next	s:4:"next";
en	messages:last	s:4:"prev";
en	messages:page_first	s:5:"first";
en	messages:page_last	s:4:"last";
en	messages:histlegend	s:279:"Diff selection: mark the radio boxes of the revisions to compare and hit enter or the button at the bottom.<br />\nLegend: '''({{int:cur}})''' = difference with latest revision, '''({{int:last}})''' = difference with preceding revision, '''{{int:minoreditletter}}''' = minor edit.";
en	messages:history-fieldset-title	s:14:"Browse history";
en	messages:history-show-deleted	s:12:"Deleted only";
en	messages:history_copyright	s:1:"-";
en	messages:histfirst	s:8:"Earliest";
en	messages:histlast	s:6:"Latest";
en	messages:historysize	s:31:"({{PLURAL:$1|1 byte|$1 bytes}})";
en	messages:historyempty	s:7:"(empty)";
en	messages:history-feed-title	s:16:"Revision history";
en	messages:history-feed-description	s:42:"Revision history for this page on the wiki";
en	messages:history-feed-item-nocomment	s:8:"$1 at $2";
en	messages:history-feed-empty	s:155:"The requested page does not exist.\nIt may have been deleted from the wiki, or renamed.\nTry [[Special:Search|searching on the wiki]] for relevant new pages.";
en	messages:rev-deleted-comment	s:22:"(edit summary removed)";
en	messages:rev-deleted-user	s:18:"(username removed)";
en	messages:rev-deleted-event	s:20:"(log action removed)";
en	messages:rev-deleted-user-contribs	s:65:"[username or IP address removed - edit hidden from contributions]";
en	messages:rev-deleted-text-permission	s:145:"This page revision has been '''deleted'''.\nDetails can be found in the [{{fullurl:{{#Special:Log}}/delete|page={{FULLPAGENAMEE}}}} deletion log].";
en	messages:rev-deleted-text-unhide	s:227:"This page revision has been '''deleted'''.\nDetails can be found in the [{{fullurl:{{#Special:Log}}/delete|page={{FULLPAGENAMEE}}}} deletion log].\nAs an administrator you can still [$1 view this revision] if you wish to proceed.";
en	messages:rev-suppressed-text-unhide	s:235:"This page revision has been '''suppressed'''.\nDetails can be found in the [{{fullurl:{{#Special:Log}}/suppress|page={{FULLPAGENAMEE}}}} suppression log].\nAs an administrator you can still [$1 view this revision] if you wish to proceed.";
en	messages:rev-deleted-text-view	s:182:"This page revision has been '''deleted'''.\nAs an administrator you can view it; details can be found in the [{{fullurl:{{#Special:Log}}/delete|page={{FULLPAGENAMEE}}}} deletion log].";
en	messages:rev-suppressed-text-view	s:190:"This page revision has been '''suppressed'''.\nAs an administrator you can view it; details can be found in the [{{fullurl:{{#Special:Log}}/suppress|page={{FULLPAGENAMEE}}}} suppression log].";
en	messages:rev-deleted-no-diff	s:181:"You cannot view this diff because one of the revisions has been '''deleted'''.\nDetails can be found in the [{{fullurl:{{#Special:Log}}/delete|page={{FULLPAGENAMEE}}}} deletion log].";
en	messages:rev-suppressed-no-diff	s:78:"You cannot view this diff because one of the revisions has been '''deleted'''.";
en	messages:rev-deleted-unhide-diff	s:238:"One of the revisions of this diff has been '''deleted'''.\nDetails can be found in the [{{fullurl:{{#Special:Log}}/delete|page={{FULLPAGENAMEE}}}} deletion log].\nAs an administrator you can still [$1 view this diff] if you wish to proceed.";
en	messages:rev-suppressed-unhide-diff	s:246:"One of the revisions of this diff has been '''suppressed'''.\nDetails can be found in the [{{fullurl:{{#Special:Log}}/suppress|page={{FULLPAGENAMEE}}}} suppression log].\nAs an administrator you can still [$1 view this diff] if you wish to proceed.";
en	messages:rev-deleted-diff-view	s:204:"One of the revisions of this diff has been '''deleted'''.\nAs an administrator you can view this diff; details can be found in the [{{fullurl:{{#Special:Log}}/delete|page={{FULLPAGENAMEE}}}} deletion log].";
en	messages:revdelete-offender	s:16:"Revision author:";
en	messages:suppressionlog	s:15:"Suppression log";
en	messages:rev-suppressed-diff-view	s:212:"One of the revisions of this diff has been '''suppressed'''.\nAs an administrator you can view this diff; details can be found in the [{{fullurl:{{#Special:Log}}/suppress|page={{FULLPAGENAMEE}}}} suppression log].";
en	messages:rev-delundel	s:9:"show/hide";
en	messages:rev-showdeleted	s:4:"show";
en	messages:revisiondelete	s:25:"Delete/undelete revisions";
en	messages:revdelete-nooldid-title	s:23:"Invalid target revision";
en	messages:revdelete-nooldid-text	s:167:"You have either not specified a target revision(s) to perform this\nfunction, the specified revision does not exist, or you are attempting to hide the current revision.";
en	messages:revdelete-nologtype-title	s:17:"No log type given";
en	messages:revdelete-nologtype-text	s:60:"You have not specified a log type to perform this action on.";
en	messages:revdelete-nologid-title	s:17:"Invalid log entry";
en	messages:mergehistory-go	s:20:"Show mergeable edits";
en	messages:revdelete-nologid-text	s:112:"You have either not specified a target log event to perform this function or the specified entry does not exist.";
en	messages:revdelete-no-file	s:34:"The file specified does not exist.";
en	messages:revdelete-show-file-confirm	s:97:"Are you sure you want to view a deleted revision of the file "<nowiki>$1</nowiki>" from $2 at $3?";
en	messages:revdelete-show-file-submit	s:3:"Yes";
en	messages:revdelete-selected	s:68:"'''{{PLURAL:$2|Selected revision|Selected revisions}} of [[:$1]]:'''";
en	messages:logdelete-selected	s:59:"'''{{PLURAL:$1|Selected log event|Selected log events}}:'''";
en	messages:revdelete-text	s:325:"'''Deleted revisions and events will still appear in the page history and logs, but parts of their content will be inaccessible to the public.'''\nOther administrators on {{SITENAME}} will still be able to access the hidden content and can undelete it again through this same interface, unless additional restrictions are set.";
en	messages:revdelete-confirm	s:168:"Please confirm that you intend to do this, that you understand the consequences, and that you are doing this in accordance with [[{{MediaWiki:Policy-url}}|the policy]].";
en	messages:revdelete-suppress-text	s:209:"Suppression should '''only''' be used for the following cases:\n* Potentially libelous information\n* Inappropriate personal information\n*: ''home addresses and telephone numbers, social security numbers, etc.''";
en	messages:revdelete-legend	s:27:"Set visibility restrictions";
en	messages:revdelete-hide-text	s:18:"Hide revision text";
en	messages:revdelete-hide-image	s:17:"Hide file content";
en	messages:revdelete-hide-name	s:22:"Hide action and target";
en	messages:revdelete-hide-comment	s:17:"Hide edit summary";
en	messages:revdelete-hide-user	s:33:"Hide editor's username/IP address";
en	messages:revdelete-hide-restricted	s:51:"Suppress data from administrators as well as others";
en	messages:revdelete-radio-same	s:15:"(do not change)";
en	messages:revdelete-radio-set	s:3:"Yes";
en	messages:revdelete-radio-unset	s:2:"No";
en	messages:revdelete-suppress	s:51:"Suppress data from administrators as well as others";
en	messages:revdelete-unsuppress	s:41:"Remove restrictions on restored revisions";
en	messages:revdelete-log	s:7:"Reason:";
en	messages:revdelete-submit	s:50:"Apply to selected {{PLURAL:$1|revision|revisions}}";
en	messages:revdelete-logentry	s:39:"changed revision visibility of "[[$1]]"";
en	messages:logdelete-logentry	s:36:"changed event visibility of "[[$1]]"";
en	messages:revdelete-success	s:47:"'''Revision visibility successfully updated.'''";
en	messages:revdelete-failure	s:50:"'''Revision visibility could not be updated:'''\n$1";
en	messages:logdelete-success	s:38:"'''Log visibility successfully set.'''";
en	messages:logdelete-failure	s:41:"'''Log visibility could not be set:'''\n$1";
en	messages:revdel-restore	s:17:"change visibility";
en	messages:revdel-restore-deleted	s:17:"deleted revisions";
en	messages:revdel-restore-visible	s:17:"visible revisions";
en	messages:pagehist	s:12:"Page history";
en	messages:deletedhist	s:15:"Deleted history";
en	messages:revdelete-content	s:7:"content";
en	messages:revdelete-summary	s:12:"edit summary";
en	messages:revdelete-uname	s:8:"username";
en	messages:revdelete-restricted	s:38:"applied restrictions to administrators";
en	messages:revdelete-unrestricted	s:39:"removed restrictions for administrators";
en	messages:revdelete-hid	s:6:"hid $1";
en	messages:revdelete-unhid	s:8:"unhid $1";
en	messages:revdelete-log-message	s:42:"$1 for $2 {{PLURAL:$2|revision|revisions}}";
en	messages:logdelete-log-message	s:36:"$1 for $2 {{PLURAL:$2|event|events}}";
en	messages:revdelete-hide-current	s:86:"Error hiding the item dated $2, $1: this is the current revision.\nIt cannot be hidden.";
en	messages:revdelete-show-no-access	s:106:"Error showing the item dated $2, $1: this item has been marked "restricted".\nYou do not have access to it.";
en	messages:revdelete-modify-no-access	s:108:"Error modifying the item dated $2, $1: this item has been marked "restricted".\nYou do not have access to it.";
en	messages:revdelete-modify-missing	s:60:"Error modifying item ID $1: it is missing from the database!";
en	messages:revdelete-no-change	s:83:"'''Warning:''' the item dated $2, $1 already had the requested visibility settings.";
en	messages:revdelete-concurrent-change	s:151:"Error modifying the item dated $2, $1: its status appears to have been changed by someone else while you attempted to modify it.\nPlease check the logs.";
en	messages:revdelete-only-restricted	s:149:"Error hiding the item dated $2, $1: you cannot suppress items from view by administrators without also selecting one of the other visibility options.";
en	messages:revdelete-reason-dropdown	s:119:"*Common delete reasons\n** Copyright violation\n** Inappropriate personal information\n** Potentially libelous information";
en	messages:revdelete-otherreason	s:24:"Other/additional reason:";
en	messages:revdelete-reasonotherlist	s:12:"Other reason";
en	messages:revdelete-edit-reasonlist	s:19:"Edit delete reasons";
en	messages:suppressionlogtext	s:186:"Below is a list of deletions and blocks involving content hidden from administrators.\nSee the [[Special:IPBlockList|IP block list]] for the list of currently operational bans and blocks.";
en	messages:mergehistory	s:20:"Merge page histories";
en	messages:mergehistory-header	s:156:"This page lets you merge revisions of the history of one source page into a newer page.\nMake sure that this change will maintain historical page continuity.";
en	messages:mergehistory-box	s:29:"Merge revisions of two pages:";
en	messages:mergehistory-from	s:12:"Source page:";
en	messages:mergehistory-into	s:17:"Destination page:";
en	messages:mergehistory-list	s:22:"Mergeable edit history";
en	messages:mergehistory-merge	s:224:"The following revisions of [[:$1]] can be merged into [[:$2]].\nUse the radio button column to merge in only the revisions created at and before the specified time.\nNote that using the navigation links will reset this column.";
en	messages:mergehistory-empty	s:27:"No revisions can be merged.";
en	messages:mergehistory-success	s:80:"$3 {{PLURAL:$3|revision|revisions}} of [[:$1]] successfully merged into [[:$2]].";
en	messages:mergehistory-fail	s:77:"Unable to perform history merge, please recheck the page and time parameters.";
en	messages:mergehistory-no-source	s:30:"Source page $1 does not exist.";
en	messages:mergehistory-no-destination	s:35:"Destination page $1 does not exist.";
en	messages:mergehistory-invalid-source	s:34:"Source page must be a valid title.";
en	messages:mergehistory-invalid-destination	s:39:"Destination page must be a valid title.";
en	messages:mergehistory-autocomment	s:27:"Merged [[:$1]] into [[:$2]]";
en	messages:mergehistory-comment	s:31:"Merged [[:$1]] into [[:$2]]: $3";
en	messages:mergehistory-same-destination	s:47:"Source and destination pages cannot be the same";
en	messages:mergehistory-reason	s:7:"Reason:";
en	messages:mergelog	s:9:"Merge log";
en	messages:pagemerge-logentry	s:46:"merged [[$1]] into [[$2]] (revisions up to $3)";
en	messages:revertmerge	s:7:"Unmerge";
en	messages:mergelogpagetext	s:75:"Below is a list of the most recent merges of one page history into another.";
en	messages:history-title	s:24:"Revision history of "$1"";
en	messages:difference	s:30:"(Difference between revisions)";
en	messages:difference-multipage	s:26:"(Difference between pages)";
en	messages:lineno	s:8:"Line $1:";
en	messages:compareselectedversions	s:26:"Compare selected revisions";
en	messages:showhideselectedversions	s:28:"Show/hide selected revisions";
en	messages:editundo	s:4:"undo";
en	messages:diff-multi	s:112:"({{PLURAL:$1|One intermediate revision|$1 intermediate revisions}} by {{PLURAL:$2|one user|$2 users}} not shown)";
en	messages:diff-multi-manyusers	s:118:"({{PLURAL:$1|One intermediate revision|$1 intermediate revisions}} by more than $2 {{PLURAL:$2|user|users}} not shown)";
en	messages:search-summary	s:0:"";
en	messages:searchresults	s:14:"Search results";
en	messages:searchresults-title	s:23:"Search results for "$1"";
en	messages:searchresulttext	s:95:"For more information about searching {{SITENAME}}, see [[{{MediaWiki:Helppage}}|{{int:help}}]].";
en	messages:searchsubtitle	s:166:"You searched for '''[[:$1]]''' ([[Special:Prefixindex/$1|all pages starting with "$1"]]{{int:pipe-separator}}[[Special:WhatLinksHere/$1|all pages that link to "$1"]])";
en	messages:searchsubtitleinvalid	s:25:"You searched for '''$1'''";
en	messages:toomanymatches	s:60:"Too many matches were returned, please try a different query";
en	messages:titlematches	s:18:"Page title matches";
en	messages:notitlematches	s:21:"No page title matches";
en	messages:textmatches	s:17:"Page text matches";
en	messages:notextmatches	s:20:"No page text matches";
en	messages:prevn	s:25:"previous {{PLURAL:$1|$1}}";
en	messages:nextn	s:21:"next {{PLURAL:$1|$1}}";
en	messages:prevn-title	s:40:"Previous $1 {{PLURAL:$1|result|results}}";
en	messages:nextn-title	s:36:"Next $1 {{PLURAL:$1|result|results}}";
en	messages:shown-title	s:45:"Show $1 {{PLURAL:$1|result|results}} per page";
en	messages:viewprevnext	s:40:"View ($1 {{int:pipe-separator}} $2) ($3)";
en	messages:searchmenu-legend	s:14:"Search options";
en	messages:searchmenu-exists	s:51:"'''There is a page named "[[:$1]]" on this wiki.'''";
en	messages:searchmenu-new	s:45:"'''Create the page "[[:$1]]" on this wiki!'''";
en	messages:searchmenu-new-nocreate	s:0:"";
en	messages:searchhelp-url	s:13:"Help:Contents";
en	messages:searchmenu-prefix	s:56:"[[Special:PrefixIndex/$1|Browse pages with this prefix]]";
en	messages:searchmenu-help	s:46:"[[{{MediaWiki:Searchhelp-url}}|{{int:help}}]]?";
en	messages:searchprofile-articles	s:13:"Content pages";
en	messages:searchprofile-project	s:22:"Help and Project pages";
en	messages:searchprofile-images	s:10:"Multimedia";
en	messages:searchprofile-everything	s:10:"Everything";
en	messages:searchprofile-advanced	s:8:"Advanced";
en	messages:searchprofile-articles-tooltip	s:12:"Search in $1";
en	messages:searchprofile-project-tooltip	s:12:"Search in $1";
en	messages:searchprofile-images-tooltip	s:16:"Search for files";
en	messages:searchprofile-everything-tooltip	s:44:"Search all of content (including talk pages)";
en	messages:searchprofile-advanced-tooltip	s:27:"Search in custom namespaces";
en	messages:search-result-size	s:34:"$1 ({{PLURAL:$2|1 word|$2 words}})";
en	messages:search-result-category-size	s:111:"{{PLURAL:$1|1 member|$1 members}} ({{PLURAL:$2|1 subcategory|$2 subcategories}}, {{PLURAL:$3|1 file|$3 files}})";
en	messages:search-result-score	s:14:"Relevance: $1%";
en	messages:search-redirect	s:13:"(redirect $1)";
en	messages:search-section	s:12:"(section $1)";
en	messages:search-suggest	s:16:"Did you mean: $1";
en	messages:search-interwiki-caption	s:15:"Sister projects";
en	messages:search-interwiki-default	s:11:"$1 results:";
en	messages:search-interwiki-custom	s:0:"";
en	messages:search-interwiki-more	s:6:"(more)";
en	messages:search-mwsuggest-enabled	s:16:"with suggestions";
en	messages:search-mwsuggest-disabled	s:14:"no suggestions";
en	messages:search-relatedarticle	s:7:"Related";
en	messages:mwsuggest-disable	s:24:"Disable AJAX suggestions";
en	messages:searcheverything-enable	s:24:"Search in all namespaces";
en	messages:searchrelated	s:7:"related";
en	messages:searchall	s:3:"all";
en	messages:showingresults	s:90:"Showing below up to {{PLURAL:$1|'''1''' result|'''$1''' results}} starting with #'''$2'''.";
en	messages:showingresultsnum	s:84:"Showing below {{PLURAL:$3|'''1''' result|'''$3''' results}} starting with #'''$2'''.";
en	messages:showingresultsheader	s:88:"{{PLURAL:$5|Result '''$1''' of '''$3'''|Results '''$1 - $2''' of '''$3'''}} for '''$4'''";
en	messages:prefs-namespaces	s:10:"Namespaces";
en	messages:nonefound	s:198:"'''Note''': Only some namespaces are searched by default.\nTry prefixing your query with ''all:'' to search all content (including talk pages, templates, etc), or use the desired namespace as prefix.";
en	messages:search-nonefound	s:41:"There were no results matching the query.";
en	messages:powersearch	s:15:"Advanced search";
en	messages:powersearch-legend	s:15:"Advanced search";
en	messages:powersearch-ns	s:21:"Search in namespaces:";
en	messages:powersearch-redir	s:14:"List redirects";
en	messages:powersearch-field	s:10:"Search for";
en	messages:powersearch-togglelabel	s:6:"Check:";
en	messages:powersearch-toggleall	s:3:"All";
en	messages:powersearch-togglenone	s:4:"None";
en	messages:search-external	s:15:"External search";
en	messages:searchdisabled	s:143:"{{SITENAME}} search is disabled.\nYou can search via Google in the meantime.\nNote that their indexes of {{SITENAME}} content may be out of date.";
en	messages:googlesearch	s:659:"<form method="get" action="http://www.google.com/search" id="googlesearch">\n    <input type="hidden" name="domains" value="{{SERVER}}" />\n    <input type="hidden" name="num" value="50" />\n    <input type="hidden" name="ie" value="$2" />\n    <input type="hidden" name="oe" value="$2" />\n\n    <input type="text" name="q" size="31" maxlength="255" value="$1" />\n    <input type="submit" name="btnG" value="$3" />\n  <div>\n    <input type="radio" name="sitesearch" id="gwiki" value="{{SERVER}}" checked="checked" /><label for="gwiki">{{SITENAME}}</label>\n    <input type="radio" name="sitesearch" id="gWWW" value="" /><label for="gWWW">WWW</label>\n  </div>\n</form>";
en	messages:opensearch-desc	s:34:"{{SITENAME}} ({{CONTENTLANGUAGE}})";
en	messages:qbsettings	s:8:"Quickbar";
en	messages:qbsettings-none	s:4:"None";
en	messages:qbsettings-fixedleft	s:10:"Fixed left";
en	messages:qbsettings-fixedright	s:11:"Fixed right";
en	messages:qbsettings-floatingleft	s:13:"Floating left";
en	messages:qbsettings-floatingright	s:14:"Floating right";
en	messages:preferences	s:11:"Preferences";
en	messages:preferences-summary	s:0:"";
en	messages:mypreferences	s:14:"My preferences";
en	messages:prefs-edits	s:16:"Number of edits:";
en	messages:prefsnologin	s:13:"Not logged in";
en	messages:prefsnologintext	s:127:"You must be <span class="plainlinks">[{{fullurl:{{#Special:UserLogin}}|returnto=$1}} logged in]</span> to set user preferences.";
en	messages:changepassword	s:15:"Change password";
en	messages:prefs-skin	s:4:"Skin";
en	messages:skin-preview	s:7:"Preview";
en	messages:prefs-math	s:4:"Math";
en	messages:datedefault	s:13:"No preference";
en	messages:prefs-datetime	s:13:"Date and time";
en	messages:prefs-personal	s:12:"User profile";
en	messages:prefs-rc	s:14:"Recent changes";
en	messages:prefs-watchlist	s:9:"Watchlist";
en	messages:prefs-watchlist-days	s:26:"Days to show in watchlist:";
en	messages:prefs-watchlist-days-max	s:14:"Maximum 7 days";
en	messages:prefs-watchlist-edits	s:56:"Maximum number of changes to show in expanded watchlist:";
en	messages:prefs-watchlist-edits-max	s:20:"Maximum number: 1000";
en	messages:prefs-watchlist-token	s:16:"Watchlist token:";
en	messages:prefs-misc	s:4:"Misc";
en	messages:prefs-resetpass	s:15:"Change password";
en	messages:prefs-email	s:14:"E-mail options";
en	messages:prefs-rendering	s:10:"Appearance";
en	messages:saveprefs	s:4:"Save";
en	messages:resetprefs	s:21:"Clear unsaved changes";
en	messages:restoreprefs	s:28:"Restore all default settings";
en	messages:prefs-editing	s:7:"Editing";
en	messages:prefs-edit-boxsize	s:24:"Size of the edit window.";
en	messages:rows	s:5:"Rows:";
en	messages:columns	s:8:"Columns:";
en	messages:searchresultshead	s:6:"Search";
en	messages:resultsperpage	s:14:"Hits per page:";
en	messages:contextlines	s:14:"Lines per hit:";
en	messages:contextchars	s:17:"Context per line:";
en	messages:stub-threshold	s:72:"Threshold for <a href="#" class="stub">stub link</a> formatting (bytes):";
en	messages:stub-threshold-disabled	s:8:"Disabled";
en	messages:recentchangesdays	s:31:"Days to show in recent changes:";
en	messages:recentchangesdays-max	s:33:"Maximum $1 {{PLURAL:$1|day|days}}";
en	messages:recentchangescount	s:35:"Number of edits to show by default:";
en	messages:prefs-help-recentchangescount	s:55:"This includes recent changes, page histories, and logs.";
en	messages:prefs-help-watchlist-token	s:237:"Filling in this field with a secret key will generate an RSS feed for your watchlist.\nAnyone who knows the key in this field will be able to read your watchlist, so choose a secure value.\nHere's a randomly-generated value you can use: $1";
en	messages:savedprefs	s:33:"Your preferences have been saved.";
en	messages:allpages-summary	s:0:"";
en	messages:timezonelegend	s:10:"Time zone:";
en	messages:localtime	s:11:"Local time:";
en	messages:timezoneuseserverdefault	s:18:"Use server default";
en	messages:timezoneuseoffset	s:22:"Other (specify offset)";
en	messages:timezoneoffset	s:9:"Offset¹:";
en	messages:servertime	s:12:"Server time:";
en	messages:guesstimezone	s:20:"Fill in from browser";
en	messages:timezoneregion-africa	s:6:"Africa";
en	messages:timezoneregion-america	s:7:"America";
en	messages:timezoneregion-antarctica	s:10:"Antarctica";
en	messages:timezoneregion-arctic	s:6:"Arctic";
en	messages:timezoneregion-asia	s:4:"Asia";
en	messages:timezoneregion-atlantic	s:14:"Atlantic Ocean";
en	messages:timezoneregion-australia	s:9:"Australia";
en	messages:timezoneregion-europe	s:6:"Europe";
en	messages:timezoneregion-indian	s:12:"Indian Ocean";
en	messages:timezoneregion-pacific	s:13:"Pacific Ocean";
en	messages:allowemail	s:30:"Enable e-mail from other users";
en	messages:prefs-searchoptions	s:14:"Search options";
en	messages:undeletereset	s:5:"Reset";
en	messages:defaultns	s:37:"Otherwise search in these namespaces:";
en	messages:default	s:7:"default";
en	messages:prefs-files	s:5:"Files";
en	messages:prefs-custom-css	s:10:"Custom CSS";
en	messages:prefs-custom-js	s:17:"Custom JavaScript";
en	messages:prefs-common-css-js	s:36:"Shared CSS/JavaScript for all skins:";
en	messages:prefs-reset-intro	s:92:"You can use this page to reset your preferences to the site defaults.\nThis cannot be undone.";
en	messages:prefs-emailconfirm-label	s:20:"E-mail confirmation:";
en	messages:prefs-textboxsize	s:22:"Size of editing window";
en	messages:youremail	s:7:"E-mail:";
en	messages:username	s:9:"Username:";
en	messages:uid	s:8:"User ID:";
en	messages:prefs-memberingroups	s:37:"Member of {{PLURAL:$1|group|groups}}:";
en	messages:prefs-memberingroups-type	s:2:"$1";
en	messages:prefs-registration	s:18:"Registration time:";
en	messages:prefs-registration-date-time	s:2:"$1";
en	messages:yourrealname	s:10:"Real name:";
en	messages:yourlanguage	s:9:"Language:";
en	messages:yourvariant	s:8:"Variant:";
en	messages:yournick	s:14:"New signature:";
en	messages:prefs-help-signature	s:129:"Comments on talk pages should be signed with "<nowiki>~~~~</nowiki>" which will be converted into your signature and a timestamp.";
en	messages:badsig	s:39:"Invalid raw signature.\nCheck HTML tags.";
en	messages:badsiglength	s:96:"Your signature is too long.\nIt must not be more than $1 {{PLURAL:$1|character|characters}} long.";
en	messages:yourgender	s:7:"Gender:";
en	messages:gender-unknown	s:11:"Unspecified";
en	messages:gender-male	s:4:"Male";
en	messages:gender-female	s:6:"Female";
en	messages:prefs-help-gender	s:94:"Optional: used for gender-correct addressing by the software.\nThis information will be public.";
en	messages:email	s:6:"E-mail";
en	messages:prefs-help-realname	s:111:"Real name is optional.\nIf you choose to provide it, this will be used for giving you attribution for your work.";
en	messages:prefs-help-email	s:213:"E-mail address is optional, but is needed for password resets, should you forget your password.\nYou can also choose to let others contact you through your user or talk page without needing to reveal your identity.";
en	messages:prefs-help-email-required	s:27:"E-mail address is required.";
en	messages:prefs-info	s:17:"Basic information";
en	messages:prefs-i18n	s:20:"Internationalisation";
en	messages:prefs-signature	s:9:"Signature";
en	messages:prefs-dateformat	s:11:"Date format";
en	messages:prefs-timeoffset	s:11:"Time offset";
en	messages:prefs-advancedediting	s:16:"Advanced options";
en	messages:prefs-advancedrc	s:16:"Advanced options";
en	messages:prefs-advancedrendering	s:16:"Advanced options";
en	messages:prefs-advancedsearchoptions	s:16:"Advanced options";
en	messages:prefs-advancedwatchlist	s:16:"Advanced options";
en	messages:prefs-displayrc	s:15:"Display options";
en	messages:prefs-displaysearchoptions	s:15:"Display options";
en	messages:prefs-displaywatchlist	s:15:"Display options";
en	messages:prefs-diffs	s:5:"Diffs";
en	messages:email-address-validity-valid	s:28:"E-mail address appears valid";
en	messages:email-address-validity-invalid	s:28:"Enter a valid e-mail address";
en	messages:userrights	s:22:"User rights management";
en	messages:userrights-summary	s:0:"";
en	messages:userrights-lookup-user	s:18:"Manage user groups";
en	messages:userrights-user-editname	s:17:"Enter a username:";
en	messages:editusergroup	s:16:"Edit user groups";
en	messages:editinguser	s:164:"Changing user rights of user '''[[User:$1|$1]]''' ([[User talk:$1|{{int:talkpagelinktext}}]]{{int:pipe-separator}}[[Special:Contributions/$1|{{int:contribslink}}]])";
en	messages:userrights-editusergroup	s:16:"Edit user groups";
en	messages:saveusergroups	s:16:"Save user groups";
en	messages:userrights-groupsmember	s:10:"Member of:";
en	messages:userrights-groupsmember-auto	s:19:"Implicit member of:";
en	messages:userrights-groups-help	s:234:"You may alter the groups this user is in:\n* A checked box means the user is in that group.\n* An unchecked box means the user is not in that group.\n* A * indicates that you cannot remove the group once you have added it, or vice versa.";
en	messages:userrights-reason	s:7:"Reason:";
en	messages:userrights-no-interwiki	s:62:"You do not have permission to edit user rights on other wikis.";
en	messages:userrights-nodatabase	s:43:"Database $1 does not exist or is not local.";
en	messages:right-reset-passwords	s:28:"Reset other users' passwords";
en	messages:userrights-nologin	s:90:"You must [[Special:UserLogin|log in]] with an administrator account to assign user rights.";
en	messages:userrights-notallowed	s:60:"Your account does not have permission to assign user rights.";
en	messages:userrights-changeable-col	s:21:"Groups you can change";
en	messages:userrights-unchangeable-col	s:24:"Groups you cannot change";
en	messages:userrights-irreversible-marker	s:3:"$1*";
en	messages:group	s:6:"Group:";
en	messages:group-user	s:5:"Users";
en	messages:group-autoconfirmed	s:19:"Autoconfirmed users";
en	messages:group-bot	s:4:"Bots";
en	messages:group-sysop	s:14:"Administrators";
en	messages:group-bureaucrat	s:11:"Bureaucrats";
en	messages:group-suppress	s:10:"Oversights";
en	messages:group-all	s:5:"(all)";
en	messages:group-user-member	s:4:"user";
en	messages:group-autoconfirmed-member	s:18:"autoconfirmed user";
en	messages:group-bot-member	s:3:"bot";
en	messages:group-sysop-member	s:13:"administrator";
en	messages:group-bureaucrat-member	s:10:"bureaucrat";
en	messages:group-suppress-member	s:9:"oversight";
en	messages:grouppage-user	s:20:"{{ns:project}}:Users";
en	messages:grouppage-autoconfirmed	s:34:"{{ns:project}}:Autoconfirmed users";
en	messages:grouppage-bot	s:19:"{{ns:project}}:Bots";
en	messages:grouppage-sysop	s:29:"{{ns:project}}:Administrators";
en	messages:grouppage-bureaucrat	s:26:"{{ns:project}}:Bureaucrats";
en	messages:grouppage-suppress	s:24:"{{ns:project}}:Oversight";
en	messages:right-read	s:10:"Read pages";
en	messages:right-edit	s:10:"Edit pages";
en	messages:right-createpage	s:45:"Create pages (which are not discussion pages)";
en	messages:right-createtalk	s:23:"Create discussion pages";
en	messages:right-createaccount	s:24:"Create new user accounts";
en	messages:right-minoredit	s:19:"Mark edits as minor";
en	messages:right-move	s:10:"Move pages";
en	messages:right-move-subpages	s:30:"Move pages with their subpages";
en	messages:right-move-rootuserpages	s:20:"Move root user pages";
en	messages:right-movefile	s:10:"Move files";
en	messages:right-suppressredirect	s:56:"Not create redirects from source pages when moving pages";
en	messages:right-upload	s:12:"Upload files";
en	messages:right-reupload	s:24:"Overwrite existing files";
en	messages:right-reupload-own	s:44:"Overwrite existing files uploaded by oneself";
en	messages:right-reupload-shared	s:53:"Override files on the shared media repository locally";
en	messages:right-upload_by_url	s:23:"Upload files from a URL";
en	messages:right-purge	s:52:"Purge the site cache for a page without confirmation";
en	messages:right-autoconfirmed	s:25:"Edit semi-protected pages";
en	messages:right-bot	s:34:"Be treated as an automated process";
en	messages:right-nominornewtalk	s:72:"Not have minor edits to discussion pages trigger the new messages prompt";
en	messages:right-apihighlimits	s:32:"Use higher limits in API queries";
en	messages:right-writeapi	s:20:"Use of the write API";
en	messages:right-delete	s:12:"Delete pages";
en	messages:right-bigdelete	s:33:"Delete pages with large histories";
en	messages:right-deleterevision	s:47:"Delete and undelete specific revisions of pages";
en	messages:right-deletedhistory	s:59:"View deleted history entries, without their associated text";
en	messages:right-deletedtext	s:55:"View deleted text and changes between deleted revisions";
en	messages:right-browsearchive	s:20:"Search deleted pages";
en	messages:right-undelete	s:15:"Undelete a page";
en	messages:right-suppressrevision	s:55:"Review and restore revisions hidden from administrators";
en	messages:right-suppressionlog	s:17:"View private logs";
en	messages:right-block	s:30:"Block other users from editing";
en	messages:right-blockemail	s:32:"Block a user from sending e-mail";
en	messages:right-hideuser	s:43:"Block a username, hiding it from the public";
en	messages:right-ipblock-exempt	s:46:"Bypass IP blocks, auto-blocks and range blocks";
en	messages:right-proxyunbannable	s:34:"Bypass automatic blocks of proxies";
en	messages:right-unblockself	s:18:"Unblock themselves";
en	messages:right-protect	s:49:"Change protection levels and edit protected pages";
en	messages:right-editprotected	s:51:"Edit protected pages (without cascading protection)";
en	messages:right-editinterface	s:23:"Edit the user interface";
en	messages:right-editusercssjs	s:42:"Edit other users' CSS and JavaScript files";
en	messages:right-editusercss	s:27:"Edit other users' CSS files";
en	messages:right-edituserjs	s:34:"Edit other users' JavaScript files";
en	messages:right-rollback	s:72:"Quickly rollback the edits of the last user who edited a particular page";
en	messages:right-markbotedits	s:35:"Mark rolled-back edits as bot edits";
en	messages:right-noratelimit	s:30:"Not be affected by rate limits";
en	messages:right-import	s:29:"Import pages from other wikis";
en	messages:right-importupload	s:31:"Import pages from a file upload";
en	messages:right-patrol	s:31:"Mark others' edits as patrolled";
en	messages:right-autopatrol	s:54:"Have one's own edits automatically marked as patrolled";
en	messages:right-patrolmarks	s:32:"View recent changes patrol marks";
en	messages:right-unwatchedpages	s:30:"View a list of unwatched pages";
en	messages:right-trackback	s:18:"Submit a trackback";
en	messages:right-mergehistory	s:26:"Merge the history of pages";
en	messages:right-userrights	s:20:"Edit all user rights";
en	messages:right-userrights-interwiki	s:40:"Edit user rights of users on other wikis";
en	messages:right-siteadmin	s:28:"Lock and unlock the database";
en	messages:right-override-export-depth	s:54:"Export pages including linked pages up to a depth of 5";
en	messages:right-sendemail	s:26:"Send e-mail to other users";
en	messages:rightslog	s:15:"User rights log";
en	messages:rightslogtext	s:40:"This is a log of changes to user rights.";
en	messages:rightslogentry	s:45:"changed group membership for $1 from $2 to $3";
en	messages:rightsnone	s:6:"(none)";
en	messages:action-read	s:14:"read this page";
en	messages:action-edit	s:14:"edit this page";
en	messages:action-createpage	s:12:"create pages";
en	messages:action-createtalk	s:23:"create discussion pages";
en	messages:action-createaccount	s:24:"create this user account";
en	messages:action-minoredit	s:23:"mark this edit as minor";
en	messages:action-move	s:14:"move this page";
en	messages:action-move-subpages	s:32:"move this page, and its subpages";
en	messages:action-move-rootuserpages	s:20:"move root user pages";
en	messages:action-movefile	s:14:"move this file";
en	messages:action-upload	s:16:"upload this file";
en	messages:action-reupload	s:28:"overwrite this existing file";
en	messages:action-reupload-shared	s:41:"override this file on a shared repository";
en	messages:action-upload_by_url	s:27:"upload this file from a URL";
en	messages:action-writeapi	s:17:"use the write API";
en	messages:action-delete	s:16:"delete this page";
en	messages:action-deleterevision	s:20:"delete this revision";
en	messages:action-deletedhistory	s:32:"view this page's deleted history";
en	messages:action-browsearchive	s:20:"search deleted pages";
en	messages:action-undelete	s:18:"undelete this page";
en	messages:action-suppressrevision	s:39:"review and restore this hidden revision";
en	messages:action-suppressionlog	s:21:"view this private log";
en	messages:action-block	s:28:"block this user from editing";
en	messages:action-protect	s:38:"change protection levels for this page";
en	messages:action-import	s:34:"import this page from another wiki";
en	messages:action-importupload	s:35:"import this page from a file upload";
en	messages:action-patrol	s:30:"mark others' edit as patrolled";
en	messages:action-autopatrol	s:34:"have your edit marked as patrolled";
en	messages:action-unwatchedpages	s:32:"view the list of unwatched pages";
en	messages:action-trackback	s:18:"submit a trackback";
en	messages:action-mergehistory	s:30:"merge the history of this page";
en	messages:action-userrights	s:20:"edit all user rights";
en	messages:action-userrights-interwiki	s:40:"edit user rights of users on other wikis";
en	messages:action-siteadmin	s:27:"lock or unlock the database";
en	messages:nchanges	s:31:"$1 {{PLURAL:$1|change|changes}}";
en	messages:recentchanges	s:14:"Recent changes";
en	messages:recentchanges-url	s:21:"Special:RecentChanges";
en	messages:recentchanges-legend	s:22:"Recent changes options";
en	messages:recentchangestext	s:55:"Track the most recent changes to the wiki on this page.";
en	messages:recentchanges-feed-description	s:55:"Track the most recent changes to the wiki in this feed.";
en	messages:recentchanges-label-newpage	s:28:"This edit created a new page";
en	messages:recentchanges-label-minor	s:20:"This is a minor edit";
en	messages:recentchanges-label-bot	s:32:"This edit was performed by a bot";
en	messages:recentchanges-label-unpatrolled	s:36:"This edit has not yet been patrolled";
en	messages:rcnote	s:126:"Below {{PLURAL:$1|is '''1''' change|are the last '''$1''' changes}} in the last {{PLURAL:$2|day|'''$2''' days}}, as of $5, $4.";
en	messages:rcnotefrom	s:60:"Below are the changes since '''$2''' (up to '''$1''' shown).";
en	messages:rclistfrom	s:33:"Show new changes starting from $1";
en	messages:rcshowhideminor	s:14:"$1 minor edits";
en	messages:rcshowhidebots	s:7:"$1 bots";
en	messages:rcshowhideliu	s:18:"$1 logged-in users";
en	messages:rcshowhideanons	s:18:"$1 anonymous users";
en	messages:rcshowhidepatr	s:18:"$1 patrolled edits";
en	messages:rcshowhidemine	s:11:"$1 my edits";
en	messages:rclinks	s:44:"Show last $1 changes in last $2 days<br />$3";
en	messages:diff	s:4:"diff";
en	messages:hist	s:4:"hist";
en	messages:hide	s:4:"Hide";
en	messages:show	s:4:"Show";
en	messages:minoreditletter	s:1:"m";
en	messages:newpageletter	s:1:"N";
en	messages:boteditletter	s:1:"b";
en	messages:unpatrolledletter	s:1:"!";
en	messages:sectionlink	s:3:"→";
en	messages:number_of_watching_users_RCview	s:4:"[$1]";
en	messages:number_of_watching_users_pageview	s:38:"[$1 watching {{PLURAL:$1|user|users}}]";
en	messages:rc_categories	s:39:"Limit to categories (separate with "|")";
en	messages:rc_categories_any	s:3:"Any";
en	messages:rc-change-size	s:2:"$1";
en	messages:newsectionsummary	s:20:"/* $1 */ new section";
en	messages:rc-enhanced-expand	s:34:"Show details (requires JavaScript)";
en	messages:rc-enhanced-hide	s:12:"Hide details";
en	messages:recentchangeslinked	s:15:"Related changes";
en	messages:recentchangeslinked-feed	s:15:"Related changes";
en	messages:recentchangeslinked-toolbox	s:15:"Related changes";
en	messages:recentchangeslinked-title	s:23:"Changes related to "$1"";
en	messages:recentchangeslinked-backlink	s:6:"← $1";
en	messages:recentchangeslinked-noresult	s:51:"No changes on linked pages during the given period.";
en	messages:recentchangeslinked-summary	s:180:"This is a list of changes made recently to pages linked from a specified page (or to members of a specified category).\nPages on [[Special:Watchlist|your watchlist]] are '''bold'''.";
en	messages:recentchangeslinked-page	s:10:"Page name:";
en	messages:recentchangeslinked-to	s:54:"Show changes to pages linked to the given page instead";
en	messages:upload	s:11:"Upload file";
en	messages:uploadbtn	s:11:"Upload file";
en	messages:reuploaddesc	s:43:"Cancel upload and return to the upload form";
en	messages:upload-tryagain	s:32:"Submit modified file description";
en	messages:uploadnologin	s:13:"Not logged in";
en	messages:uploadnologintext	s:60:"You must be [[Special:UserLogin|logged in]] to upload files.";
en	messages:upload_directory_missing	s:79:"The upload directory ($1) is missing and could not be created by the webserver.";
en	messages:upload_directory_read_only	s:59:"The upload directory ($1) is not writable by the webserver.";
en	messages:uploaderror	s:12:"Upload error";
en	messages:upload-summary	s:0:"";
en	messages:upload-recreate-warning	s:137:"'''Warning: A file by that name has been deleted or moved.'''\n\nThe deletion and move log for this page are provided here for convenience:";
en	messages:uploaddisabledtext	s:26:"File uploads are disabled.";
en	messages:php-uploaddisabledtext	s:72:"File uploads are disabled in PHP.\nPlease check the file_uploads setting.";
en	messages:uploadscripted	s:92:"This file contains HTML or script code that may be erroneously interpreted by a web browser.";
en	messages:uploadvirus	s:38:"The file contains a virus!\nDetails: $1";
en	messages:upload-source	s:11:"Source file";
en	messages:sourcefilename	s:16:"Source filename:";
en	messages:sourceurl	s:11:"Source URL:";
en	messages:destfilename	s:21:"Destination filename:";
en	messages:uploadtext	s:775:"Use the form below to upload files.\nTo view or search previously uploaded files go to the [[Special:FileList|list of uploaded files]], (re)uploads are also logged in the [[Special:Log/upload|upload log]], deletions in the [[Special:Log/delete|deletion log]].\n\nTo include a file in a page, use a link in one of the following forms:\n* '''<tt><nowiki>[[</nowiki>{{ns:file}}<nowiki>:File.jpg]]</nowiki></tt>''' to use the full version of the file\n* '''<tt><nowiki>[[</nowiki>{{ns:file}}<nowiki>:File.png|200px|thumb|left|alt text]]</nowiki></tt>''' to use a 200 pixel wide rendition in a box in the left margin with 'alt text' as description\n* '''<tt><nowiki>[[</nowiki>{{ns:media}}<nowiki>:File.ogg]]</nowiki></tt>''' for directly linking to the file without displaying the file";
en	messages:upload-permitted	s:25:"Permitted file types: $1.";
en	messages:upload-preferred	s:25:"Preferred file types: $1.";
en	messages:upload-prohibited	s:26:"Prohibited file types: $1.";
en	messages:uploadfooter	s:1:"-";
en	messages:uploadlog	s:10:"upload log";
en	messages:uploadlogpage	s:10:"Upload log";
en	messages:uploadlogpagetext	s:126:"Below is a list of the most recent file uploads.\nSee the [[Special:NewFiles|gallery of new files]] for a more visual overview.";
en	messages:filename	s:8:"Filename";
en	messages:filedesc	s:7:"Summary";
en	messages:fileuploadsummary	s:8:"Summary:";
en	messages:filereuploadsummary	s:13:"File changes:";
en	messages:filestatus	s:17:"Copyright status:";
en	messages:filesource	s:7:"Source:";
en	messages:uploadedfiles	s:14:"Uploaded files";
en	messages:ignorewarning	s:35:"Ignore warning and save file anyway";
en	messages:ignorewarnings	s:19:"Ignore any warnings";
en	messages:minlength1	s:39:"File names must be at least one letter.";
en	messages:illegalfilename	s:125:"The filename "$1" contains characters that are not allowed in page titles.\nPlease rename the file and try uploading it again.";
en	messages:badfilename	s:35:"File name has been changed to "$1".";
en	messages:filetype-mime-mismatch	s:40:"File extension does not match MIME type.";
en	messages:filetype-badmime	s:59:"Files of the MIME type "$1" are not allowed to be uploaded.";
en	messages:filetype-bad-ie-mime	s:133:"Cannot upload this file because Internet Explorer would detect it as "$1", which is a disallowed and potentially dangerous file type.";
en	messages:filetype-unwanted-type	s:93:"'''".$1"''' is an unwanted file type.\nPreferred {{PLURAL:$3|file type is|file types are}} $2.";
en	messages:filetype-banned-type	s:97:"'''".$1"''' is not a permitted file type.\nPermitted {{PLURAL:$3|file type is|file types are}} $2.";
en	messages:filetype-missing	s:40:"The file has no extension (like ".jpg").";
en	messages:empty-file	s:33:"The file you submitted was empty.";
en	messages:file-too-large	s:37:"The file you submitted was too large.";
en	messages:filename-tooshort	s:26:"The filename is too short.";
en	messages:filetype-banned	s:28:"This type of file is banned.";
en	messages:verification-error	s:41:"This file did not pass file verification.";
en	messages:hookaborted	s:68:"The modification you tried to make was aborted by an extension hook.";
en	messages:illegal-filename	s:28:"The filename is not allowed.";
en	messages:overwrite	s:44:"Overwriting an existing file is not allowed.";
en	messages:unknown-error	s:25:"An unknown error occured.";
en	messages:tmp-create-error	s:32:"Could not create temporary file.";
en	messages:tmp-write-error	s:29:"Error writing temporary file.";
en	messages:large-file	s:68:"It is recommended that files are no larger than $1;\nthis file is $2.";
en	messages:largefileserver	s:59:"This file is bigger than the server is configured to allow.";
en	messages:emptyfile	s:144:"The file you uploaded seems to be empty.\nThis might be due to a typo in the file name.\nPlease check whether you really want to upload this file.";
en	messages:fileexists	s:132:"A file with this name exists already, please check '''<tt>[[:$1]]</tt>''' if you are not sure if you want to change it.\n[[$1|thumb]]";
en	messages:filepageexists	s:277:"The description page for this file has already been created at '''<tt>[[:$1]]</tt>''', but no file with this name currently exists.\nThe summary you enter will not appear on the description page.\nTo make your summary appear there, you will need to manually edit it.\n[[$1|thumb]]";
en	messages:http-curl-error	s:22:"Error fetching URL: $1";
en	messages:fileexists-extension	s:184:"A file with a similar name exists: [[$2|thumb]]\n* Name of the uploading file: '''<tt>[[:$1]]</tt>'''\n* Name of the existing file: '''<tt>[[:$2]]</tt>'''\nPlease choose a different name.";
en	messages:fileexists-thumbnail-yes	s:226:"The file seems to be an image of reduced size ''(thumbnail)''.\n[[$1|thumb]]\nPlease check the file '''<tt>[[:$1]]</tt>'''.\nIf the checked file is the same image of original size it is not necessary to upload an extra thumbnail.";
en	messages:file-thumbnail-no	s:198:"The filename begins with '''<tt>$1</tt>'''.\nIt seems to be an image of reduced size ''(thumbnail)''.\nIf you have this image in full resolution upload this one, otherwise change the file name please.";
en	messages:fileexists-forbidden	s:166:"A file with this name already exists, and cannot be overwritten.\nIf you still want to upload your file, please go back and use a new name.\n[[File:$1|thumb|center|$1]]";
en	messages:fileexists-shared-forbidden	s:169:"A file with this name exists already in the shared file repository.\nIf you still want to upload your file, please go back and use a new name.\n[[File:$1|thumb|center|$1]]";
en	messages:file-exists-duplicate	s:67:"This file is a duplicate of the following {{PLURAL:$1|file|files}}:";
en	messages:file-deleted-duplicate	s:149:"A file identical to this file ([[:$1]]) has previously been deleted.\nYou should check that file's deletion history before proceeding to re-upload it.";
en	messages:uploadwarning	s:14:"Upload warning";
en	messages:uploadwarning-text	s:55:"Please modify the file description below and try again.";
en	messages:savefile	s:9:"Save file";
en	messages:uploadedimage	s:17:"uploaded "[[$1]]"";
en	messages:overwroteimage	s:34:"uploaded a new version of "[[$1]]"";
en	messages:uploaddisabled	s:17:"Uploads disabled.";
en	messages:copyuploaddisabled	s:23:"Upload by URL disabled.";
en	messages:uploadfromurl-queued	s:28:"Your upload has been queued.";
en	messages:undeletebtn	s:7:"Restore";
en	messages:upload-maxfilesize	s:21:"Maximum file size: $1";
en	messages:upload-description	s:16:"File description";
en	messages:upload-options	s:14:"Upload options";
en	messages:watchthisupload	s:15:"Watch this file";
en	messages:filewasdeleted	s:136:"A file of this name has been previously uploaded and subsequently deleted.\nYou should check the $1 before proceeding to upload it again.";
en	messages:upload-wasdeleted	s:213:"'''Warning: You are uploading a file that was previously deleted.'''\n\nYou should consider whether it is appropriate to continue uploading this file.\nThe deletion log for this file is provided here for convenience:";
en	messages:filename-bad-prefix	s:200:"The name of the file you are uploading begins with '''"$1"''', which is a non-descriptive name typically assigned automatically by digital cameras.\nPlease choose a more descriptive name for your file.";
en	messages:filename-prefix-blacklist	s:432:" #<!-- leave this line exactly as it is --> <pre>\n# Syntax is as follows:\n#   * Everything from a "#" character to the end of the line is a comment\n#   * Every non-blank line is a prefix for typical file names assigned automatically by digital cameras\nCIMG # Casio\nDSC_ # Nikon\nDSCF # Fuji\nDSCN # Nikon\nDUW # some mobile phones\nIMG # generic\nJD # Jenoptik\nMGP # Pentax\nPICT # misc.\n #</pre> <!-- leave this line exactly as it is -->";
en	messages:upload-success-subj	s:17:"Successful upload";
en	messages:upload-success-msg	s:79:"Your upload from [$2] was successful. It is available here: [[:{{ns:file}}:$1]]";
en	messages:upload-failure-subj	s:14:"Upload problem";
en	messages:upload-failure-msg	s:51:"There was a problem with your upload from [$2]:\n\n$1";
en	messages:upload-warning-subj	s:14:"Upload warning";
en	messages:upload-warning-msg	s:134:"There was a problem with your upload from [$2]. You may return to the [[Special:Upload/stash/$1|upload form]] to correct this problem.";
en	messages:upload-proto-error	s:18:"Incorrect protocol";
en	messages:upload-proto-error-text	s:87:"Remote upload requires URLs beginning with <code>http://</code> or <code>ftp://</code>.";
en	messages:upload-file-error	s:14:"Internal error";
en	messages:upload-file-error-text	s:145:"An internal error occurred when attempting to create a temporary file on the server.\nPlease contact an [[Special:ListUsers/sysop|administrator]].";
en	messages:upload-misc-error	s:20:"Unknown upload error";
en	messages:upload-misc-error-text	s:189:"An unknown error occurred during the upload.\nPlease verify that the URL is valid and accessible and try again.\nIf the problem persists, contact an [[Special:ListUsers/sysop|administrator]].";
en	messages:upload-too-many-redirects	s:36:"The URL contained too many redirects";
en	messages:upload-unknown-size	s:12:"Unknown size";
en	messages:upload-http-error	s:25:"An HTTP error occured: $1";
en	messages:img-auth-accessdenied	s:13:"Access denied";
en	messages:img-auth-nopathinfo	s:181:"Missing PATH_INFO.\nYour server is not set up to pass this information.\nIt may be CGI-based and cannot support img_auth.\nSee http://www.mediawiki.org/wiki/Manual:Image_Authorization.";
en	messages:img-auth-notindir	s:57:"Requested path is not in the configured upload directory.";
en	messages:img-auth-badtitle	s:44:"Unable to construct a valid title from "$1".";
en	messages:img-auth-nologinnWL	s:55:"You are not logged in and "$1" is not in the whitelist.";
en	messages:img-auth-nofile	s:25:"File "$1" does not exist.";
en	messages:img-auth-isdir	s:71:"You are trying to access a directory "$1".\nOnly file access is allowed.";
en	messages:img-auth-streaming	s:15:"Streaming "$1".";
en	messages:img-auth-public	s:158:"The function of img_auth.php is to output files from a private wiki.\nThis wiki is configured as a public wiki.\nFor optimal security, img_auth.php is disabled.";
en	messages:img-auth-noread	s:39:"User does not have access to read "$1".";
en	messages:img-auth-bad-query-string	s:36:"The URL has an invalid query string.";
en	messages:http-invalid-url	s:15:"Invalid URL: $1";
en	messages:http-invalid-scheme	s:44:"URLs with the "$1" scheme are not supported.";
en	messages:http-request-error	s:41:"HTTP request failed due to unknown error.";
en	messages:http-read-error	s:16:"HTTP read error.";
en	messages:http-timed-out	s:23:"HTTP request timed out.";
en	messages:others	s:6:"others";
en	messages:http-host-unreachable	s:20:"Could not reach URL.";
en	messages:http-bad-status	s:50:"There was a problem during the HTTP request: $1 $2";
en	messages:upload-curl-error6	s:19:"Could not reach URL";
en	messages:upload-curl-error6-text	s:102:"The URL provided could not be reached.\nPlease double-check that the URL is correct and the site is up.";
en	messages:upload-curl-error28	s:14:"Upload timeout";
en	messages:upload-curl-error28-text	s:138:"The site took too long to respond.\nPlease check the site is up, wait a short while and try again.\nYou may want to try at a less busy time.";
en	messages:license	s:10:"Licensing:";
en	messages:license-header	s:9:"Licensing";
en	messages:nolicense	s:13:"None selected";
en	messages:licenses	s:1:"-";
en	messages:license-nopreview	s:23:"(Preview not available)";
en	messages:upload_source_url	s:35:" (a valid, publicly accessible URL)";
en	messages:upload_source_file	s:26:" (a file on your computer)";
en	messages:listfiles-summary	s:156:"This special page shows all uploaded files.\nBy default the last uploaded files are shown at top of the list.\nA click on a column header changes the sorting.";
en	messages:listfiles_search_for	s:22:"Search for media name:";
en	messages:imgfile	s:4:"file";
en	messages:listfiles	s:9:"File list";
en	messages:listfiles_thumb	s:9:"Thumbnail";
en	messages:listfiles_date	s:4:"Date";
en	messages:listfiles_name	s:4:"Name";
en	messages:listfiles_user	s:4:"User";
en	messages:listfiles_size	s:4:"Size";
en	messages:listfiles_description	s:11:"Description";
en	messages:listfiles_count	s:8:"Versions";
en	messages:file-anchor-link	s:4:"File";
en	messages:filehist	s:12:"File history";
en	messages:filehist-help	s:66:"Click on a date/time to view the file as it appeared at that time.";
en	messages:filehist-deleteall	s:10:"delete all";
en	messages:filehist-deleteone	s:6:"delete";
en	messages:filehist-revert	s:6:"revert";
en	messages:filehist-current	s:7:"current";
en	messages:filehist-datetime	s:9:"Date/Time";
en	messages:filehist-thumb	s:9:"Thumbnail";
en	messages:filehist-thumbtext	s:30:"Thumbnail for version as of $1";
en	messages:filehist-nothumb	s:12:"No thumbnail";
en	messages:filehist-user	s:4:"User";
en	messages:filehist-dimensions	s:10:"Dimensions";
en	messages:filehist-filesize	s:9:"File size";
en	messages:filehist-comment	s:7:"Comment";
en	messages:filehist-missing	s:12:"File missing";
en	messages:imagelinks	s:10:"File links";
en	messages:linkstoimage	s:66:"The following {{PLURAL:$1|page links|$1 pages link}} to this file:";
en	messages:linkstoimage-more	s:215:"More than $1 {{PLURAL:$1|page links|pages link}} to this file.\nThe following list shows the {{PLURAL:$1|first page link|first $1 page links}} to this file only.\nA [[Special:WhatLinksHere/$2|full list]] is available.";
en	messages:nolinkstoimage	s:42:"There are no pages that link to this file.";
en	messages:morelinkstoimage	s:58:"View [[Special:WhatLinksHere/$1|more links]] to this file.";
en	messages:redirectstofile	s:74:"The following {{PLURAL:$1|file redirects|$1 files redirect}} to this file:";
en	messages:duplicatesoffile	s:135:"The following {{PLURAL:$1|file is a duplicate|$1 files are duplicates}} of this file ([[Special:FileDuplicateSearch/$2|more details]]):";
en	messages:sharedupload	s:55:"This file is from $1 and may be used by other projects.";
en	messages:sharedupload-desc-there	s:122:"This file is from $1 and may be used by other projects.\nPlease see the [$2 file description page] for further information.";
en	messages:sharedupload-desc-here	s:127:"This file is from $1 and may be used by other projects.\nThe description on its [$2 file description page] there is shown below.";
en	messages:shareddescriptionfollows	s:1:"-";
en	messages:filepage-nofile	s:28:"No file by this name exists.";
en	messages:filepage-nofile-link	s:56:"No file by this name exists, but you can [$1 upload it].";
en	messages:uploadnewversion-linktext	s:33:"Upload a new version of this file";
en	messages:shared-repo-from	s:7:"from $1";
en	messages:shared-repo	s:19:"a shared repository";
en	messages:shared-repo-name-wikimediacommons	s:17:"Wikimedia Commons";
en	messages:filepage.css	s:101:"/* CSS placed here is included on the file description page, also included on foreign client wikis */";
en	messages:filerevert	s:9:"Revert $1";
en	messages:filerevert-backlink	s:6:"← $1";
en	messages:filerevert-legend	s:11:"Revert file";
en	messages:filerevert-intro	s:88:"You are about to revert the file '''[[Media:$1|$1]]''' to the [$4 version as of $3, $2].";
en	messages:filerevert-comment	s:7:"Reason:";
en	messages:filerevert-defaultcomment	s:32:"Reverted to version as of $2, $1";
en	messages:filerevert-submit	s:6:"Revert";
en	messages:filerevert-success	s:73:"'''[[Media:$1|$1]]''' has been reverted to the [$4 version as of $3, $2].";
en	messages:filerevert-badversion	s:76:"There is no previous local version of this file with the provided timestamp.";
en	messages:filedelete	s:9:"Delete $1";
en	messages:filedelete-backlink	s:6:"← $1";
en	messages:filedelete-legend	s:11:"Delete file";
en	messages:filedelete-intro	s:85:"You are about to delete the file '''[[Media:$1|$1]]''' along with all of its history.";
en	messages:filedelete-intro-old	s:72:"You are deleting the version of '''[[Media:$1|$1]]''' as of [$4 $3, $2].";
en	messages:filedelete-comment	s:7:"Reason:";
en	messages:filedelete-submit	s:6:"Delete";
en	messages:filedelete-success	s:26:"'''$1''' has been deleted.";
en	messages:filedelete-success-old	s:67:"The version of '''[[Media:$1|$1]]''' as of $3, $2 has been deleted.";
en	messages:filedelete-nofile	s:24:"'''$1''' does not exist.";
en	messages:uncategorizedcategories	s:24:"Uncategorized categories";
en	messages:filedelete-nofile-old	s:71:"There is no archived version of '''$1''' with the specified attributes.";
en	messages:filedelete-otherreason	s:24:"Other/additional reason:";
en	messages:filedelete-reason-otherlist	s:12:"Other reason";
en	messages:filedelete-reason-dropdown	s:64:"*Common delete reasons\n** Copyright violation\n** Duplicated file";
en	messages:filedelete-edit-reasonlist	s:19:"Edit delete reasons";
en	messages:filedelete-maintenance	s:74:"Deletion and restoration of files temporarily disabled during maintenance.";
en	messages:mimesearch	s:11:"MIME search";
en	messages:mimesearch-summary	s:115:"This page enables the filtering of files for their MIME type.\nInput: contenttype/subtype, e.g. <tt>image/jpeg</tt>.";
en	messages:mimetype	s:10:"MIME type:";
en	messages:download	s:8:"download";
en	messages:unwatchedpages	s:15:"Unwatched pages";
en	messages:unwatchedpages-summary	s:0:"";
en	messages:listredirects	s:17:"List of redirects";
en	messages:listredirects-summary	s:0:"";
en	messages:unusedtemplates	s:16:"Unused templates";
en	messages:unusedtemplates-summary	s:0:"";
en	messages:unusedtemplatestext	s:171:"This page lists all pages in the {{ns:template}} namespace which are not included in another page.\nRemember to check for other links to the templates before deleting them.";
en	messages:unusedtemplateswlh	s:11:"other links";
en	messages:randompage	s:11:"Random page";
en	messages:randompage-nopages	s:75:"There are no pages in the following {{PLURAL:$2|namespace|namespaces}}: $1.";
en	messages:randompage-url	s:14:"Special:Random";
en	messages:randomredirect	s:15:"Random redirect";
en	messages:randomredirect-nopages	s:45:"There are no redirects in the namespace "$1".";
en	messages:statistics	s:10:"Statistics";
en	messages:statistics-summary	s:0:"";
en	messages:statistics-header-pages	s:15:"Page statistics";
en	messages:statistics-header-edits	s:15:"Edit statistics";
en	messages:statistics-header-views	s:15:"View statistics";
en	messages:statistics-header-users	s:15:"User statistics";
en	messages:statistics-header-hooks	s:16:"Other statistics";
en	messages:statistics-articles	s:13:"Content pages";
en	messages:statistics-pages	s:5:"Pages";
en	messages:statistics-pages-desc	s:60:"All pages in the wiki, including talk pages, redirects, etc.";
en	messages:statistics-files	s:14:"Uploaded files";
en	messages:statistics-edits	s:40:"Page edits since {{SITENAME}} was set up";
en	messages:statistics-edits-average	s:22:"Average edits per page";
en	messages:statistics-views-total	s:11:"Views total";
en	messages:statistics-views-total-desc	s:62:"Views to non-existing pages and special pages are not included";
en	messages:statistics-views-peredit	s:14:"Views per edit";
en	messages:statistics-users	s:38:"Registered [[Special:ListUsers|users]]";
en	messages:statistics-users-active	s:12:"Active users";
en	messages:statistics-users-active-desc	s:72:"Users who have performed an action in the last {{PLURAL:$1|day|$1 days}}";
en	messages:statistics-mostpopular	s:17:"Most viewed pages";
en	messages:statistics-footer	s:0:"";
en	messages:disambiguations	s:20:"Disambiguation pages";
en	messages:disambiguations-summary	s:0:"";
en	messages:disambiguationspage	s:17:"Template:disambig";
en	messages:disambiguations-text	s:231:"The following pages link to a '''disambiguation page'''.\nThey should link to the appropriate topic instead.<br />\nA page is treated as disambiguation page if it uses a template which is linked from [[MediaWiki:Disambiguationspage]]";
en	messages:doubleredirects	s:16:"Double redirects";
en	messages:doubleredirects-summary	s:0:"";
en	messages:doubleredirectstext	s:297:"This page lists pages which redirect to other redirect pages.\nEach row contains links to the first and second redirect, as well as the target of the second redirect, which is usually the "real" target page, which the first redirect should point to.\n<del>Crossed out</del> entries have been solved.";
en	messages:double-redirect-fixed-move	s:50:"[[$1]] has been moved.\nIt now redirects to [[$2]].";
en	messages:double-redirect-fixer	s:14:"Redirect fixer";
en	messages:brokenredirects	s:16:"Broken redirects";
en	messages:brokenredirects-summary	s:0:"";
en	messages:brokenredirectstext	s:51:"The following redirects link to non-existent pages:";
en	messages:brokenredirects-edit	s:4:"edit";
en	messages:brokenredirects-delete	s:6:"delete";
en	messages:withoutinterwiki	s:28:"Pages without language links";
en	messages:withoutinterwiki-summary	s:59:"The following pages do not link to other language versions.";
en	messages:withoutinterwiki-legend	s:6:"Prefix";
en	messages:withoutinterwiki-submit	s:4:"Show";
en	messages:fewestrevisions	s:31:"Pages with the fewest revisions";
en	messages:fewestrevisions-summary	s:0:"";
en	messages:nbytes	s:27:"$1 {{PLURAL:$1|byte|bytes}}";
en	messages:ncategories	s:36:"$1 {{PLURAL:$1|category|categories}}";
en	messages:nlinks	s:27:"$1 {{PLURAL:$1|link|links}}";
en	messages:nmembers	s:31:"$1 {{PLURAL:$1|member|members}}";
en	messages:nrevisions	s:35:"$1 {{PLURAL:$1|revision|revisions}}";
en	messages:nviews	s:27:"$1 {{PLURAL:$1|view|views}}";
en	messages:nimagelinks	s:35:"Used on $1 {{PLURAL:$1|page|pages}}";
en	messages:ntransclusions	s:35:"used on $1 {{PLURAL:$1|page|pages}}";
en	messages:specialpage-empty	s:37:"There are no results for this report.";
en	messages:lonelypages	s:14:"Orphaned pages";
en	messages:lonelypages-summary	s:0:"";
en	messages:lonelypagestext	s:88:"The following pages are not linked from or transcluded into other pages in {{SITENAME}}.";
en	messages:uncategorizedpages	s:19:"Uncategorized pages";
en	messages:uncategorizedpages-summary	s:0:"";
en	messages:uncategorizedcategories-summary	s:0:"";
en	messages:uncategorizedimages	s:19:"Uncategorized files";
en	messages:uncategorizedimages-summary	s:0:"";
en	messages:uncategorizedtemplates	s:23:"Uncategorized templates";
en	messages:uncategorizedtemplates-summary	s:0:"";
en	messages:unusedcategories	s:17:"Unused categories";
en	messages:unusedimages	s:12:"Unused files";
en	messages:popularpages	s:13:"Popular pages";
en	messages:popularpages-summary	s:0:"";
en	messages:wantedcategories	s:17:"Wanted categories";
en	messages:wantedcategories-summary	s:0:"";
en	messages:wantedpages	s:12:"Wanted pages";
en	messages:wantedpages-summary	s:0:"";
en	messages:wantedpages-badtitle	s:31:"Invalid title in result set: $1";
en	messages:wantedfiles	s:12:"Wanted files";
en	messages:wantedfiles-summary	s:0:"";
en	messages:wantedtemplates	s:16:"Wanted templates";
en	messages:wantedtemplates-summary	s:0:"";
en	messages:mostlinked	s:20:"Most linked-to pages";
en	messages:mostlinked-summary	s:0:"";
en	messages:mostlinkedcategories	s:25:"Most linked-to categories";
en	messages:mostlinkedcategories-summary	s:0:"";
en	messages:mostlinkedtemplates	s:24:"Most linked-to templates";
en	messages:mostlinkedtemplates-summary	s:0:"";
en	messages:mostcategories	s:30:"Pages with the most categories";
en	messages:mostcategories-summary	s:0:"";
en	messages:mostimages	s:20:"Most linked-to files";
en	messages:mostimages-summary	s:0:"";
en	messages:mostrevisions	s:29:"Pages with the most revisions";
en	messages:mostrevisions-summary	s:0:"";
en	messages:prefixindex	s:21:"All pages with prefix";
en	messages:prefixindex-summary	s:0:"";
en	messages:shortpages	s:11:"Short pages";
en	messages:shortpages-summary	s:0:"";
en	messages:longpages	s:10:"Long pages";
en	messages:longpages-summary	s:0:"";
en	messages:deadendpages	s:14:"Dead-end pages";
en	messages:deadendpages-summary	s:0:"";
en	messages:deadendpagestext	s:63:"The following pages do not link to other pages in {{SITENAME}}.";
en	messages:protectedpages	s:15:"Protected pages";
en	messages:protectedpages-indef	s:27:"Indefinite protections only";
en	messages:protectedpages-summary	s:0:"";
en	messages:protectedpages-cascade	s:26:"Cascading protections only";
en	messages:protectedpagestext	s:56:"The following pages are protected from moving or editing";
en	messages:protectedpagesempty	s:55:"No pages are currently protected with these parameters.";
en	messages:protectedtitles	s:16:"Protected titles";
en	messages:protectedtitles-summary	s:0:"";
en	messages:protectedtitlestext	s:48:"The following titles are protected from creation";
en	messages:protectedtitlesempty	s:56:"No titles are currently protected with these parameters.";
en	messages:listusers	s:9:"User list";
en	messages:listusers-summary	s:0:"";
en	messages:listusers-editsonly	s:26:"Show only users with edits";
en	messages:listusers-creationsort	s:21:"Sort by creation date";
en	messages:usereditcount	s:27:"$1 {{PLURAL:$1|edit|edits}}";
en	messages:usercreated	s:19:"Created on $1 at $2";
en	messages:newpages	s:9:"New pages";
en	messages:newpages-summary	s:0:"";
en	messages:newpages-username	s:9:"Username:";
en	messages:ancientpages	s:12:"Oldest pages";
en	messages:ancientpages-summary	s:0:"";
en	messages:move	s:4:"Move";
en	messages:movethispage	s:14:"Move this page";
en	messages:unusedimagestext	s:191:"The following files exist but are not embedded in any page.\nPlease note that other web sites may link to a file with a direct URL, and so may still be listed here despite being in active use.";
en	messages:unusedcategoriestext	s:89:"The following category pages exist, although no other page or category makes use of them.";
en	messages:notargettitle	s:9:"No target";
en	messages:notargettext	s:73:"You have not specified a target page or user to perform this function on.";
en	messages:nopagetitle	s:19:"No such target page";
en	messages:nopagetext	s:50:"The target page you have specified does not exist.";
en	messages:pager-newer-n	s:30:"{{PLURAL:$1|newer 1|newer $1}}";
en	messages:pager-older-n	s:30:"{{PLURAL:$1|older 1|older $1}}";
en	messages:suppress	s:9:"Oversight";
en	messages:booksources	s:12:"Book sources";
en	messages:booksources-summary	s:0:"";
en	messages:booksources-search-legend	s:23:"Search for book sources";
en	messages:booksources-isbn	s:5:"ISBN:";
en	messages:booksources-go	s:2:"Go";
en	messages:booksources-text	s:140:"Below is a list of links to other sites that sell new and used books, and may also have further information about books you are looking for:";
en	messages:booksources-invalid-isbn	s:94:"The given ISBN does not appear to be valid; check for errors copying from the original source.";
en	messages:rfcurl	s:32:"http://tools.ietf.org/html/rfc$1";
en	messages:pubmedurl	s:51:"http://www.ncbi.nlm.nih.gov/pubmed/$1?dopt=Abstract";
en	messages:specialloguserlabel	s:5:"User:";
en	messages:speciallogtitlelabel	s:6:"Title:";
en	messages:log	s:4:"Logs";
en	messages:all-logs-page	s:15:"All public logs";
en	messages:alllogstext	s:184:"Combined display of all available logs of {{SITENAME}}.\nYou can narrow down the view by selecting a log type, the username (case-sensitive), or the affected page (also case-sensitive).";
en	messages:logempty	s:25:"No matching items in log.";
en	messages:log-title-wildcard	s:37:"Search titles starting with this text";
en	messages:allpages	s:9:"All pages";
en	messages:alphaindexline	s:8:"$1 to $2";
en	messages:nextpage	s:14:"Next page ($1)";
en	messages:prevpage	s:18:"Previous page ($1)";
en	messages:allpagesfrom	s:26:"Display pages starting at:";
en	messages:allpagesto	s:24:"Display pages ending at:";
en	messages:allarticles	s:9:"All pages";
en	messages:allinnamespace	s:24:"All pages ($1 namespace)";
en	messages:allnotinnamespace	s:31:"All pages (not in $1 namespace)";
en	messages:allpagesprev	s:8:"Previous";
en	messages:allpagesnext	s:4:"Next";
en	messages:allpagessubmit	s:2:"Go";
en	messages:allpagesprefix	s:26:"Display pages with prefix:";
en	messages:allpagesbadtitle	s:149:"The given page title was invalid or had an inter-language or inter-wiki prefix.\nIt may contain one or more characters which cannot be used in titles.";
en	messages:allpages-bad-ns	s:42:"{{SITENAME}} does not have namespace "$1".";
en	messages:categories	s:10:"Categories";
en	messages:categories-summary	s:0:"";
en	messages:categoriespagetext	s:204:"The following {{PLURAL:$1|category contains|categories contain}} pages or media.\n[[Special:UnusedCategories|Unused categories]] are not shown here.\nAlso see [[Special:WantedCategories|wanted categories]].";
en	messages:categoriesfrom	s:31:"Display categories starting at:";
en	messages:special-categories-sort-count	s:13:"sort by count";
en	messages:special-categories-sort-abc	s:19:"sort alphabetically";
en	messages:deletedcontributions	s:26:"Deleted user contributions";
en	messages:deletedcontributions-title	s:26:"Deleted user contributions";
en	messages:sp-deletedcontributions-contribs	s:13:"contributions";
en	messages:linksearch	s:14:"External links";
en	messages:linksearch-pat	s:15:"Search pattern:";
en	messages:linksearch-ns	s:10:"Namespace:";
en	messages:linksearch-ok	s:6:"Search";
en	messages:linksearch-text	s:87:"Wildcards such as "*.wikipedia.org" may be used.<br />\nSupported protocols: <tt>$1</tt>";
en	messages:linksearch-line	s:20:"$1 is linked from $2";
en	messages:linksearch-error	s:55:"Wildcards may appear only at the start of the hostname.";
en	messages:listusersfrom	s:26:"Display users starting at:";
en	messages:listusers-submit	s:4:"Show";
en	messages:listusers-noresult	s:14:"No user found.";
en	messages:listusers-blocked	s:9:"(blocked)";
en	messages:activeusers	s:17:"Active users list";
en	messages:activeusers-summary	s:0:"";
en	messages:activeusers-intro	s:96:"This is a list of users who had some kind of activity within the last $1 {{PLURAL:$1|day|days}}.";
en	messages:activeusers-count	s:65:"$1 {{PLURAL:$1|edit|edits}} in the last {{PLURAL:$3|day|$3 days}}";
en	messages:activeusers-from	s:26:"Display users starting at:";
en	messages:activeusers-hidebots	s:9:"Hide bots";
en	messages:activeusers-hidesysops	s:19:"Hide administrators";
en	messages:activeusers-noresult	s:15:"No users found.";
en	messages:newuserlogpage	s:17:"User creation log";
en	messages:newuserlogpagetext	s:32:"This is a log of user creations.";
en	messages:newuserlogentry	s:0:"";
en	messages:newuserlog-byemail	s:23:"password sent by e-mail";
en	messages:newuserlog-create-entry	s:16:"New user account";
en	messages:newuserlog-create2-entry	s:22:"created new account $1";
en	messages:newuserlog-autocreate-entry	s:29:"Account created automatically";
en	messages:listgrouprights	s:17:"User group rights";
en	messages:listgrouprights-summary	s:201:"The following is a list of user groups defined on this wiki, with their associated access rights.\nThere may be [[{{MediaWiki:Listgrouprights-helppage}}|additional information]] about individual rights.";
en	messages:listgrouprights-key	s:121:"* <span class="listgrouprights-granted">Granted right</span>\n* <span class="listgrouprights-revoked">Revoked right</span>";
en	messages:listgrouprights-group	s:5:"Group";
en	messages:listgrouprights-rights	s:6:"Rights";
en	messages:listgrouprights-helppage	s:17:"Help:Group rights";
en	messages:listgrouprights-members	s:17:"(list of members)";
en	messages:listgrouprights-right-display	s:61:"<span class="listgrouprights-granted">$1 <tt>($2)</tt></span>";
en	messages:listgrouprights-right-revoked	s:61:"<span class="listgrouprights-revoked">$1 <tt>($2)</tt></span>";
en	messages:listgrouprights-addgroup	s:34:"Add {{PLURAL:$2|group|groups}}: $1";
en	messages:listgrouprights-removegroup	s:37:"Remove {{PLURAL:$2|group|groups}}: $1";
en	messages:listgrouprights-addgroup-all	s:14:"Add all groups";
en	messages:listgrouprights-removegroup-all	s:17:"Remove all groups";
en	messages:listgrouprights-addgroup-self	s:49:"Add {{PLURAL:$2|group|groups}} to own account: $1";
en	messages:listgrouprights-removegroup-self	s:54:"Remove {{PLURAL:$2|group|groups}} from own account: $1";
en	messages:listgrouprights-addgroup-self-all	s:29:"Add all groups to own account";
en	messages:listgrouprights-removegroup-self-all	s:34:"Remove all groups from own account";
en	messages:mailnologin	s:15:"No send address";
en	messages:mailnologintext	s:150:"You must be [[Special:UserLogin|logged in]] and have a valid e-mail address in your [[Special:Preferences|preferences]] to send e-mail to other users.";
en	messages:emailuser	s:16:"E-mail this user";
en	messages:emailpage	s:11:"E-mail user";
en	messages:emailpagetext	s:251:"You can use the form below to send an e-mail message to this user.\nThe e-mail address you entered in [[Special:Preferences|your user preferences]] will appear as the "From" address of the e-mail, so the recipient will be able to reply directly to you.";
en	messages:usermailererror	s:27:"Mail object returned error:";
en	messages:defemailsubject	s:19:"{{SITENAME}} e-mail";
en	messages:usermaildisabled	s:20:"User e-mail disabled";
en	messages:usermaildisabledtext	s:50:"You cannot send e-mail to other users on this wiki";
en	messages:noemailtitle	s:17:"No e-mail address";
en	messages:noemailtext	s:51:"This user has not specified a valid e-mail address.";
en	messages:nowikiemailtitle	s:17:"No e-mail allowed";
en	messages:nowikiemailtext	s:60:"This user has chosen not to receive e-mail from other users.";
en	messages:email-legend	s:43:"Send an e-mail to another {{SITENAME}} user";
en	messages:emailfrom	s:5:"From:";
en	messages:emailto	s:3:"To:";
en	messages:emailsubject	s:8:"Subject:";
en	messages:emailmessage	s:8:"Message:";
en	messages:emailsend	s:4:"Send";
en	messages:emailccme	s:31:"E-mail me a copy of my message.";
en	messages:emailccsubject	s:30:"Copy of your message to $1: $2";
en	messages:emailsent	s:11:"E-mail sent";
en	messages:emailsenttext	s:34:"Your e-mail message has been sent.";
en	messages:emailuserfooter	s:79:"This e-mail was sent by $1 to $2 by the "E-mail user" function at {{SITENAME}}.";
en	messages:usermessage-summary	s:23:"Leaving system message.";
en	messages:usermessage-editor	s:16:"System messenger";
en	messages:usermessage-template	s:21:"MediaWiki:UserMessage";
en	messages:watchlist	s:12:"My watchlist";
en	messages:mywatchlist	s:12:"My watchlist";
en	messages:watchlistfor2	s:9:"For $1 $2";
en	messages:nowatchlist	s:36:"You have no items on your watchlist.";
en	messages:watchlistanontext	s:50:"Please $1 to view or edit items on your watchlist.";
en	messages:watchnologin	s:13:"Not logged in";
en	messages:watchnologintext	s:69:"You must be [[Special:UserLogin|logged in]] to modify your watchlist.";
en	messages:addedwatch	s:18:"Added to watchlist";
en	messages:addedwatchtext	s:278:"The page "[[:$1]]" has been added to your [[Special:Watchlist|watchlist]].\nFuture changes to this page and its associated talk page will be listed there, and the page will appear '''bolded''' in the [[Special:RecentChanges|list of recent changes]] to make it easier to pick out.";
en	messages:removedwatch	s:22:"Removed from watchlist";
en	messages:removedwatchtext	s:78:"The page "[[:$1]]" has been removed from [[Special:Watchlist|your watchlist]].";
en	messages:watch	s:5:"Watch";
en	messages:watchthispage	s:15:"Watch this page";
en	messages:unwatch	s:7:"Unwatch";
en	messages:unwatchthispage	s:13:"Stop watching";
en	messages:notanarticle	s:18:"Not a content page";
en	messages:notvisiblerev	s:54:"The last revision by a different user has been deleted";
en	messages:watchnochange	s:68:"None of your watched items were edited in the time period displayed.";
en	messages:watchlist-details	s:74:"{{PLURAL:$1|$1 page|$1 pages}} on your watchlist, not counting talk pages.";
en	messages:wlheader-enotif	s:33:"* E-mail notification is enabled.";
en	messages:wlheader-showupdated	s:83:"* Pages which have been changed since you last visited them are shown in '''bold'''";
en	messages:watchmethod-recent	s:39:"checking recent edits for watched pages";
en	messages:watchmethod-list	s:39:"checking watched pages for recent edits";
en	messages:watchlistcontains	s:52:"Your watchlist contains $1 {{PLURAL:$1|page|pages}}.";
en	messages:iteminvalidname	s:39:"Problem with item '$1', invalid name...";
en	messages:wlnote	s:115:"Below {{PLURAL:$1|is the last change|are the last '''$1''' changes}} in the last {{PLURAL:$2|hour|'''$2''' hours}}.";
en	messages:wlshowlast	s:29:"Show last $1 hours $2 days $3";
en	messages:watchlist-options	s:17:"Watchlist options";
en	messages:watching	s:11:"Watching...";
en	messages:unwatching	s:13:"Unwatching...";
en	messages:enotif_mailer	s:32:"{{SITENAME}} notification mailer";
en	messages:enotif_reset	s:22:"Mark all pages visited";
en	messages:enotif_newpagetext	s:19:"This is a new page.";
en	messages:enotif_impersonal_salutation	s:17:"{{SITENAME}} user";
en	messages:changed	s:7:"changed";
en	messages:created	s:7:"created";
en	messages:enotif_subject	s:70:"{{SITENAME}} page $PAGETITLE has been $CHANGEDORCREATED by $PAGEEDITOR";
en	messages:enotif_lastvisited	s:45:"See $1 for all changes since your last visit.";
en	messages:enotif_lastdiff	s:27:"See $1 to view this change.";
en	messages:enotif_anon_editor	s:17:"anonymous user $1";
en	messages:enotif_body	s:745:"Dear $WATCHINGUSERNAME,\n\n\nThe {{SITENAME}} page $PAGETITLE has been $CHANGEDORCREATED on $PAGEEDITDATE by $PAGEEDITOR, see $PAGETITLE_URL for the current revision.\n\n$NEWPAGE\n\nEditor's summary: $PAGESUMMARY $PAGEMINOREDIT\n\nContact the editor:\nmail: $PAGEEDITOR_EMAIL\nwiki: $PAGEEDITOR_WIKI\n\nThere will be no other notifications in case of further changes unless you visit this page.\nYou could also reset the notification flags for all your watched pages on your watchlist.\n\n             Your friendly {{SITENAME}} notification system\n\n--\nTo change your watchlist settings, visit\n{{fullurl:{{#special:Watchlist}}/edit}}\n\nTo delete the page from your watchlist, visit\n$UNWATCHURL\n\nFeedback and further assistance:\n{{fullurl:{{MediaWiki:Helppage}}}}";
en	messages:deletepage	s:11:"Delete page";
en	messages:confirm	s:7:"Confirm";
en	messages:excontent	s:17:"content was: "$1"";
en	messages:excontentauthor	s:82:"content was: "$1" (and the only contributor was "[[Special:Contributions/$2|$2]]")";
en	messages:exbeforeblank	s:33:"content before blanking was: "$1"";
en	messages:exblank	s:14:"page was empty";
en	messages:delete-confirm	s:11:"Delete "$1"";
en	messages:delete-backlink	s:6:"← $1";
en	messages:delete-legend	s:6:"Delete";
en	messages:historywarning	s:117:"'''Warning:''' The page you are about to delete has a history with approximately $1 {{PLURAL:$1|revision|revisions}}:";
en	messages:confirmdeletetext	s:230:"You are about to delete a page along with all of its history.\nPlease confirm that you intend to do this, that you understand the consequences, and that you are doing this in accordance with [[{{MediaWiki:Policy-url}}|the policy]].";
en	messages:actioncomplete	s:15:"Action complete";
en	messages:actionfailed	s:13:"Action failed";
en	messages:deletedtext	s:80:""<nowiki>$1</nowiki>" has been deleted.\nSee $2 for a record of recent deletions.";
en	messages:deletedarticle	s:16:"deleted "[[$1]]"";
en	messages:suppressedarticle	s:19:"suppressed "[[$1]]"";
en	messages:dellogpage	s:12:"Deletion log";
en	messages:dellogpagetext	s:45:"Below is a list of the most recent deletions.";
en	messages:deletionlog	s:12:"deletion log";
en	messages:reverted	s:28:"Reverted to earlier revision";
en	messages:deletecomment	s:7:"Reason:";
en	messages:deleteotherreason	s:24:"Other/additional reason:";
en	messages:deletereasonotherlist	s:12:"Other reason";
en	messages:deletereason-dropdown	s:76:"*Common delete reasons\n** Author request\n** Copyright violation\n** Vandalism";
en	messages:delete-edit-reasonlist	s:21:"Edit deletion reasons";
en	messages:delete-toobig	s:170:"This page has a large edit history, over $1 {{PLURAL:$1|revision|revisions}}.\nDeletion of such pages has been restricted to prevent accidental disruption of {{SITENAME}}.";
en	messages:delete-warning-toobig	s:160:"This page has a large edit history, over $1 {{PLURAL:$1|revision|revisions}}.\nDeleting it may disrupt database operations of {{SITENAME}};\nproceed with caution.";
en	messages:rollback	s:15:"Roll back edits";
en	messages:rollback_short	s:8:"Rollback";
en	messages:rollbacklink	s:8:"rollback";
en	messages:rollbackfailed	s:15:"Rollback failed";
en	messages:cantrollback	s:65:"Cannot revert edit;\nlast contributor is only author of this page.";
en	messages:alreadyrolled	s:352:"Cannot rollback last edit of [[:$1]] by [[User:$2|$2]] ([[User talk:$2|talk]]{{int:pipe-separator}}[[Special:Contributions/$2|{{int:contribslink}}]]);\nsomeone else has edited or rolled back the page already.\n\nThe last edit to the page was by [[User:$3|$3]] ([[User talk:$3|talk]]{{int:pipe-separator}}[[Special:Contributions/$3|{{int:contribslink}}]]).";
en	messages:editcomment	s:31:"The edit summary was: "''$1''".";
en	messages:revertpage	s:108:"Reverted edits by [[Special:Contributions/$2|$2]] ([[User talk:$2|talk]]) to last revision by [[User:$1|$1]]";
en	messages:revertpage-nouser	s:71:"Reverted edits by (username removed) to last revision by [[User:$1|$1]]";
en	messages:rollback-success	s:58:"Reverted edits by $1;\nchanged back to last revision by $2.";
en	messages:sessionfailure-title	s:15:"Session failure";
en	messages:undeletelink	s:12:"view/restore";
en	messages:undeleteviewlink	s:4:"view";
en	messages:sessionfailure	s:192:"There seems to be a problem with your login session;\nthis action has been canceled as a precaution against session hijacking.\nGo back to the previous page, reload that page and then try again.";
en	messages:protectlogpage	s:14:"Protection log";
en	messages:protectlogtext	s:171:"Below is a list of page protections and page unprotections.\nSee the [[Special:ProtectedPages|protected pages list]] for the list of currently operational page protections.";
en	messages:protectedarticle	s:18:"protected "[[$1]]"";
en	messages:modifiedarticleprotection	s:37:"changed protection level for "[[$1]]"";
en	messages:unprotectedarticle	s:20:"unprotected "[[$1]]"";
en	messages:movedarticleprotection	s:51:"moved protection settings from "[[$2]]" to "[[$1]]"";
en	messages:protect-title	s:32:"Change protection level for "$1"";
en	messages:prot_1movedto2	s:22:"[[$1]] moved to [[$2]]";
en	messages:protect-backlink	s:6:"← $1";
en	messages:protect-legend	s:18:"Confirm protection";
en	messages:protectcomment	s:7:"Reason:";
en	messages:protectexpiry	s:8:"Expires:";
en	messages:protect_expiry_invalid	s:23:"Expiry time is invalid.";
en	messages:protect_expiry_old	s:27:"Expiry time is in the past.";
en	messages:protect-unchain-permissions	s:30:"Unlock further protect options";
en	messages:protect-text	s:89:"You may view and change the protection level here for the page '''<nowiki>$1</nowiki>'''.";
en	messages:protect-locked-blocked	s:103:"You cannot change protection levels while blocked.\nHere are the current settings for the page '''$1''':";
en	messages:protect-locked-dblock	s:120:"Protection levels cannot be changed due to an active database lock.\nHere are the current settings for the page '''$1''':";
en	messages:protect-locked-access	s:124:"Your account does not have permission to change page protection levels.\nHere are the current settings for the page '''$1''':";
en	messages:protect-cascadeon	s:246:"This page is currently protected because it is included in the following {{PLURAL:$1|page, which has|pages, which have}} cascading protection turned on.\nYou can change this page's protection level, but it will not affect the cascading protection.";
en	messages:protect-default	s:15:"Allow all users";
en	messages:protect-fallback	s:23:"Require "$1" permission";
en	messages:protect-level-autoconfirmed	s:32:"Block new and unregistered users";
en	messages:protect-level-sysop	s:19:"Administrators only";
en	messages:protect-summary-cascade	s:9:"cascading";
en	messages:protect-expiring	s:16:"expires $1 (UTC)";
en	messages:protect-expiry-indefinite	s:10:"indefinite";
en	messages:protect-cascade	s:58:"Protect pages included in this page (cascading protection)";
en	messages:protect-cantedit	s:100:"You cannot change the protection levels of this page, because you do not have permission to edit it.";
en	messages:protect-othertime	s:11:"Other time:";
en	messages:protect-othertime-op	s:10:"other time";
en	messages:protect-existing-expiry	s:28:"Existing expiry time: $3, $2";
en	messages:protect-otherreason	s:24:"Other/additional reason:";
en	messages:protect-otherreason-op	s:12:"Other reason";
en	messages:protect-dropdown	s:127:"*Common protection reasons\n** Excessive vandalism\n** Excessive spamming\n** Counter-productive edit warring\n** High traffic page";
en	messages:protect-edit-reasonlist	s:23:"Edit protection reasons";
en	messages:protect-expiry-options	s:139:"1 hour:1 hour,1 day:1 day,1 week:1 week,2 weeks:2 weeks,1 month:1 month,3 months:3 months,6 months:6 months,1 year:1 year,infinite:infinite";
en	messages:restriction-type	s:11:"Permission:";
en	messages:restriction-level	s:18:"Restriction level:";
en	messages:minimum-size	s:8:"Min size";
en	messages:maximum-size	s:9:"Max size:";
en	messages:pagesize	s:7:"(bytes)";
en	messages:restriction-edit	s:4:"Edit";
en	messages:restriction-move	s:4:"Move";
en	messages:restriction-create	s:6:"Create";
en	messages:restriction-upload	s:6:"Upload";
en	messages:restriction-level-sysop	s:15:"fully protected";
en	messages:restriction-level-autoconfirmed	s:14:"semi protected";
en	messages:restriction-level-all	s:9:"any level";
en	messages:undelete	s:18:"View deleted pages";
en	messages:undeletepage	s:30:"View and restore deleted pages";
en	messages:undeletepagetitle	s:64:"'''The following consists of deleted revisions of [[:$1|$1]]'''.";
en	messages:viewdeletedpage	s:18:"View deleted pages";
en	messages:undeletepagetext	s:178:"The following {{PLURAL:$1|page has been deleted but is|$1 pages have been deleted but are}} still in the archive and can be restored.\nThe archive may be periodically cleaned out.";
en	messages:undelete-fieldset-title	s:17:"Restore revisions";
en	messages:undeleteextrahelp	s:340:"To restore the page's entire history, leave all checkboxes deselected and click '''''{{int:undeletebtn}}'''''.\nTo perform a selective restoration, check the boxes corresponding to the revisions to be restored, and click '''''{{int:undeletebtn}}'''''.\nClicking '''''{{int:undeletereset}}''''' will clear the comment field and all checkboxes.";
en	messages:undeleterevisions	s:44:"$1 {{PLURAL:$1|revision|revisions}} archived";
en	messages:undeletehistory	s:198:"If you restore the page, all revisions will be restored to the history.\nIf a new page with the same name has been created since the deletion, the restored revisions will appear in the prior history.";
en	messages:undeleterevdel	s:179:"Undeletion will not be performed if it will result in the top page or file revision being partially deleted.\nIn such cases, you must uncheck or unhide the newest deleted revision.";
en	messages:undeletehistorynoadmin	s:236:"This page has been deleted.\nThe reason for deletion is shown in the summary below, along with details of the users who had edited this page before deletion.\nThe actual text of these deleted revisions is only available to administrators.";
en	messages:undelete-revision	s:47:"Deleted revision of $1 (as of $4, at $5) by $3:";
en	messages:undeleterevision-missing	s:121:"Invalid or missing revision.\nYou may have a bad link, or the revision may have been restored or removed from the archive.";
en	messages:undelete-nodiff	s:27:"No previous revision found.";
en	messages:undeleteinvert	s:16:"Invert selection";
en	messages:undeletecomment	s:7:"Reason:";
en	messages:undeletedarticle	s:17:"restored "[[$1]]"";
en	messages:undeletedrevisions	s:46:"{{PLURAL:$1|1 revision|$1 revisions}} restored";
en	messages:undeletedrevisions-files	s:80:"{{PLURAL:$1|1 revision|$1 revisions}} and {{PLURAL:$2|1 file|$2 files}} restored";
en	messages:undeletedfiles	s:38:"{{PLURAL:$1|1 file|$1 files}} restored";
en	messages:cannotundelete	s:64:"Undelete failed;\nsomeone else may have undeleted the page first.";
en	messages:undeletedpage	s:126:"'''$1 has been restored'''\n\nConsult the [[Special:Log/delete|deletion log]] for a record of recent deletions and restorations.";
en	messages:undelete-header	s:71:"See [[Special:Log/delete|the deletion log]] for recently deleted pages.";
en	messages:undelete-search-box	s:20:"Search deleted pages";
en	messages:undelete-search-prefix	s:25:"Show pages starting with:";
en	messages:undelete-search-submit	s:6:"Search";
en	messages:undelete-no-results	s:48:"No matching pages found in the deletion archive.";
en	messages:undelete-filename-mismatch	s:66:"Cannot undelete file revision with timestamp $1: filename mismatch";
en	messages:undelete-bad-store-key	s:82:"Cannot undelete file revision with timestamp $1: file was missing before deletion.";
en	messages:undelete-cleanup-error	s:40:"Error deleting unused archive file "$1".";
en	messages:undelete-missing-filearchive	s:107:"Unable to restore file archive ID $1 because it is not in the database.\nIt may have already been undeleted.";
en	messages:undelete-error-short	s:25:"Error undeleting file: $1";
en	messages:undelete-error-long	s:54:"Errors were encountered while undeleting the file:\n\n$1";
en	messages:undelete-show-file-confirm	s:99:"Are you sure you want to view the deleted revision of the file "<nowiki>$1</nowiki>" from $2 at $3?";
en	messages:undelete-show-file-submit	s:3:"Yes";
en	messages:namespace	s:10:"Namespace:";
en	messages:invert	s:16:"Invert selection";
en	messages:blanknamespace	s:6:"(Main)";
en	messages:contributions	s:18:"User contributions";
en	messages:contributions-title	s:25:"User contributions for $1";
en	messages:mycontris	s:16:"My contributions";
en	messages:contribsub2	s:11:"For $1 ($2)";
en	messages:nocontribs	s:46:"No changes were found matching these criteria.";
en	messages:uctop	s:5:"(top)";
en	messages:month	s:25:"From month (and earlier):";
en	messages:year	s:24:"From year (and earlier):";
en	messages:sp-contributions-newbies	s:39:"Show contributions of new accounts only";
en	messages:sp-contributions-newbies-sub	s:16:"For new accounts";
en	messages:sp-contributions-newbies-title	s:35:"User contributions for new accounts";
en	messages:sp-contributions-blocklog	s:9:"block log";
en	messages:sp-contributions-deleted	s:26:"deleted user contributions";
en	messages:sp-contributions-uploads	s:7:"uploads";
en	messages:sp-contributions-logs	s:4:"logs";
en	messages:sp-contributions-talk	s:4:"talk";
en	messages:sp-contributions-userrights	s:22:"user rights management";
en	messages:sp-contributions-blocked-notice	s:91:"This user is currently blocked.\nThe latest block log entry is provided below for reference:";
en	messages:ipblocklist-empty	s:23:"The blocklist is empty.";
en	messages:sp-contributions-blocked-notice-anon	s:97:"This IP address is currently blocked.\nThe latest block log entry is provided below for reference:";
en	messages:sp-contributions-search	s:24:"Search for contributions";
en	messages:sp-contributions-username	s:23:"IP address or username:";
en	messages:sp-contributions-toponly	s:41:"Only show edits that are latest revisions";
en	messages:sp-contributions-submit	s:6:"Search";
en	messages:sp-contributions-explain	s:0:"";
en	messages:sp-contributions-footer	s:1:"-";
en	messages:sp-contributions-footer-anon	s:1:"-";
en	messages:whatlinkshere	s:15:"What links here";
en	messages:whatlinkshere-title	s:23:"Pages that link to "$1"";
en	messages:whatlinkshere-summary	s:0:"";
en	messages:whatlinkshere-page	s:5:"Page:";
en	messages:whatlinkshere-backlink	s:6:"← $1";
en	messages:linkshere	s:42:"The following pages link to '''[[:$1]]''':";
en	messages:nolinkshere	s:31:"No pages link to '''[[:$1]]'''.";
en	messages:nolinkshere-ns	s:55:"No pages link to '''[[:$1]]''' in the chosen namespace.";
en	messages:isredirect	s:13:"redirect page";
en	messages:istemplate	s:12:"transclusion";
en	messages:isimage	s:10:"image link";
en	messages:whatlinkshere-prev	s:34:"{{PLURAL:$1|previous|previous $1}}";
en	messages:whatlinkshere-next	s:26:"{{PLURAL:$1|next|next $1}}";
en	messages:whatlinkshere-links	s:9:"← links";
en	messages:whatlinkshere-hideredirs	s:12:"$1 redirects";
en	messages:whatlinkshere-hidetrans	s:16:"$1 transclusions";
en	messages:whatlinkshere-hidelinks	s:8:"$1 links";
en	messages:whatlinkshere-hideimages	s:14:"$1 image links";
en	messages:whatlinkshere-filters	s:7:"Filters";
en	messages:blockip	s:10:"Block user";
en	messages:blockip-title	s:10:"Block user";
en	messages:blockip-legend	s:10:"Block user";
en	messages:blockiptext	s:280:"Use the form below to block write access from a specific IP address or username.\nThis should be done only to prevent vandalism, and in accordance with [[{{MediaWiki:Policy-url}}|policy]].\nFill in a specific reason below (for example, citing particular pages that were vandalized).";
en	messages:ipaddress	s:11:"IP address:";
en	messages:ipadressorusername	s:23:"IP address or username:";
en	messages:ipbexpiry	s:7:"Expiry:";
en	messages:ipbreason	s:7:"Reason:";
en	messages:ipbreasonotherlist	s:12:"Other reason";
en	messages:ipbreason-dropdown	s:253:"*Common block reasons\n** Inserting false information\n** Removing content from pages\n** Spamming links to external sites\n** Inserting nonsense/gibberish into pages\n** Intimidating behaviour/harassment\n** Abusing multiple accounts\n** Unacceptable username";
en	messages:ipbanononly	s:26:"Block anonymous users only";
en	messages:ipbcreateaccount	s:24:"Prevent account creation";
en	messages:ipbemailban	s:32:"Prevent user from sending e-mail";
en	messages:ipbenableautoblock	s:112:"Automatically block the last IP address used by this user, and any subsequent IP addresses they try to edit from";
en	messages:ipbsubmit	s:15:"Block this user";
en	messages:ipbother	s:11:"Other time:";
en	messages:ipboptions	s:155:"2 hours:2 hours,1 day:1 day,3 days:3 days,1 week:1 week,2 weeks:2 weeks,1 month:1 month,3 months:3 months,6 months:6 months,1 year:1 year,infinite:infinite";
en	messages:ipbotheroption	s:5:"other";
en	messages:ipbotherreason	s:24:"Other/additional reason:";
en	messages:ipbhidename	s:34:"Hide username from edits and lists";
en	messages:ipbwatchuser	s:37:"Watch this user's user and talk pages";
en	messages:ipballowusertalk	s:51:"Allow this user to edit own talk page while blocked";
en	messages:ipb-change-block	s:37:"Re-block the user with these settings";
en	messages:badipaddress	s:18:"Invalid IP address";
en	messages:blockipsuccesssub	s:15:"Block succeeded";
en	messages:blockipsuccesstext	s:115:"[[Special:Contributions/$1|$1]] has been blocked.<br />\nSee [[Special:IPBlockList|IP block list]] to review blocks.";
en	messages:ipb-edit-dropdown	s:18:"Edit block reasons";
en	messages:ipb-unblock-addr	s:10:"Unblock $1";
en	messages:ipb-unblock	s:32:"Unblock a username or IP address";
en	messages:ipb-blocklist	s:20:"View existing blocks";
en	messages:ipb-blocklist-contribs	s:20:"Contributions for $1";
en	messages:unblockip	s:12:"Unblock user";
en	messages:unblockiptext	s:90:"Use the form below to restore write access to a previously blocked IP address or username.";
en	messages:ipusubmit	s:17:"Remove this block";
en	messages:unblocked	s:33:"[[User:$1|$1]] has been unblocked";
en	messages:unblocked-id	s:25:"Block $1 has been removed";
en	messages:ipblocklist	s:34:"Blocked IP addresses and usernames";
en	messages:ipblocklist-legend	s:19:"Find a blocked user";
en	messages:ipblocklist-username	s:23:"Username or IP address:";
en	messages:ipblocklist-sh-userblocks	s:17:"$1 account blocks";
en	messages:ipblocklist-sh-tempblocks	s:19:"$1 temporary blocks";
en	messages:ipblocklist-sh-addressblocks	s:19:"$1 single IP blocks";
en	messages:ipblocklist-summary	s:0:"";
en	messages:ipblocklist-submit	s:6:"Search";
en	messages:ipblocklist-localblock	s:11:"Local block";
en	messages:ipblocklist-otherblocks	s:32:"Other {{PLURAL:$1|block|blocks}}";
en	messages:blocklistline	s:22:"$1, $2 blocked $3 ($4)";
en	messages:infiniteblock	s:8:"infinite";
en	messages:expiringblock	s:19:"expires on $1 at $2";
en	messages:anononlyblock	s:10:"anon. only";
en	messages:noautoblockblock	s:18:"autoblock disabled";
en	messages:createaccountblock	s:24:"account creation blocked";
en	messages:emailblock	s:14:"e-mail blocked";
en	messages:blocklist-nousertalk	s:25:"cannot edit own talk page";
en	messages:ipblocklist-no-results	s:52:"The requested IP address or username is not blocked.";
en	messages:blocklink	s:5:"block";
en	messages:unblocklink	s:7:"unblock";
en	messages:change-blocklink	s:12:"change block";
en	messages:contribslink	s:8:"contribs";
en	messages:autoblocker	s:120:"Autoblocked because your IP address has been recently used by "[[User:$1|$1]]".\nThe reason given for $1's block is: "$2"";
en	messages:blocklogpage	s:9:"Block log";
en	messages:blocklog-showlog	s:85:"This user has been blocked previously.\nThe block log is provided below for reference:";
en	messages:blocklog-showsuppresslog	s:99:"This user has been blocked and hidden previously.\nThe suppress log is provided below for reference:";
en	messages:blocklogentry	s:43:"blocked [[$1]] with an expiry time of $2 $3";
en	messages:reblock-logentry	s:62:"changed block settings for [[$1]] with an expiry time of $2 $3";
en	messages:blocklogtext	s:206:"This is a log of user blocking and unblocking actions.\nAutomatically blocked IP addresses are not listed.\nSee the [[Special:IPBlockList|IP block list]] for the list of currently operational bans and blocks.";
en	messages:unblocklogentry	s:12:"unblocked $1";
en	messages:block-log-flags-anononly	s:20:"anonymous users only";
en	messages:block-log-flags-nocreate	s:25:"account creation disabled";
en	messages:block-log-flags-noautoblock	s:18:"autoblock disabled";
en	messages:block-log-flags-noemail	s:14:"e-mail blocked";
en	messages:block-log-flags-nousertalk	s:25:"cannot edit own talk page";
en	messages:block-log-flags-angry-autoblock	s:26:"enhanced autoblock enabled";
en	messages:block-log-flags-hiddenname	s:15:"username hidden";
en	messages:range_block_disabled	s:61:"The administrator ability to create range blocks is disabled.";
en	messages:ipb_expiry_invalid	s:20:"Expiry time invalid.";
en	messages:ipb_expiry_temp	s:41:"Hidden username blocks must be permanent.";
en	messages:ipb_hide_invalid	s:60:"Unable to suppress this account; it may have too many edits.";
en	messages:ipb_already_blocked	s:23:""$1" is already blocked";
en	messages:ipb-needreblock	s:80:"== Already blocked ==\n$1 is already blocked.\nDo you want to change the settings?";
en	messages:ipb-otherblocks-header	s:32:"Other {{PLURAL:$1|block|blocks}}";
en	messages:ipb_cant_unblock	s:65:"Error: Block ID $1 not found.\nIt may have been unblocked already.";
en	messages:ipb_blocked_as_range	s:146:"Error: The IP address $1 is not blocked directly and cannot be unblocked.\nIt is, however, blocked as part of the range $2, which can be unblocked.";
en	messages:ip_range_invalid	s:17:"Invalid IP range.";
en	messages:ip_range_toolarge	s:45:"Range blocks larger than /$1 are not allowed.";
en	messages:blockme	s:8:"Block me";
en	messages:proxyblocker	s:13:"Proxy blocker";
en	linkTrail	s:18:"/^([a-z]+)(.*)$/sD";
en	messages:proxyblocker-disabled	s:26:"This function is disabled.";
en	messages:proxyblockreason	s:173:"Your IP address has been blocked because it is an open proxy.\nPlease contact your Internet service provider or tech support and inform them of this serious security problem.";
en	messages:proxyblocksuccess	s:5:"Done.";
en	messages:sorbs	s:5:"DNSBL";
en	messages:sorbsreason	s:77:"Your IP address is listed as an open proxy in the DNSBL used by {{SITENAME}}.";
en	messages:sorbs_create_account_reason	s:106:"Your IP address is listed as an open proxy in the DNSBL used by {{SITENAME}}.\nYou cannot create an account";
en	messages:cant-block-while-blocked	s:51:"You cannot block other users while you are blocked.";
en	messages:cant-see-hidden-user	s:152:"The user you are trying to block has already been blocked and hidden.\nSince you do not have the hideuser right, you cannot see or edit the user's block.";
en	messages:ipbblocked	s:73:"You cannot block or unblock other users, because you are yourself blocked";
en	messages:ipbnounblockself	s:39:"You are not allowed to unblock yourself";
en	messages:lockdb	s:13:"Lock database";
en	messages:unlockdb	s:15:"Unlock database";
en	messages:lockdbtext	s:294:"Locking the database will suspend the ability of all users to edit pages, change their preferences, edit their watchlists, and other things requiring changes in the database.\nPlease confirm that this is what you intend to do, and that you will unlock the database when your maintenance is done.";
en	messages:unlockdbtext	s:227:"Unlocking the database will restore the ability of all users to edit pages, change their preferences, edit their watchlists, and other things requiring changes in the database.\nPlease confirm that this is what you intend to do.";
en	messages:lockconfirm	s:40:"Yes, I really want to lock the database.";
en	messages:unlockconfirm	s:42:"Yes, I really want to unlock the database.";
en	messages:lockbtn	s:13:"Lock database";
en	messages:unlockbtn	s:15:"Unlock database";
en	messages:locknoconfirm	s:39:"You did not check the confirmation box.";
en	messages:lockdbsuccesssub	s:23:"Database lock succeeded";
en	messages:unlockdbsuccesssub	s:21:"Database lock removed";
en	messages:lockdbsuccesstext	s:120:"The database has been locked.<br />\nRemember to [[Special:UnlockDB|remove the lock]] after your maintenance is complete.";
en	messages:unlockdbsuccesstext	s:31:"The database has been unlocked.";
en	messages:lockfilenotwritable	s:116:"The database lock file is not writable.\nTo lock or unlock the database, this needs to be writable by the web server.";
en	messages:databasenotlocked	s:27:"The database is not locked.";
en	messages:move-page	s:7:"Move $1";
en	messages:move-page-backlink	s:6:"← $1";
en	messages:move-page-legend	s:9:"Move page";
en	messages:protectedpagemovewarning	s:159:"'''Warning:''' This page has been protected so that only users with administrator privileges can move it.\nThe latest log entry is provided below for reference:";
en	messages:semiprotectedpagemovewarning	s:137:"'''Note:''' This page has been protected so that only registered users can move it.\nThe latest log entry is provided below for reference:";
en	messages:movepagetext	s:883:"Using the form below will rename a page, moving all of its history to the new name.\nThe old title will become a redirect page to the new title.\nYou can update redirects that point to the original title automatically.\nIf you choose not to, be sure to check for [[Special:DoubleRedirects|double]] or [[Special:BrokenRedirects|broken redirects]].\nYou are responsible for making sure that links continue to point where they are supposed to go.\n\nNote that the page will '''not''' be moved if there is already a page at the new title, unless it is empty or a redirect and has no past edit history.\nThis means that you can rename a page back to where it was renamed from if you make a mistake, and you cannot overwrite an existing page.\n\n'''Warning!'''\nThis can be a drastic and unexpected change for a popular page;\nplease be sure you understand the consequences of this before proceeding.";
en	messages:movepagetext-noredirectfixer	s:788:"Using the form below will rename a page, moving all of its history to the new name.\nThe old title will become a redirect page to the new title.\nBe sure to check for [[Special:DoubleRedirects|double]] or [[Special:BrokenRedirects|broken redirects]].\nYou are responsible for making sure that links continue to point where they are supposed to go.\n\nNote that the page will '''not''' be moved if there is already a page at the new title, unless it is empty or a redirect and has no past edit history.\nThis means that you can rename a page back to where it was renamed from if you make a mistake, and you cannot overwrite an existing page.\n\n'''Warning!'''\nThis can be a drastic and unexpected change for a popular page;\nplease be sure you understand the consequences of this before proceeding.";
en	messages:movepagetalktext	s:247:"The associated talk page will be automatically moved along with it '''unless:'''\n*A non-empty talk page already exists under the new name, or\n*You uncheck the box below.\n\nIn those cases, you will have to move or merge the page manually if desired.";
en	messages:movearticle	s:10:"Move page:";
en	messages:moveuserpage-warning	s:132:"'''Warning:''' You are about to move a user page. Please note that only the page will be moved and the user will ''not'' be renamed.";
en	messages:movenologin	s:13:"Not logged in";
en	messages:movenologintext	s:81:"You must be a registered user and [[Special:UserLogin|logged in]] to move a page.";
en	messages:movenotallowed	s:41:"You do not have permission to move pages.";
en	messages:movenotallowedfile	s:41:"You do not have permission to move files.";
en	messages:cant-move-user-page	s:68:"You do not have permission to move user pages (apart from subpages).";
en	messages:cant-move-to-user-page	s:84:"You do not have permission to move a page to a user page (except to a user subpage).";
en	messages:newtitle	s:13:"To new title:";
en	messages:move-watch	s:33:"Watch source page and target page";
en	messages:movepagebtn	s:9:"Move page";
en	messages:pagemovedsub	s:14:"Move succeeded";
en	messages:movepage-moved	s:33:"'''"$1" has been moved to "$2"'''";
en	messages:movepage-moved-redirect	s:28:"A redirect has been created.";
en	messages:movepage-moved-noredirect	s:47:"The creation of a redirect has been suppressed.";
en	messages:articleexists	s:105:"A page of that name already exists, or the name you have chosen is not valid.\nPlease choose another name.";
en	messages:cantmove-titleprotected	s:95:"You cannot move a page to this location, because the new title has been protected from creation";
en	messages:talkexists	s:155:"'''The page itself was moved successfully, but the talk page could not be moved because one already exists at the new title.\nPlease merge them manually.'''";
en	messages:movedto	s:8:"moved to";
en	namespaceAliases	a:0:{}
en	messages:movetalk	s:25:"Move associated talk page";
en	messages:move-subpages	s:24:"Move subpages (up to $1)";
en	messages:move-talk-subpages	s:37:"Move subpages of talk page (up to $1)";
en	messages:movepage-page-exists	s:67:"The page $1 already exists and cannot be automatically overwritten.";
en	messages:movepage-page-moved	s:33:"The page $1 has been moved to $2.";
en	messages:movepage-page-unmoved	s:37:"The page $1 could not be moved to $2.";
en	messages:movepage-max-pages	s:98:"The maximum of $1 {{PLURAL:$1|page|pages}} has been moved and no more will be moved automatically.";
en	messages:1movedto2	s:22:"moved [[$1]] to [[$2]]";
en	messages:1movedto2_redir	s:36:"moved [[$1]] to [[$2]] over redirect";
en	messages:move-redirect-suppressed	s:19:"redirect suppressed";
en	messages:movelogpage	s:8:"Move log";
en	messages:movelogpagetext	s:34:"Below is a list of all page moves.";
en	messages:movesubpage	s:30:"{{PLURAL:$1|Subpage|Subpages}}";
en	messages:movesubpagetext	s:60:"This page has $1 {{PLURAL:$1|subpage|subpages}} shown below.";
en	messages:movenosubpage	s:26:"This page has no subpages.";
en	messages:movereason	s:7:"Reason:";
en	messages:revertmove	s:6:"revert";
en	messages:delete_and_move	s:15:"Delete and move";
en	messages:delete_and_move_text	s:121:"== Deletion required ==\nThe destination page "[[:$1]]" already exists.\nDo you want to delete it to make way for the move?";
en	messages:delete_and_move_confirm	s:20:"Yes, delete the page";
en	messages:delete_and_move_reason	s:28:"Deleted to make way for move";
en	messages:selfmove	s:75:"Source and destination titles are the same;\ncannot move a page over itself.";
en	messages:immobile-source-namespace	s:35:"Cannot move pages in namespace "$1"";
en	messages:immobile-target-namespace	s:37:"Cannot move pages into namespace "$1"";
en	messages:immobile-target-namespace-iw	s:51:"Interwiki link is not a valid target for page move.";
en	messages:immobile-source-page	s:25:"This page is not movable.";
en	messages:immobile-target-page	s:38:"Cannot move to that destination title.";
en	messages:imagenocrossnamespace	s:38:"Cannot move file to non-file namespace";
en	messages:nonfile-cannot-move-to-file	s:38:"Cannot move non-file to file namespace";
en	messages:imagetypemismatch	s:46:"The new file extension does not match its type";
en	messages:imageinvalidfilename	s:31:"The target file name is invalid";
en	messages:fix-double-redirects	s:53:"Update any redirects that point to the original title";
en	messages:move-leave-redirect	s:23:"Leave a redirect behind";
en	messages:move-over-sharedrepo	s:115:"== File exists ==\n[[:$1]] exists on a shared repository. Moving a file to this title will override the shared file.";
en	messages:file-exists-sharedrepo	s:90:"The file name chosen is already in use on a shared repository.\nPlease choose another name.";
en	messages:export	s:12:"Export pages";
en	messages:exporttext	s:588:"You can export the text and editing history of a particular page or set of pages wrapped in some XML.\nThis can be imported into another wiki using MediaWiki via the [[Special:Import|import page]].\n\nTo export pages, enter the titles in the text box below, one title per line, and select whether you want the current revision as well as all old revisions, with the page history lines, or the current revision with the info about the last edit.\n\nIn the latter case you can also use a link, for example [[{{#Special:Export}}/{{MediaWiki:Mainpage}}]] for the page "[[{{MediaWiki:Mainpage}}]]".";
en	messages:exportcuronly	s:55:"Include only the current revision, not the full history";
en	messages:exportnohistory	s:116:"----\n'''Note:''' Exporting the full history of pages through this form has been disabled due to performance reasons.";
en	messages:export-submit	s:6:"Export";
en	messages:export-addcattext	s:24:"Add pages from category:";
en	messages:export-addcat	s:3:"Add";
en	messages:export-addnstext	s:25:"Add pages from namespace:";
en	messages:export-addns	s:3:"Add";
en	messages:export-download	s:12:"Save as file";
en	messages:export-templates	s:17:"Include templates";
en	messages:export-pagelinks	s:35:"Include linked pages to a depth of:";
en	messages:allmessages	s:15:"System messages";
en	messages:allmessagesname	s:4:"Name";
en	messages:allmessagesdefault	s:20:"Default message text";
en	messages:allmessagescurrent	s:20:"Current message text";
en	messages:allmessagestext	s:266:"This is a list of system messages available in the MediaWiki namespace.\nPlease visit [http://www.mediawiki.org/wiki/Localisation MediaWiki Localisation] and [http://translatewiki.net translatewiki.net] if you wish to contribute to the generic MediaWiki localisation.";
en	messages:allmessagesnotsupportedDB	s:80:"This page cannot be used because '''$wgUseDatabaseMessages''' has been disabled.";
en	messages:allmessages-filter-legend	s:6:"Filter";
en	messages:allmessages-filter	s:30:"Filter by customisation state:";
en	messages:allmessages-filter-unmodified	s:10:"Unmodified";
en	messages:allmessages-filter-all	s:3:"All";
en	messages:allmessages-filter-modified	s:8:"Modified";
en	messages:allmessages-prefix	s:17:"Filter by prefix:";
en	messages:allmessages-language	s:9:"Language:";
en	messages:allmessages-filter-submit	s:2:"Go";
en	messages:thumbnail-more	s:7:"Enlarge";
en	messages:filemissing	s:12:"File missing";
en	messages:thumbnail_error	s:28:"Error creating thumbnail: $1";
en	messages:djvu_page_error	s:22:"DjVu page out of range";
en	messages:djvu_no_xml	s:33:"Unable to fetch XML for DjVu file";
en	messages:thumbnail_invalid_params	s:28:"Invalid thumbnail parameters";
en	messages:thumbnail_dest_directory	s:38:"Unable to create destination directory";
en	messages:thumbnail_image-type	s:24:"Image type not supported";
en	messages:thumbnail_gd-library	s:56:"Incomplete GD library configuration: missing function $1";
en	messages:thumbnail_image-missing	s:28:"File seems to be missing: $1";
en	messages:import	s:12:"Import pages";
en	messages:importinterwiki	s:16:"Transwiki import";
en	messages:import-interwiki-text	s:174:"Select a wiki and page title to import.\nRevision dates and editors' names will be preserved.\nAll transwiki import actions are logged at the [[Special:Log/import|import log]].";
en	messages:import-interwiki-source	s:17:"Source wiki/page:";
en	messages:import-interwiki-history	s:40:"Copy all history revisions for this page";
en	messages:import-interwiki-templates	s:21:"Include all templates";
en	messages:import-interwiki-submit	s:6:"Import";
en	messages:import-interwiki-namespace	s:22:"Destination namespace:";
en	messages:import-upload-filename	s:9:"Filename:";
en	messages:import-comment	s:8:"Comment:";
en	messages:importtext	s:133:"Please export the file from the source wiki using the [[Special:Export|export utility]].\nSave it to your computer and upload it here.";
en	messages:importstart	s:18:"Importing pages...";
en	messages:import-revision-count	s:35:"$1 {{PLURAL:$1|revision|revisions}}";
en	messages:importnopages	s:19:"No pages to import.";
en	messages:imported-log-entries	s:48:"Imported $1 {{PLURAL:$1|log entry|log entries}}.";
en	messages:importfailed	s:34:"Import failed: <nowiki>$1</nowiki>";
en	messages:importunknownsource	s:26:"Unknown import source type";
en	messages:importcantopen	s:26:"Could not open import file";
en	messages:importbadinterwiki	s:18:"Bad interwiki link";
en	messages:importnotext	s:16:"Empty or no text";
en	messages:importsuccess	s:16:"Import finished!";
en	messages:importhistoryconflict	s:72:"Conflicting history revision exists (may have imported this page before)";
en	messages:importnosources	s:86:"No transwiki import sources have been defined and direct history uploads are disabled.";
en	messages:importnofile	s:28:"No import file was uploaded.";
en	messages:importuploaderrorsize	s:78:"Upload of import file failed.\nThe file is bigger than the allowed upload size.";
en	messages:importuploaderrorpartial	s:67:"Upload of import file failed.\nThe file was only partially uploaded.";
en	messages:importuploaderrortemp	s:60:"Upload of import file failed.\nA temporary folder is missing.";
en	messages:import-parse-failure	s:24:"XML import parse failure";
en	messages:import-noarticle	s:18:"No page to import!";
en	messages:import-nonewrevisions	s:39:"All revisions were previously imported.";
en	messages:xml-error-string	s:35:"$1 at line $2, col $3 (byte $4): $5";
en	messages:import-upload	s:15:"Upload XML data";
en	messages:import-token-mismatch	s:39:"Loss of session data.\nPlease try again.";
en	messages:import-invalid-interwiki	s:38:"Cannot import from the specified wiki.";
en	messages:importlogpage	s:10:"Import log";
en	messages:importlogpagetext	s:67:"Administrative imports of pages with edit history from other wikis.";
en	messages:import-logentry-upload	s:30:"imported [[$1]] by file upload";
en	messages:import-logentry-upload-detail	s:35:"$1 {{PLURAL:$1|revision|revisions}}";
en	messages:import-logentry-interwiki	s:14:"transwikied $1";
en	messages:import-logentry-interwiki-detail	s:43:"$1 {{PLURAL:$1|revision|revisions}} from $2";
en	messages:accesskey-pt-userpage	s:1:".";
en	messages:accesskey-pt-anonuserpage	s:1:".";
en	messages:accesskey-pt-mytalk	s:1:"n";
en	messages:accesskey-pt-anontalk	s:1:"n";
en	messages:accesskey-pt-preferences	s:0:"";
en	messages:accesskey-pt-watchlist	s:1:"l";
en	messages:accesskey-pt-mycontris	s:1:"y";
en	messages:accesskey-pt-login	s:1:"o";
en	messages:accesskey-pt-anonlogin	s:1:"o";
en	messages:accesskey-pt-logout	s:0:"";
en	messages:accesskey-ca-talk	s:1:"t";
en	messages:accesskey-ca-edit	s:1:"e";
en	messages:accesskey-ca-addsection	s:1:"+";
en	messages:accesskey-ca-viewsource	s:1:"e";
en	messages:accesskey-ca-history	s:1:"h";
en	messages:accesskey-ca-protect	s:1:"=";
en	messages:accesskey-ca-unprotect	s:1:"=";
en	messages:accesskey-ca-delete	s:1:"d";
en	messages:accesskey-ca-undelete	s:1:"d";
en	messages:accesskey-ca-move	s:1:"m";
en	messages:accesskey-ca-watch	s:1:"w";
en	messages:accesskey-ca-unwatch	s:1:"w";
en	messages:accesskey-search	s:1:"f";
en	messages:accesskey-search-go	s:0:"";
en	messages:accesskey-search-fulltext	s:0:"";
en	messages:accesskey-p-logo	s:0:"";
en	messages:accesskey-n-mainpage	s:1:"z";
en	messages:accesskey-n-mainpage-description	s:1:"z";
en	messages:accesskey-n-portal	s:0:"";
en	messages:accesskey-n-currentevents	s:0:"";
en	messages:accesskey-n-recentchanges	s:1:"r";
en	messages:accesskey-n-randompage	s:1:"x";
en	messages:accesskey-n-help	s:0:"";
en	messages:accesskey-t-whatlinkshere	s:1:"j";
en	messages:accesskey-t-recentchangeslinked	s:1:"k";
en	messages:accesskey-feed-rss	s:0:"";
en	messages:accesskey-feed-atom	s:0:"";
en	messages:accesskey-t-contributions	s:0:"";
en	messages:accesskey-t-emailuser	s:0:"";
en	messages:accesskey-t-permalink	s:0:"";
en	messages:accesskey-t-print	s:1:"p";
en	messages:accesskey-t-upload	s:1:"u";
en	messages:accesskey-t-specialpages	s:1:"q";
en	messages:accesskey-ca-nstab-main	s:1:"c";
en	messages:accesskey-ca-nstab-user	s:1:"c";
en	messages:accesskey-ca-nstab-media	s:1:"c";
en	messages:accesskey-ca-nstab-special	s:0:"";
en	messages:accesskey-ca-nstab-project	s:1:"a";
en	messages:accesskey-ca-nstab-image	s:1:"c";
en	messages:accesskey-ca-nstab-mediawiki	s:1:"c";
en	messages:accesskey-ca-nstab-template	s:1:"c";
en	messages:accesskey-ca-nstab-help	s:1:"c";
en	messages:accesskey-ca-nstab-category	s:1:"c";
en	messages:accesskey-minoredit	s:1:"i";
en	messages:accesskey-save	s:1:"s";
en	messages:accesskey-preview	s:1:"p";
en	messages:accesskey-diff	s:1:"v";
en	messages:accesskey-compareselectedversions	s:1:"v";
en	messages:accesskey-watch	s:1:"w";
en	messages:accesskey-upload	s:1:"s";
en	messages:accesskey-preferences-save	s:1:"s";
en	messages:accesskey-summary	s:1:"b";
en	messages:accesskey-userrights-set	s:1:"s";
en	messages:accesskey-blockip-block	s:1:"s";
en	messages:accesskey-export	s:1:"s";
en	messages:accesskey-import	s:1:"s";
en	messages:tooltip-pt-userpage	s:14:"Your user page";
en	messages:tooltip-pt-anonuserpage	s:51:"The user page for the IP address you are editing as";
en	messages:tooltip-pt-mytalk	s:14:"Your talk page";
en	messages:tooltip-pt-anontalk	s:43:"Discussion about edits from this IP address";
en	messages:tooltip-pt-preferences	s:16:"Your preferences";
en	messages:tooltip-pt-watchlist	s:48:"The list of pages you are monitoring for changes";
en	messages:tooltip-pt-mycontris	s:26:"List of your contributions";
en	messages:tooltip-pt-login	s:58:"You are encouraged to log in; however, it is not mandatory";
en	messages:tooltip-pt-anonlogin	s:58:"You are encouraged to log in; however, it is not mandatory";
en	messages:tooltip-pt-logout	s:7:"Log out";
en	messages:tooltip-ca-talk	s:33:"Discussion about the content page";
en	messages:tooltip-ca-edit	s:67:"You can edit this page. Please use the preview button before saving";
en	messages:tooltip-ca-addsection	s:19:"Start a new section";
en	messages:tooltip-ca-viewsource	s:47:"This page is protected.\nYou can view its source";
en	messages:tooltip-ca-history	s:27:"Past revisions of this page";
en	messages:tooltip-ca-protect	s:17:"Protect this page";
en	messages:tooltip-ca-unprotect	s:19:"Unprotect this page";
en	messages:tooltip-ca-delete	s:16:"Delete this page";
en	messages:tooltip-ca-undelete	s:57:"Restore the edits done to this page before it was deleted";
en	messages:tooltip-ca-move	s:14:"Move this page";
en	messages:tooltip-ca-watch	s:31:"Add this page to your watchlist";
en	messages:tooltip-ca-unwatch	s:36:"Remove this page from your watchlist";
en	messages:tooltip-search	s:19:"Search {{SITENAME}}";
en	messages:tooltip-search-go	s:43:"Go to a page with this exact name if exists";
en	messages:tooltip-search-fulltext	s:30:"Search the pages for this text";
en	messages:tooltip-p-logo	s:19:"Visit the main page";
en	messages:tooltip-n-mainpage	s:19:"Visit the main page";
en	messages:tooltip-n-mainpage-description	s:19:"Visit the main page";
en	messages:tooltip-n-portal	s:56:"About the project, what you can do, where to find things";
en	messages:tooltip-n-currentevents	s:45:"Find background information on current events";
en	messages:tooltip-n-recentchanges	s:38:"The list of recent changes in the wiki";
en	messages:tooltip-n-randompage	s:18:"Load a random page";
en	messages:tooltip-n-help	s:21:"The place to find out";
en	messages:tooltip-t-whatlinkshere	s:37:"List of all wiki pages that link here";
en	messages:tooltip-t-recentchangeslinked	s:45:"Recent changes in pages linked from this page";
en	messages:tooltip-feed-rss	s:22:"RSS feed for this page";
en	messages:tooltip-feed-atom	s:23:"Atom feed for this page";
en	messages:tooltip-t-contributions	s:43:"View the list of contributions of this user";
en	messages:tooltip-t-emailuser	s:27:"Send an e-mail to this user";
en	messages:tooltip-t-upload	s:12:"Upload files";
en	messages:tooltip-t-specialpages	s:25:"List of all special pages";
en	messages:tooltip-t-print	s:30:"Printable version of this page";
en	messages:tooltip-t-permalink	s:43:"Permanent link to this revision of the page";
en	messages:tooltip-ca-nstab-main	s:21:"View the content page";
en	messages:tooltip-ca-nstab-user	s:18:"View the user page";
en	messages:tooltip-ca-nstab-media	s:19:"View the media page";
en	messages:tooltip-ca-nstab-special	s:55:"This is a special page, you cannot edit the page itself";
en	messages:tooltip-ca-nstab-project	s:21:"View the project page";
en	messages:tooltip-ca-nstab-image	s:18:"View the file page";
en	messages:tooltip-ca-nstab-mediawiki	s:23:"View the system message";
en	messages:tooltip-ca-nstab-template	s:17:"View the template";
en	messages:tooltip-ca-nstab-help	s:18:"View the help page";
en	messages:tooltip-ca-nstab-category	s:22:"View the category page";
en	messages:tooltip-minoredit	s:25:"Mark this as a minor edit";
en	messages:tooltip-save	s:17:"Save your changes";
en	messages:tooltip-preview	s:52:"Preview your changes, please use this before saving!";
en	messages:tooltip-diff	s:39:"Show which changes you made to the text";
en	messages:tooltip-compareselectedversions	s:67:"See the differences between the two selected revisions of this page";
en	messages:tooltip-watch	s:31:"Add this page to your watchlist";
en	messages:tooltip-recreate	s:49:"Recreate the page even though it has been deleted";
en	messages:tooltip-upload	s:12:"Start upload";
en	messages:tooltip-rollback	s:76:""Rollback" reverts edit(s) to this page of the last contributor in one click";
en	messages:tooltip-undo	s:107:""Undo" reverts this edit and opens the edit form in preview mode. It allows adding a reason in the summary.";
en	messages:tooltip-preferences-save	s:16:"Save preferences";
en	messages:tooltip-summary	s:21:"Enter a short summary";
en	messages:common.css	s:50:"/* CSS placed here will be applied to all skins */";
en	messages:standard.css	s:60:"/* CSS placed here will affect users of the Standard skin */";
en	messages:nostalgia.css	s:61:"/* CSS placed here will affect users of the Nostalgia skin */";
en	messages:cologneblue.css	s:64:"/* CSS placed here will affect users of the Cologne Blue skin */";
en	messages:monobook.css	s:60:"/* CSS placed here will affect users of the Monobook skin */";
en	messages:myskin.css	s:58:"/* CSS placed here will affect users of the MySkin skin */";
en	messages:chick.css	s:57:"/* CSS placed here will affect users of the Chick skin */";
en	messages:simple.css	s:58:"/* CSS placed here will affect users of the Simple skin */";
en	messages:modern.css	s:58:"/* CSS placed here will affect users of the Modern skin */";
en	messages:vector.css	s:58:"/* CSS placed here will affect users of the Vector skin */";
en	messages:print.css	s:50:"/* CSS placed here will affect the print output */";
en	messages:handheld.css	s:99:"/* CSS placed here will affect handheld devices based on the skin configured in $wgHandheldStyle */";
en	messages:common.js	s:74:"/* Any JavaScript here will be loaded for all users on every page load. */";
en	messages:standard.js	s:74:"/* Any JavaScript here will be loaded for users using the Standard skin */";
en	messages:nostalgia.js	s:75:"/* Any JavaScript here will be loaded for users using the Nostalgia skin */";
en	messages:cologneblue.js	s:78:"/* Any JavaScript here will be loaded for users using the Cologne Blue skin */";
en	messages:monobook.js	s:74:"/* Any JavaScript here will be loaded for users using the MonoBook skin */";
en	messages:myskin.js	s:72:"/* Any JavaScript here will be loaded for users using the MySkin skin */";
en	messages:chick.js	s:71:"/* Any JavaScript here will be loaded for users using the Chick skin */";
en	messages:simple.js	s:72:"/* Any JavaScript here will be loaded for users using the Simple skin */";
en	messages:modern.js	s:72:"/* Any JavaScript here will be loaded for users using the Modern skin */";
en	messages:vector.js	s:72:"/* Any JavaScript here will be loaded for users using the Vector skin */";
en	messages:nodublincore	s:50:"Dublin Core RDF metadata disabled for this server.";
en	messages:nocreativecommons	s:55:"Creative Commons RDF metadata disabled for this server.";
en	messages:notacceptable	s:69:"The wiki server cannot provide data in a format your client can read.";
en	messages:anonymous	s:50:"Anonymous {{PLURAL:$1|user|users}} of {{SITENAME}}";
en	messages:siteuser	s:20:"{{SITENAME}} user $1";
en	messages:anonuser	s:30:"{{SITENAME}} anonymous user $1";
en	messages:lastmodifiedatby	s:41:"This page was last modified $2, $1 by $3.";
en	messages:othercontribs	s:20:"Based on work by $1.";
en	messages:siteusers	s:40:"{{SITENAME}} {{PLURAL:$2|user|users}} $1";
en	messages:anonusers	s:50:"{{SITENAME}} anonymous {{PLURAL:$2|user|users}} $1";
en	messages:creditspage	s:12:"Page credits";
en	messages:nocredits	s:49:"There is no credits info available for this page.";
en	messages:spamprotectiontitle	s:22:"Spam protection filter";
en	messages:spamprotectiontext	s:125:"The text you wanted to save was blocked by the spam filter.\nThis is probably caused by a link to a blacklisted external site.";
en	messages:spamprotectionmatch	s:56:"The following text is what triggered our spam filter: $1";
en	messages:spambot_username	s:22:"MediaWiki spam cleanup";
en	messages:spam_reverting	s:53:"Reverting to last revision not containing links to $1";
en	messages:spam_blanking	s:45:"All revisions contained links to $1, blanking";
en	messages:infosubtitle	s:20:"Information for page";
en	messages:numedits	s:26:"Number of edits (page): $1";
en	messages:numtalkedits	s:37:"Number of edits (discussion page): $1";
en	messages:numwatchers	s:22:"Number of watchers: $1";
en	messages:numauthors	s:37:"Number of distinct authors (page): $1";
en	messages:numtalkauthors	s:48:"Number of distinct authors (discussion page): $1";
en	messages:skinname-standard	s:7:"Classic";
en	messages:skinname-nostalgia	s:9:"Nostalgia";
en	messages:skinname-cologneblue	s:12:"Cologne Blue";
en	messages:skinname-monobook	s:8:"MonoBook";
en	messages:skinname-myskin	s:6:"MySkin";
en	messages:skinname-chick	s:5:"Chick";
en	messages:skinname-simple	s:6:"Simple";
en	messages:skinname-modern	s:6:"Modern";
en	messages:skinname-vector	s:6:"Vector";
en	messages:mw_math_png	s:17:"Always render PNG";
en	messages:mw_math_simple	s:31:"HTML if very simple or else PNG";
en	messages:mw_math_html	s:28:"HTML if possible or else PNG";
en	messages:mw_math_source	s:35:"Leave it as TeX (for text browsers)";
en	messages:mw_math_modern	s:31:"Recommended for modern browsers";
en	messages:mw_math_mathml	s:33:"MathML if possible (experimental)";
en	messages:math_failure	s:15:"Failed to parse";
en	messages:math_unknown_error	s:13:"unknown error";
en	messages:math_unknown_function	s:16:"unknown function";
en	messages:math_lexing_error	s:12:"lexing error";
en	messages:math_syntax_error	s:12:"syntax error";
en	messages:math_image_error	s:99:"PNG conversion failed; check for correct installation of latex and dvipng (or dvips + gs + convert)";
en	messages:math_bad_tmpdir	s:45:"Cannot write to or create math temp directory";
en	messages:math_bad_output	s:47:"Cannot write to or create math output directory";
en	messages:math_notexvc	s:62:"Missing texvc executable; please see math/README to configure.";
en	messages:markaspatrolleddiff	s:17:"Mark as patrolled";
en	messages:markaspatrolledlink	s:4:"[$1]";
en	messages:markaspatrolledtext	s:27:"Mark this page as patrolled";
en	messages:markedaspatrolled	s:19:"Marked as patrolled";
en	messages:markedaspatrolledtext	s:62:"The selected revision of [[:$1]] has been marked as patrolled.";
en	messages:rcpatroldisabled	s:30:"Recent changes patrol disabled";
en	messages:exif-bitspersample	s:18:"Bits per component";
en	messages:rcpatroldisabledtext	s:56:"The recent changes patrol feature is currently disabled.";
en	messages:markedaspatrollederror	s:24:"Cannot mark as patrolled";
en	messages:markedaspatrollederrortext	s:52:"You need to specify a revision to mark as patrolled.";
en	messages:markedaspatrollederror-noautopatrol	s:58:"You are not allowed to mark your own changes as patrolled.";
en	messages:patrol-log-page	s:10:"Patrol log";
en	messages:patrol-log-header	s:37:"This is a log of patrolled revisions.";
en	messages:patrol-log-line	s:28:"marked $1 of $2 patrolled $3";
en	messages:patrol-log-auto	s:11:"(automatic)";
en	messages:patrol-log-diff	s:11:"revision $1";
en	messages:log-show-hide-patrol	s:13:"$1 patrol log";
en	messages:deletedrevision	s:23:"Deleted old revision $1";
en	messages:filedeleteerror-short	s:23:"Error deleting file: $1";
en	messages:filedeleteerror-long	s:52:"Errors were encountered while deleting the file:\n\n$1";
en	messages:filedelete-missing	s:59:"The file "$1" cannot be deleted, because it does not exist.";
en	messages:filedelete-old-unregistered	s:56:"The specified file revision "$1" is not in the database.";
en	messages:filedelete-current-unregistered	s:47:"The specified file "$1" is not in the database.";
en	messages:filedelete-archive-read-only	s:60:"The archive directory "$1" is not writable by the webserver.";
en	messages:previousdiff	s:14:"← Older edit";
en	messages:nextdiff	s:14:"Newer edit →";
en	messages:mediawarning	s:106:"'''Warning''': This file type may contain malicious code.\nBy executing it, your system may be compromised.";
en	messages:imagemaxsize	s:55:"Image size limit:<br />''(for file description pages)''";
en	messages:thumbsize	s:15:"Thumbnail size:";
en	messages:widthheight	s:6:"$1×$2";
en	messages:widthheightpage	s:35:"$1×$2, $3 {{PLURAL:$3|page|pages}}";
en	messages:file-info	s:28:"file size: $1, MIME type: $2";
en	messages:file-info-size	s:45:"$1 × $2 pixels, file size: $3, MIME type: $4";
en	messages:file-nohires	s:46:"<small>No higher resolution available.</small>";
en	messages:svg-long-desc	s:50:"SVG file, nominally $1 × $2 pixels, file size: $3";
en	messages:show-big-image	s:15:"Full resolution";
en	messages:show-big-image-thumb	s:52:"<small>Size of this preview: $1 × $2 pixels</small>";
en	messages:file-info-gif-looped	s:6:"looped";
en	messages:file-info-gif-frames	s:29:"$1 {{PLURAL:$1|frame|frames}}";
en	messages:file-info-png-looped	s:6:"looped";
en	messages:file-info-png-repeat	s:34:"played $1 {{PLURAL:$1|time|times}}";
en	messages:file-info-png-frames	s:29:"$1 {{PLURAL:$1|frame|frames}}";
en	messages:newimages	s:20:"Gallery of new files";
en	messages:imagelisttext	s:63:"Below is a list of '''$1''' {{PLURAL:$1|file|files}} sorted $2.";
en	messages:newimages-summary	s:48:"This special page shows the last uploaded files.";
en	messages:newimages-legend	s:6:"Filter";
en	messages:newimages-label	s:27:"Filename (or a part of it):";
en	messages:showhidebots	s:9:"($1 bots)";
en	messages:noimages	s:15:"Nothing to see.";
en	messages:ilsubmit	s:6:"Search";
en	messages:bydate	s:7:"by date";
en	messages:sp-newimages-showfrom	s:35:"Show new files starting from $2, $1";
en	messages:video-dims	s:10:"$1, $2×$3";
en	messages:seconds-abbrev	s:1:"s";
en	messages:minutes-abbrev	s:1:"m";
en	messages:hours-abbrev	s:1:"h";
en	messages:bad_image_list	s:252:"The format is as follows:\n\nOnly list items (lines starting with *) are considered.\nThe first link on a line must be a link to a bad file.\nAny subsequent links on the same line are considered to be exceptions, i.e. pages where the file may occur inline.";
en	messages:variantname-zh-hans	s:4:"hans";
en	messages:variantname-zh-hant	s:4:"hant";
en	messages:variantname-zh-cn	s:2:"cn";
en	messages:variantname-zh-tw	s:2:"tw";
en	messages:variantname-zh-hk	s:2:"hk";
en	messages:variantname-zh-mo	s:2:"mo";
en	messages:variantname-zh-sg	s:2:"sg";
en	messages:variantname-zh-my	s:2:"my";
en	messages:variantname-zh	s:2:"zh";
en	messages:variantname-gan-hans	s:4:"hans";
en	messages:variantname-gan-hant	s:4:"hant";
en	messages:variantname-gan	s:3:"gan";
en	messages:variantname-sr-ec	s:5:"sr-ec";
en	messages:variantname-sr-el	s:5:"sr-el";
en	messages:variantname-sr	s:2:"sr";
en	messages:variantname-kk-kz	s:5:"kk-kz";
en	messages:variantname-kk-tr	s:5:"kk-tr";
en	messages:variantname-kk-cn	s:5:"kk-cn";
en	messages:variantname-kk-cyrl	s:7:"kk-cyrl";
en	messages:variantname-kk-latn	s:7:"kk-latn";
en	messages:variantname-kk-arab	s:7:"kk-arab";
en	messages:variantname-kk	s:2:"kk";
en	messages:variantname-ku-arab	s:7:"ku-Arab";
en	messages:variantname-ku-latn	s:7:"ku-Latn";
en	messages:variantname-ku	s:2:"ku";
en	messages:variantname-tg-cyrl	s:7:"tg-Cyrl";
en	messages:variantname-tg-latn	s:7:"tg-Latn";
en	messages:variantname-tg	s:2:"tg";
en	messages:metadata	s:8:"Metadata";
en	messages:metadata-help	s:232:"This file contains additional information, probably added from the digital camera or scanner used to create or digitize it.\nIf the file has been modified from its original state, some details may not fully reflect the modified file.";
en	messages:metadata-expand	s:21:"Show extended details";
en	messages:metadata-collapse	s:21:"Hide extended details";
en	messages:metadata-fields	s:245:"EXIF metadata fields listed in this message will be included on image page display when the metadata table is collapsed.\nOthers will be hidden by default.\n* make\n* model\n* datetimeoriginal\n* exposuretime\n* fnumber\n* isospeedratings\n* focallength";
en	messages:exif-imagewidth	s:5:"Width";
en	messages:exif-imagelength	s:6:"Height";
en	messages:exif-compression	s:18:"Compression scheme";
en	messages:exif-photometricinterpretation	s:17:"Pixel composition";
en	messages:exif-orientation	s:11:"Orientation";
en	messages:exif-samplesperpixel	s:20:"Number of components";
en	messages:exif-planarconfiguration	s:16:"Data arrangement";
en	messages:exif-ycbcrsubsampling	s:27:"Subsampling ratio of Y to C";
en	messages:exif-ycbcrpositioning	s:19:"Y and C positioning";
en	messages:exif-xresolution	s:21:"Horizontal resolution";
en	messages:exif-yresolution	s:19:"Vertical resolution";
en	messages:exif-resolutionunit	s:26:"Unit of X and Y resolution";
en	messages:exif-stripoffsets	s:19:"Image data location";
en	messages:exif-rowsperstrip	s:24:"Number of rows per strip";
en	messages:exif-stripbytecounts	s:26:"Bytes per compressed strip";
en	messages:exif-jpeginterchangeformat	s:18:"Offset to JPEG SOI";
en	messages:exif-jpeginterchangeformatlength	s:18:"Bytes of JPEG data";
en	messages:exif-transferfunction	s:17:"Transfer function";
en	messages:exif-whitepoint	s:24:"White point chromaticity";
en	messages:exif-primarychromaticities	s:29:"Chromaticities of primarities";
en	messages:exif-ycbcrcoefficients	s:46:"Color space transformation matrix coefficients";
en	messages:exif-referenceblackwhite	s:40:"Pair of black and white reference values";
en	messages:exif-datetime	s:25:"File change date and time";
en	messages:exif-imagedescription	s:11:"Image title";
en	messages:exif-make	s:19:"Camera manufacturer";
en	messages:exif-model	s:12:"Camera model";
en	messages:exif-software	s:13:"Software used";
en	messages:exif-artist	s:6:"Author";
en	messages:exif-copyright	s:16:"Copyright holder";
en	messages:exif-exifversion	s:12:"Exif version";
en	messages:exif-flashpixversion	s:26:"Supported Flashpix version";
en	messages:exif-colorspace	s:11:"Color space";
en	messages:exif-componentsconfiguration	s:25:"Meaning of each component";
en	messages:exif-compressedbitsperpixel	s:22:"Image compression mode";
en	messages:exif-pixelydimension	s:11:"Image width";
en	messages:exif-pixelxdimension	s:12:"Image height";
en	messages:exif-makernote	s:18:"Manufacturer notes";
en	messages:exif-usercomment	s:13:"User comments";
en	messages:exif-relatedsoundfile	s:18:"Related audio file";
en	messages:exif-datetimeoriginal	s:32:"Date and time of data generation";
en	messages:exif-datetimedigitized	s:27:"Date and time of digitizing";
en	messages:exif-subsectime	s:19:"DateTime subseconds";
en	messages:exif-subsectimeoriginal	s:27:"DateTimeOriginal subseconds";
en	messages:exif-subsectimedigitized	s:28:"DateTimeDigitized subseconds";
en	messages:exif-exposuretime	s:13:"Exposure time";
en	messages:exif-exposuretime-format	s:11:"$1 sec ($2)";
en	messages:exif-fnumber	s:8:"F Number";
en	messages:exif-fnumber-format	s:4:"f/$1";
en	messages:exif-exposureprogram	s:16:"Exposure Program";
en	messages:exif-spectralsensitivity	s:20:"Spectral sensitivity";
en	messages:exif-isospeedratings	s:16:"ISO speed rating";
en	messages:exif-oecf	s:32:"Optoelectronic conversion factor";
en	messages:exif-shutterspeedvalue	s:18:"APEX shutter speed";
en	messages:exif-aperturevalue	s:13:"APEX aperture";
en	messages:exif-brightnessvalue	s:15:"APEX brightness";
en	messages:exif-exposurebiasvalue	s:18:"APEX exposure bias";
en	messages:exif-maxaperturevalue	s:21:"Maximum land aperture";
en	messages:exif-subjectdistance	s:16:"Subject distance";
en	messages:exif-meteringmode	s:13:"Metering mode";
en	messages:exif-lightsource	s:12:"Light source";
en	messages:exif-flash	s:5:"Flash";
en	messages:exif-focallength	s:17:"Lens focal length";
en	messages:exif-focallength-format	s:5:"$1 mm";
en	messages:exif-subjectarea	s:12:"Subject area";
en	messages:exif-flashenergy	s:12:"Flash energy";
en	messages:exif-spatialfrequencyresponse	s:26:"Spatial frequency response";
en	messages:exif-focalplanexresolution	s:24:"Focal plane X resolution";
en	messages:exif-focalplaneyresolution	s:24:"Focal plane Y resolution";
en	messages:exif-focalplaneresolutionunit	s:27:"Focal plane resolution unit";
en	messages:exif-subjectlocation	s:16:"Subject location";
en	messages:exif-exposureindex	s:14:"Exposure index";
en	messages:exif-sensingmethod	s:14:"Sensing method";
en	messages:exif-filesource	s:11:"File source";
en	messages:exif-scenetype	s:10:"Scene type";
en	messages:exif-cfapattern	s:11:"CFA pattern";
en	messages:exif-customrendered	s:23:"Custom image processing";
en	messages:exif-exposuremode	s:13:"Exposure mode";
en	messages:exif-whitebalance	s:13:"White balance";
en	messages:exif-digitalzoomratio	s:18:"Digital zoom ratio";
en	messages:exif-focallengthin35mmfilm	s:26:"Focal length in 35 mm film";
en	messages:exif-scenecapturetype	s:18:"Scene capture type";
en	messages:exif-gaincontrol	s:13:"Scene control";
en	messages:exif-contrast	s:8:"Contrast";
en	messages:exif-saturation	s:10:"Saturation";
en	messages:exif-sharpness	s:9:"Sharpness";
en	messages:exif-devicesettingdescription	s:27:"Device settings description";
en	messages:exif-subjectdistancerange	s:22:"Subject distance range";
en	messages:exif-imageuniqueid	s:15:"Unique image ID";
en	messages:exif-gpsversionid	s:15:"GPS tag version";
en	messages:exif-gpslatituderef	s:23:"North or south latitude";
en	messages:exif-gpslatitude	s:8:"Latitude";
en	messages:exif-gpslongituderef	s:22:"East or west longitude";
en	messages:exif-gpslongitude	s:9:"Longitude";
en	messages:exif-gpsaltituderef	s:18:"Altitude reference";
en	messages:exif-gpsaltitude	s:8:"Altitude";
en	messages:exif-gpstimestamp	s:23:"GPS time (atomic clock)";
en	messages:exif-gpssatellites	s:31:"Satellites used for measurement";
en	messages:exif-gpsstatus	s:15:"Receiver status";
en	messages:exif-gpsmeasuremode	s:16:"Measurement mode";
en	messages:exif-gpsdop	s:21:"Measurement precision";
en	messages:exif-gpsspeedref	s:10:"Speed unit";
en	messages:exif-gpsspeed	s:21:"Speed of GPS receiver";
en	messages:exif-gpstrackref	s:35:"Reference for direction of movement";
en	messages:exif-gpstrack	s:21:"Direction of movement";
en	messages:exif-gpsimgdirectionref	s:32:"Reference for direction of image";
en	messages:exif-gpsimgdirection	s:18:"Direction of image";
en	messages:exif-gpsmapdatum	s:25:"Geodetic survey data used";
en	messages:exif-gpsdestlatituderef	s:37:"Reference for latitude of destination";
en	messages:exif-gpsdestlatitude	s:20:"Latitude destination";
en	messages:exif-gpsdestlongituderef	s:38:"Reference for longitude of destination";
en	messages:exif-gpsdestlongitude	s:24:"Longitude of destination";
en	messages:exif-gpsdestbearingref	s:36:"Reference for bearing of destination";
en	messages:exif-gpsdestbearing	s:22:"Bearing of destination";
en	messages:exif-gpsdestdistanceref	s:37:"Reference for distance to destination";
en	messages:exif-gpsdestdistance	s:23:"Distance to destination";
en	messages:exif-gpsprocessingmethod	s:29:"Name of GPS processing method";
en	messages:exif-gpsareainformation	s:16:"Name of GPS area";
en	messages:exif-gpsdatestamp	s:8:"GPS date";
en	messages:exif-gpsdifferential	s:27:"GPS differential correction";
en	messages:exif-objectname	s:11:"Short title";
en	messages:exif-make-value	s:2:"$1";
en	messages:exif-model-value	s:2:"$1";
en	messages:exif-software-value	s:2:"$1";
en	messages:exif-compression-1	s:12:"Uncompressed";
en	messages:exif-compression-6	s:4:"JPEG";
en	messages:exif-photometricinterpretation-2	s:3:"RGB";
en	messages:exif-photometricinterpretation-6	s:5:"YCbCr";
en	messages:exif-unknowndate	s:12:"Unknown date";
en	messages:exif-orientation-1	s:6:"Normal";
en	messages:exif-orientation-2	s:20:"Flipped horizontally";
en	messages:exif-orientation-3	s:13:"Rotated 180°";
en	messages:exif-orientation-4	s:18:"Flipped vertically";
en	messages:exif-orientation-5	s:39:"Rotated 90° CCW and flipped vertically";
en	messages:exif-orientation-6	s:15:"Rotated 90° CW";
en	messages:exif-orientation-7	s:38:"Rotated 90° CW and flipped vertically";
en	messages:exif-orientation-8	s:16:"Rotated 90° CCW";
en	messages:exif-planarconfiguration-1	s:13:"chunky format";
en	messages:exif-planarconfiguration-2	s:13:"planar format";
en	messages:exif-xyresolution-i	s:6:"$1 dpi";
en	messages:exif-xyresolution-c	s:6:"$1 dpc";
en	messages:exif-colorspace-1	s:4:"sRGB";
en	messages:exif-colorspace-ffff.h	s:6:"FFFF.H";
en	messages:exif-componentsconfiguration-0	s:14:"does not exist";
en	messages:exif-componentsconfiguration-1	s:1:"Y";
en	messages:exif-componentsconfiguration-2	s:2:"Cb";
en	messages:exif-componentsconfiguration-3	s:2:"Cr";
en	messages:exif-componentsconfiguration-4	s:1:"R";
en	messages:exif-componentsconfiguration-5	s:1:"G";
en	messages:exif-componentsconfiguration-6	s:1:"B";
en	messages:exif-exposureprogram-0	s:11:"Not defined";
en	messages:exif-exposureprogram-1	s:6:"Manual";
en	messages:exif-exposureprogram-2	s:14:"Normal program";
en	messages:exif-exposureprogram-3	s:17:"Aperture priority";
en	messages:exif-exposureprogram-4	s:16:"Shutter priority";
en	messages:exif-exposureprogram-5	s:47:"Creative program (biased toward depth of field)";
en	messages:exif-exposureprogram-6	s:49:"Action program (biased toward fast shutter speed)";
en	messages:exif-exposureprogram-7	s:67:"Portrait mode (for closeup photos with the background out of focus)";
en	messages:exif-exposureprogram-8	s:66:"Landscape mode (for landscape photos with the background in focus)";
en	messages:exif-subjectdistance-value	s:9:"$1 meters";
en	messages:exif-meteringmode-0	s:7:"Unknown";
en	messages:exif-meteringmode-1	s:7:"Average";
en	messages:exif-meteringmode-2	s:23:"Center weighted average";
en	messages:exif-meteringmode-3	s:4:"Spot";
en	messages:exif-meteringmode-4	s:10:"Multi-Spot";
en	messages:exif-meteringmode-5	s:7:"Pattern";
en	messages:exif-meteringmode-6	s:7:"Partial";
en	messages:exif-meteringmode-255	s:5:"Other";
en	messages:exif-lightsource-0	s:7:"Unknown";
en	messages:exif-lightsource-1	s:8:"Daylight";
en	messages:exif-lightsource-2	s:11:"Fluorescent";
en	messages:exif-lightsource-3	s:29:"Tungsten (incandescent light)";
en	messages:exif-lightsource-4	s:5:"Flash";
en	messages:exif-lightsource-9	s:12:"Fine weather";
en	messages:exif-lightsource-10	s:14:"Cloudy weather";
en	messages:exif-lightsource-11	s:5:"Shade";
en	messages:exif-lightsource-12	s:39:"Daylight fluorescent (D 5700 – 7100K)";
en	messages:exif-lightsource-13	s:40:"Day white fluorescent (N 4600 – 5400K)";
en	messages:exif-lightsource-14	s:41:"Cool white fluorescent (W 3900 – 4500K)";
en	messages:exif-lightsource-15	s:37:"White fluorescent (WW 3200 – 3700K)";
en	messages:exif-lightsource-17	s:16:"Standard light A";
en	messages:exif-lightsource-18	s:16:"Standard light B";
en	messages:exif-lightsource-19	s:16:"Standard light C";
en	messages:exif-lightsource-20	s:3:"D55";
en	messages:exif-lightsource-21	s:3:"D65";
en	messages:exif-lightsource-22	s:3:"D75";
en	messages:exif-lightsource-23	s:3:"D50";
en	messages:exif-lightsource-24	s:19:"ISO studio tungsten";
en	messages:exif-lightsource-255	s:18:"Other light source";
en	messages:exif-flash-fired-0	s:18:"Flash did not fire";
en	messages:exif-flash-fired-1	s:11:"Flash fired";
en	messages:exif-flash-return-0	s:35:"no strobe return detection function";
en	messages:exif-flash-return-2	s:32:"strobe return light not detected";
en	messages:exif-flash-return-3	s:28:"strobe return light detected";
en	messages:exif-flash-mode-1	s:23:"compulsory flash firing";
en	messages:exif-flash-mode-2	s:28:"compulsory flash suppression";
en	messages:exif-flash-mode-3	s:9:"auto mode";
en	messages:exif-flash-function-1	s:17:"No flash function";
en	messages:exif-flash-redeye-1	s:22:"red-eye reduction mode";
en	messages:exif-focalplaneresolutionunit-2	s:6:"inches";
en	messages:exif-sensingmethod-1	s:9:"Undefined";
en	messages:exif-sensingmethod-2	s:26:"One-chip color area sensor";
en	messages:exif-sensingmethod-3	s:26:"Two-chip color area sensor";
en	messages:exif-sensingmethod-4	s:28:"Three-chip color area sensor";
en	messages:exif-sensingmethod-5	s:28:"Color sequential area sensor";
en	messages:exif-sensingmethod-7	s:16:"Trilinear sensor";
en	messages:exif-sensingmethod-8	s:30:"Color sequential linear sensor";
en	messages:exif-filesource-3	s:20:"Digital still camera";
en	messages:exif-scenetype-1	s:29:"A directly photographed image";
en	messages:exif-customrendered-0	s:14:"Normal process";
en	messages:exif-customrendered-1	s:14:"Custom process";
en	messages:exif-exposuremode-0	s:13:"Auto exposure";
en	messages:exif-exposuremode-1	s:15:"Manual exposure";
en	messages:exif-exposuremode-2	s:12:"Auto bracket";
en	messages:exif-whitebalance-0	s:18:"Auto white balance";
en	messages:exif-whitebalance-1	s:20:"Manual white balance";
en	messages:exif-scenecapturetype-0	s:8:"Standard";
en	messages:exif-scenecapturetype-1	s:9:"Landscape";
en	messages:exif-scenecapturetype-2	s:8:"Portrait";
en	messages:exif-scenecapturetype-3	s:11:"Night scene";
en	messages:exif-gaincontrol-0	s:4:"None";
en	messages:exif-gaincontrol-1	s:11:"Low gain up";
en	messages:exif-gaincontrol-2	s:12:"High gain up";
en	messages:exif-gaincontrol-3	s:13:"Low gain down";
en	messages:exif-gaincontrol-4	s:14:"High gain down";
en	messages:exif-contrast-0	s:6:"Normal";
en	messages:exif-contrast-1	s:4:"Soft";
en	messages:exif-contrast-2	s:4:"Hard";
en	messages:exif-saturation-0	s:6:"Normal";
en	messages:exif-saturation-1	s:14:"Low saturation";
en	messages:exif-saturation-2	s:15:"High saturation";
en	messages:exif-sharpness-0	s:6:"Normal";
en	messages:exif-sharpness-1	s:4:"Soft";
en	messages:exif-sharpness-2	s:4:"Hard";
en	messages:exif-subjectdistancerange-0	s:7:"Unknown";
en	messages:exif-subjectdistancerange-1	s:5:"Macro";
en	messages:exif-subjectdistancerange-2	s:10:"Close view";
en	messages:exif-subjectdistancerange-3	s:12:"Distant view";
en	messages:exif-gpslatitude-n	s:14:"North latitude";
en	messages:exif-gpslatitude-s	s:14:"South latitude";
en	messages:exif-gpslongitude-e	s:14:"East longitude";
en	messages:exif-gpslongitude-w	s:14:"West longitude";
en	messages:exif-gpsstatus-a	s:23:"Measurement in progress";
en	messages:exif-gpsstatus-v	s:28:"Measurement interoperability";
en	messages:exif-gpsmeasuremode-2	s:25:"2-dimensional measurement";
en	messages:exif-gpsmeasuremode-3	s:25:"3-dimensional measurement";
en	messages:exif-gpsspeed-k	s:19:"Kilometers per hour";
en	messages:exif-gpsspeed-m	s:14:"Miles per hour";
en	messages:exif-gpsspeed-n	s:5:"Knots";
en	messages:exif-gpsdirection-t	s:14:"True direction";
en	messages:exif-gpsdirection-m	s:18:"Magnetic direction";
en	messages:edit-externally	s:44:"Edit this file using an external application";
en	messages:edit-externally-help	s:105:"(See the [http://www.mediawiki.org/wiki/Manual:External_editors setup instructions] for more information)";
en	messages:recentchangesall	s:3:"all";
en	messages:imagelistall	s:3:"all";
en	messages:watchlistall2	s:3:"all";
en	messages:namespacesall	s:3:"all";
en	messages:monthsall	s:3:"all";
en	messages:limitall	s:3:"all";
en	messages:confirmemail	s:22:"Confirm e-mail address";
en	messages:confirmemail_noemail	s:92:"You do not have a valid e-mail address set in your [[Special:Preferences|user preferences]].";
en	messages:confirmemail_text	s:284:"{{SITENAME}} requires that you validate your e-mail address before using e-mail features.\nActivate the button below to send a confirmation mail to your address.\nThe mail will include a link containing a code;\nload the link in your browser to confirm that your e-mail address is valid.";
en	messages:confirmemail_pending	s:180:"A confirmation code has already been e-mailed to you;\nif you recently created your account, you may wish to wait a few minutes for it to arrive before trying to request a new code.";
en	messages:confirmemail_send	s:24:"Mail a confirmation code";
en	messages:confirmemail_sent	s:25:"Confirmation e-mail sent.";
en	messages:confirmemail_oncreate	s:176:"A confirmation code was sent to your e-mail address.\nThis code is not required to log in, but you will need to provide it before enabling any e-mail-based features in the wiki.";
en	messages:confirmemail_sendfailed	s:129:"{{SITENAME}} could not send your confirmation mail.\nPlease check your e-mail address for invalid characters.\n\nMailer returned: $1";
en	messages:confirmemail_invalid	s:53:"Invalid confirmation code.\nThe code may have expired.";
en	messages:confirmemail_needlogin	s:46:"You need to $1 to confirm your e-mail address.";
en	messages:confirmemail_success	s:100:"Your e-mail address has been confirmed.\nYou may now [[Special:UserLogin|log in]] and enjoy the wiki.";
en	messages:confirmemail_loggedin	s:43:"Your e-mail address has now been confirmed.";
en	messages:confirmemail_error	s:46:"Something went wrong saving your confirmation.";
en	messages:confirmemail_subject	s:40:"{{SITENAME}} e-mail address confirmation";
en	messages:confirmemail_body	s:400:"Someone, probably you, from IP address $1,\nhas registered an account "$2" with this e-mail address on {{SITENAME}}.\n\nTo confirm that this account really does belong to you and activate\ne-mail features on {{SITENAME}}, open this link in your browser:\n\n$3\n\nIf you did *not* register the account, follow this link\nto cancel the e-mail address confirmation:\n\n$5\n\nThis confirmation code will expire at $4.";
en	messages:confirmemail_body_changed	s:415:"Someone, probably you, from IP address $1,\nhas changed the e-mail address of the account "$2" to this address on {{SITENAME}}.\n\nTo confirm that this account really does belong to you and reactivate\ne-mail features on {{SITENAME}}, open this link in your browser:\n\n$3\n\nIf the account does *not* belong to you, follow this link\nto cancel the e-mail address confirmation:\n\n$5\n\nThis confirmation code will expire at $4.";
en	messages:confirmemail_body_set	s:411:"Someone, probably you, from IP address $1,\nhas set the e-mail address of the account "$2" to this address on {{SITENAME}}.\n\nTo confirm that this account really does belong to you and reactivate\ne-mail features on {{SITENAME}}, open this link in your browser:\n\n$3\n\nIf the account does *not* belong to you, follow this link\nto cancel the e-mail address confirmation:\n\n$5\n\nThis confirmation code will expire at $4.";
en	messages:confirmemail_invalidated	s:36:"E-mail address confirmation canceled";
en	messages:invalidateemail	s:26:"Cancel e-mail confirmation";
en	messages:scarytranscludedisabled	s:36:"[Interwiki transcluding is disabled]";
en	messages:scarytranscludefailed	s:30:"[Template fetch failed for $1]";
en	messages:scarytranscludetoolong	s:17:"[URL is too long]";
en	messages:trackbackbox	s:34:"Trackbacks for this page:<br />\n$1";
en	messages:trackback	s:16:"; $4 $5: [$2 $1]";
en	messages:trackbackexcerpt	s:37:"; $4 $5: [$2 $1]: <nowiki>$3</nowiki>";
en	messages:trackbackremove	s:13:"([$1 Delete])";
en	messages:trackbacklink	s:9:"Trackback";
en	messages:trackbackdeleteok	s:39:"The trackback was successfully deleted.";
en	messages:deletedwhileediting	s:63:"'''Warning''': This page was deleted after you started editing!";
en	messages:confirmrecreate	s:168:"User [[User:$1|$1]] ([[User talk:$1|talk]]) deleted this page after you started editing with reason:\n: ''$2''\nPlease confirm that you really want to recreate this page.";
en	messages:recreate	s:8:"Recreate";
en	messages:unit-pixel	s:2:"px";
en	messages:confirm_purge_button	s:2:"OK";
en	messages:confirm-purge-top	s:29:"Clear the cache of this page?";
en	messages:confirm-purge-bottom	s:79:"Purging a page clears the cache and forces the most current revision to appear.";
en	messages:catseparator	s:1:"|";
en	messages:semicolon-separator	s:6:";&#32;";
en	messages:comma-separator	s:6:",&#32;";
en	messages:colon-separator	s:6:":&#32;";
en	messages:autocomment-prefix	s:6:"-&#32;";
en	messages:pipe-separator	s:11:"&#32;|&#32;";
en	messages:word-separator	s:5:"&#32;";
en	messages:ellipsis	s:3:"...";
en	messages:percent	s:3:"$1%";
en	messages:parentheses	s:4:"($1)";
en	messages:imgmultipageprev	s:17:"← previous page";
en	messages:imgmultipagenext	s:13:"next page →";
en	messages:imgmultigo	s:3:"Go!";
en	messages:imgmultigoto	s:13:"Go to page $1";
en	messages:ascending_abbrev	s:3:"asc";
en	messages:descending_abbrev	s:4:"desc";
en	messages:table_pager_next	s:9:"Next page";
en	messages:table_pager_prev	s:13:"Previous page";
en	messages:table_pager_first	s:10:"First page";
en	messages:table_pager_last	s:9:"Last page";
en	messages:table_pager_limit	s:22:"Show $1 items per page";
en	messages:table_pager_limit_label	s:15:"Items per page:";
en	messages:table_pager_limit_submit	s:2:"Go";
en	messages:table_pager_empty	s:10:"No results";
en	messages:autosumm-blank	s:16:"Blanked the page";
en	messages:autosumm-replace	s:26:"Replaced content with "$1"";
en	messages:autoredircomment	s:25:"Redirected page to [[$1]]";
en	messages:autosumm-new	s:22:"Created page with "$1"";
en	messages:autoblock_whitelist	s:406:"AOL http://webmaster.info.aol.com/proxyinfo.html\n*64.12.96.0/19\n*149.174.160.0/20\n*152.163.240.0/21\n*152.163.248.0/22\n*152.163.252.0/23\n*152.163.96.0/22\n*152.163.100.0/23\n*195.93.32.0/22\n*195.93.48.0/22\n*195.93.64.0/19\n*195.93.96.0/19\n*195.93.16.0/20\n*198.81.0.0/22\n*198.81.16.0/20\n*198.81.8.0/23\n*202.67.64.128/25\n*205.188.192.0/20\n*205.188.208.0/23\n*205.188.112.0/20\n*205.188.146.144/30\n*207.200.112.0/21";
en	messages:size-bytes	s:4:"$1 B";
en	messages:size-kilobytes	s:5:"$1 KB";
en	messages:size-megabytes	s:5:"$1 MB";
en	messages:size-gigabytes	s:5:"$1 GB";
en	messages:livepreview-loading	s:10:"Loading...";
en	messages:livepreview-ready	s:17:"Loading... Ready!";
en	messages:livepreview-failed	s:40:"Live preview failed!\nTry normal preview.";
en	messages:livepreview-error	s:47:"Failed to connect: $1 "$2".\nTry normal preview.";
en	messages:lag-warn-normal	s:81:"Changes newer than $1 {{PLURAL:$1|second|seconds}} may not be shown in this list.";
en	messages:lag-warn-high	s:114:"Due to high database server lag, changes newer than $1 {{PLURAL:$1|second|seconds}} may not be shown in this list.";
en	messages:watchlistedit-numitems	s:78:"Your watchlist contains {{PLURAL:$1|1 title|$1 titles}}, excluding talk pages.";
en	messages:watchlistedit-noitems	s:34:"Your watchlist contains no titles.";
en	messages:watchlistedit-normal-title	s:14:"Edit watchlist";
en	messages:watchlistedit-normal-legend	s:28:"Remove titles from watchlist";
en	messages:watchlistedit-normal-explain	s:193:"Titles on your watchlist are shown below.\nTo remove a title, check the box next to it, and click "{{int:Watchlistedit-normal-submit}}".\nYou can also [[Special:Watchlist/raw|edit the raw list]].";
en	messages:watchlistedit-normal-submit	s:13:"Remove titles";
en	messages:watchlistedit-normal-done	s:69:"{{PLURAL:$1|1 title was|$1 titles were}} removed from your watchlist:";
en	messages:watchlistedit-raw-title	s:18:"Edit raw watchlist";
en	messages:watchlistedit-raw-legend	s:18:"Edit raw watchlist";
en	messages:watchlistedit-raw-explain	s:242:"Titles on your watchlist are shown below, and can be edited by adding to and removing from the list;\none title per line.\nWhen finished, click "{{int:Watchlistedit-raw-submit}}".\nYou can also [[Special:Watchlist/edit|use the standard editor]].";
en	messages:watchlistedit-raw-titles	s:7:"Titles:";
en	messages:watchlistedit-raw-submit	s:16:"Update watchlist";
en	messages:watchlistedit-raw-done	s:32:"Your watchlist has been updated.";
en	messages:watchlistedit-raw-added	s:47:"{{PLURAL:$1|1 title was|$1 titles were}} added:";
en	messages:watchlistedit-raw-removed	s:49:"{{PLURAL:$1|1 title was|$1 titles were}} removed:";
en	messages:watchlisttools-view	s:21:"View relevant changes";
en	messages:watchlisttools-edit	s:23:"View and edit watchlist";
en	messages:watchlisttools-raw	s:18:"Edit raw watchlist";
en	messages:iranian-calendar-m1	s:9:"Farvardin";
en	messages:iranian-calendar-m2	s:11:"Ordibehesht";
en	messages:iranian-calendar-m3	s:7:"Khordad";
en	messages:iranian-calendar-m4	s:3:"Tir";
en	messages:iranian-calendar-m5	s:6:"Mordad";
en	messages:iranian-calendar-m6	s:9:"Shahrivar";
en	messages:iranian-calendar-m7	s:4:"Mehr";
en	messages:iranian-calendar-m8	s:4:"Aban";
en	messages:iranian-calendar-m9	s:4:"Azar";
en	messages:iranian-calendar-m10	s:3:"Dey";
en	messages:iranian-calendar-m11	s:6:"Bahman";
en	messages:iranian-calendar-m12	s:6:"Esfand";
en	messages:hijri-calendar-m1	s:8:"Muharram";
en	messages:hijri-calendar-m2	s:5:"Safar";
en	messages:hijri-calendar-m3	s:14:"Rabi' al-awwal";
en	messages:hijri-calendar-m4	s:14:"Rabi' al-thani";
en	messages:hijri-calendar-m5	s:15:"Jumada al-awwal";
en	messages:hijri-calendar-m6	s:15:"Jumada al-thani";
en	messages:hijri-calendar-m7	s:5:"Rajab";
en	messages:hijri-calendar-m8	s:8:"Sha'aban";
en	messages:hijri-calendar-m9	s:7:"Ramadan";
en	messages:hijri-calendar-m10	s:7:"Shawwal";
en	messages:hijri-calendar-m11	s:13:"Dhu al-Qi'dah";
en	messages:hijri-calendar-m12	s:13:"Dhu al-Hijjah";
en	messages:hebrew-calendar-m1	s:7:"Tishrei";
en	messages:hebrew-calendar-m2	s:8:"Cheshvan";
en	messages:hebrew-calendar-m3	s:6:"Kislev";
en	messages:hebrew-calendar-m4	s:5:"Tevet";
en	messages:hebrew-calendar-m5	s:6:"Shevat";
en	messages:hebrew-calendar-m6	s:4:"Adar";
en	messages:hebrew-calendar-m6a	s:6:"Adar I";
en	messages:hebrew-calendar-m6b	s:7:"Adar II";
en	messages:hebrew-calendar-m7	s:5:"Nisan";
en	messages:hebrew-calendar-m8	s:4:"Iyar";
en	messages:hebrew-calendar-m9	s:5:"Sivan";
en	messages:hebrew-calendar-m10	s:5:"Tamuz";
en	messages:hebrew-calendar-m11	s:2:"Av";
en	messages:hebrew-calendar-m12	s:4:"Elul";
en	messages:hebrew-calendar-m1-gen	s:7:"Tishrei";
en	messages:hebrew-calendar-m2-gen	s:8:"Cheshvan";
en	messages:hebrew-calendar-m3-gen	s:6:"Kislev";
en	messages:hebrew-calendar-m4-gen	s:5:"Tevet";
en	messages:hebrew-calendar-m5-gen	s:6:"Shevat";
en	messages:hebrew-calendar-m6-gen	s:4:"Adar";
en	messages:hebrew-calendar-m6a-gen	s:6:"Adar I";
en	messages:hebrew-calendar-m6b-gen	s:7:"Adar II";
en	messages:hebrew-calendar-m7-gen	s:5:"Nisan";
en	messages:hebrew-calendar-m8-gen	s:4:"Iyar";
en	messages:hebrew-calendar-m9-gen	s:5:"Sivan";
en	messages:hebrew-calendar-m10-gen	s:5:"Tamuz";
en	messages:hebrew-calendar-m11-gen	s:2:"Av";
en	messages:hebrew-calendar-m12-gen	s:4:"Elul";
en	messages:signature	s:21:"[[{{ns:user}}:$1|$2]]";
en	messages:signature-anon	s:36:"[[{{#special:Contributions}}/$1|$2]]";
en	messages:timezone-utc	s:3:"UTC";
en	messages:unknown_extension_tag	s:26:"Unknown extension tag "$1"";
en	messages:duplicate-defaultsort	s:77:"'''Warning:''' Default sort key "$2" overrides earlier default sort key "$1".";
en	messages:version	s:7:"Version";
en	messages:version-extensions	s:20:"Installed extensions";
en	messages:version-specialpages	s:13:"Special pages";
en	messages:version-parserhooks	s:12:"Parser hooks";
en	messages:version-variables	s:9:"Variables";
en	messages:version-skins	s:5:"Skins";
en	messages:version-other	s:5:"Other";
en	messages:version-mediahandlers	s:14:"Media handlers";
en	messages:version-hooks	s:5:"Hooks";
en	messages:version-extension-functions	s:19:"Extension functions";
en	messages:version-parser-extensiontags	s:21:"Parser extension tags";
en	messages:version-parser-function-hooks	s:21:"Parser function hooks";
en	messages:version-skin-extension-functions	s:24:"Skin extension functions";
en	messages:version-hook-name	s:9:"Hook name";
en	messages:version-hook-subscribedby	s:13:"Subscribed by";
en	messages:version-version	s:12:"(Version $1)";
en	messages:version-svn-revision	s:5:"(r$2)";
en	messages:version-license	s:7:"License";
en	messages:version-poweredby-credits	s:93:"This wiki is powered by '''[http://www.mediawiki.org/ MediaWiki]''', copyright © 2001-$1 $2.";
en	messages:version-poweredby-others	s:6:"others";
en	messages:sqlite-no-fts	s:35:"$1 without full-text search support";
en	rtl	b:0;
en	capitalizeAllNouns	b:0;
en	digitTransformTable	N;
en	separatorTransformTable	N;
en	fallback8bitEncoding	s:12:"windows-1252";
en	linkPrefixExtension	b:0;
en	defaultUserOptionOverrides	a:0:{}
en	messages:version-license-info	s:782:"MediaWiki is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.\n\nMediaWiki is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\nYou should have received [{{SERVER}}{{SCRIPTPATH}}/COPYING a copy of the GNU General Public License] along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA or [http://www.gnu.org/licenses/old-licenses/gpl-2.0.html read it online].";
en	messages:version-software	s:18:"Installed software";
en	messages:version-software-product	s:7:"Product";
en	messages:version-software-version	s:7:"Version";
en	messages:filepath	s:9:"File path";
en	messages:filepath-page	s:5:"File:";
en	messages:filepath-submit	s:2:"Go";
en	messages:filepath-summary	s:217:"This special page returns the complete path for a file.\nImages are shown in full resolution, other file types are started with their associated program directly.\n\nEnter the file name without the "{{ns:file}}:" prefix.";
en	messages:fileduplicatesearch	s:26:"Search for duplicate files";
en	messages:fileduplicatesearch-summary	s:103:"Search for duplicate files based on hash values.\n\nEnter the filename without the "{{ns:file}}:" prefix.";
en	messages:fileduplicatesearch-legend	s:22:"Search for a duplicate";
en	messages:fileduplicatesearch-filename	s:9:"Filename:";
en	messages:fileduplicatesearch-submit	s:6:"Search";
en	messages:fileduplicatesearch-info	s:52:"$1 × $2 pixel<br />File size: $3<br />MIME type: $4";
en	messages:fileduplicatesearch-result-1	s:43:"The file "$1" has no identical duplication.";
en	messages:fileduplicatesearch-result-n	s:82:"The file "$1" has {{PLURAL:$2|1 identical duplication|$2 identical duplications}}.";
en	messages:specialpages	s:13:"Special pages";
en	messages:specialpages-summary	s:0:"";
en	messages:specialpages-note	s:106:"----\n* Normal special pages.\n* <strong class="mw-specialpagerestricted">Restricted special pages.</strong>";
en	messages:specialpages-group-maintenance	s:19:"Maintenance reports";
en	messages:specialpages-group-other	s:19:"Other special pages";
en	messages:specialpages-group-login	s:15:"Login / sign up";
en	messages:specialpages-group-changes	s:23:"Recent changes and logs";
en	messages:specialpages-group-media	s:25:"Media reports and uploads";
en	messages:specialpages-group-users	s:16:"Users and rights";
en	messages:specialpages-group-highuse	s:14:"High use pages";
en	messages:specialpages-group-pages	s:14:"Lists of pages";
en	messages:specialpages-group-pagetools	s:10:"Page tools";
en	messages:specialpages-group-wiki	s:19:"Wiki data and tools";
en	messages:specialpages-group-redirects	s:25:"Redirecting special pages";
en	messages:specialpages-group-spam	s:10:"Spam tools";
en	messages:blankpage	s:10:"Blank page";
en	messages:intentionallyblankpage	s:38:"This page is intentionally left blank.";
en	messages:external_image_whitelist	s:440:" #Leave this line exactly as it is<pre>\n#Put regular expression fragments (just the part that goes between the //) below\n#These will be matched with the URLs of external (hotlinked) images\n#Those that match will be displayed as images, otherwise only a link to the image will be shown\n#Lines beginning with # are treated as comments\n#This is case-insensitive\n\n#Put all regex fragments above this line. Leave this line exactly as it is</pre>";
en	messages:tags	s:17:"Valid change tags";
en	messages:tag-filter	s:28:"[[Special:Tags|Tag]] filter:";
en	messages:tag-filter-submit	s:6:"Filter";
en	messages:tags-title	s:4:"Tags";
en	messages:tags-intro	s:84:"This page lists the tags that the software may mark an edit with, and their meaning.";
en	messages:tags-tag	s:8:"Tag name";
en	messages:tags-display-header	s:26:"Appearance on change lists";
en	messages:tags-description-header	s:27:"Full description of meaning";
en	messages:tags-hitcount-header	s:14:"Tagged changes";
en	messages:tags-edit	s:4:"edit";
en	messages:tags-hitcount	s:31:"$1 {{PLURAL:$1|change|changes}}";
en	messages:comparepages	s:13:"Compare pages";
en	messages:compare-selector	s:22:"Compare page revisions";
en	messages:compare-page1	s:6:"Page 1";
en	messages:compare-page2	s:6:"Page 2";
en	messages:compare-rev1	s:10:"Revision 1";
en	messages:compare-rev2	s:10:"Revision 2";
en	messages:compare-submit	s:7:"Compare";
en	messages:dberr-header	s:23:"This wiki has a problem";
en	messages:dberr-problems	s:56:"Sorry!\nThis site is experiencing technical difficulties.";
en	messages:dberr-again	s:40:"Try waiting a few minutes and reloading.";
en	messages:dberr-info	s:40:"(Cannot contact the database server: $1)";
en	messages:dberr-usegoogle	s:49:"You can try searching via Google in the meantime.";
en	messages:dberr-outofdate	s:58:"Note that their indexes of our content may be out of date.";
en	messages:dberr-cachederror	s:71:"This is a cached copy of the requested page, and may not be up to date.";
en	messages:htmlform-invalid-input	s:42:"There are problems with some of your input";
en	messages:htmlform-select-badoption	s:46:"The value you specified is not a valid option.";
en	messages:htmlform-int-invalid	s:42:"The value you specified is not an integer.";
en	messages:htmlform-float-invalid	s:40:"The value you specified is not a number.";
en	messages:htmlform-int-toolow	s:50:"The value you specified is below the minimum of $1";
en	messages:htmlform-int-toohigh	s:50:"The value you specified is above the maximum of $1";
en	messages:htmlform-required	s:22:"This value is required";
en	messages:htmlform-submit	s:6:"Submit";
en	messages:htmlform-reset	s:12:"Undo changes";
en	messages:htmlform-selectorother-other	s:5:"Other";
en	messages:sqlite-has-fts	s:32:"$1 with full-text search support";
en	dateFormats	a:12:{s:8:"mdy time";s:3:"H:i";s:8:"mdy date";s:6:"F j, Y";s:8:"mdy both";s:11:"H:i, F j, Y";s:8:"dmy time";s:3:"H:i";s:8:"dmy date";s:5:"j F Y";s:8:"dmy both";s:10:"H:i, j F Y";s:8:"ymd time";s:3:"H:i";s:8:"ymd date";s:5:"Y F j";s:8:"ymd both";s:10:"H:i, Y F j";s:13:"ISO 8601 time";s:11:"xnH:xni:xns";s:13:"ISO 8601 date";s:11:"xnY-xnm-xnd";s:13:"ISO 8601 both";s:25:"xnY-xnm-xnd"T"xnH:xni:xns";}
en	datePreferences	a:5:{i:0;s:7:"default";i:1;s:3:"mdy";i:2;s:3:"dmy";i:3;s:3:"ymd";i:4;s:8:"ISO 8601";}
en	datePreferenceMigrationMap	a:4:{i:0;s:7:"default";i:1;s:3:"mdy";i:2;s:3:"dmy";i:3;s:3:"ymd";}
en	defaultDateFormat	s:10:"dmy or mdy";
en	extraUserToggles	a:0:{}
en	specialPageAliases	a:94:{s:15:"DoubleRedirects";a:1:{i:0;s:15:"DoubleRedirects";}s:15:"BrokenRedirects";a:1:{i:0;s:15:"BrokenRedirects";}s:15:"Disambiguations";a:1:{i:0;s:15:"Disambiguations";}s:9:"Userlogin";a:1:{i:0;s:9:"UserLogin";}s:10:"Userlogout";a:1:{i:0;s:10:"UserLogout";}s:13:"CreateAccount";a:1:{i:0;s:13:"CreateAccount";}s:11:"Preferences";a:1:{i:0;s:11:"Preferences";}s:9:"Watchlist";a:1:{i:0;s:9:"Watchlist";}s:13:"Recentchanges";a:1:{i:0;s:13:"RecentChanges";}s:6:"Upload";a:1:{i:0;s:6:"Upload";}s:11:"UploadStash";a:1:{i:0;s:11:"UploadStash";}s:9:"Listfiles";a:3:{i:0;s:9:"ListFiles";i:1;s:8:"FileList";i:2;s:9:"ImageList";}s:9:"Newimages";a:2:{i:0;s:8:"NewFiles";i:1;s:9:"NewImages";}s:9:"Listusers";a:2:{i:0;s:9:"ListUsers";i:1;s:8:"UserList";}s:15:"Listgrouprights";a:2:{i:0;s:15:"ListGroupRights";i:1;s:15:"UserGroupRights";}s:10:"Statistics";a:1:{i:0;s:10:"Statistics";}s:10:"Randompage";a:2:{i:0;s:6:"Random";i:1;s:10:"RandomPage";}s:11:"Lonelypages";a:2:{i:0;s:11:"LonelyPages";i:1;s:13:"OrphanedPages";}s:18:"Uncategorizedpages";a:1:{i:0;s:18:"UncategorizedPages";}s:23:"Uncategorizedcategories";a:1:{i:0;s:23:"UncategorizedCategories";}s:19:"Uncategorizedimages";a:2:{i:0;s:18:"UncategorizedFiles";i:1;s:19:"UncategorizedImages";}s:22:"Uncategorizedtemplates";a:1:{i:0;s:22:"UncategorizedTemplates";}s:16:"Unusedcategories";a:1:{i:0;s:16:"UnusedCategories";}s:12:"Unusedimages";a:2:{i:0;s:11:"UnusedFiles";i:1;s:12:"UnusedImages";}s:11:"Wantedpages";a:2:{i:0;s:11:"WantedPages";i:1;s:11:"BrokenLinks";}s:16:"Wantedcategories";a:1:{i:0;s:16:"WantedCategories";}s:11:"Wantedfiles";a:1:{i:0;s:11:"WantedFiles";}s:15:"Wantedtemplates";a:1:{i:0;s:15:"WantedTemplates";}s:10:"Mostlinked";a:2:{i:0;s:15:"MostLinkedPages";i:1;s:10:"MostLinked";}s:20:"Mostlinkedcategories";a:2:{i:0;s:20:"MostLinkedCategories";i:1;s:18:"MostUsedCategories";}s:19:"Mostlinkedtemplates";a:2:{i:0;s:19:"MostLinkedTemplates";i:1;s:17:"MostUsedTemplates";}s:10:"Mostimages";a:3:{i:0;s:15:"MostLinkedFiles";i:1;s:9:"MostFiles";i:2;s:10:"MostImages";}s:14:"Mostcategories";a:1:{i:0;s:14:"MostCategories";}s:13:"Mostrevisions";a:1:{i:0;s:13:"MostRevisions";}s:15:"Fewestrevisions";a:1:{i:0;s:15:"FewestRevisions";}s:10:"Shortpages";a:1:{i:0;s:10:"ShortPages";}s:9:"Longpages";a:1:{i:0;s:9:"LongPages";}s:8:"Newpages";a:1:{i:0;s:8:"NewPages";}s:12:"Ancientpages";a:1:{i:0;s:12:"AncientPages";}s:12:"Deadendpages";a:1:{i:0;s:12:"DeadendPages";}s:14:"Protectedpages";a:1:{i:0;s:14:"ProtectedPages";}s:15:"Protectedtitles";a:1:{i:0;s:15:"ProtectedTitles";}s:8:"Allpages";a:1:{i:0;s:8:"AllPages";}s:11:"Prefixindex";a:1:{i:0;s:11:"PrefixIndex";}s:11:"Ipblocklist";a:3:{i:0;s:9:"BlockList";i:1;s:10:"ListBlocks";i:2;s:11:"IPBlockList";}s:7:"Unblock";a:1:{i:0;s:7:"Unblock";}s:12:"Specialpages";a:1:{i:0;s:12:"SpecialPages";}s:13:"Contributions";a:1:{i:0;s:13:"Contributions";}s:9:"Emailuser";a:1:{i:0;s:9:"EmailUser";}s:12:"Confirmemail";a:1:{i:0;s:12:"ConfirmEmail";}s:13:"Whatlinkshere";a:1:{i:0;s:13:"WhatLinksHere";}s:19:"Recentchangeslinked";a:2:{i:0;s:19:"RecentChangesLinked";i:1;s:14:"RelatedChanges";}s:8:"Movepage";a:1:{i:0;s:8:"MovePage";}s:7:"Blockme";a:1:{i:0;s:7:"BlockMe";}s:11:"Booksources";a:1:{i:0;s:11:"BookSources";}s:10:"Categories";a:1:{i:0;s:10:"Categories";}s:6:"Export";a:1:{i:0;s:6:"Export";}s:7:"Version";a:1:{i:0;s:7:"Version";}s:11:"Allmessages";a:1:{i:0;s:11:"AllMessages";}s:3:"Log";a:2:{i:0;s:3:"Log";i:1;s:4:"Logs";}s:7:"Blockip";a:3:{i:0;s:5:"Block";i:1;s:7:"BlockIP";i:2;s:9:"BlockUser";}s:8:"Undelete";a:1:{i:0;s:8:"Undelete";}s:6:"Import";a:1:{i:0;s:6:"Import";}s:6:"Lockdb";a:1:{i:0;s:6:"LockDB";}s:8:"Unlockdb";a:1:{i:0;s:8:"UnlockDB";}s:10:"Userrights";a:3:{i:0;s:10:"UserRights";i:1;s:9:"MakeSysop";i:2;s:7:"MakeBot";}s:10:"MIMEsearch";a:1:{i:0;s:10:"MIMESearch";}s:19:"FileDuplicateSearch";a:1:{i:0;s:19:"FileDuplicateSearch";}s:14:"Unwatchedpages";a:1:{i:0;s:14:"UnwatchedPages";}s:13:"Listredirects";a:1:{i:0;s:13:"ListRedirects";}s:14:"Revisiondelete";a:1:{i:0;s:14:"RevisionDelete";}s:15:"Unusedtemplates";a:1:{i:0;s:15:"UnusedTemplates";}s:14:"Randomredirect";a:1:{i:0;s:14:"RandomRedirect";}s:6:"Mypage";a:1:{i:0;s:6:"MyPage";}s:6:"Mytalk";a:1:{i:0;s:6:"MyTalk";}s:15:"Mycontributions";a:1:{i:0;s:15:"MyContributions";}s:9:"Myuploads";a:1:{i:0;s:9:"MyUploads";}s:10:"Listadmins";a:1:{i:0;s:10:"ListAdmins";}s:8:"Listbots";a:1:{i:0;s:8:"ListBots";}s:12:"Popularpages";a:1:{i:0;s:12:"PopularPages";}s:6:"Search";a:1:{i:0;s:6:"Search";}s:9:"Resetpass";a:3:{i:0;s:14:"ChangePassword";i:1;s:9:"ResetPass";i:2;s:13:"ResetPassword";}s:16:"Withoutinterwiki";a:1:{i:0;s:16:"WithoutInterwiki";}s:12:"MergeHistory";a:1:{i:0;s:12:"MergeHistory";}s:8:"Filepath";a:1:{i:0;s:8:"FilePath";}s:15:"Invalidateemail";a:1:{i:0;s:15:"InvalidateEmail";}s:9:"Blankpage";a:1:{i:0;s:9:"BlankPage";}s:10:"LinkSearch";a:1:{i:0;s:10:"LinkSearch";}s:20:"DeletedContributions";a:1:{i:0;s:20:"DeletedContributions";}s:4:"Tags";a:1:{i:0;s:4:"Tags";}s:11:"Activeusers";a:1:{i:0;s:11:"ActiveUsers";}s:12:"ComparePages";a:1:{i:0;s:12:"ComparePages";}s:8:"Badtitle";a:1:{i:0;s:8:"Badtitle";}s:14:"DisableAccount";a:1:{i:0;s:14:"DisableAccount";}}
en	imageFiles	a:11:{s:11:"button-bold";s:15:"button_bold.png";s:13:"button-italic";s:17:"button_italic.png";s:11:"button-link";s:15:"button_link.png";s:14:"button-extlink";s:18:"button_extlink.png";s:15:"button-headline";s:19:"button_headline.png";s:12:"button-image";s:16:"button_image.png";s:12:"button-media";s:16:"button_media.png";s:11:"button-math";s:15:"button_math.png";s:13:"button-nowiki";s:17:"button_nowiki.png";s:10:"button-sig";s:14:"button_sig.png";s:9:"button-hr";s:13:"button_hr.png";}
en	preloadedMessages	a:96:{i:0;s:9:"aboutpage";i:1;s:9:"aboutsite";i:2;s:17:"accesskey-ca-edit";i:3;s:20:"accesskey-ca-history";i:4;s:23:"accesskey-ca-nstab-main";i:5;s:17:"accesskey-ca-talk";i:6;s:25:"accesskey-n-currentevents";i:7;s:16:"accesskey-n-help";i:8;s:32:"accesskey-n-mainpage-description";i:9;s:18:"accesskey-n-portal";i:10;s:22:"accesskey-n-randompage";i:11;s:25:"accesskey-n-recentchanges";i:12;s:23:"accesskey-n-sitesupport";i:13;s:16:"accesskey-p-logo";i:14;s:18:"accesskey-pt-login";i:15;s:16:"accesskey-search";i:16;s:25:"accesskey-search-fulltext";i:17;s:19:"accesskey-search-go";i:18;s:21:"accesskey-t-permalink";i:19;s:17:"accesskey-t-print";i:20;s:31:"accesskey-t-recentchangeslinked";i:21;s:24:"accesskey-t-specialpages";i:22;s:25:"accesskey-t-whatlinkshere";i:23;s:10:"anonnotice";i:24;s:12:"catseparator";i:25;s:15:"colon-separator";i:26;s:13:"currentevents";i:27;s:17:"currentevents-url";i:28;s:14:"disclaimerpage";i:29;s:11:"disclaimers";i:30;s:4:"edit";i:31;s:4:"help";i:32;s:8:"helppage";i:33;s:13:"history_short";i:34;s:6:"jumpto";i:35;s:16:"jumptonavigation";i:36;s:12:"jumptosearch";i:37;s:14:"lastmodifiedat";i:38;s:8:"mainpage";i:39;s:20:"mainpage-description";i:40;s:23:"nav-login-createaccount";i:41;s:10:"navigation";i:42;s:10:"nstab-main";i:43;s:15:"opensearch-desc";i:44;s:14:"pagecategories";i:45;s:18:"pagecategorieslink";i:46;s:9:"pagetitle";i:47;s:23:"pagetitle-view-mainpage";i:48;s:9:"permalink";i:49;s:13:"personaltools";i:50;s:6:"portal";i:51;s:10:"portal-url";i:52;s:16:"printableversion";i:53;s:7:"privacy";i:54;s:11:"privacypage";i:55;s:10:"randompage";i:56;s:14:"randompage-url";i:57;s:13:"recentchanges";i:58;s:17:"recentchanges-url";i:59;s:27:"recentchangeslinked-toolbox";i:60;s:13:"retrievedfrom";i:61;s:6:"search";i:62;s:13:"searcharticle";i:63;s:12:"searchbutton";i:64;s:7:"sidebar";i:65;s:14:"site-atom-feed";i:66;s:13:"site-rss-feed";i:67;s:10:"sitenotice";i:68;s:12:"specialpages";i:69;s:7:"tagline";i:70;s:4:"talk";i:71;s:7:"toolbox";i:72;s:15:"tooltip-ca-edit";i:73;s:18:"tooltip-ca-history";i:74;s:21:"tooltip-ca-nstab-main";i:75;s:15:"tooltip-ca-talk";i:76;s:23:"tooltip-n-currentevents";i:77;s:14:"tooltip-n-help";i:78;s:30:"tooltip-n-mainpage-description";i:79;s:16:"tooltip-n-portal";i:80;s:20:"tooltip-n-randompage";i:81;s:23:"tooltip-n-recentchanges";i:82;s:21:"tooltip-n-sitesupport";i:83;s:14:"tooltip-p-logo";i:84;s:20:"tooltip-p-navigation";i:85;s:16:"tooltip-pt-login";i:86;s:14:"tooltip-search";i:87;s:23:"tooltip-search-fulltext";i:88;s:17:"tooltip-search-go";i:89;s:19:"tooltip-t-permalink";i:90;s:15:"tooltip-t-print";i:91;s:29:"tooltip-t-recentchangeslinked";i:92;s:22:"tooltip-t-specialpages";i:93;s:23:"tooltip-t-whatlinkshere";i:94;s:5:"views";i:95;s:13:"whatlinkshere";}
en	fallbackSequence	a:0:{}
en	deps	a:4:{i:0;O:14:"FileDependency":2:{s:8:"filename";s:76:"/var/www/devel.mwds.info/web/talkbox2/help/languages/messages/MessagesEn.php";s:9:"timestamp";i:1322436156;}s:24:"wgExtensionMessagesFiles";O:16:"GlobalDependency":2:{s:4:"name";s:24:"wgExtensionMessagesFiles";s:5:"value";a:0:{}}s:23:"wgExtensionAliasesFiles";O:16:"GlobalDependency":2:{s:4:"name";s:23:"wgExtensionAliasesFiles";s:5:"value";a:0:{}}s:7:"version";O:18:"ConstantDependency":2:{s:4:"name";s:13:"MW_LC_VERSION";s:5:"value";i:1;}}
en	list	a:1:{s:8:"messages";a:2790:{i:0;s:7:"sidebar";i:1;s:13:"tog-underline";i:2;s:19:"tog-highlightbroken";i:3;s:11:"tog-justify";i:4;s:13:"tog-hideminor";i:5;s:17:"tog-hidepatrolled";i:6;s:25:"tog-newpageshidepatrolled";i:7;s:19:"tog-extendwatchlist";i:8;s:12:"tog-usenewrc";i:9;s:18:"tog-numberheadings";i:10;s:15:"tog-showtoolbar";i:11;s:18:"tog-editondblclick";i:12;s:15:"tog-editsection";i:13;s:27:"tog-editsectiononrightclick";i:14;s:11:"tog-showtoc";i:15;s:20:"tog-rememberpassword";i:16;s:18:"tog-watchcreations";i:17;s:16:"tog-watchdefault";i:18;s:14:"tog-watchmoves";i:19;s:17:"tog-watchdeletion";i:20;s:16:"tog-minordefault";i:21;s:16:"tog-previewontop";i:22;s:18:"tog-previewonfirst";i:23;s:11:"tog-nocache";i:24;s:24:"tog-enotifwatchlistpages";i:25;s:23:"tog-enotifusertalkpages";i:26;s:20:"tog-enotifminoredits";i:27;s:20:"tog-enotifrevealaddr";i:28;s:23:"tog-shownumberswatching";i:29;s:10:"tog-oldsig";i:30;s:12:"tog-fancysig";i:31;s:18:"tog-externaleditor";i:32;s:16:"tog-externaldiff";i:33;s:17:"tog-showjumplinks";i:34;s:18:"tog-uselivepreview";i:35;s:20:"tog-forceeditsummary";i:36;s:20:"tog-watchlisthideown";i:37;s:21:"tog-watchlisthidebots";i:38;s:22:"tog-watchlisthideminor";i:39;s:20:"tog-watchlisthideliu";i:40;s:22:"tog-watchlisthideanons";i:41;s:26:"tog-watchlisthidepatrolled";i:42;s:20:"tog-nolangconversion";i:43;s:16:"tog-ccmeonemails";i:44;s:12:"tog-diffonly";i:45;s:18:"tog-showhiddencats";i:46;s:17:"tog-noconvertlink";i:47;s:18:"tog-norollbackdiff";i:48;s:16:"underline-always";i:49;s:15:"underline-never";i:50;s:17:"underline-default";i:51;s:14:"editfont-style";i:52;s:16:"editfont-default";i:53;s:18:"editfont-monospace";i:54;s:18:"editfont-sansserif";i:55;s:14:"editfont-serif";i:56;s:6:"sunday";i:57;s:6:"monday";i:58;s:7:"tuesday";i:59;s:9:"wednesday";i:60;s:8:"thursday";i:61;s:6:"friday";i:62;s:8:"saturday";i:63;s:3:"sun";i:64;s:3:"mon";i:65;s:3:"tue";i:66;s:3:"wed";i:67;s:3:"thu";i:68;s:3:"fri";i:69;s:3:"sat";i:70;s:7:"january";i:71;s:8:"february";i:72;s:5:"march";i:73;s:5:"april";i:74;s:8:"may_long";i:75;s:4:"june";i:76;s:4:"july";i:77;s:6:"august";i:78;s:9:"september";i:79;s:7:"october";i:80;s:8:"november";i:81;s:8:"december";i:82;s:11:"january-gen";i:83;s:12:"february-gen";i:84;s:9:"march-gen";i:85;s:9:"april-gen";i:86;s:7:"may-gen";i:87;s:8:"june-gen";i:88;s:8:"july-gen";i:89;s:10:"august-gen";i:90;s:13:"september-gen";i:91;s:11:"october-gen";i:92;s:12:"november-gen";i:93;s:12:"december-gen";i:94;s:3:"jan";i:95;s:3:"feb";i:96;s:3:"mar";i:97;s:3:"apr";i:98;s:3:"may";i:99;s:3:"jun";i:100;s:3:"jul";i:101;s:3:"aug";i:102;s:3:"sep";i:103;s:3:"oct";i:104;s:3:"nov";i:105;s:3:"dec";i:106;s:14:"pagecategories";i:107;s:18:"pagecategorieslink";i:108;s:15:"category_header";i:109;s:13:"subcategories";i:110;s:21:"category-media-header";i:111;s:14:"category-empty";i:112;s:17:"hidden-categories";i:113;s:24:"hidden-category-category";i:114;s:21:"category-subcat-count";i:115;s:29:"category-subcat-count-limited";i:116;s:22:"category-article-count";i:117;s:30:"category-article-count-limited";i:118;s:19:"category-file-count";i:119;s:27:"category-file-count-limited";i:120;s:22:"listingcontinuesabbrev";i:121;s:14:"index-category";i:122;s:16:"noindex-category";i:123;s:10:"linkprefix";i:124;s:12:"mainpagetext";i:125;s:17:"mainpagedocfooter";i:126;s:5:"about";i:127;s:7:"article";i:128;s:9:"newwindow";i:129;s:6:"cancel";i:130;s:13:"moredotdotdot";i:131;s:6:"mypage";i:132;s:6:"mytalk";i:133;s:8:"anontalk";i:134;s:10:"navigation";i:135;s:3:"and";i:136;s:6:"qbfind";i:137;s:8:"qbbrowse";i:138;s:6:"qbedit";i:139;s:13:"qbpageoptions";i:140;s:10:"qbpageinfo";i:141;s:11:"qbmyoptions";i:142;s:14:"qbspecialpages";i:143;s:3:"faq";i:144;s:7:"faqpage";i:145;s:9:"sitetitle";i:146;s:12:"sitesubtitle";i:147;s:24:"vector-action-addsection";i:148;s:20:"vector-action-delete";i:149;s:18:"vector-action-move";i:150;s:21:"vector-action-protect";i:151;s:22:"vector-action-undelete";i:152;s:23:"vector-action-unprotect";i:153;s:30:"vector-simplesearch-preference";i:154;s:18:"vector-view-create";i:155;s:16:"vector-view-edit";i:156;s:19:"vector-view-history";i:157;s:16:"vector-view-view";i:158;s:22:"vector-view-viewsource";i:159;s:7:"actions";i:160;s:10:"namespaces";i:161;s:8:"variants";i:162;s:14:"errorpagetitle";i:163;s:8:"returnto";i:164;s:7:"tagline";i:165;s:4:"help";i:166;s:6:"search";i:167;s:12:"searchbutton";i:168;s:2:"go";i:169;s:13:"searcharticle";i:170;s:7:"history";i:171;s:13:"history_short";i:172;s:13:"updatedmarker";i:173;s:10:"info_short";i:174;s:16:"printableversion";i:175;s:9:"permalink";i:176;s:5:"print";i:177;s:4:"edit";i:178;s:6:"create";i:179;s:12:"editthispage";i:180;s:16:"create-this-page";i:181;s:6:"delete";i:182;s:14:"deletethispage";i:183;s:14:"undelete_short";i:184;s:7:"protect";i:185;s:14:"protect_change";i:186;s:15:"protectthispage";i:187;s:9:"unprotect";i:188;s:17:"unprotectthispage";i:189;s:7:"newpage";i:190;s:8:"talkpage";i:191;s:16:"talkpagelinktext";i:192;s:11:"specialpage";i:193;s:13:"personaltools";i:194;s:11:"postcomment";i:195;s:10:"addsection";i:196;s:11:"articlepage";i:197;s:4:"talk";i:198;s:5:"views";i:199;s:7:"toolbox";i:200;s:8:"userpage";i:201;s:11:"projectpage";i:202;s:9:"imagepage";i:203;s:13:"mediawikipage";i:204;s:12:"templatepage";i:205;s:12:"viewhelppage";i:206;s:12:"categorypage";i:207;s:12:"viewtalkpage";i:208;s:14:"otherlanguages";i:209;s:14:"redirectedfrom";i:210;s:15:"redirectpagesub";i:211;s:14:"talkpageheader";i:212;s:14:"lastmodifiedat";i:213;s:9:"viewcount";i:214;s:13:"protectedpage";i:215;s:6:"jumpto";i:216;s:16:"jumptonavigation";i:217;s:12:"jumptosearch";i:218;s:15:"view-pool-error";i:219;s:12:"pool-timeout";i:220;s:14:"pool-queuefull";i:221;s:17:"pool-errorunknown";i:222;s:9:"aboutsite";i:223;s:9:"aboutpage";i:224;s:9:"copyright";i:225;s:13:"copyrightpage";i:226;s:13:"currentevents";i:227;s:17:"currentevents-url";i:228;s:11:"disclaimers";i:229;s:14:"disclaimerpage";i:230;s:8:"edithelp";i:231;s:12:"edithelppage";i:232;s:8:"helppage";i:233;s:8:"mainpage";i:234;s:20:"mainpage-description";i:235;s:10:"policy-url";i:236;s:6:"portal";i:237;s:10:"portal-url";i:238;s:7:"privacy";i:239;s:11:"privacypage";i:240;s:9:"badaccess";i:241;s:16:"badaccess-group0";i:242;s:16:"badaccess-groups";i:243;s:15:"versionrequired";i:244;s:19:"versionrequiredtext";i:245;s:2:"ok";i:246;s:9:"pagetitle";i:247;s:23:"pagetitle-view-mainpage";i:248;s:13:"retrievedfrom";i:249;s:18:"youhavenewmessages";i:250;s:15:"newmessageslink";i:251;s:19:"newmessagesdifflink";i:252;s:23:"youhavenewmessagesmulti";i:253;s:16:"newtalkseparator";i:254;s:11:"editsection";i:255;s:20:"editsection-brackets";i:256;s:7:"editold";i:257;s:13:"viewsourceold";i:258;s:8:"editlink";i:259;s:14:"viewsourcelink";i:260;s:15:"editsectionhint";i:261;s:3:"toc";i:262;s:7:"showtoc";i:263;s:7:"hidetoc";i:264;s:13:"thisisdeleted";i:265;s:11:"viewdeleted";i:266;s:11:"restorelink";i:267;s:9:"feedlinks";i:268;s:12:"feed-invalid";i:269;s:16:"feed-unavailable";i:270;s:13:"site-rss-feed";i:271;s:14:"site-atom-feed";i:272;s:13:"page-rss-feed";i:273;s:14:"page-atom-feed";i:274;s:9:"feed-atom";i:275;s:8:"feed-rss";i:276;s:10:"sitenotice";i:277;s:10:"anonnotice";i:278;s:28:"newsectionheaderdefaultlevel";i:279;s:14:"red-link-title";i:280;s:10:"nstab-main";i:281;s:10:"nstab-user";i:282;s:11:"nstab-media";i:283;s:13:"nstab-special";i:284;s:13:"nstab-project";i:285;s:11:"nstab-image";i:286;s:15:"nstab-mediawiki";i:287;s:14:"nstab-template";i:288;s:10:"nstab-help";i:289;s:14:"nstab-category";i:290;s:12:"nosuchaction";i:291;s:16:"nosuchactiontext";i:292;s:17:"nosuchspecialpage";i:293;s:17:"nospecialpagetext";i:294;s:5:"error";i:295;s:13:"databaseerror";i:296;s:11:"dberrortext";i:297;s:13:"dberrortextcl";i:298;s:15:"laggedslavemode";i:299;s:8:"readonly";i:300;s:15:"enterlockreason";i:301;s:12:"readonlytext";i:302;s:15:"missing-article";i:303;s:18:"missingarticle-rev";i:304;s:19:"missingarticle-diff";i:305;s:12:"readonly_lag";i:306;s:13:"internalerror";i:307;s:18:"internalerror_info";i:308;s:19:"fileappenderrorread";i:309;s:15:"fileappenderror";i:310;s:13:"filecopyerror";i:311;s:15:"filerenameerror";i:312;s:15:"filedeleteerror";i:313;s:20:"directorycreateerror";i:314;s:12:"filenotfound";i:315;s:15:"fileexistserror";i:316;s:10:"unexpected";i:317;s:9:"formerror";i:318;s:15:"badarticleerror";i:319;s:12:"cannotdelete";i:320;s:8:"badtitle";i:321;s:12:"badtitletext";i:322;s:10:"perfcached";i:323;s:12:"perfcachedts";i:324;s:20:"querypage-no-updates";i:325;s:20:"wrong_wfQuery_params";i:326;s:10:"viewsource";i:327;s:13:"viewsourcefor";i:328;s:15:"actionthrottled";i:329;s:19:"actionthrottledtext";i:330;s:17:"protectedpagetext";i:331;s:14:"viewsourcetext";i:332;s:18:"protectedinterface";i:333;s:16:"editinginterface";i:334;s:9:"sqlhidden";i:335;s:16:"cascadeprotected";i:336;s:18:"namespaceprotected";i:337;s:20:"customcssjsprotected";i:338;s:19:"ns-specialprotected";i:339;s:14:"titleprotected";i:340;s:16:"virus-badscanner";i:341;s:16:"virus-scanfailed";i:342;s:20:"virus-unknownscanner";i:343;s:10:"logouttext";i:344;s:15:"welcomecreation";i:345;s:8:"yourname";i:346;s:12:"yourpassword";i:347;s:17:"yourpasswordagain";i:348;s:18:"remembermypassword";i:349;s:23:"securelogin-stick-https";i:350;s:14:"yourdomainname";i:351;s:15:"externaldberror";i:352;s:5:"login";i:353;s:23:"nav-login-createaccount";i:354;s:11:"loginprompt";i:355;s:9:"userlogin";i:356;s:17:"userloginnocreate";i:357;s:6:"logout";i:358;s:10:"userlogout";i:359;s:11:"notloggedin";i:360;s:7:"nologin";i:361;s:11:"nologinlink";i:362;s:13:"createaccount";i:363;s:10:"gotaccount";i:364;s:14:"gotaccountlink";i:365;s:17:"createaccountmail";i:366;s:19:"createaccountreason";i:367;s:9:"badretype";i:368;s:10:"userexists";i:369;s:10:"loginerror";i:370;s:18:"createaccounterror";i:371;s:12:"nocookiesnew";i:372;s:14:"nocookieslogin";i:373;s:6:"noname";i:374;s:17:"loginsuccesstitle";i:375;s:12:"loginsuccess";i:376;s:10:"nosuchuser";i:377;s:15:"nosuchusershort";i:378;s:15:"nouserspecified";i:379;s:17:"login-userblocked";i:380;s:13:"wrongpassword";i:381;s:18:"wrongpasswordempty";i:382;s:16:"passwordtooshort";i:383;s:19:"password-name-match";i:384;s:24:"password-login-forbidden";i:385;s:14:"mailmypassword";i:386;s:21:"passwordremindertitle";i:387;s:20:"passwordremindertext";i:388;s:7:"noemail";i:389;s:13:"noemailcreate";i:390;s:12:"passwordsent";i:391;s:20:"blocked-mailpassword";i:392;s:12:"eauthentsent";i:393;s:22:"throttled-mailpassword";i:394;s:10:"loginstart";i:395;s:8:"loginend";i:396;s:11:"signupstart";i:397;s:9:"signupend";i:398;s:9:"mailerror";i:399;s:26:"acct_creation_throttle_hit";i:400;s:18:"emailauthenticated";i:401;s:21:"emailnotauthenticated";i:402;s:12:"noemailprefs";i:403;s:16:"emailconfirmlink";i:404;s:19:"invalidemailaddress";i:405;s:14:"accountcreated";i:406;s:18:"accountcreatedtext";i:407;s:19:"createaccount-title";i:408;s:18:"createaccount-text";i:409;s:17:"usernamehasherror";i:410;s:15:"login-throttled";i:411;s:18:"loginlanguagelabel";i:412;s:18:"loginlanguagelinks";i:413;s:21:"suspicious-userlogout";i:414;s:15:"pear-mail-error";i:415;s:14:"php-mail-error";i:416;s:22:"php-mail-error-unknown";i:417;s:9:"resetpass";i:418;s:18:"resetpass_announce";i:419;s:14:"resetpass_text";i:420;s:16:"resetpass_header";i:421;s:11:"oldpassword";i:422;s:11:"newpassword";i:423;s:9:"retypenew";i:424;s:16:"resetpass_submit";i:425;s:17:"resetpass_success";i:426;s:19:"resetpass_forbidden";i:427;s:17:"resetpass-no-info";i:428;s:25:"resetpass-submit-loggedin";i:429;s:23:"resetpass-submit-cancel";i:430;s:23:"resetpass-wrong-oldpass";i:431;s:23:"resetpass-temp-password";i:432;s:11:"bold_sample";i:433;s:8:"bold_tip";i:434;s:13:"italic_sample";i:435;s:10:"italic_tip";i:436;s:11:"link_sample";i:437;s:8:"link_tip";i:438;s:14:"extlink_sample";i:439;s:11:"extlink_tip";i:440;s:15:"headline_sample";i:441;s:12:"headline_tip";i:442;s:11:"math_sample";i:443;s:8:"math_tip";i:444;s:13:"nowiki_sample";i:445;s:10:"nowiki_tip";i:446;s:12:"image_sample";i:447;s:9:"image_tip";i:448;s:12:"media_sample";i:449;s:9:"media_tip";i:450;s:7:"sig_tip";i:451;s:6:"hr_tip";i:452;s:7:"summary";i:453;s:7:"subject";i:454;s:9:"minoredit";i:455;s:9:"watchthis";i:456;s:11:"savearticle";i:457;s:7:"preview";i:458;s:11:"showpreview";i:459;s:15:"showlivepreview";i:460;s:8:"showdiff";i:461;s:15:"anoneditwarning";i:462;s:18:"anonpreviewwarning";i:463;s:14:"missingsummary";i:464;s:18:"missingcommenttext";i:465;s:20:"missingcommentheader";i:466;s:15:"summary-preview";i:467;s:15:"subject-preview";i:468;s:12:"blockedtitle";i:469;s:11:"blockedtext";i:470;s:15:"autoblockedtext";i:471;s:15:"blockednoreason";i:472;s:21:"blockedoriginalsource";i:473;s:17:"blockededitsource";i:474;s:18:"whitelistedittitle";i:475;s:17:"whitelistedittext";i:476;s:15:"confirmedittext";i:477;s:18:"nosuchsectiontitle";i:478;s:17:"nosuchsectiontext";i:479;s:13:"loginreqtitle";i:480;s:12:"loginreqlink";i:481;s:16:"loginreqpagetext";i:482;s:12:"accmailtitle";i:483;s:11:"accmailtext";i:484;s:10:"newarticle";i:485;s:14:"newarticletext";i:486;s:18:"newarticletextanon";i:487;s:12:"talkpagetext";i:488;s:16:"anontalkpagetext";i:489;s:13:"noarticletext";i:490;s:26:"noarticletext-nopermission";i:491;s:17:"noarticletextanon";i:492;s:25:"userpage-userdoesnotexist";i:493;s:30:"userpage-userdoesnotexist-view";i:494;s:25:"blocked-notice-logextract";i:495;s:14:"clearyourcache";i:496;s:20:"usercssyoucanpreview";i:497;s:19:"userjsyoucanpreview";i:498;s:14:"usercsspreview";i:499;s:13:"userjspreview";i:500;s:14:"sitecsspreview";i:501;s:13:"sitejspreview";i:502;s:21:"userinvalidcssjstitle";i:503;s:7:"updated";i:504;s:4:"note";i:505;s:11:"previewnote";i:506;s:15:"previewconflict";i:507;s:20:"session_fail_preview";i:508;s:25:"session_fail_preview_html";i:509;s:21:"token_suffix_mismatch";i:510;s:7:"editing";i:511;s:14:"editingsection";i:512;s:14:"editingcomment";i:513;s:12:"editconflict";i:514;s:15:"explainconflict";i:515;s:8:"yourtext";i:516;s:13:"storedversion";i:517;s:17:"nonunicodebrowser";i:518;s:10:"editingold";i:519;s:8:"yourdiff";i:520;s:16:"copyrightwarning";i:521;s:17:"copyrightwarning2";i:522;s:20:"editpage-tos-summary";i:523;s:13:"longpage-hint";i:524;s:13:"longpageerror";i:525;s:15:"readonlywarning";i:526;s:20:"protectedpagewarning";i:527;s:24:"semiprotectedpagewarning";i:528;s:23:"cascadeprotectedwarning";i:529;s:21:"titleprotectedwarning";i:530;s:13:"templatesused";i:531;s:20:"templatesusedpreview";i:532;s:20:"templatesusedsection";i:533;s:18:"template-protected";i:534;s:22:"template-semiprotected";i:535;s:16:"hiddencategories";i:536;s:9:"edittools";i:537;s:13:"nocreatetitle";i:538;s:12:"nocreatetext";i:539;s:17:"nocreate-loggedin";i:540;s:29:"sectioneditnotsupported-title";i:541;s:28:"sectioneditnotsupported-text";i:542;s:17:"permissionserrors";i:543;s:21:"permissionserrorstext";i:544;s:32:"permissionserrorstext-withaction";i:545;s:26:"recreate-moveddeleted-warn";i:546;s:19:"moveddeleted-notice";i:547;s:11:"log-fulllog";i:548;s:17:"edit-hook-aborted";i:549;s:17:"edit-gone-missing";i:550;s:13:"edit-conflict";i:551;s:14:"edit-no-change";i:552;s:19:"edit-already-exists";i:553;s:18:"addsection-preload";i:554;s:20:"addsection-editintro";i:555;s:32:"expensive-parserfunction-warning";i:556;s:33:"expensive-parserfunction-category";i:557;s:38:"post-expand-template-inclusion-warning";i:558;s:39:"post-expand-template-inclusion-category";i:559;s:37:"post-expand-template-argument-warning";i:560;s:38:"post-expand-template-argument-category";i:561;s:28:"parser-template-loop-warning";i:562;s:39:"parser-template-recursion-depth-warning";i:563;s:32:"language-converter-depth-warning";i:564;s:12:"undo-success";i:565;s:12:"undo-failure";i:566;s:10:"undo-norev";i:567;s:12:"undo-summary";i:568;s:22:"cantcreateaccounttitle";i:569;s:22:"cantcreateaccount-text";i:570;s:12:"viewpagelogs";i:571;s:9:"nohistory";i:572;s:10:"currentrev";i:573;s:15:"currentrev-asof";i:574;s:12:"revisionasof";i:575;s:13:"revision-info";i:576;s:21:"revision-info-current";i:577;s:12:"revision-nav";i:578;s:16:"previousrevision";i:579;s:12:"nextrevision";i:580;s:19:"currentrevisionlink";i:581;s:3:"cur";i:582;s:4:"next";i:583;s:4:"last";i:584;s:10:"page_first";i:585;s:9:"page_last";i:586;s:10:"histlegend";i:587;s:22:"history-fieldset-title";i:588;s:20:"history-show-deleted";i:589;s:17:"history_copyright";i:590;s:9:"histfirst";i:591;s:8:"histlast";i:592;s:11:"historysize";i:593;s:12:"historyempty";i:594;s:18:"history-feed-title";i:595;s:24:"history-feed-description";i:596;s:27:"history-feed-item-nocomment";i:597;s:18:"history-feed-empty";i:598;s:19:"rev-deleted-comment";i:599;s:16:"rev-deleted-user";i:600;s:17:"rev-deleted-event";i:601;s:25:"rev-deleted-user-contribs";i:602;s:27:"rev-deleted-text-permission";i:603;s:23:"rev-deleted-text-unhide";i:604;s:26:"rev-suppressed-text-unhide";i:605;s:21:"rev-deleted-text-view";i:606;s:24:"rev-suppressed-text-view";i:607;s:19:"rev-deleted-no-diff";i:608;s:22:"rev-suppressed-no-diff";i:609;s:23:"rev-deleted-unhide-diff";i:610;s:26:"rev-suppressed-unhide-diff";i:611;s:21:"rev-deleted-diff-view";i:612;s:24:"rev-suppressed-diff-view";i:613;s:12:"rev-delundel";i:614;s:15:"rev-showdeleted";i:615;s:14:"revisiondelete";i:616;s:23:"revdelete-nooldid-title";i:617;s:22:"revdelete-nooldid-text";i:618;s:25:"revdelete-nologtype-title";i:619;s:24:"revdelete-nologtype-text";i:620;s:23:"revdelete-nologid-title";i:621;s:22:"revdelete-nologid-text";i:622;s:17:"revdelete-no-file";i:623;s:27:"revdelete-show-file-confirm";i:624;s:26:"revdelete-show-file-submit";i:625;s:18:"revdelete-selected";i:626;s:18:"logdelete-selected";i:627;s:14:"revdelete-text";i:628;s:17:"revdelete-confirm";i:629;s:23:"revdelete-suppress-text";i:630;s:16:"revdelete-legend";i:631;s:19:"revdelete-hide-text";i:632;s:20:"revdelete-hide-image";i:633;s:19:"revdelete-hide-name";i:634;s:22:"revdelete-hide-comment";i:635;s:19:"revdelete-hide-user";i:636;s:25:"revdelete-hide-restricted";i:637;s:20:"revdelete-radio-same";i:638;s:19:"revdelete-radio-set";i:639;s:21:"revdelete-radio-unset";i:640;s:18:"revdelete-suppress";i:641;s:20:"revdelete-unsuppress";i:642;s:13:"revdelete-log";i:643;s:16:"revdelete-submit";i:644;s:18:"revdelete-logentry";i:645;s:18:"logdelete-logentry";i:646;s:17:"revdelete-success";i:647;s:17:"revdelete-failure";i:648;s:17:"logdelete-success";i:649;s:17:"logdelete-failure";i:650;s:14:"revdel-restore";i:651;s:22:"revdel-restore-deleted";i:652;s:22:"revdel-restore-visible";i:653;s:8:"pagehist";i:654;s:11:"deletedhist";i:655;s:17:"revdelete-content";i:656;s:17:"revdelete-summary";i:657;s:15:"revdelete-uname";i:658;s:20:"revdelete-restricted";i:659;s:22:"revdelete-unrestricted";i:660;s:13:"revdelete-hid";i:661;s:15:"revdelete-unhid";i:662;s:21:"revdelete-log-message";i:663;s:21:"logdelete-log-message";i:664;s:22:"revdelete-hide-current";i:665;s:24:"revdelete-show-no-access";i:666;s:26:"revdelete-modify-no-access";i:667;s:24:"revdelete-modify-missing";i:668;s:19:"revdelete-no-change";i:669;s:27:"revdelete-concurrent-change";i:670;s:25:"revdelete-only-restricted";i:671;s:25:"revdelete-reason-dropdown";i:672;s:21:"revdelete-otherreason";i:673;s:25:"revdelete-reasonotherlist";i:674;s:25:"revdelete-edit-reasonlist";i:675;s:18:"revdelete-offender";i:676;s:14:"suppressionlog";i:677;s:18:"suppressionlogtext";i:678;s:12:"mergehistory";i:679;s:19:"mergehistory-header";i:680;s:16:"mergehistory-box";i:681;s:17:"mergehistory-from";i:682;s:17:"mergehistory-into";i:683;s:17:"mergehistory-list";i:684;s:18:"mergehistory-merge";i:685;s:15:"mergehistory-go";i:686;s:19:"mergehistory-submit";i:687;s:18:"mergehistory-empty";i:688;s:20:"mergehistory-success";i:689;s:17:"mergehistory-fail";i:690;s:22:"mergehistory-no-source";i:691;s:27:"mergehistory-no-destination";i:692;s:27:"mergehistory-invalid-source";i:693;s:32:"mergehistory-invalid-destination";i:694;s:24:"mergehistory-autocomment";i:695;s:20:"mergehistory-comment";i:696;s:29:"mergehistory-same-destination";i:697;s:19:"mergehistory-reason";i:698;s:8:"mergelog";i:699;s:18:"pagemerge-logentry";i:700;s:11:"revertmerge";i:701;s:16:"mergelogpagetext";i:702;s:13:"history-title";i:703;s:10:"difference";i:704;s:20:"difference-multipage";i:705;s:6:"lineno";i:706;s:23:"compareselectedversions";i:707;s:24:"showhideselectedversions";i:708;s:8:"editundo";i:709;s:10:"diff-multi";i:710;s:20:"diff-multi-manyusers";i:711;s:14:"search-summary";i:712;s:13:"searchresults";i:713;s:19:"searchresults-title";i:714;s:16:"searchresulttext";i:715;s:14:"searchsubtitle";i:716;s:21:"searchsubtitleinvalid";i:717;s:14:"toomanymatches";i:718;s:12:"titlematches";i:719;s:14:"notitlematches";i:720;s:11:"textmatches";i:721;s:13:"notextmatches";i:722;s:5:"prevn";i:723;s:5:"nextn";i:724;s:11:"prevn-title";i:725;s:11:"nextn-title";i:726;s:11:"shown-title";i:727;s:12:"viewprevnext";i:728;s:17:"searchmenu-legend";i:729;s:17:"searchmenu-exists";i:730;s:14:"searchmenu-new";i:731;s:23:"searchmenu-new-nocreate";i:732;s:14:"searchhelp-url";i:733;s:17:"searchmenu-prefix";i:734;s:15:"searchmenu-help";i:735;s:22:"searchprofile-articles";i:736;s:21:"searchprofile-project";i:737;s:20:"searchprofile-images";i:738;s:24:"searchprofile-everything";i:739;s:22:"searchprofile-advanced";i:740;s:30:"searchprofile-articles-tooltip";i:741;s:29:"searchprofile-project-tooltip";i:742;s:28:"searchprofile-images-tooltip";i:743;s:32:"searchprofile-everything-tooltip";i:744;s:30:"searchprofile-advanced-tooltip";i:745;s:18:"search-result-size";i:746;s:27:"search-result-category-size";i:747;s:19:"search-result-score";i:748;s:15:"search-redirect";i:749;s:14:"search-section";i:750;s:14:"search-suggest";i:751;s:24:"search-interwiki-caption";i:752;s:24:"search-interwiki-default";i:753;s:23:"search-interwiki-custom";i:754;s:21:"search-interwiki-more";i:755;s:24:"search-mwsuggest-enabled";i:756;s:25:"search-mwsuggest-disabled";i:757;s:21:"search-relatedarticle";i:758;s:17:"mwsuggest-disable";i:759;s:23:"searcheverything-enable";i:760;s:13:"searchrelated";i:761;s:9:"searchall";i:762;s:14:"showingresults";i:763;s:17:"showingresultsnum";i:764;s:20:"showingresultsheader";i:765;s:9:"nonefound";i:766;s:16:"search-nonefound";i:767;s:11:"powersearch";i:768;s:18:"powersearch-legend";i:769;s:14:"powersearch-ns";i:770;s:17:"powersearch-redir";i:771;s:17:"powersearch-field";i:772;s:23:"powersearch-togglelabel";i:773;s:21:"powersearch-toggleall";i:774;s:22:"powersearch-togglenone";i:775;s:15:"search-external";i:776;s:14:"searchdisabled";i:777;s:12:"googlesearch";i:778;s:15:"opensearch-desc";i:779;s:10:"qbsettings";i:780;s:15:"qbsettings-none";i:781;s:20:"qbsettings-fixedleft";i:782;s:21:"qbsettings-fixedright";i:783;s:23:"qbsettings-floatingleft";i:784;s:24:"qbsettings-floatingright";i:785;s:11:"preferences";i:786;s:19:"preferences-summary";i:787;s:13:"mypreferences";i:788;s:11:"prefs-edits";i:789;s:12:"prefsnologin";i:790;s:16:"prefsnologintext";i:791;s:14:"changepassword";i:792;s:10:"prefs-skin";i:793;s:12:"skin-preview";i:794;s:10:"prefs-math";i:795;s:11:"datedefault";i:796;s:14:"prefs-datetime";i:797;s:14:"prefs-personal";i:798;s:8:"prefs-rc";i:799;s:15:"prefs-watchlist";i:800;s:20:"prefs-watchlist-days";i:801;s:24:"prefs-watchlist-days-max";i:802;s:21:"prefs-watchlist-edits";i:803;s:25:"prefs-watchlist-edits-max";i:804;s:21:"prefs-watchlist-token";i:805;s:10:"prefs-misc";i:806;s:15:"prefs-resetpass";i:807;s:11:"prefs-email";i:808;s:15:"prefs-rendering";i:809;s:9:"saveprefs";i:810;s:10:"resetprefs";i:811;s:12:"restoreprefs";i:812;s:13:"prefs-editing";i:813;s:18:"prefs-edit-boxsize";i:814;s:4:"rows";i:815;s:7:"columns";i:816;s:17:"searchresultshead";i:817;s:14:"resultsperpage";i:818;s:12:"contextlines";i:819;s:12:"contextchars";i:820;s:14:"stub-threshold";i:821;s:23:"stub-threshold-disabled";i:822;s:17:"recentchangesdays";i:823;s:21:"recentchangesdays-max";i:824;s:18:"recentchangescount";i:825;s:29:"prefs-help-recentchangescount";i:826;s:26:"prefs-help-watchlist-token";i:827;s:10:"savedprefs";i:828;s:14:"timezonelegend";i:829;s:9:"localtime";i:830;s:24:"timezoneuseserverdefault";i:831;s:17:"timezoneuseoffset";i:832;s:14:"timezoneoffset";i:833;s:10:"servertime";i:834;s:13:"guesstimezone";i:835;s:21:"timezoneregion-africa";i:836;s:22:"timezoneregion-america";i:837;s:25:"timezoneregion-antarctica";i:838;s:21:"timezoneregion-arctic";i:839;s:19:"timezoneregion-asia";i:840;s:23:"timezoneregion-atlantic";i:841;s:24:"timezoneregion-australia";i:842;s:21:"timezoneregion-europe";i:843;s:21:"timezoneregion-indian";i:844;s:22:"timezoneregion-pacific";i:845;s:10:"allowemail";i:846;s:19:"prefs-searchoptions";i:847;s:16:"prefs-namespaces";i:848;s:9:"defaultns";i:849;s:7:"default";i:850;s:11:"prefs-files";i:851;s:16:"prefs-custom-css";i:852;s:15:"prefs-custom-js";i:853;s:19:"prefs-common-css-js";i:854;s:17:"prefs-reset-intro";i:855;s:24:"prefs-emailconfirm-label";i:856;s:17:"prefs-textboxsize";i:857;s:9:"youremail";i:858;s:8:"username";i:859;s:3:"uid";i:860;s:20:"prefs-memberingroups";i:861;s:25:"prefs-memberingroups-type";i:862;s:18:"prefs-registration";i:863;s:28:"prefs-registration-date-time";i:864;s:12:"yourrealname";i:865;s:12:"yourlanguage";i:866;s:11:"yourvariant";i:867;s:8:"yournick";i:868;s:20:"prefs-help-signature";i:869;s:6:"badsig";i:870;s:12:"badsiglength";i:871;s:10:"yourgender";i:872;s:14:"gender-unknown";i:873;s:11:"gender-male";i:874;s:13:"gender-female";i:875;s:17:"prefs-help-gender";i:876;s:5:"email";i:877;s:19:"prefs-help-realname";i:878;s:16:"prefs-help-email";i:879;s:25:"prefs-help-email-required";i:880;s:10:"prefs-info";i:881;s:10:"prefs-i18n";i:882;s:15:"prefs-signature";i:883;s:16:"prefs-dateformat";i:884;s:16:"prefs-timeoffset";i:885;s:21:"prefs-advancedediting";i:886;s:16:"prefs-advancedrc";i:887;s:23:"prefs-advancedrendering";i:888;s:27:"prefs-advancedsearchoptions";i:889;s:23:"prefs-advancedwatchlist";i:890;s:15:"prefs-displayrc";i:891;s:26:"prefs-displaysearchoptions";i:892;s:22:"prefs-displaywatchlist";i:893;s:11:"prefs-diffs";i:894;s:28:"email-address-validity-valid";i:895;s:30:"email-address-validity-invalid";i:896;s:10:"userrights";i:897;s:18:"userrights-summary";i:898;s:22:"userrights-lookup-user";i:899;s:24:"userrights-user-editname";i:900;s:13:"editusergroup";i:901;s:11:"editinguser";i:902;s:24:"userrights-editusergroup";i:903;s:14:"saveusergroups";i:904;s:23:"userrights-groupsmember";i:905;s:28:"userrights-groupsmember-auto";i:906;s:22:"userrights-groups-help";i:907;s:17:"userrights-reason";i:908;s:23:"userrights-no-interwiki";i:909;s:21:"userrights-nodatabase";i:910;s:18:"userrights-nologin";i:911;s:21:"userrights-notallowed";i:912;s:25:"userrights-changeable-col";i:913;s:27:"userrights-unchangeable-col";i:914;s:30:"userrights-irreversible-marker";i:915;s:5:"group";i:916;s:10:"group-user";i:917;s:19:"group-autoconfirmed";i:918;s:9:"group-bot";i:919;s:11:"group-sysop";i:920;s:16:"group-bureaucrat";i:921;s:14:"group-suppress";i:922;s:9:"group-all";i:923;s:17:"group-user-member";i:924;s:26:"group-autoconfirmed-member";i:925;s:16:"group-bot-member";i:926;s:18:"group-sysop-member";i:927;s:23:"group-bureaucrat-member";i:928;s:21:"group-suppress-member";i:929;s:14:"grouppage-user";i:930;s:23:"grouppage-autoconfirmed";i:931;s:13:"grouppage-bot";i:932;s:15:"grouppage-sysop";i:933;s:20:"grouppage-bureaucrat";i:934;s:18:"grouppage-suppress";i:935;s:10:"right-read";i:936;s:10:"right-edit";i:937;s:16:"right-createpage";i:938;s:16:"right-createtalk";i:939;s:19:"right-createaccount";i:940;s:15:"right-minoredit";i:941;s:10:"right-move";i:942;s:19:"right-move-subpages";i:943;s:24:"right-move-rootuserpages";i:944;s:14:"right-movefile";i:945;s:22:"right-suppressredirect";i:946;s:12:"right-upload";i:947;s:14:"right-reupload";i:948;s:18:"right-reupload-own";i:949;s:21:"right-reupload-shared";i:950;s:19:"right-upload_by_url";i:951;s:11:"right-purge";i:952;s:19:"right-autoconfirmed";i:953;s:9:"right-bot";i:954;s:20:"right-nominornewtalk";i:955;s:19:"right-apihighlimits";i:956;s:14:"right-writeapi";i:957;s:12:"right-delete";i:958;s:15:"right-bigdelete";i:959;s:20:"right-deleterevision";i:960;s:20:"right-deletedhistory";i:961;s:17:"right-deletedtext";i:962;s:19:"right-browsearchive";i:963;s:14:"right-undelete";i:964;s:22:"right-suppressrevision";i:965;s:20:"right-suppressionlog";i:966;s:11:"right-block";i:967;s:16:"right-blockemail";i:968;s:14:"right-hideuser";i:969;s:20:"right-ipblock-exempt";i:970;s:21:"right-proxyunbannable";i:971;s:17:"right-unblockself";i:972;s:13:"right-protect";i:973;s:19:"right-editprotected";i:974;s:19:"right-editinterface";i:975;s:19:"right-editusercssjs";i:976;s:17:"right-editusercss";i:977;s:16:"right-edituserjs";i:978;s:14:"right-rollback";i:979;s:18:"right-markbotedits";i:980;s:17:"right-noratelimit";i:981;s:12:"right-import";i:982;s:18:"right-importupload";i:983;s:12:"right-patrol";i:984;s:16:"right-autopatrol";i:985;s:17:"right-patrolmarks";i:986;s:20:"right-unwatchedpages";i:987;s:15:"right-trackback";i:988;s:18:"right-mergehistory";i:989;s:16:"right-userrights";i:990;s:26:"right-userrights-interwiki";i:991;s:15:"right-siteadmin";i:992;s:21:"right-reset-passwords";i:993;s:27:"right-override-export-depth";i:994;s:15:"right-sendemail";i:995;s:9:"rightslog";i:996;s:13:"rightslogtext";i:997;s:14:"rightslogentry";i:998;s:10:"rightsnone";i:999;s:11:"action-read";i:1000;s:11:"action-edit";i:1001;s:17:"action-createpage";i:1002;s:17:"action-createtalk";i:1003;s:20:"action-createaccount";i:1004;s:16:"action-minoredit";i:1005;s:11:"action-move";i:1006;s:20:"action-move-subpages";i:1007;s:25:"action-move-rootuserpages";i:1008;s:15:"action-movefile";i:1009;s:13:"action-upload";i:1010;s:15:"action-reupload";i:1011;s:22:"action-reupload-shared";i:1012;s:20:"action-upload_by_url";i:1013;s:15:"action-writeapi";i:1014;s:13:"action-delete";i:1015;s:21:"action-deleterevision";i:1016;s:21:"action-deletedhistory";i:1017;s:20:"action-browsearchive";i:1018;s:15:"action-undelete";i:1019;s:23:"action-suppressrevision";i:1020;s:21:"action-suppressionlog";i:1021;s:12:"action-block";i:1022;s:14:"action-protect";i:1023;s:13:"action-import";i:1024;s:19:"action-importupload";i:1025;s:13:"action-patrol";i:1026;s:17:"action-autopatrol";i:1027;s:21:"action-unwatchedpages";i:1028;s:16:"action-trackback";i:1029;s:19:"action-mergehistory";i:1030;s:17:"action-userrights";i:1031;s:27:"action-userrights-interwiki";i:1032;s:16:"action-siteadmin";i:1033;s:8:"nchanges";i:1034;s:13:"recentchanges";i:1035;s:17:"recentchanges-url";i:1036;s:20:"recentchanges-legend";i:1037;s:17:"recentchangestext";i:1038;s:30:"recentchanges-feed-description";i:1039;s:27:"recentchanges-label-newpage";i:1040;s:25:"recentchanges-label-minor";i:1041;s:23:"recentchanges-label-bot";i:1042;s:31:"recentchanges-label-unpatrolled";i:1043;s:6:"rcnote";i:1044;s:10:"rcnotefrom";i:1045;s:10:"rclistfrom";i:1046;s:15:"rcshowhideminor";i:1047;s:14:"rcshowhidebots";i:1048;s:13:"rcshowhideliu";i:1049;s:15:"rcshowhideanons";i:1050;s:14:"rcshowhidepatr";i:1051;s:14:"rcshowhidemine";i:1052;s:7:"rclinks";i:1053;s:4:"diff";i:1054;s:4:"hist";i:1055;s:4:"hide";i:1056;s:4:"show";i:1057;s:15:"minoreditletter";i:1058;s:13:"newpageletter";i:1059;s:13:"boteditletter";i:1060;s:17:"unpatrolledletter";i:1061;s:11:"sectionlink";i:1062;s:31:"number_of_watching_users_RCview";i:1063;s:33:"number_of_watching_users_pageview";i:1064;s:13:"rc_categories";i:1065;s:17:"rc_categories_any";i:1066;s:14:"rc-change-size";i:1067;s:17:"newsectionsummary";i:1068;s:18:"rc-enhanced-expand";i:1069;s:16:"rc-enhanced-hide";i:1070;s:19:"recentchangeslinked";i:1071;s:24:"recentchangeslinked-feed";i:1072;s:27:"recentchangeslinked-toolbox";i:1073;s:25:"recentchangeslinked-title";i:1074;s:28:"recentchangeslinked-backlink";i:1075;s:28:"recentchangeslinked-noresult";i:1076;s:27:"recentchangeslinked-summary";i:1077;s:24:"recentchangeslinked-page";i:1078;s:22:"recentchangeslinked-to";i:1079;s:6:"upload";i:1080;s:9:"uploadbtn";i:1081;s:12:"reuploaddesc";i:1082;s:15:"upload-tryagain";i:1083;s:13:"uploadnologin";i:1084;s:17:"uploadnologintext";i:1085;s:24:"upload_directory_missing";i:1086;s:26:"upload_directory_read_only";i:1087;s:11:"uploaderror";i:1088;s:14:"upload-summary";i:1089;s:23:"upload-recreate-warning";i:1090;s:10:"uploadtext";i:1091;s:16:"upload-permitted";i:1092;s:16:"upload-preferred";i:1093;s:17:"upload-prohibited";i:1094;s:12:"uploadfooter";i:1095;s:9:"uploadlog";i:1096;s:13:"uploadlogpage";i:1097;s:17:"uploadlogpagetext";i:1098;s:8:"filename";i:1099;s:8:"filedesc";i:1100;s:17:"fileuploadsummary";i:1101;s:19:"filereuploadsummary";i:1102;s:10:"filestatus";i:1103;s:10:"filesource";i:1104;s:13:"uploadedfiles";i:1105;s:13:"ignorewarning";i:1106;s:14:"ignorewarnings";i:1107;s:10:"minlength1";i:1108;s:15:"illegalfilename";i:1109;s:11:"badfilename";i:1110;s:22:"filetype-mime-mismatch";i:1111;s:16:"filetype-badmime";i:1112;s:20:"filetype-bad-ie-mime";i:1113;s:22:"filetype-unwanted-type";i:1114;s:20:"filetype-banned-type";i:1115;s:16:"filetype-missing";i:1116;s:10:"empty-file";i:1117;s:14:"file-too-large";i:1118;s:17:"filename-tooshort";i:1119;s:15:"filetype-banned";i:1120;s:18:"verification-error";i:1121;s:11:"hookaborted";i:1122;s:16:"illegal-filename";i:1123;s:9:"overwrite";i:1124;s:13:"unknown-error";i:1125;s:16:"tmp-create-error";i:1126;s:15:"tmp-write-error";i:1127;s:10:"large-file";i:1128;s:15:"largefileserver";i:1129;s:9:"emptyfile";i:1130;s:10:"fileexists";i:1131;s:14:"filepageexists";i:1132;s:20:"fileexists-extension";i:1133;s:24:"fileexists-thumbnail-yes";i:1134;s:17:"file-thumbnail-no";i:1135;s:20:"fileexists-forbidden";i:1136;s:27:"fileexists-shared-forbidden";i:1137;s:21:"file-exists-duplicate";i:1138;s:22:"file-deleted-duplicate";i:1139;s:13:"uploadwarning";i:1140;s:18:"uploadwarning-text";i:1141;s:8:"savefile";i:1142;s:13:"uploadedimage";i:1143;s:14:"overwroteimage";i:1144;s:14:"uploaddisabled";i:1145;s:18:"copyuploaddisabled";i:1146;s:20:"uploadfromurl-queued";i:1147;s:18:"uploaddisabledtext";i:1148;s:22:"php-uploaddisabledtext";i:1149;s:14:"uploadscripted";i:1150;s:11:"uploadvirus";i:1151;s:13:"upload-source";i:1152;s:14:"sourcefilename";i:1153;s:9:"sourceurl";i:1154;s:12:"destfilename";i:1155;s:18:"upload-maxfilesize";i:1156;s:18:"upload-description";i:1157;s:14:"upload-options";i:1158;s:15:"watchthisupload";i:1159;s:14:"filewasdeleted";i:1160;s:17:"upload-wasdeleted";i:1161;s:19:"filename-bad-prefix";i:1162;s:25:"filename-prefix-blacklist";i:1163;s:19:"upload-success-subj";i:1164;s:18:"upload-success-msg";i:1165;s:19:"upload-failure-subj";i:1166;s:18:"upload-failure-msg";i:1167;s:19:"upload-warning-subj";i:1168;s:18:"upload-warning-msg";i:1169;s:18:"upload-proto-error";i:1170;s:23:"upload-proto-error-text";i:1171;s:17:"upload-file-error";i:1172;s:22:"upload-file-error-text";i:1173;s:17:"upload-misc-error";i:1174;s:22:"upload-misc-error-text";i:1175;s:25:"upload-too-many-redirects";i:1176;s:19:"upload-unknown-size";i:1177;s:17:"upload-http-error";i:1178;s:21:"img-auth-accessdenied";i:1179;s:19:"img-auth-nopathinfo";i:1180;s:17:"img-auth-notindir";i:1181;s:17:"img-auth-badtitle";i:1182;s:19:"img-auth-nologinnWL";i:1183;s:15:"img-auth-nofile";i:1184;s:14:"img-auth-isdir";i:1185;s:18:"img-auth-streaming";i:1186;s:15:"img-auth-public";i:1187;s:15:"img-auth-noread";i:1188;s:25:"img-auth-bad-query-string";i:1189;s:16:"http-invalid-url";i:1190;s:19:"http-invalid-scheme";i:1191;s:18:"http-request-error";i:1192;s:15:"http-read-error";i:1193;s:14:"http-timed-out";i:1194;s:15:"http-curl-error";i:1195;s:21:"http-host-unreachable";i:1196;s:15:"http-bad-status";i:1197;s:18:"upload-curl-error6";i:1198;s:23:"upload-curl-error6-text";i:1199;s:19:"upload-curl-error28";i:1200;s:24:"upload-curl-error28-text";i:1201;s:7:"license";i:1202;s:14:"license-header";i:1203;s:9:"nolicense";i:1204;s:8:"licenses";i:1205;s:17:"license-nopreview";i:1206;s:17:"upload_source_url";i:1207;s:18:"upload_source_file";i:1208;s:17:"listfiles-summary";i:1209;s:20:"listfiles_search_for";i:1210;s:7:"imgfile";i:1211;s:9:"listfiles";i:1212;s:15:"listfiles_thumb";i:1213;s:14:"listfiles_date";i:1214;s:14:"listfiles_name";i:1215;s:14:"listfiles_user";i:1216;s:14:"listfiles_size";i:1217;s:21:"listfiles_description";i:1218;s:15:"listfiles_count";i:1219;s:16:"file-anchor-link";i:1220;s:8:"filehist";i:1221;s:13:"filehist-help";i:1222;s:18:"filehist-deleteall";i:1223;s:18:"filehist-deleteone";i:1224;s:15:"filehist-revert";i:1225;s:16:"filehist-current";i:1226;s:17:"filehist-datetime";i:1227;s:14:"filehist-thumb";i:1228;s:18:"filehist-thumbtext";i:1229;s:16:"filehist-nothumb";i:1230;s:13:"filehist-user";i:1231;s:19:"filehist-dimensions";i:1232;s:17:"filehist-filesize";i:1233;s:16:"filehist-comment";i:1234;s:16:"filehist-missing";i:1235;s:10:"imagelinks";i:1236;s:12:"linkstoimage";i:1237;s:17:"linkstoimage-more";i:1238;s:14:"nolinkstoimage";i:1239;s:16:"morelinkstoimage";i:1240;s:15:"redirectstofile";i:1241;s:16:"duplicatesoffile";i:1242;s:12:"sharedupload";i:1243;s:23:"sharedupload-desc-there";i:1244;s:22:"sharedupload-desc-here";i:1245;s:24:"shareddescriptionfollows";i:1246;s:15:"filepage-nofile";i:1247;s:20:"filepage-nofile-link";i:1248;s:25:"uploadnewversion-linktext";i:1249;s:16:"shared-repo-from";i:1250;s:11:"shared-repo";i:1251;s:33:"shared-repo-name-wikimediacommons";i:1252;s:12:"filepage.css";i:1253;s:10:"filerevert";i:1254;s:19:"filerevert-backlink";i:1255;s:17:"filerevert-legend";i:1256;s:16:"filerevert-intro";i:1257;s:18:"filerevert-comment";i:1258;s:25:"filerevert-defaultcomment";i:1259;s:17:"filerevert-submit";i:1260;s:18:"filerevert-success";i:1261;s:21:"filerevert-badversion";i:1262;s:10:"filedelete";i:1263;s:19:"filedelete-backlink";i:1264;s:17:"filedelete-legend";i:1265;s:16:"filedelete-intro";i:1266;s:20:"filedelete-intro-old";i:1267;s:18:"filedelete-comment";i:1268;s:17:"filedelete-submit";i:1269;s:18:"filedelete-success";i:1270;s:22:"filedelete-success-old";i:1271;s:17:"filedelete-nofile";i:1272;s:21:"filedelete-nofile-old";i:1273;s:22:"filedelete-otherreason";i:1274;s:27:"filedelete-reason-otherlist";i:1275;s:26:"filedelete-reason-dropdown";i:1276;s:26:"filedelete-edit-reasonlist";i:1277;s:22:"filedelete-maintenance";i:1278;s:10:"mimesearch";i:1279;s:18:"mimesearch-summary";i:1280;s:8:"mimetype";i:1281;s:8:"download";i:1282;s:14:"unwatchedpages";i:1283;s:22:"unwatchedpages-summary";i:1284;s:13:"listredirects";i:1285;s:21:"listredirects-summary";i:1286;s:15:"unusedtemplates";i:1287;s:23:"unusedtemplates-summary";i:1288;s:19:"unusedtemplatestext";i:1289;s:18:"unusedtemplateswlh";i:1290;s:10:"randompage";i:1291;s:18:"randompage-nopages";i:1292;s:14:"randompage-url";i:1293;s:14:"randomredirect";i:1294;s:22:"randomredirect-nopages";i:1295;s:10:"statistics";i:1296;s:18:"statistics-summary";i:1297;s:23:"statistics-header-pages";i:1298;s:23:"statistics-header-edits";i:1299;s:23:"statistics-header-views";i:1300;s:23:"statistics-header-users";i:1301;s:23:"statistics-header-hooks";i:1302;s:19:"statistics-articles";i:1303;s:16:"statistics-pages";i:1304;s:21:"statistics-pages-desc";i:1305;s:16:"statistics-files";i:1306;s:16:"statistics-edits";i:1307;s:24:"statistics-edits-average";i:1308;s:22:"statistics-views-total";i:1309;s:27:"statistics-views-total-desc";i:1310;s:24:"statistics-views-peredit";i:1311;s:16:"statistics-users";i:1312;s:23:"statistics-users-active";i:1313;s:28:"statistics-users-active-desc";i:1314;s:22:"statistics-mostpopular";i:1315;s:17:"statistics-footer";i:1316;s:15:"disambiguations";i:1317;s:23:"disambiguations-summary";i:1318;s:19:"disambiguationspage";i:1319;s:20:"disambiguations-text";i:1320;s:15:"doubleredirects";i:1321;s:23:"doubleredirects-summary";i:1322;s:19:"doubleredirectstext";i:1323;s:26:"double-redirect-fixed-move";i:1324;s:21:"double-redirect-fixer";i:1325;s:15:"brokenredirects";i:1326;s:23:"brokenredirects-summary";i:1327;s:19:"brokenredirectstext";i:1328;s:20:"brokenredirects-edit";i:1329;s:22:"brokenredirects-delete";i:1330;s:16:"withoutinterwiki";i:1331;s:24:"withoutinterwiki-summary";i:1332;s:23:"withoutinterwiki-legend";i:1333;s:23:"withoutinterwiki-submit";i:1334;s:15:"fewestrevisions";i:1335;s:23:"fewestrevisions-summary";i:1336;s:6:"nbytes";i:1337;s:11:"ncategories";i:1338;s:6:"nlinks";i:1339;s:8:"nmembers";i:1340;s:10:"nrevisions";i:1341;s:6:"nviews";i:1342;s:11:"nimagelinks";i:1343;s:14:"ntransclusions";i:1344;s:17:"specialpage-empty";i:1345;s:11:"lonelypages";i:1346;s:19:"lonelypages-summary";i:1347;s:15:"lonelypagestext";i:1348;s:18:"uncategorizedpages";i:1349;s:26:"uncategorizedpages-summary";i:1350;s:23:"uncategorizedcategories";i:1351;s:31:"uncategorizedcategories-summary";i:1352;s:19:"uncategorizedimages";i:1353;s:27:"uncategorizedimages-summary";i:1354;s:22:"uncategorizedtemplates";i:1355;s:30:"uncategorizedtemplates-summary";i:1356;s:16:"unusedcategories";i:1357;s:12:"unusedimages";i:1358;s:12:"popularpages";i:1359;s:20:"popularpages-summary";i:1360;s:16:"wantedcategories";i:1361;s:24:"wantedcategories-summary";i:1362;s:11:"wantedpages";i:1363;s:19:"wantedpages-summary";i:1364;s:20:"wantedpages-badtitle";i:1365;s:11:"wantedfiles";i:1366;s:19:"wantedfiles-summary";i:1367;s:15:"wantedtemplates";i:1368;s:23:"wantedtemplates-summary";i:1369;s:10:"mostlinked";i:1370;s:18:"mostlinked-summary";i:1371;s:20:"mostlinkedcategories";i:1372;s:28:"mostlinkedcategories-summary";i:1373;s:19:"mostlinkedtemplates";i:1374;s:27:"mostlinkedtemplates-summary";i:1375;s:14:"mostcategories";i:1376;s:22:"mostcategories-summary";i:1377;s:10:"mostimages";i:1378;s:18:"mostimages-summary";i:1379;s:13:"mostrevisions";i:1380;s:21:"mostrevisions-summary";i:1381;s:11:"prefixindex";i:1382;s:19:"prefixindex-summary";i:1383;s:10:"shortpages";i:1384;s:18:"shortpages-summary";i:1385;s:9:"longpages";i:1386;s:17:"longpages-summary";i:1387;s:12:"deadendpages";i:1388;s:20:"deadendpages-summary";i:1389;s:16:"deadendpagestext";i:1390;s:14:"protectedpages";i:1391;s:20:"protectedpages-indef";i:1392;s:22:"protectedpages-summary";i:1393;s:22:"protectedpages-cascade";i:1394;s:18:"protectedpagestext";i:1395;s:19:"protectedpagesempty";i:1396;s:15:"protectedtitles";i:1397;s:23:"protectedtitles-summary";i:1398;s:19:"protectedtitlestext";i:1399;s:20:"protectedtitlesempty";i:1400;s:9:"listusers";i:1401;s:17:"listusers-summary";i:1402;s:19:"listusers-editsonly";i:1403;s:22:"listusers-creationsort";i:1404;s:13:"usereditcount";i:1405;s:11:"usercreated";i:1406;s:8:"newpages";i:1407;s:16:"newpages-summary";i:1408;s:17:"newpages-username";i:1409;s:12:"ancientpages";i:1410;s:20:"ancientpages-summary";i:1411;s:4:"move";i:1412;s:12:"movethispage";i:1413;s:16:"unusedimagestext";i:1414;s:20:"unusedcategoriestext";i:1415;s:13:"notargettitle";i:1416;s:12:"notargettext";i:1417;s:11:"nopagetitle";i:1418;s:10:"nopagetext";i:1419;s:13:"pager-newer-n";i:1420;s:13:"pager-older-n";i:1421;s:8:"suppress";i:1422;s:11:"booksources";i:1423;s:19:"booksources-summary";i:1424;s:25:"booksources-search-legend";i:1425;s:16:"booksources-isbn";i:1426;s:14:"booksources-go";i:1427;s:16:"booksources-text";i:1428;s:24:"booksources-invalid-isbn";i:1429;s:6:"rfcurl";i:1430;s:9:"pubmedurl";i:1431;s:19:"specialloguserlabel";i:1432;s:20:"speciallogtitlelabel";i:1433;s:3:"log";i:1434;s:13:"all-logs-page";i:1435;s:11:"alllogstext";i:1436;s:8:"logempty";i:1437;s:18:"log-title-wildcard";i:1438;s:8:"allpages";i:1439;s:16:"allpages-summary";i:1440;s:14:"alphaindexline";i:1441;s:8:"nextpage";i:1442;s:8:"prevpage";i:1443;s:12:"allpagesfrom";i:1444;s:10:"allpagesto";i:1445;s:11:"allarticles";i:1446;s:14:"allinnamespace";i:1447;s:17:"allnotinnamespace";i:1448;s:12:"allpagesprev";i:1449;s:12:"allpagesnext";i:1450;s:14:"allpagessubmit";i:1451;s:14:"allpagesprefix";i:1452;s:16:"allpagesbadtitle";i:1453;s:15:"allpages-bad-ns";i:1454;s:10:"categories";i:1455;s:18:"categories-summary";i:1456;s:18:"categoriespagetext";i:1457;s:14:"categoriesfrom";i:1458;s:29:"special-categories-sort-count";i:1459;s:27:"special-categories-sort-abc";i:1460;s:20:"deletedcontributions";i:1461;s:26:"deletedcontributions-title";i:1462;s:32:"sp-deletedcontributions-contribs";i:1463;s:10:"linksearch";i:1464;s:14:"linksearch-pat";i:1465;s:13:"linksearch-ns";i:1466;s:13:"linksearch-ok";i:1467;s:15:"linksearch-text";i:1468;s:15:"linksearch-line";i:1469;s:16:"linksearch-error";i:1470;s:13:"listusersfrom";i:1471;s:16:"listusers-submit";i:1472;s:18:"listusers-noresult";i:1473;s:17:"listusers-blocked";i:1474;s:11:"activeusers";i:1475;s:19:"activeusers-summary";i:1476;s:17:"activeusers-intro";i:1477;s:17:"activeusers-count";i:1478;s:16:"activeusers-from";i:1479;s:20:"activeusers-hidebots";i:1480;s:22:"activeusers-hidesysops";i:1481;s:20:"activeusers-noresult";i:1482;s:14:"newuserlogpage";i:1483;s:18:"newuserlogpagetext";i:1484;s:15:"newuserlogentry";i:1485;s:18:"newuserlog-byemail";i:1486;s:23:"newuserlog-create-entry";i:1487;s:24:"newuserlog-create2-entry";i:1488;s:27:"newuserlog-autocreate-entry";i:1489;s:15:"listgrouprights";i:1490;s:23:"listgrouprights-summary";i:1491;s:19:"listgrouprights-key";i:1492;s:21:"listgrouprights-group";i:1493;s:22:"listgrouprights-rights";i:1494;s:24:"listgrouprights-helppage";i:1495;s:23:"listgrouprights-members";i:1496;s:29:"listgrouprights-right-display";i:1497;s:29:"listgrouprights-right-revoked";i:1498;s:24:"listgrouprights-addgroup";i:1499;s:27:"listgrouprights-removegroup";i:1500;s:28:"listgrouprights-addgroup-all";i:1501;s:31:"listgrouprights-removegroup-all";i:1502;s:29:"listgrouprights-addgroup-self";i:1503;s:32:"listgrouprights-removegroup-self";i:1504;s:33:"listgrouprights-addgroup-self-all";i:1505;s:36:"listgrouprights-removegroup-self-all";i:1506;s:11:"mailnologin";i:1507;s:15:"mailnologintext";i:1508;s:9:"emailuser";i:1509;s:9:"emailpage";i:1510;s:13:"emailpagetext";i:1511;s:15:"usermailererror";i:1512;s:15:"defemailsubject";i:1513;s:16:"usermaildisabled";i:1514;s:20:"usermaildisabledtext";i:1515;s:12:"noemailtitle";i:1516;s:11:"noemailtext";i:1517;s:16:"nowikiemailtitle";i:1518;s:15:"nowikiemailtext";i:1519;s:12:"email-legend";i:1520;s:9:"emailfrom";i:1521;s:7:"emailto";i:1522;s:12:"emailsubject";i:1523;s:12:"emailmessage";i:1524;s:9:"emailsend";i:1525;s:9:"emailccme";i:1526;s:14:"emailccsubject";i:1527;s:9:"emailsent";i:1528;s:13:"emailsenttext";i:1529;s:15:"emailuserfooter";i:1530;s:19:"usermessage-summary";i:1531;s:18:"usermessage-editor";i:1532;s:20:"usermessage-template";i:1533;s:9:"watchlist";i:1534;s:11:"mywatchlist";i:1535;s:13:"watchlistfor2";i:1536;s:11:"nowatchlist";i:1537;s:17:"watchlistanontext";i:1538;s:12:"watchnologin";i:1539;s:16:"watchnologintext";i:1540;s:10:"addedwatch";i:1541;s:14:"addedwatchtext";i:1542;s:12:"removedwatch";i:1543;s:16:"removedwatchtext";i:1544;s:5:"watch";i:1545;s:13:"watchthispage";i:1546;s:7:"unwatch";i:1547;s:15:"unwatchthispage";i:1548;s:12:"notanarticle";i:1549;s:13:"notvisiblerev";i:1550;s:13:"watchnochange";i:1551;s:17:"watchlist-details";i:1552;s:15:"wlheader-enotif";i:1553;s:20:"wlheader-showupdated";i:1554;s:18:"watchmethod-recent";i:1555;s:16:"watchmethod-list";i:1556;s:17:"watchlistcontains";i:1557;s:15:"iteminvalidname";i:1558;s:6:"wlnote";i:1559;s:10:"wlshowlast";i:1560;s:17:"watchlist-options";i:1561;s:8:"watching";i:1562;s:10:"unwatching";i:1563;s:13:"enotif_mailer";i:1564;s:12:"enotif_reset";i:1565;s:18:"enotif_newpagetext";i:1566;s:28:"enotif_impersonal_salutation";i:1567;s:7:"changed";i:1568;s:7:"created";i:1569;s:14:"enotif_subject";i:1570;s:18:"enotif_lastvisited";i:1571;s:15:"enotif_lastdiff";i:1572;s:18:"enotif_anon_editor";i:1573;s:11:"enotif_body";i:1574;s:10:"deletepage";i:1575;s:7:"confirm";i:1576;s:9:"excontent";i:1577;s:15:"excontentauthor";i:1578;s:13:"exbeforeblank";i:1579;s:7:"exblank";i:1580;s:14:"delete-confirm";i:1581;s:15:"delete-backlink";i:1582;s:13:"delete-legend";i:1583;s:14:"historywarning";i:1584;s:17:"confirmdeletetext";i:1585;s:14:"actioncomplete";i:1586;s:12:"actionfailed";i:1587;s:11:"deletedtext";i:1588;s:14:"deletedarticle";i:1589;s:17:"suppressedarticle";i:1590;s:10:"dellogpage";i:1591;s:14:"dellogpagetext";i:1592;s:11:"deletionlog";i:1593;s:8:"reverted";i:1594;s:13:"deletecomment";i:1595;s:17:"deleteotherreason";i:1596;s:21:"deletereasonotherlist";i:1597;s:21:"deletereason-dropdown";i:1598;s:22:"delete-edit-reasonlist";i:1599;s:13:"delete-toobig";i:1600;s:21:"delete-warning-toobig";i:1601;s:8:"rollback";i:1602;s:14:"rollback_short";i:1603;s:12:"rollbacklink";i:1604;s:14:"rollbackfailed";i:1605;s:12:"cantrollback";i:1606;s:13:"alreadyrolled";i:1607;s:11:"editcomment";i:1608;s:10:"revertpage";i:1609;s:17:"revertpage-nouser";i:1610;s:16:"rollback-success";i:1611;s:20:"sessionfailure-title";i:1612;s:14:"sessionfailure";i:1613;s:14:"protectlogpage";i:1614;s:14:"protectlogtext";i:1615;s:16:"protectedarticle";i:1616;s:25:"modifiedarticleprotection";i:1617;s:18:"unprotectedarticle";i:1618;s:22:"movedarticleprotection";i:1619;s:13:"protect-title";i:1620;s:14:"prot_1movedto2";i:1621;s:16:"protect-backlink";i:1622;s:14:"protect-legend";i:1623;s:14:"protectcomment";i:1624;s:13:"protectexpiry";i:1625;s:22:"protect_expiry_invalid";i:1626;s:18:"protect_expiry_old";i:1627;s:27:"protect-unchain-permissions";i:1628;s:12:"protect-text";i:1629;s:22:"protect-locked-blocked";i:1630;s:21:"protect-locked-dblock";i:1631;s:21:"protect-locked-access";i:1632;s:17:"protect-cascadeon";i:1633;s:15:"protect-default";i:1634;s:16:"protect-fallback";i:1635;s:27:"protect-level-autoconfirmed";i:1636;s:19:"protect-level-sysop";i:1637;s:23:"protect-summary-cascade";i:1638;s:16:"protect-expiring";i:1639;s:25:"protect-expiry-indefinite";i:1640;s:15:"protect-cascade";i:1641;s:16:"protect-cantedit";i:1642;s:17:"protect-othertime";i:1643;s:20:"protect-othertime-op";i:1644;s:23:"protect-existing-expiry";i:1645;s:19:"protect-otherreason";i:1646;s:22:"protect-otherreason-op";i:1647;s:16:"protect-dropdown";i:1648;s:23:"protect-edit-reasonlist";i:1649;s:22:"protect-expiry-options";i:1650;s:16:"restriction-type";i:1651;s:17:"restriction-level";i:1652;s:12:"minimum-size";i:1653;s:12:"maximum-size";i:1654;s:8:"pagesize";i:1655;s:16:"restriction-edit";i:1656;s:16:"restriction-move";i:1657;s:18:"restriction-create";i:1658;s:18:"restriction-upload";i:1659;s:23:"restriction-level-sysop";i:1660;s:31:"restriction-level-autoconfirmed";i:1661;s:21:"restriction-level-all";i:1662;s:8:"undelete";i:1663;s:12:"undeletepage";i:1664;s:17:"undeletepagetitle";i:1665;s:15:"viewdeletedpage";i:1666;s:16:"undeletepagetext";i:1667;s:23:"undelete-fieldset-title";i:1668;s:17:"undeleteextrahelp";i:1669;s:17:"undeleterevisions";i:1670;s:15:"undeletehistory";i:1671;s:14:"undeleterevdel";i:1672;s:22:"undeletehistorynoadmin";i:1673;s:17:"undelete-revision";i:1674;s:24:"undeleterevision-missing";i:1675;s:15:"undelete-nodiff";i:1676;s:11:"undeletebtn";i:1677;s:12:"undeletelink";i:1678;s:16:"undeleteviewlink";i:1679;s:13:"undeletereset";i:1680;s:14:"undeleteinvert";i:1681;s:15:"undeletecomment";i:1682;s:16:"undeletedarticle";i:1683;s:18:"undeletedrevisions";i:1684;s:24:"undeletedrevisions-files";i:1685;s:14:"undeletedfiles";i:1686;s:14:"cannotundelete";i:1687;s:13:"undeletedpage";i:1688;s:15:"undelete-header";i:1689;s:19:"undelete-search-box";i:1690;s:22:"undelete-search-prefix";i:1691;s:22:"undelete-search-submit";i:1692;s:19:"undelete-no-results";i:1693;s:26:"undelete-filename-mismatch";i:1694;s:22:"undelete-bad-store-key";i:1695;s:22:"undelete-cleanup-error";i:1696;s:28:"undelete-missing-filearchive";i:1697;s:20:"undelete-error-short";i:1698;s:19:"undelete-error-long";i:1699;s:26:"undelete-show-file-confirm";i:1700;s:25:"undelete-show-file-submit";i:1701;s:9:"namespace";i:1702;s:6:"invert";i:1703;s:14:"blanknamespace";i:1704;s:13:"contributions";i:1705;s:19:"contributions-title";i:1706;s:9:"mycontris";i:1707;s:11:"contribsub2";i:1708;s:10:"nocontribs";i:1709;s:5:"uctop";i:1710;s:5:"month";i:1711;s:4:"year";i:1712;s:24:"sp-contributions-newbies";i:1713;s:28:"sp-contributions-newbies-sub";i:1714;s:30:"sp-contributions-newbies-title";i:1715;s:25:"sp-contributions-blocklog";i:1716;s:24:"sp-contributions-deleted";i:1717;s:24:"sp-contributions-uploads";i:1718;s:21:"sp-contributions-logs";i:1719;s:21:"sp-contributions-talk";i:1720;s:27:"sp-contributions-userrights";i:1721;s:31:"sp-contributions-blocked-notice";i:1722;s:36:"sp-contributions-blocked-notice-anon";i:1723;s:23:"sp-contributions-search";i:1724;s:25:"sp-contributions-username";i:1725;s:24:"sp-contributions-toponly";i:1726;s:23:"sp-contributions-submit";i:1727;s:24:"sp-contributions-explain";i:1728;s:23:"sp-contributions-footer";i:1729;s:28:"sp-contributions-footer-anon";i:1730;s:13:"whatlinkshere";i:1731;s:19:"whatlinkshere-title";i:1732;s:21:"whatlinkshere-summary";i:1733;s:18:"whatlinkshere-page";i:1734;s:22:"whatlinkshere-backlink";i:1735;s:9:"linkshere";i:1736;s:11:"nolinkshere";i:1737;s:14:"nolinkshere-ns";i:1738;s:10:"isredirect";i:1739;s:10:"istemplate";i:1740;s:7:"isimage";i:1741;s:18:"whatlinkshere-prev";i:1742;s:18:"whatlinkshere-next";i:1743;s:19:"whatlinkshere-links";i:1744;s:24:"whatlinkshere-hideredirs";i:1745;s:23:"whatlinkshere-hidetrans";i:1746;s:23:"whatlinkshere-hidelinks";i:1747;s:24:"whatlinkshere-hideimages";i:1748;s:21:"whatlinkshere-filters";i:1749;s:7:"blockip";i:1750;s:13:"blockip-title";i:1751;s:14:"blockip-legend";i:1752;s:11:"blockiptext";i:1753;s:9:"ipaddress";i:1754;s:18:"ipadressorusername";i:1755;s:9:"ipbexpiry";i:1756;s:9:"ipbreason";i:1757;s:18:"ipbreasonotherlist";i:1758;s:18:"ipbreason-dropdown";i:1759;s:11:"ipbanononly";i:1760;s:16:"ipbcreateaccount";i:1761;s:11:"ipbemailban";i:1762;s:18:"ipbenableautoblock";i:1763;s:9:"ipbsubmit";i:1764;s:8:"ipbother";i:1765;s:10:"ipboptions";i:1766;s:14:"ipbotheroption";i:1767;s:14:"ipbotherreason";i:1768;s:11:"ipbhidename";i:1769;s:12:"ipbwatchuser";i:1770;s:16:"ipballowusertalk";i:1771;s:16:"ipb-change-block";i:1772;s:12:"badipaddress";i:1773;s:17:"blockipsuccesssub";i:1774;s:18:"blockipsuccesstext";i:1775;s:17:"ipb-edit-dropdown";i:1776;s:16:"ipb-unblock-addr";i:1777;s:11:"ipb-unblock";i:1778;s:13:"ipb-blocklist";i:1779;s:22:"ipb-blocklist-contribs";i:1780;s:9:"unblockip";i:1781;s:13:"unblockiptext";i:1782;s:9:"ipusubmit";i:1783;s:9:"unblocked";i:1784;s:12:"unblocked-id";i:1785;s:11:"ipblocklist";i:1786;s:18:"ipblocklist-legend";i:1787;s:20:"ipblocklist-username";i:1788;s:25:"ipblocklist-sh-userblocks";i:1789;s:25:"ipblocklist-sh-tempblocks";i:1790;s:28:"ipblocklist-sh-addressblocks";i:1791;s:19:"ipblocklist-summary";i:1792;s:18:"ipblocklist-submit";i:1793;s:22:"ipblocklist-localblock";i:1794;s:23:"ipblocklist-otherblocks";i:1795;s:13:"blocklistline";i:1796;s:13:"infiniteblock";i:1797;s:13:"expiringblock";i:1798;s:13:"anononlyblock";i:1799;s:16:"noautoblockblock";i:1800;s:18:"createaccountblock";i:1801;s:10:"emailblock";i:1802;s:20:"blocklist-nousertalk";i:1803;s:17:"ipblocklist-empty";i:1804;s:22:"ipblocklist-no-results";i:1805;s:9:"blocklink";i:1806;s:11:"unblocklink";i:1807;s:16:"change-blocklink";i:1808;s:12:"contribslink";i:1809;s:11:"autoblocker";i:1810;s:12:"blocklogpage";i:1811;s:16:"blocklog-showlog";i:1812;s:24:"blocklog-showsuppresslog";i:1813;s:13:"blocklogentry";i:1814;s:16:"reblock-logentry";i:1815;s:12:"blocklogtext";i:1816;s:15:"unblocklogentry";i:1817;s:24:"block-log-flags-anononly";i:1818;s:24:"block-log-flags-nocreate";i:1819;s:27:"block-log-flags-noautoblock";i:1820;s:23:"block-log-flags-noemail";i:1821;s:26:"block-log-flags-nousertalk";i:1822;s:31:"block-log-flags-angry-autoblock";i:1823;s:26:"block-log-flags-hiddenname";i:1824;s:20:"range_block_disabled";i:1825;s:18:"ipb_expiry_invalid";i:1826;s:15:"ipb_expiry_temp";i:1827;s:16:"ipb_hide_invalid";i:1828;s:19:"ipb_already_blocked";i:1829;s:15:"ipb-needreblock";i:1830;s:22:"ipb-otherblocks-header";i:1831;s:16:"ipb_cant_unblock";i:1832;s:20:"ipb_blocked_as_range";i:1833;s:16:"ip_range_invalid";i:1834;s:17:"ip_range_toolarge";i:1835;s:7:"blockme";i:1836;s:12:"proxyblocker";i:1837;s:21:"proxyblocker-disabled";i:1838;s:16:"proxyblockreason";i:1839;s:17:"proxyblocksuccess";i:1840;s:5:"sorbs";i:1841;s:11:"sorbsreason";i:1842;s:27:"sorbs_create_account_reason";i:1843;s:24:"cant-block-while-blocked";i:1844;s:20:"cant-see-hidden-user";i:1845;s:10:"ipbblocked";i:1846;s:16:"ipbnounblockself";i:1847;s:6:"lockdb";i:1848;s:8:"unlockdb";i:1849;s:10:"lockdbtext";i:1850;s:12:"unlockdbtext";i:1851;s:11:"lockconfirm";i:1852;s:13:"unlockconfirm";i:1853;s:7:"lockbtn";i:1854;s:9:"unlockbtn";i:1855;s:13:"locknoconfirm";i:1856;s:16:"lockdbsuccesssub";i:1857;s:18:"unlockdbsuccesssub";i:1858;s:17:"lockdbsuccesstext";i:1859;s:19:"unlockdbsuccesstext";i:1860;s:19:"lockfilenotwritable";i:1861;s:17:"databasenotlocked";i:1862;s:9:"move-page";i:1863;s:18:"move-page-backlink";i:1864;s:16:"move-page-legend";i:1865;s:12:"movepagetext";i:1866;s:28:"movepagetext-noredirectfixer";i:1867;s:16:"movepagetalktext";i:1868;s:11:"movearticle";i:1869;s:20:"moveuserpage-warning";i:1870;s:11:"movenologin";i:1871;s:15:"movenologintext";i:1872;s:14:"movenotallowed";i:1873;s:18:"movenotallowedfile";i:1874;s:19:"cant-move-user-page";i:1875;s:22:"cant-move-to-user-page";i:1876;s:8:"newtitle";i:1877;s:10:"move-watch";i:1878;s:11:"movepagebtn";i:1879;s:12:"pagemovedsub";i:1880;s:14:"movepage-moved";i:1881;s:23:"movepage-moved-redirect";i:1882;s:25:"movepage-moved-noredirect";i:1883;s:13:"articleexists";i:1884;s:23:"cantmove-titleprotected";i:1885;s:10:"talkexists";i:1886;s:7:"movedto";i:1887;s:8:"movetalk";i:1888;s:13:"move-subpages";i:1889;s:18:"move-talk-subpages";i:1890;s:20:"movepage-page-exists";i:1891;s:19:"movepage-page-moved";i:1892;s:21:"movepage-page-unmoved";i:1893;s:18:"movepage-max-pages";i:1894;s:9:"1movedto2";i:1895;s:15:"1movedto2_redir";i:1896;s:24:"move-redirect-suppressed";i:1897;s:11:"movelogpage";i:1898;s:15:"movelogpagetext";i:1899;s:11:"movesubpage";i:1900;s:15:"movesubpagetext";i:1901;s:13:"movenosubpage";i:1902;s:10:"movereason";i:1903;s:10:"revertmove";i:1904;s:15:"delete_and_move";i:1905;s:20:"delete_and_move_text";i:1906;s:23:"delete_and_move_confirm";i:1907;s:22:"delete_and_move_reason";i:1908;s:8:"selfmove";i:1909;s:25:"immobile-source-namespace";i:1910;s:25:"immobile-target-namespace";i:1911;s:28:"immobile-target-namespace-iw";i:1912;s:20:"immobile-source-page";i:1913;s:20:"immobile-target-page";i:1914;s:21:"imagenocrossnamespace";i:1915;s:27:"nonfile-cannot-move-to-file";i:1916;s:17:"imagetypemismatch";i:1917;s:20:"imageinvalidfilename";i:1918;s:20:"fix-double-redirects";i:1919;s:19:"move-leave-redirect";i:1920;s:24:"protectedpagemovewarning";i:1921;s:28:"semiprotectedpagemovewarning";i:1922;s:20:"move-over-sharedrepo";i:1923;s:22:"file-exists-sharedrepo";i:1924;s:6:"export";i:1925;s:10:"exporttext";i:1926;s:13:"exportcuronly";i:1927;s:15:"exportnohistory";i:1928;s:13:"export-submit";i:1929;s:17:"export-addcattext";i:1930;s:13:"export-addcat";i:1931;s:16:"export-addnstext";i:1932;s:12:"export-addns";i:1933;s:15:"export-download";i:1934;s:16:"export-templates";i:1935;s:16:"export-pagelinks";i:1936;s:11:"allmessages";i:1937;s:15:"allmessagesname";i:1938;s:18:"allmessagesdefault";i:1939;s:18:"allmessagescurrent";i:1940;s:15:"allmessagestext";i:1941;s:25:"allmessagesnotsupportedDB";i:1942;s:25:"allmessages-filter-legend";i:1943;s:18:"allmessages-filter";i:1944;s:29:"allmessages-filter-unmodified";i:1945;s:22:"allmessages-filter-all";i:1946;s:27:"allmessages-filter-modified";i:1947;s:18:"allmessages-prefix";i:1948;s:20:"allmessages-language";i:1949;s:25:"allmessages-filter-submit";i:1950;s:14:"thumbnail-more";i:1951;s:11:"filemissing";i:1952;s:15:"thumbnail_error";i:1953;s:15:"djvu_page_error";i:1954;s:11:"djvu_no_xml";i:1955;s:24:"thumbnail_invalid_params";i:1956;s:24:"thumbnail_dest_directory";i:1957;s:20:"thumbnail_image-type";i:1958;s:20:"thumbnail_gd-library";i:1959;s:23:"thumbnail_image-missing";i:1960;s:6:"import";i:1961;s:15:"importinterwiki";i:1962;s:21:"import-interwiki-text";i:1963;s:23:"import-interwiki-source";i:1964;s:24:"import-interwiki-history";i:1965;s:26:"import-interwiki-templates";i:1966;s:23:"import-interwiki-submit";i:1967;s:26:"import-interwiki-namespace";i:1968;s:22:"import-upload-filename";i:1969;s:14:"import-comment";i:1970;s:10:"importtext";i:1971;s:11:"importstart";i:1972;s:21:"import-revision-count";i:1973;s:13:"importnopages";i:1974;s:20:"imported-log-entries";i:1975;s:12:"importfailed";i:1976;s:19:"importunknownsource";i:1977;s:14:"importcantopen";i:1978;s:18:"importbadinterwiki";i:1979;s:12:"importnotext";i:1980;s:13:"importsuccess";i:1981;s:21:"importhistoryconflict";i:1982;s:15:"importnosources";i:1983;s:12:"importnofile";i:1984;s:21:"importuploaderrorsize";i:1985;s:24:"importuploaderrorpartial";i:1986;s:21:"importuploaderrortemp";i:1987;s:20:"import-parse-failure";i:1988;s:16:"import-noarticle";i:1989;s:21:"import-nonewrevisions";i:1990;s:16:"xml-error-string";i:1991;s:13:"import-upload";i:1992;s:21:"import-token-mismatch";i:1993;s:24:"import-invalid-interwiki";i:1994;s:13:"importlogpage";i:1995;s:17:"importlogpagetext";i:1996;s:22:"import-logentry-upload";i:1997;s:29:"import-logentry-upload-detail";i:1998;s:25:"import-logentry-interwiki";i:1999;s:32:"import-logentry-interwiki-detail";i:2000;s:21:"accesskey-pt-userpage";i:2001;s:25:"accesskey-pt-anonuserpage";i:2002;s:19:"accesskey-pt-mytalk";i:2003;s:21:"accesskey-pt-anontalk";i:2004;s:24:"accesskey-pt-preferences";i:2005;s:22:"accesskey-pt-watchlist";i:2006;s:22:"accesskey-pt-mycontris";i:2007;s:18:"accesskey-pt-login";i:2008;s:22:"accesskey-pt-anonlogin";i:2009;s:19:"accesskey-pt-logout";i:2010;s:17:"accesskey-ca-talk";i:2011;s:17:"accesskey-ca-edit";i:2012;s:23:"accesskey-ca-addsection";i:2013;s:23:"accesskey-ca-viewsource";i:2014;s:20:"accesskey-ca-history";i:2015;s:20:"accesskey-ca-protect";i:2016;s:22:"accesskey-ca-unprotect";i:2017;s:19:"accesskey-ca-delete";i:2018;s:21:"accesskey-ca-undelete";i:2019;s:17:"accesskey-ca-move";i:2020;s:18:"accesskey-ca-watch";i:2021;s:20:"accesskey-ca-unwatch";i:2022;s:16:"accesskey-search";i:2023;s:19:"accesskey-search-go";i:2024;s:25:"accesskey-search-fulltext";i:2025;s:16:"accesskey-p-logo";i:2026;s:20:"accesskey-n-mainpage";i:2027;s:32:"accesskey-n-mainpage-description";i:2028;s:18:"accesskey-n-portal";i:2029;s:25:"accesskey-n-currentevents";i:2030;s:25:"accesskey-n-recentchanges";i:2031;s:22:"accesskey-n-randompage";i:2032;s:16:"accesskey-n-help";i:2033;s:25:"accesskey-t-whatlinkshere";i:2034;s:31:"accesskey-t-recentchangeslinked";i:2035;s:18:"accesskey-feed-rss";i:2036;s:19:"accesskey-feed-atom";i:2037;s:25:"accesskey-t-contributions";i:2038;s:21:"accesskey-t-emailuser";i:2039;s:21:"accesskey-t-permalink";i:2040;s:17:"accesskey-t-print";i:2041;s:18:"accesskey-t-upload";i:2042;s:24:"accesskey-t-specialpages";i:2043;s:23:"accesskey-ca-nstab-main";i:2044;s:23:"accesskey-ca-nstab-user";i:2045;s:24:"accesskey-ca-nstab-media";i:2046;s:26:"accesskey-ca-nstab-special";i:2047;s:26:"accesskey-ca-nstab-project";i:2048;s:24:"accesskey-ca-nstab-image";i:2049;s:28:"accesskey-ca-nstab-mediawiki";i:2050;s:27:"accesskey-ca-nstab-template";i:2051;s:23:"accesskey-ca-nstab-help";i:2052;s:27:"accesskey-ca-nstab-category";i:2053;s:19:"accesskey-minoredit";i:2054;s:14:"accesskey-save";i:2055;s:17:"accesskey-preview";i:2056;s:14:"accesskey-diff";i:2057;s:33:"accesskey-compareselectedversions";i:2058;s:15:"accesskey-watch";i:2059;s:16:"accesskey-upload";i:2060;s:26:"accesskey-preferences-save";i:2061;s:17:"accesskey-summary";i:2062;s:24:"accesskey-userrights-set";i:2063;s:23:"accesskey-blockip-block";i:2064;s:16:"accesskey-export";i:2065;s:16:"accesskey-import";i:2066;s:19:"tooltip-pt-userpage";i:2067;s:23:"tooltip-pt-anonuserpage";i:2068;s:17:"tooltip-pt-mytalk";i:2069;s:19:"tooltip-pt-anontalk";i:2070;s:22:"tooltip-pt-preferences";i:2071;s:20:"tooltip-pt-watchlist";i:2072;s:20:"tooltip-pt-mycontris";i:2073;s:16:"tooltip-pt-login";i:2074;s:20:"tooltip-pt-anonlogin";i:2075;s:17:"tooltip-pt-logout";i:2076;s:15:"tooltip-ca-talk";i:2077;s:15:"tooltip-ca-edit";i:2078;s:21:"tooltip-ca-addsection";i:2079;s:21:"tooltip-ca-viewsource";i:2080;s:18:"tooltip-ca-history";i:2081;s:18:"tooltip-ca-protect";i:2082;s:20:"tooltip-ca-unprotect";i:2083;s:17:"tooltip-ca-delete";i:2084;s:19:"tooltip-ca-undelete";i:2085;s:15:"tooltip-ca-move";i:2086;s:16:"tooltip-ca-watch";i:2087;s:18:"tooltip-ca-unwatch";i:2088;s:14:"tooltip-search";i:2089;s:17:"tooltip-search-go";i:2090;s:23:"tooltip-search-fulltext";i:2091;s:14:"tooltip-p-logo";i:2092;s:18:"tooltip-n-mainpage";i:2093;s:30:"tooltip-n-mainpage-description";i:2094;s:16:"tooltip-n-portal";i:2095;s:23:"tooltip-n-currentevents";i:2096;s:23:"tooltip-n-recentchanges";i:2097;s:20:"tooltip-n-randompage";i:2098;s:14:"tooltip-n-help";i:2099;s:23:"tooltip-t-whatlinkshere";i:2100;s:29:"tooltip-t-recentchangeslinked";i:2101;s:16:"tooltip-feed-rss";i:2102;s:17:"tooltip-feed-atom";i:2103;s:23:"tooltip-t-contributions";i:2104;s:19:"tooltip-t-emailuser";i:2105;s:16:"tooltip-t-upload";i:2106;s:22:"tooltip-t-specialpages";i:2107;s:15:"tooltip-t-print";i:2108;s:19:"tooltip-t-permalink";i:2109;s:21:"tooltip-ca-nstab-main";i:2110;s:21:"tooltip-ca-nstab-user";i:2111;s:22:"tooltip-ca-nstab-media";i:2112;s:24:"tooltip-ca-nstab-special";i:2113;s:24:"tooltip-ca-nstab-project";i:2114;s:22:"tooltip-ca-nstab-image";i:2115;s:26:"tooltip-ca-nstab-mediawiki";i:2116;s:25:"tooltip-ca-nstab-template";i:2117;s:21:"tooltip-ca-nstab-help";i:2118;s:25:"tooltip-ca-nstab-category";i:2119;s:17:"tooltip-minoredit";i:2120;s:12:"tooltip-save";i:2121;s:15:"tooltip-preview";i:2122;s:12:"tooltip-diff";i:2123;s:31:"tooltip-compareselectedversions";i:2124;s:13:"tooltip-watch";i:2125;s:16:"tooltip-recreate";i:2126;s:14:"tooltip-upload";i:2127;s:16:"tooltip-rollback";i:2128;s:12:"tooltip-undo";i:2129;s:24:"tooltip-preferences-save";i:2130;s:15:"tooltip-summary";i:2131;s:10:"common.css";i:2132;s:12:"standard.css";i:2133;s:13:"nostalgia.css";i:2134;s:15:"cologneblue.css";i:2135;s:12:"monobook.css";i:2136;s:10:"myskin.css";i:2137;s:9:"chick.css";i:2138;s:10:"simple.css";i:2139;s:10:"modern.css";i:2140;s:10:"vector.css";i:2141;s:9:"print.css";i:2142;s:12:"handheld.css";i:2143;s:9:"common.js";i:2144;s:11:"standard.js";i:2145;s:12:"nostalgia.js";i:2146;s:14:"cologneblue.js";i:2147;s:11:"monobook.js";i:2148;s:9:"myskin.js";i:2149;s:8:"chick.js";i:2150;s:9:"simple.js";i:2151;s:9:"modern.js";i:2152;s:9:"vector.js";i:2153;s:12:"nodublincore";i:2154;s:17:"nocreativecommons";i:2155;s:13:"notacceptable";i:2156;s:9:"anonymous";i:2157;s:8:"siteuser";i:2158;s:8:"anonuser";i:2159;s:16:"lastmodifiedatby";i:2160;s:13:"othercontribs";i:2161;s:6:"others";i:2162;s:9:"siteusers";i:2163;s:9:"anonusers";i:2164;s:11:"creditspage";i:2165;s:9:"nocredits";i:2166;s:19:"spamprotectiontitle";i:2167;s:18:"spamprotectiontext";i:2168;s:19:"spamprotectionmatch";i:2169;s:16:"spambot_username";i:2170;s:14:"spam_reverting";i:2171;s:13:"spam_blanking";i:2172;s:12:"infosubtitle";i:2173;s:8:"numedits";i:2174;s:12:"numtalkedits";i:2175;s:11:"numwatchers";i:2176;s:10:"numauthors";i:2177;s:14:"numtalkauthors";i:2178;s:17:"skinname-standard";i:2179;s:18:"skinname-nostalgia";i:2180;s:20:"skinname-cologneblue";i:2181;s:17:"skinname-monobook";i:2182;s:15:"skinname-myskin";i:2183;s:14:"skinname-chick";i:2184;s:15:"skinname-simple";i:2185;s:15:"skinname-modern";i:2186;s:15:"skinname-vector";i:2187;s:11:"mw_math_png";i:2188;s:14:"mw_math_simple";i:2189;s:12:"mw_math_html";i:2190;s:14:"mw_math_source";i:2191;s:14:"mw_math_modern";i:2192;s:14:"mw_math_mathml";i:2193;s:12:"math_failure";i:2194;s:18:"math_unknown_error";i:2195;s:21:"math_unknown_function";i:2196;s:17:"math_lexing_error";i:2197;s:17:"math_syntax_error";i:2198;s:16:"math_image_error";i:2199;s:15:"math_bad_tmpdir";i:2200;s:15:"math_bad_output";i:2201;s:12:"math_notexvc";i:2202;s:19:"markaspatrolleddiff";i:2203;s:19:"markaspatrolledlink";i:2204;s:19:"markaspatrolledtext";i:2205;s:17:"markedaspatrolled";i:2206;s:21:"markedaspatrolledtext";i:2207;s:16:"rcpatroldisabled";i:2208;s:20:"rcpatroldisabledtext";i:2209;s:22:"markedaspatrollederror";i:2210;s:26:"markedaspatrollederrortext";i:2211;s:35:"markedaspatrollederror-noautopatrol";i:2212;s:15:"patrol-log-page";i:2213;s:17:"patrol-log-header";i:2214;s:15:"patrol-log-line";i:2215;s:15:"patrol-log-auto";i:2216;s:15:"patrol-log-diff";i:2217;s:20:"log-show-hide-patrol";i:2218;s:15:"deletedrevision";i:2219;s:21:"filedeleteerror-short";i:2220;s:20:"filedeleteerror-long";i:2221;s:18:"filedelete-missing";i:2222;s:27:"filedelete-old-unregistered";i:2223;s:31:"filedelete-current-unregistered";i:2224;s:28:"filedelete-archive-read-only";i:2225;s:12:"previousdiff";i:2226;s:8:"nextdiff";i:2227;s:12:"mediawarning";i:2228;s:12:"imagemaxsize";i:2229;s:9:"thumbsize";i:2230;s:11:"widthheight";i:2231;s:15:"widthheightpage";i:2232;s:9:"file-info";i:2233;s:14:"file-info-size";i:2234;s:12:"file-nohires";i:2235;s:13:"svg-long-desc";i:2236;s:14:"show-big-image";i:2237;s:20:"show-big-image-thumb";i:2238;s:20:"file-info-gif-looped";i:2239;s:20:"file-info-gif-frames";i:2240;s:20:"file-info-png-looped";i:2241;s:20:"file-info-png-repeat";i:2242;s:20:"file-info-png-frames";i:2243;s:9:"newimages";i:2244;s:13:"imagelisttext";i:2245;s:17:"newimages-summary";i:2246;s:16:"newimages-legend";i:2247;s:15:"newimages-label";i:2248;s:12:"showhidebots";i:2249;s:8:"noimages";i:2250;s:8:"ilsubmit";i:2251;s:6:"bydate";i:2252;s:21:"sp-newimages-showfrom";i:2253;s:10:"video-dims";i:2254;s:14:"seconds-abbrev";i:2255;s:14:"minutes-abbrev";i:2256;s:12:"hours-abbrev";i:2257;s:14:"bad_image_list";i:2258;s:19:"variantname-zh-hans";i:2259;s:19:"variantname-zh-hant";i:2260;s:17:"variantname-zh-cn";i:2261;s:17:"variantname-zh-tw";i:2262;s:17:"variantname-zh-hk";i:2263;s:17:"variantname-zh-mo";i:2264;s:17:"variantname-zh-sg";i:2265;s:17:"variantname-zh-my";i:2266;s:14:"variantname-zh";i:2267;s:20:"variantname-gan-hans";i:2268;s:20:"variantname-gan-hant";i:2269;s:15:"variantname-gan";i:2270;s:17:"variantname-sr-ec";i:2271;s:17:"variantname-sr-el";i:2272;s:14:"variantname-sr";i:2273;s:17:"variantname-kk-kz";i:2274;s:17:"variantname-kk-tr";i:2275;s:17:"variantname-kk-cn";i:2276;s:19:"variantname-kk-cyrl";i:2277;s:19:"variantname-kk-latn";i:2278;s:19:"variantname-kk-arab";i:2279;s:14:"variantname-kk";i:2280;s:19:"variantname-ku-arab";i:2281;s:19:"variantname-ku-latn";i:2282;s:14:"variantname-ku";i:2283;s:19:"variantname-tg-cyrl";i:2284;s:19:"variantname-tg-latn";i:2285;s:14:"variantname-tg";i:2286;s:8:"metadata";i:2287;s:13:"metadata-help";i:2288;s:15:"metadata-expand";i:2289;s:17:"metadata-collapse";i:2290;s:15:"metadata-fields";i:2291;s:15:"exif-imagewidth";i:2292;s:16:"exif-imagelength";i:2293;s:18:"exif-bitspersample";i:2294;s:16:"exif-compression";i:2295;s:30:"exif-photometricinterpretation";i:2296;s:16:"exif-orientation";i:2297;s:20:"exif-samplesperpixel";i:2298;s:24:"exif-planarconfiguration";i:2299;s:21:"exif-ycbcrsubsampling";i:2300;s:21:"exif-ycbcrpositioning";i:2301;s:16:"exif-xresolution";i:2302;s:16:"exif-yresolution";i:2303;s:19:"exif-resolutionunit";i:2304;s:17:"exif-stripoffsets";i:2305;s:17:"exif-rowsperstrip";i:2306;s:20:"exif-stripbytecounts";i:2307;s:26:"exif-jpeginterchangeformat";i:2308;s:32:"exif-jpeginterchangeformatlength";i:2309;s:21:"exif-transferfunction";i:2310;s:15:"exif-whitepoint";i:2311;s:26:"exif-primarychromaticities";i:2312;s:22:"exif-ycbcrcoefficients";i:2313;s:24:"exif-referenceblackwhite";i:2314;s:13:"exif-datetime";i:2315;s:21:"exif-imagedescription";i:2316;s:9:"exif-make";i:2317;s:10:"exif-model";i:2318;s:13:"exif-software";i:2319;s:11:"exif-artist";i:2320;s:14:"exif-copyright";i:2321;s:16:"exif-exifversion";i:2322;s:20:"exif-flashpixversion";i:2323;s:15:"exif-colorspace";i:2324;s:28:"exif-componentsconfiguration";i:2325;s:27:"exif-compressedbitsperpixel";i:2326;s:20:"exif-pixelydimension";i:2327;s:20:"exif-pixelxdimension";i:2328;s:14:"exif-makernote";i:2329;s:16:"exif-usercomment";i:2330;s:21:"exif-relatedsoundfile";i:2331;s:21:"exif-datetimeoriginal";i:2332;s:22:"exif-datetimedigitized";i:2333;s:15:"exif-subsectime";i:2334;s:23:"exif-subsectimeoriginal";i:2335;s:24:"exif-subsectimedigitized";i:2336;s:17:"exif-exposuretime";i:2337;s:24:"exif-exposuretime-format";i:2338;s:12:"exif-fnumber";i:2339;s:19:"exif-fnumber-format";i:2340;s:20:"exif-exposureprogram";i:2341;s:24:"exif-spectralsensitivity";i:2342;s:20:"exif-isospeedratings";i:2343;s:9:"exif-oecf";i:2344;s:22:"exif-shutterspeedvalue";i:2345;s:18:"exif-aperturevalue";i:2346;s:20:"exif-brightnessvalue";i:2347;s:22:"exif-exposurebiasvalue";i:2348;s:21:"exif-maxaperturevalue";i:2349;s:20:"exif-subjectdistance";i:2350;s:17:"exif-meteringmode";i:2351;s:16:"exif-lightsource";i:2352;s:10:"exif-flash";i:2353;s:16:"exif-focallength";i:2354;s:23:"exif-focallength-format";i:2355;s:16:"exif-subjectarea";i:2356;s:16:"exif-flashenergy";i:2357;s:29:"exif-spatialfrequencyresponse";i:2358;s:26:"exif-focalplanexresolution";i:2359;s:26:"exif-focalplaneyresolution";i:2360;s:29:"exif-focalplaneresolutionunit";i:2361;s:20:"exif-subjectlocation";i:2362;s:18:"exif-exposureindex";i:2363;s:18:"exif-sensingmethod";i:2364;s:15:"exif-filesource";i:2365;s:14:"exif-scenetype";i:2366;s:15:"exif-cfapattern";i:2367;s:19:"exif-customrendered";i:2368;s:17:"exif-exposuremode";i:2369;s:17:"exif-whitebalance";i:2370;s:21:"exif-digitalzoomratio";i:2371;s:26:"exif-focallengthin35mmfilm";i:2372;s:21:"exif-scenecapturetype";i:2373;s:16:"exif-gaincontrol";i:2374;s:13:"exif-contrast";i:2375;s:15:"exif-saturation";i:2376;s:14:"exif-sharpness";i:2377;s:29:"exif-devicesettingdescription";i:2378;s:25:"exif-subjectdistancerange";i:2379;s:18:"exif-imageuniqueid";i:2380;s:17:"exif-gpsversionid";i:2381;s:19:"exif-gpslatituderef";i:2382;s:16:"exif-gpslatitude";i:2383;s:20:"exif-gpslongituderef";i:2384;s:17:"exif-gpslongitude";i:2385;s:19:"exif-gpsaltituderef";i:2386;s:16:"exif-gpsaltitude";i:2387;s:17:"exif-gpstimestamp";i:2388;s:18:"exif-gpssatellites";i:2389;s:14:"exif-gpsstatus";i:2390;s:19:"exif-gpsmeasuremode";i:2391;s:11:"exif-gpsdop";i:2392;s:16:"exif-gpsspeedref";i:2393;s:13:"exif-gpsspeed";i:2394;s:16:"exif-gpstrackref";i:2395;s:13:"exif-gpstrack";i:2396;s:23:"exif-gpsimgdirectionref";i:2397;s:20:"exif-gpsimgdirection";i:2398;s:16:"exif-gpsmapdatum";i:2399;s:23:"exif-gpsdestlatituderef";i:2400;s:20:"exif-gpsdestlatitude";i:2401;s:24:"exif-gpsdestlongituderef";i:2402;s:21:"exif-gpsdestlongitude";i:2403;s:22:"exif-gpsdestbearingref";i:2404;s:19:"exif-gpsdestbearing";i:2405;s:23:"exif-gpsdestdistanceref";i:2406;s:20:"exif-gpsdestdistance";i:2407;s:24:"exif-gpsprocessingmethod";i:2408;s:23:"exif-gpsareainformation";i:2409;s:17:"exif-gpsdatestamp";i:2410;s:20:"exif-gpsdifferential";i:2411;s:15:"exif-objectname";i:2412;s:15:"exif-make-value";i:2413;s:16:"exif-model-value";i:2414;s:19:"exif-software-value";i:2415;s:18:"exif-compression-1";i:2416;s:18:"exif-compression-6";i:2417;s:32:"exif-photometricinterpretation-2";i:2418;s:32:"exif-photometricinterpretation-6";i:2419;s:16:"exif-unknowndate";i:2420;s:18:"exif-orientation-1";i:2421;s:18:"exif-orientation-2";i:2422;s:18:"exif-orientation-3";i:2423;s:18:"exif-orientation-4";i:2424;s:18:"exif-orientation-5";i:2425;s:18:"exif-orientation-6";i:2426;s:18:"exif-orientation-7";i:2427;s:18:"exif-orientation-8";i:2428;s:26:"exif-planarconfiguration-1";i:2429;s:26:"exif-planarconfiguration-2";i:2430;s:19:"exif-xyresolution-i";i:2431;s:19:"exif-xyresolution-c";i:2432;s:17:"exif-colorspace-1";i:2433;s:22:"exif-colorspace-ffff.h";i:2434;s:30:"exif-componentsconfiguration-0";i:2435;s:30:"exif-componentsconfiguration-1";i:2436;s:30:"exif-componentsconfiguration-2";i:2437;s:30:"exif-componentsconfiguration-3";i:2438;s:30:"exif-componentsconfiguration-4";i:2439;s:30:"exif-componentsconfiguration-5";i:2440;s:30:"exif-componentsconfiguration-6";i:2441;s:22:"exif-exposureprogram-0";i:2442;s:22:"exif-exposureprogram-1";i:2443;s:22:"exif-exposureprogram-2";i:2444;s:22:"exif-exposureprogram-3";i:2445;s:22:"exif-exposureprogram-4";i:2446;s:22:"exif-exposureprogram-5";i:2447;s:22:"exif-exposureprogram-6";i:2448;s:22:"exif-exposureprogram-7";i:2449;s:22:"exif-exposureprogram-8";i:2450;s:26:"exif-subjectdistance-value";i:2451;s:19:"exif-meteringmode-0";i:2452;s:19:"exif-meteringmode-1";i:2453;s:19:"exif-meteringmode-2";i:2454;s:19:"exif-meteringmode-3";i:2455;s:19:"exif-meteringmode-4";i:2456;s:19:"exif-meteringmode-5";i:2457;s:19:"exif-meteringmode-6";i:2458;s:21:"exif-meteringmode-255";i:2459;s:18:"exif-lightsource-0";i:2460;s:18:"exif-lightsource-1";i:2461;s:18:"exif-lightsource-2";i:2462;s:18:"exif-lightsource-3";i:2463;s:18:"exif-lightsource-4";i:2464;s:18:"exif-lightsource-9";i:2465;s:19:"exif-lightsource-10";i:2466;s:19:"exif-lightsource-11";i:2467;s:19:"exif-lightsource-12";i:2468;s:19:"exif-lightsource-13";i:2469;s:19:"exif-lightsource-14";i:2470;s:19:"exif-lightsource-15";i:2471;s:19:"exif-lightsource-17";i:2472;s:19:"exif-lightsource-18";i:2473;s:19:"exif-lightsource-19";i:2474;s:19:"exif-lightsource-20";i:2475;s:19:"exif-lightsource-21";i:2476;s:19:"exif-lightsource-22";i:2477;s:19:"exif-lightsource-23";i:2478;s:19:"exif-lightsource-24";i:2479;s:20:"exif-lightsource-255";i:2480;s:18:"exif-flash-fired-0";i:2481;s:18:"exif-flash-fired-1";i:2482;s:19:"exif-flash-return-0";i:2483;s:19:"exif-flash-return-2";i:2484;s:19:"exif-flash-return-3";i:2485;s:17:"exif-flash-mode-1";i:2486;s:17:"exif-flash-mode-2";i:2487;s:17:"exif-flash-mode-3";i:2488;s:21:"exif-flash-function-1";i:2489;s:19:"exif-flash-redeye-1";i:2490;s:31:"exif-focalplaneresolutionunit-2";i:2491;s:20:"exif-sensingmethod-1";i:2492;s:20:"exif-sensingmethod-2";i:2493;s:20:"exif-sensingmethod-3";i:2494;s:20:"exif-sensingmethod-4";i:2495;s:20:"exif-sensingmethod-5";i:2496;s:20:"exif-sensingmethod-7";i:2497;s:20:"exif-sensingmethod-8";i:2498;s:17:"exif-filesource-3";i:2499;s:16:"exif-scenetype-1";i:2500;s:21:"exif-customrendered-0";i:2501;s:21:"exif-customrendered-1";i:2502;s:19:"exif-exposuremode-0";i:2503;s:19:"exif-exposuremode-1";i:2504;s:19:"exif-exposuremode-2";i:2505;s:19:"exif-whitebalance-0";i:2506;s:19:"exif-whitebalance-1";i:2507;s:23:"exif-scenecapturetype-0";i:2508;s:23:"exif-scenecapturetype-1";i:2509;s:23:"exif-scenecapturetype-2";i:2510;s:23:"exif-scenecapturetype-3";i:2511;s:18:"exif-gaincontrol-0";i:2512;s:18:"exif-gaincontrol-1";i:2513;s:18:"exif-gaincontrol-2";i:2514;s:18:"exif-gaincontrol-3";i:2515;s:18:"exif-gaincontrol-4";i:2516;s:15:"exif-contrast-0";i:2517;s:15:"exif-contrast-1";i:2518;s:15:"exif-contrast-2";i:2519;s:17:"exif-saturation-0";i:2520;s:17:"exif-saturation-1";i:2521;s:17:"exif-saturation-2";i:2522;s:16:"exif-sharpness-0";i:2523;s:16:"exif-sharpness-1";i:2524;s:16:"exif-sharpness-2";i:2525;s:27:"exif-subjectdistancerange-0";i:2526;s:27:"exif-subjectdistancerange-1";i:2527;s:27:"exif-subjectdistancerange-2";i:2528;s:27:"exif-subjectdistancerange-3";i:2529;s:18:"exif-gpslatitude-n";i:2530;s:18:"exif-gpslatitude-s";i:2531;s:19:"exif-gpslongitude-e";i:2532;s:19:"exif-gpslongitude-w";i:2533;s:16:"exif-gpsstatus-a";i:2534;s:16:"exif-gpsstatus-v";i:2535;s:21:"exif-gpsmeasuremode-2";i:2536;s:21:"exif-gpsmeasuremode-3";i:2537;s:15:"exif-gpsspeed-k";i:2538;s:15:"exif-gpsspeed-m";i:2539;s:15:"exif-gpsspeed-n";i:2540;s:19:"exif-gpsdirection-t";i:2541;s:19:"exif-gpsdirection-m";i:2542;s:15:"edit-externally";i:2543;s:20:"edit-externally-help";i:2544;s:16:"recentchangesall";i:2545;s:12:"imagelistall";i:2546;s:13:"watchlistall2";i:2547;s:13:"namespacesall";i:2548;s:9:"monthsall";i:2549;s:8:"limitall";i:2550;s:12:"confirmemail";i:2551;s:20:"confirmemail_noemail";i:2552;s:17:"confirmemail_text";i:2553;s:20:"confirmemail_pending";i:2554;s:17:"confirmemail_send";i:2555;s:17:"confirmemail_sent";i:2556;s:21:"confirmemail_oncreate";i:2557;s:23:"confirmemail_sendfailed";i:2558;s:20:"confirmemail_invalid";i:2559;s:22:"confirmemail_needlogin";i:2560;s:20:"confirmemail_success";i:2561;s:21:"confirmemail_loggedin";i:2562;s:18:"confirmemail_error";i:2563;s:20:"confirmemail_subject";i:2564;s:17:"confirmemail_body";i:2565;s:25:"confirmemail_body_changed";i:2566;s:21:"confirmemail_body_set";i:2567;s:24:"confirmemail_invalidated";i:2568;s:15:"invalidateemail";i:2569;s:23:"scarytranscludedisabled";i:2570;s:21:"scarytranscludefailed";i:2571;s:22:"scarytranscludetoolong";i:2572;s:12:"trackbackbox";i:2573;s:9:"trackback";i:2574;s:16:"trackbackexcerpt";i:2575;s:15:"trackbackremove";i:2576;s:13:"trackbacklink";i:2577;s:17:"trackbackdeleteok";i:2578;s:19:"deletedwhileediting";i:2579;s:15:"confirmrecreate";i:2580;s:8:"recreate";i:2581;s:10:"unit-pixel";i:2582;s:20:"confirm_purge_button";i:2583;s:17:"confirm-purge-top";i:2584;s:20:"confirm-purge-bottom";i:2585;s:12:"catseparator";i:2586;s:19:"semicolon-separator";i:2587;s:15:"comma-separator";i:2588;s:15:"colon-separator";i:2589;s:18:"autocomment-prefix";i:2590;s:14:"pipe-separator";i:2591;s:14:"word-separator";i:2592;s:8:"ellipsis";i:2593;s:7:"percent";i:2594;s:11:"parentheses";i:2595;s:16:"imgmultipageprev";i:2596;s:16:"imgmultipagenext";i:2597;s:10:"imgmultigo";i:2598;s:12:"imgmultigoto";i:2599;s:16:"ascending_abbrev";i:2600;s:17:"descending_abbrev";i:2601;s:16:"table_pager_next";i:2602;s:16:"table_pager_prev";i:2603;s:17:"table_pager_first";i:2604;s:16:"table_pager_last";i:2605;s:17:"table_pager_limit";i:2606;s:23:"table_pager_limit_label";i:2607;s:24:"table_pager_limit_submit";i:2608;s:17:"table_pager_empty";i:2609;s:14:"autosumm-blank";i:2610;s:16:"autosumm-replace";i:2611;s:16:"autoredircomment";i:2612;s:12:"autosumm-new";i:2613;s:19:"autoblock_whitelist";i:2614;s:10:"size-bytes";i:2615;s:14:"size-kilobytes";i:2616;s:14:"size-megabytes";i:2617;s:14:"size-gigabytes";i:2618;s:19:"livepreview-loading";i:2619;s:17:"livepreview-ready";i:2620;s:18:"livepreview-failed";i:2621;s:17:"livepreview-error";i:2622;s:15:"lag-warn-normal";i:2623;s:13:"lag-warn-high";i:2624;s:22:"watchlistedit-numitems";i:2625;s:21:"watchlistedit-noitems";i:2626;s:26:"watchlistedit-normal-title";i:2627;s:27:"watchlistedit-normal-legend";i:2628;s:28:"watchlistedit-normal-explain";i:2629;s:27:"watchlistedit-normal-submit";i:2630;s:25:"watchlistedit-normal-done";i:2631;s:23:"watchlistedit-raw-title";i:2632;s:24:"watchlistedit-raw-legend";i:2633;s:25:"watchlistedit-raw-explain";i:2634;s:24:"watchlistedit-raw-titles";i:2635;s:24:"watchlistedit-raw-submit";i:2636;s:22:"watchlistedit-raw-done";i:2637;s:23:"watchlistedit-raw-added";i:2638;s:25:"watchlistedit-raw-removed";i:2639;s:19:"watchlisttools-view";i:2640;s:19:"watchlisttools-edit";i:2641;s:18:"watchlisttools-raw";i:2642;s:19:"iranian-calendar-m1";i:2643;s:19:"iranian-calendar-m2";i:2644;s:19:"iranian-calendar-m3";i:2645;s:19:"iranian-calendar-m4";i:2646;s:19:"iranian-calendar-m5";i:2647;s:19:"iranian-calendar-m6";i:2648;s:19:"iranian-calendar-m7";i:2649;s:19:"iranian-calendar-m8";i:2650;s:19:"iranian-calendar-m9";i:2651;s:20:"iranian-calendar-m10";i:2652;s:20:"iranian-calendar-m11";i:2653;s:20:"iranian-calendar-m12";i:2654;s:17:"hijri-calendar-m1";i:2655;s:17:"hijri-calendar-m2";i:2656;s:17:"hijri-calendar-m3";i:2657;s:17:"hijri-calendar-m4";i:2658;s:17:"hijri-calendar-m5";i:2659;s:17:"hijri-calendar-m6";i:2660;s:17:"hijri-calendar-m7";i:2661;s:17:"hijri-calendar-m8";i:2662;s:17:"hijri-calendar-m9";i:2663;s:18:"hijri-calendar-m10";i:2664;s:18:"hijri-calendar-m11";i:2665;s:18:"hijri-calendar-m12";i:2666;s:18:"hebrew-calendar-m1";i:2667;s:18:"hebrew-calendar-m2";i:2668;s:18:"hebrew-calendar-m3";i:2669;s:18:"hebrew-calendar-m4";i:2670;s:18:"hebrew-calendar-m5";i:2671;s:18:"hebrew-calendar-m6";i:2672;s:19:"hebrew-calendar-m6a";i:2673;s:19:"hebrew-calendar-m6b";i:2674;s:18:"hebrew-calendar-m7";i:2675;s:18:"hebrew-calendar-m8";i:2676;s:18:"hebrew-calendar-m9";i:2677;s:19:"hebrew-calendar-m10";i:2678;s:19:"hebrew-calendar-m11";i:2679;s:19:"hebrew-calendar-m12";i:2680;s:22:"hebrew-calendar-m1-gen";i:2681;s:22:"hebrew-calendar-m2-gen";i:2682;s:22:"hebrew-calendar-m3-gen";i:2683;s:22:"hebrew-calendar-m4-gen";i:2684;s:22:"hebrew-calendar-m5-gen";i:2685;s:22:"hebrew-calendar-m6-gen";i:2686;s:23:"hebrew-calendar-m6a-gen";i:2687;s:23:"hebrew-calendar-m6b-gen";i:2688;s:22:"hebrew-calendar-m7-gen";i:2689;s:22:"hebrew-calendar-m8-gen";i:2690;s:22:"hebrew-calendar-m9-gen";i:2691;s:23:"hebrew-calendar-m10-gen";i:2692;s:23:"hebrew-calendar-m11-gen";i:2693;s:23:"hebrew-calendar-m12-gen";i:2694;s:9:"signature";i:2695;s:14:"signature-anon";i:2696;s:12:"timezone-utc";i:2697;s:21:"unknown_extension_tag";i:2698;s:21:"duplicate-defaultsort";i:2699;s:7:"version";i:2700;s:18:"version-extensions";i:2701;s:20:"version-specialpages";i:2702;s:19:"version-parserhooks";i:2703;s:17:"version-variables";i:2704;s:13:"version-skins";i:2705;s:13:"version-other";i:2706;s:21:"version-mediahandlers";i:2707;s:13:"version-hooks";i:2708;s:27:"version-extension-functions";i:2709;s:28:"version-parser-extensiontags";i:2710;s:29:"version-parser-function-hooks";i:2711;s:32:"version-skin-extension-functions";i:2712;s:17:"version-hook-name";i:2713;s:25:"version-hook-subscribedby";i:2714;s:15:"version-version";i:2715;s:20:"version-svn-revision";i:2716;s:15:"version-license";i:2717;s:25:"version-poweredby-credits";i:2718;s:24:"version-poweredby-others";i:2719;s:20:"version-license-info";i:2720;s:16:"version-software";i:2721;s:24:"version-software-product";i:2722;s:24:"version-software-version";i:2723;s:8:"filepath";i:2724;s:13:"filepath-page";i:2725;s:15:"filepath-submit";i:2726;s:16:"filepath-summary";i:2727;s:19:"fileduplicatesearch";i:2728;s:27:"fileduplicatesearch-summary";i:2729;s:26:"fileduplicatesearch-legend";i:2730;s:28:"fileduplicatesearch-filename";i:2731;s:26:"fileduplicatesearch-submit";i:2732;s:24:"fileduplicatesearch-info";i:2733;s:28:"fileduplicatesearch-result-1";i:2734;s:28:"fileduplicatesearch-result-n";i:2735;s:12:"specialpages";i:2736;s:20:"specialpages-summary";i:2737;s:17:"specialpages-note";i:2738;s:30:"specialpages-group-maintenance";i:2739;s:24:"specialpages-group-other";i:2740;s:24:"specialpages-group-login";i:2741;s:26:"specialpages-group-changes";i:2742;s:24:"specialpages-group-media";i:2743;s:24:"specialpages-group-users";i:2744;s:26:"specialpages-group-highuse";i:2745;s:24:"specialpages-group-pages";i:2746;s:28:"specialpages-group-pagetools";i:2747;s:23:"specialpages-group-wiki";i:2748;s:28:"specialpages-group-redirects";i:2749;s:23:"specialpages-group-spam";i:2750;s:9:"blankpage";i:2751;s:22:"intentionallyblankpage";i:2752;s:24:"external_image_whitelist";i:2753;s:4:"tags";i:2754;s:10:"tag-filter";i:2755;s:17:"tag-filter-submit";i:2756;s:10:"tags-title";i:2757;s:10:"tags-intro";i:2758;s:8:"tags-tag";i:2759;s:19:"tags-display-header";i:2760;s:23:"tags-description-header";i:2761;s:20:"tags-hitcount-header";i:2762;s:9:"tags-edit";i:2763;s:13:"tags-hitcount";i:2764;s:12:"comparepages";i:2765;s:16:"compare-selector";i:2766;s:13:"compare-page1";i:2767;s:13:"compare-page2";i:2768;s:12:"compare-rev1";i:2769;s:12:"compare-rev2";i:2770;s:14:"compare-submit";i:2771;s:12:"dberr-header";i:2772;s:14:"dberr-problems";i:2773;s:11:"dberr-again";i:2774;s:10:"dberr-info";i:2775;s:15:"dberr-usegoogle";i:2776;s:15:"dberr-outofdate";i:2777;s:17:"dberr-cachederror";i:2778;s:22:"htmlform-invalid-input";i:2779;s:25:"htmlform-select-badoption";i:2780;s:20:"htmlform-int-invalid";i:2781;s:22:"htmlform-float-invalid";i:2782;s:19:"htmlform-int-toolow";i:2783;s:20:"htmlform-int-toohigh";i:2784;s:17:"htmlform-required";i:2785;s:15:"htmlform-submit";i:2786;s:14:"htmlform-reset";i:2787;s:28:"htmlform-selectorother-other";i:2788;s:14:"sqlite-has-fts";i:2789;s:13:"sqlite-no-fts";}}
en	preload	a:4:{s:8:"messages";a:96:{s:9:"aboutpage";s:13:"Project:About";s:9:"aboutsite";s:18:"About {{SITENAME}}";s:17:"accesskey-ca-edit";s:1:"e";s:20:"accesskey-ca-history";s:1:"h";s:23:"accesskey-ca-nstab-main";s:1:"c";s:17:"accesskey-ca-talk";s:1:"t";s:25:"accesskey-n-currentevents";s:0:"";s:16:"accesskey-n-help";s:0:"";s:32:"accesskey-n-mainpage-description";s:1:"z";s:18:"accesskey-n-portal";s:0:"";s:22:"accesskey-n-randompage";s:1:"x";s:25:"accesskey-n-recentchanges";s:1:"r";s:23:"accesskey-n-sitesupport";N;s:16:"accesskey-p-logo";s:0:"";s:18:"accesskey-pt-login";s:1:"o";s:16:"accesskey-search";s:1:"f";s:25:"accesskey-search-fulltext";s:0:"";s:19:"accesskey-search-go";s:0:"";s:21:"accesskey-t-permalink";s:0:"";s:17:"accesskey-t-print";s:1:"p";s:31:"accesskey-t-recentchangeslinked";s:1:"k";s:24:"accesskey-t-specialpages";s:1:"q";s:25:"accesskey-t-whatlinkshere";s:1:"j";s:10:"anonnotice";s:1:"-";s:12:"catseparator";s:1:"|";s:15:"colon-separator";s:6:":&#32;";s:13:"currentevents";s:14:"Current events";s:17:"currentevents-url";s:22:"Project:Current events";s:14:"disclaimerpage";s:26:"Project:General disclaimer";s:11:"disclaimers";s:11:"Disclaimers";s:4:"edit";s:4:"Edit";s:4:"help";s:4:"Help";s:8:"helppage";s:13:"Help:Contents";s:13:"history_short";s:7:"History";s:6:"jumpto";s:8:"Jump to:";s:16:"jumptonavigation";s:10:"navigation";s:12:"jumptosearch";s:6:"search";s:14:"lastmodifiedat";s:41:"This page was last modified on $1, at $2.";s:8:"mainpage";s:9:"Main Page";s:20:"mainpage-description";s:9:"Main page";s:23:"nav-login-createaccount";s:23:"Log in / create account";s:10:"navigation";s:10:"Navigation";s:10:"nstab-main";s:4:"Page";s:15:"opensearch-desc";s:34:"{{SITENAME}} ({{CONTENTLANGUAGE}})";s:14:"pagecategories";s:33:"{{PLURAL:$1|Category|Categories}}";s:18:"pagecategorieslink";s:18:"Special:Categories";s:9:"pagetitle";s:17:"$1 - {{SITENAME}}";s:23:"pagetitle-view-mainpage";s:12:"{{SITENAME}}";s:9:"permalink";s:14:"Permanent link";s:13:"personaltools";s:14:"Personal tools";s:6:"portal";s:16:"Community portal";s:10:"portal-url";s:24:"Project:Community portal";s:16:"printableversion";s:17:"Printable version";s:7:"privacy";s:14:"Privacy policy";s:11:"privacypage";s:22:"Project:Privacy policy";s:10:"randompage";s:11:"Random page";s:14:"randompage-url";s:14:"Special:Random";s:13:"recentchanges";s:14:"Recent changes";s:17:"recentchanges-url";s:21:"Special:RecentChanges";s:27:"recentchangeslinked-toolbox";s:15:"Related changes";s:13:"retrievedfrom";s:19:"Retrieved from "$1"";s:6:"search";s:6:"Search";s:13:"searcharticle";s:2:"Go";s:12:"searchbutton";s:6:"Search";s:7:"sidebar";s:214:"\n* navigation\n** mainpage|mainpage-description\n** portal-url|portal\n** currentevents-url|currentevents\n** recentchanges-url|recentchanges\n** randompage-url|randompage\n** helppage|help\n* SEARCH\n* TOOLBOX\n* LANGUAGES";s:14:"site-atom-feed";s:12:"$1 Atom feed";s:13:"site-rss-feed";s:11:"$1 RSS feed";s:10:"sitenotice";s:1:"-";s:12:"specialpages";s:13:"Special pages";s:7:"tagline";s:17:"From {{SITENAME}}";s:4:"talk";s:10:"Discussion";s:7:"toolbox";s:7:"Toolbox";s:15:"tooltip-ca-edit";s:67:"You can edit this page. Please use the preview button before saving";s:18:"tooltip-ca-history";s:27:"Past revisions of this page";s:21:"tooltip-ca-nstab-main";s:21:"View the content page";s:15:"tooltip-ca-talk";s:33:"Discussion about the content page";s:23:"tooltip-n-currentevents";s:45:"Find background information on current events";s:14:"tooltip-n-help";s:21:"The place to find out";s:30:"tooltip-n-mainpage-description";s:19:"Visit the main page";s:16:"tooltip-n-portal";s:56:"About the project, what you can do, where to find things";s:20:"tooltip-n-randompage";s:18:"Load a random page";s:23:"tooltip-n-recentchanges";s:38:"The list of recent changes in the wiki";s:21:"tooltip-n-sitesupport";N;s:14:"tooltip-p-logo";s:19:"Visit the main page";s:20:"tooltip-p-navigation";N;s:16:"tooltip-pt-login";s:58:"You are encouraged to log in; however, it is not mandatory";s:14:"tooltip-search";s:19:"Search {{SITENAME}}";s:23:"tooltip-search-fulltext";s:30:"Search the pages for this text";s:17:"tooltip-search-go";s:43:"Go to a page with this exact name if exists";s:19:"tooltip-t-permalink";s:43:"Permanent link to this revision of the page";s:15:"tooltip-t-print";s:30:"Printable version of this page";s:29:"tooltip-t-recentchangeslinked";s:45:"Recent changes in pages linked from this page";s:22:"tooltip-t-specialpages";s:25:"List of all special pages";s:23:"tooltip-t-whatlinkshere";s:37:"List of all wiki pages that link here";s:5:"views";s:5:"Views";s:13:"whatlinkshere";s:15:"What links here";}s:11:"dateFormats";a:12:{s:8:"mdy time";s:3:"H:i";s:8:"mdy date";s:6:"F j, Y";s:8:"mdy both";s:11:"H:i, F j, Y";s:8:"dmy time";s:3:"H:i";s:8:"dmy date";s:5:"j F Y";s:8:"dmy both";s:10:"H:i, j F Y";s:8:"ymd time";s:3:"H:i";s:8:"ymd date";s:5:"Y F j";s:8:"ymd both";s:10:"H:i, Y F j";s:13:"ISO 8601 time";s:11:"xnH:xni:xns";s:13:"ISO 8601 date";s:11:"xnY-xnm-xnd";s:13:"ISO 8601 both";s:25:"xnY-xnm-xnd"T"xnH:xni:xns";}s:14:"namespaceNames";a:17:{i:-2;s:5:"Media";i:-1;s:7:"Special";i:0;s:0:"";i:1;s:4:"Talk";i:2;s:4:"User";i:3;s:9:"User_talk";i:5;s:7:"$1_talk";i:6;s:4:"File";i:7;s:9:"File_talk";i:8;s:9:"MediaWiki";i:9;s:14:"MediaWiki_talk";i:10;s:8:"Template";i:11;s:13:"Template_talk";i:12;s:4:"Help";i:13;s:9:"Help_talk";i:14;s:8:"Category";i:15;s:13:"Category_talk";}s:26:"defaultUserOptionOverrides";a:0:{}}
\.


--
-- Data for Name: langlinks; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY langlinks (ll_from, ll_lang, ll_title) FROM stdin;
\.


--
-- Data for Name: log_search; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY log_search (ls_field, ls_value, ls_log_id) FROM stdin;
\.


--
-- Data for Name: logging; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY logging (log_id, log_type, log_action, log_timestamp, log_user, log_namespace, log_title, log_comment, log_params, log_deleted, log_user_text, log_page) FROM stdin;
\.


--
-- Data for Name: math; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY math (math_inputhash, math_outputhash, math_html_conservativeness, math_html, math_mathml) FROM stdin;
\.


--
-- Data for Name: module_deps; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY module_deps (md_module, md_skin, md_deps) FROM stdin;
mediawiki.legacy.shared	vector	["\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/common\\/images\\/feed-icon.png","\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/common\\/images\\/remove.png","\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/common\\/images\\/add.png","\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/common\\/images\\/ajax-loader.gif","\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/common\\/images\\/spinner.gif","\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/common\\/images\\/help-question.gif","\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/common\\/images\\/help-question-hover.gif","\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/common\\/images\\/tipsy-arrow.gif"]
skins.vector	vector	{"0":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/page-base.png","1":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/border.png","2":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/page-fade.png","4":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/tab-break.png","5":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/tab-normal-fade.png","6":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/tab-current-fade.png","8":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/arrow-down-icon.png","11":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/search-fade.png","12":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/portal-break.png","14":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/preferences-break.png","16":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/preferences-fade.png","17":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/preferences-base.png","18":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/bullet-icon.png","19":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/external-link-ltr-icon.png","20":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/lock-icon.png","21":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/mail-icon.png","22":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/news-icon.png","23":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/file-icon.png","24":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/talk-icon.png","25":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/audio-icon.png","26":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/video-icon.png","27":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/document-icon.png","28":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/user-icon.png","29":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/watch-icons.png","30":"\\/var\\/www\\/devel.mwds.info\\/web\\/talkbox2\\/help\\/skins\\/vector\\/images\\/watch-icon-loading.gif"}
\.


--
-- Data for Name: msg_resource; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY msg_resource (mr_resource, mr_lang, mr_blob, mr_timestamp) FROM stdin;
jquery.checkboxShiftClick	en	{}	2011-11-27 18:50:57-08
jquery.client	en	{}	2011-11-27 18:50:57-08
jquery.cookie	en	{}	2011-11-27 18:50:57-08
jquery.placeholder	en	{}	2011-11-27 18:50:57-08
mediawiki.language	en	{}	2011-11-27 18:50:57-08
mediawiki.util	en	{}	2011-11-27 18:50:57-08
mediawiki.legacy.ajax	en	{"watch":"Watch","unwatch":"Unwatch","watching":"Watching...","unwatching":"Unwatching...","tooltip-ca-watch":"Add this page to your watchlist","tooltip-ca-unwatch":"Remove this page from your watchlist"}	2011-11-27 18:50:57-08
mediawiki.legacy.wikibits	en	{"showtoc":"show","hidetoc":"hide"}	2011-11-27 18:50:57-08
mediawiki.action.edit	en	{}	2011-11-27 18:50:57-08
mediawiki.legacy.edit	en	{}	2011-11-27 18:50:57-08
\.


--
-- Data for Name: msg_resource_links; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY msg_resource_links (mrl_resource, mrl_message) FROM stdin;
mediawiki.legacy.ajax	watch
mediawiki.legacy.ajax	unwatch
mediawiki.legacy.ajax	watching
mediawiki.legacy.ajax	unwatching
mediawiki.legacy.ajax	tooltip-ca-watch
mediawiki.legacy.ajax	tooltip-ca-unwatch
mediawiki.legacy.wikibits	showtoc
mediawiki.legacy.wikibits	hidetoc
\.


--
-- Data for Name: mwuser; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY mwuser (user_id, user_name, user_real_name, user_password, user_newpassword, user_newpass_time, user_token, user_email, user_email_token, user_email_token_expires, user_email_authenticated, user_options, user_touched, user_registration, user_editcount) FROM stdin;
0	Anonymous		\N	\N	\N	\N	\N	\N	\N	\N	2011-11-27 18:35:15.804117-05	2011-11-27 15:35:15.804117-08	\N	\N
1	J Moncrieff		:B:882e34ce:d9a9952972847f926f934c6723c93a66		\N	12b2471ed352c6a94b5d6c15e4fcff5f	jeff@mwds.ca		\N	\N		2011-11-27 15:35:22-08	2011-11-27 15:35:17-08	0
\.


--
-- Data for Name: objectcache; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY objectcache (keyname, value, exptime) FROM stdin;
talkbox:messages:en	\\x4bb432b4aa2eb632b7520a730d0af6f4f753b2ceb432b4ae0500	2011-11-28 17:09:23-08
talkbox:messages:individual:Mainpage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:23-08
talkbox:messages:individual:Pagetitle	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Missing-article	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Editsectionhint	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Editsection	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Editsection-brackets	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Pagetitle-view-mainpage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Edit	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Opensearch-desc	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:November	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Lastmodifiedat	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Disclaimers	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Disclaimerpage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Privacy	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Privacypage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Aboutsite	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Aboutpage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Anonnotice	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Sitenotice	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:resourceloader:filter:minify-js:e59a430643ecd8e9d5ccb0b581781449	\\x6d94c992db201086ef790c4e4995cb6579e25934ef906bce2dd49218b1282cd638a9bc7b1a9064b9c88dfe689abf17707575b93cd74c612be0a718c53138b447337961b43b3af45fff30ce151a8d0a8474ac3e1d183771f19a56dae3a7e7035822973b9142632407d6824756b3163b08d23302a2eb8c96b714aa150e1a9962ef6d17fa1e9d4f88a4793ae01f82446874db482e051f373f873c2a6775f5601b6d453ff89daf365e744a686393db0e5abc2248685bbb83b12a1ee438411fd3aa563e03e52e85f3cb463cf0e951b7dbc6c6ac0619537f00298d7c51079adf9ce8b3612cc7a42c280536d7aaa7b848ce2ce8519b59531906d162ca2239446b026f8da4c00be94905a5de583362ae8b5051abf84d5d391fd847709447be40811f924b0ab9163bee689c5386e50dda70e003ae6ba3af5429eafeb890e8da001fb7d475500dda01a115bacf259ba8e60267a33b61978a6dc89b2949fa15a8770dd86458dec28dcebec4a5144af83c7c1615c6e8133837530629943533b99e69141d828d5d49fe67da72839929a5163587650822fa086a8a29e44e479245bbd45592bd716ff86e6de42ad08d828acdae347ed41bb27d68fc60a9804666557ea0905b1742ec6c7c33d97228c515971a247742d403cb939164708b905ee91ded3bb60089f93d9c0e5fd83693b9784f873b897d05fd106cc58df1ffa1528412de27f101c7512de0e314a52d65aecb1b9ae5daa4d8d52b5801e9fd639c7909ba0f348cab9dbbfac39d58ed6dc03ba858dd81743b722ec85341be17e45290e782bc14e4b5206f05a94e252a5557a5ecaad45d95c2ab55f9df6fefeff72f5e1aa0693b3a4f3f337deffb1f9f6a4a63d5de189d60efff00	2038-01-18 19:14:07-08
talkbox:messages:individual:Retrievedfrom	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Nav-login-createaccount	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Nstab-main	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Talk	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:History_short	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Sidebar	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Mainpage-description	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Portal-url	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Portal	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Currentevents-url	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Currentevents	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Recentchanges-url	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Recentchanges	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Randompage-url	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Randompage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Helppage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Help	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Printableversion	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Permalink	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Site-atom-feed	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Vector-view-view	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Vector-view-edit	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Vector-view-history	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-ca-nstab-main	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-ca-nstab-main	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-ca-talk	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-ca-talk	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-ca-view	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-ca-view	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-ca-edit	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-ca-edit	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-ca-history	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-ca-history	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-pt-login	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-pt-login	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Tagline	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Jumpto	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Jumptonavigation	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Jumptosearch	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Personaltools	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Namespaces	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Variants	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Views	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Actions	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Search	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-search	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-search	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Searcharticle	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-search-go	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-search-go	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:24-08
talkbox:messages:individual:Searchbutton	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-search-fulltext	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-search-fulltext	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-p-logo	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-p-logo	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-p-navigation	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Navigation	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-mainpage-description	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-mainpage-description	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-portal	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-portal	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-currentevents	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-currentevents	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-recentchanges	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-recentchanges	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-randompage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-randompage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-help	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-help	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Toolbox	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-t-whatlinkshere	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-t-whatlinkshere	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Whatlinkshere	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-t-recentchangeslinked	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-t-recentchangeslinked	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Recentchangeslinked-toolbox	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-t-specialpages	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-t-specialpages	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Specialpages	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-t-print	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-t-print	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-t-permalink	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-t-permalink	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:25-08
talkbox:resourceloader:filter:minify-js:f349fbe50bf30512b127ed6177ace7f7	\\xb5597b6fdb3610ff3f9f2213b6d6061c3b721e6ee519439725588074cb16b7051607052d9d643694a89194ed34cd77df510f5bb168396eb23c79e4ef8ec7e3ddf1484ba7d77dd373ac2911bb549ef030268a8e190cfc247215e551a3794ffd4644a634208a8b3689e38f20248eb469e4c1fc4fbff1fafdd5f9e9ebe60f83c19efdea554c848433c6893273c9985155f05cdb37cd9f8f9bf7025422a25d9f3009fd879c522241a2af55938a08f5212e6b158247c9277a4bdb389707a22d20a05281685c5f5b922ab05a967dd0ed1e1ef4eca3aed5babe6965dd372d1cd7f292d804c947342a91200c90b4bb186ff3582b240db858d0292926bca5916c4fc1456b54a04b40c8233ee6fcb606226918b3eae296007742dd3a0121476b45750238e341046396d44d137134150b28a9d35591c823c23342befc9b80b8ab196a137917b9b58044f153c6682c6965030acc84061386bf6a08736595b9dd09b8b7633ebf9a505f9db075562bd08c42a46a119c3182aa60f80cc9b8ea118fa16bfc6001e0b7d46cfe1ce1012377e0fd8a516882ed143898c77a1350a9330aac6e2b564c55038c197161c29967888f128c719730fab5761932090290c61032ee72995791f1b9ce4175f2152ee50a18a469a31688f26bbd31a1b82ba2b298c28f57a033ea05506b4404851c53c8ba652f85ac70c51cf3d886d520cc132408f4bed74c902fa8aad1261d3cc1e3f8c584b78c6aaf4c2940d2afdb4e699820d36245b84c5de47f93cec5cbcade29f51217793d833f3c41fa8a9e3ad25caecf97eaf1b9a5ae0b275d99629c28f512aa7a78b2c698b2ab196855d62a232578bc3d73758b5598c3adcee54bd16bf2edd558173cc04139261bd7b9d966925143c67e09075786f36e4bfdc0f73102e593736c811f33c30968146ae4e65851aef5f58dec5814548ac82733eb1cbacabcf3646e3cd7195672df3dbbcfabc5c093991795c2774b881326c9fa2cb3915f6269f10cee09b97d06b78ea3efe6568244d25f1f875501e9556786571de389bf186d278ab275528dc5ee6a696b28ef56a620691d85fb2ff1225329974a40060171ef1640b318a4cd25520539a5306b0bed71a9eea79b19650c2ea67acca080c6068c7273455ee59040843bd90066240a1212986bdb8a19c817b252a5ee9860ba3da64aae9aab2465465455b7ad258db134afdc76b69682a5025e582f055d732f3230443ead9ebddbceeb51dfdf46486bbd031be59bdc726b25219a10743acfc57f41d5f7b696f7e490fbfe754f54c87c2ec267eb7a7e7a46e72fb0e61014c142aff2c4b0bda0597ecf7cb6249d4eb659586ba7c6ce6ba7d0e9ee0554e50a4f9267cb31e7c3edc54c8800f3fb43058b67cf36f024d66f80cfd670b969eb0515697fbd8458e743d36defe6e6a6d95f3e5b66c910adab1af7d62cb8c0155cb982c6ca72ac8e224c9fd6ddce0458dcd1ab6bc7135d2d7a304e02cb495f4a5be9331bc217ef8a52dd3188899a5465a42f720899051f04bb44d7c09b1e93889b28158f46ce68d4c19f6f9a924bd22f8f51e12e8980c713104b5a018b402de9282ab3ceb860de0c2bf565574828531ce96f11ccf494dfe4342ac9a7256161b8d4295dc33ba1a8cbe0d2b8d4f4615adbabf3a39da233bb1ac1a5f1d3b98248bf512328b776315433878ef059f091084a22f548ad7c8f50d934f7ea4eb4b77e1946b120a6585d65d6773a1d0fa6c0781c621d86c9cac3ea8f647b25415c143ee75810a5bd273c42555575207f64c70ebb6df7dafb69e769a4bdf1dde5b9e5e827f565d72741d5e3fe2b741ea15fec8769918a396a987ab2736da1282b55fd378a5b5333fe9e505c6b0043aaf488a5e9ddcbac549a0567c8439402ef0f12828c892ecb9c7b6bafab913a3610b567237195556348ee23a56309ff0d710fb0a9c11fb2c7f983bcb9abb2a1c31c853bb59befefd14a57013dc6fe339ac6692f6f16436f0a6d3e6555f7db325d806cadd810422c97b38b8c5da21720adebef9922f641de5e0c6a6d4f101de427fb5189ce400fda680b5b9d7ba9b5d22462397b5d8cf8dc4cce9e8d1be0ecb7ac94cdb1f3cf299c6ed6f89c751f64e3688acfa9759cc3c71d39eca865f9da32ce71d6c8bb7ba58ac272de94a81cf016a5150671ecfd25958fdba85636afddcd5ac5002ae6168670ecc325550050251aa6ce7e9cb70aa552135da12b6b33a101d5e3ed479fc3152c825b87a01547ba0a0da82e23bfc441fa1782dcbf7f8d1ec9c9027cc1ff4e62c696e6c403cb49b4a4bf41f244b870917e40f59eccffd2d7ab0b8802cdbc673f34fb0f7dea37ca1fbc359acd7b8fbb499a09663a401bd6687ee0ca340fed4ae10e46eb8e875fd2c36190e69dd1bc7b4cc2b8af0fac01440519722f612007d94defa7dec962070b048fd8dd209b4d167dfaec1864874cd135cd32cda0bb6fe357b737ec1ee0f7fe3f23ad2d688d3b99104d5ab8500ff4abe2a30f19fb7dabff1f	2038-01-18 19:14:07-08
talkbox:resourceloader:filter:minify-css:87f3bfc474324b2633fa334b79d8dba8	\\xedbd0997a24ab728f857f27dd567adf7ae9925a23854ad7b5f330b080a8803bdbaef4266196510b456fdf78e40cdd4d4acaa73be73be7bbbd7312b2b05821d117bde3ba6fccb00e9f5fa5ffef17f46b6e51b4f69e6c7c5b7a727e3735e949b67e3736c57dfcc244cb22f9f3606023e5f0bbb2e5e2cdb4c32a3f093f84b9cc4f6f74f45627edb249965675f3a69fd9427a16f3d7d329acfd78d61066e9694b1f57286e58ce0cfd7d4b02c3f76bf6069fdfd3300e1c7960dea8f8cccf5e397d0768a2fa81d358f423fb62f0f36495124d11704bcf564f9fbcf4e981845e6bb5ef1adf9faa5f9fed50c6d233b7f4f93dc6f9a9bd92168f7defe7a82f505f98cd9d113f2847c1e82bf9dcf3d50df2dcca7f49b93c4c54b5e1c42fb8b5f18a16fbe15818d3cd70abf9e2b6dbefea4cea6ae73bdc82dc00fab34017aecec5b430370d38dbf9cee9cf0507865b4b99001d2e56be55b85f7c5288be45cf74b91a4a7fabfbe43266cc73da58acc88f3d4c8402ddf5fabf0e31834e29edc66f379a56a173cf91f7e94265961c4c53deca5e717f6d75347fda3fd65d4fbedeb5dcfbe267b3b0388a9be78be05b8e3bb5744e1d3b91d91e1da1fb6e3baa469a4901237b8b9aaaa2117e4b017cf8624ffd2d0e6a38edcb4b8c10a6847ec3b876f969fa7a17138c94483ae1f73e54f78f047ccf50356f223f7d4eb536f1f20c86a3edf9f0a6313da9fb3131eaf1b79e29b4efa31139fa4b373c747f0ce3d7b6e12ebf0ed8d01cea47f3af101118207af1d7ac53af2fd739c340ae91920e3d3b68c52c0bd2fb1b17f6e9093a4cd7d00a38ce21780f167f83d49bd247efe0cb45991db266cf933541f45e2baa1dd7c3df151f3aef39226959dd9d6e6e09bc9f99699a487060bf056e87fdafb7665825617f0c2d82465f30590da0c0d3fb23378059ab937ccc3f3272749407f5f00179876fefc29aa5e4ed5bd9840b2fd38c8bf3ddd3049197e0bfdfc2ce92fc521b5bfe4bb12c8db77d019803aa00dafd0d6f0ed150f3ffd8fa737b67cc5dbcddd0b5aaf6f7e3f37f30af4d397aa21494391a72f9b8624a79a1a95f1c63ccda3ef5ee7d9439fbdeeb3d77bf6b067af7f5258d5497c3649687d4f9f3f5b895946a00f949d9b997f12c173833a0dc75fb7f456fe2e7aff641280427cedc8e9e7ba3b6976a5058a27cbc83dfbdcd0af4db75e800a33ed2fa0dc95f00e0177bf2a9746455e30d8b4ed4a5f5de3e6849aef27c981a4032f3cdf5c3d15d6756baeb076412800141a696e7fb97cf96e7cbb1285c74af34cf087f47e4385f10572d9b3f165ef03b9b5ad8bf1c6d09b0e5da9f53b830e9edb1924c62b0b02770094b1b3d8083fc3d25f0c075c3d3f7a0cf11803d5033adf14faf6742ef4e51f4ffff31f4f465164ffd3cb6ce77f3dfd03fcfbfec90d938d112e33234d41e1b3da4190dfae3b1a01ed727a72d3d54702724fa88b7eb8147e93871b48d7659e5e215f31c4d7472f3e19cf6f7d3f794bcf27d7e9db551b6eb8fc91fb74c3cc3f85e9c79e9df9c50fa13e2803cdc28dfd03ac0f549c119e357504f454687f7f026c11432a43eb79126ac788fcf0f02507109def9f205b490978d3be35774fa1ffd935c2d0ce0e9ba4fef60e3ad0211fbb81e7569d2405059ae644c60bf8972839bef871a31f00e8d7fb975b6102e85c8697da9f6f1b724ca055fafa6fb76f5d95bfb004a8f855a6e0f7cb0b27f86f402fbec47b85f7c077b901f1b502dd7ca900ab7fd964b611bcc0ebef378dbdf2e2ee813df473bebe35be7119ceb0e0dbdfde794eef3cadabae3ef540771fb6eeec2158bee3dc89d9f7c26a1ebc0066009ecaf5f34f4ef3792d11ffb404688c6d353efe7521d3741cd0c7b786e751d3bf7b8e396be53334cb0eede2013c582588473e8467011fc67e04b05108f58daaf964379f7b60df9b574ccf8881537562f4dc0f012dbe3ee69887aaf78cf8ca0ffce6dbb5d9bcfc22d72c0163ad135fdc1bae0fcdce1bfca7c27bbebeb2be3d86fd6a744e06fafafd472cfbbe25774ec215848fe4ea3bd07e408579b6019dd98b1a06cd423e77411b9ede403c9f64e7196aba14b8b42f274ef6e3dcb7ec2fc63ef1adefb75ecbb337b82ed998ac73c1145aa3a4cabf74bf26590aa809be7dff7e8e93813b63db310c94379becd930b3243e44c0ebac81b8fb9730e3d525066d3d73d6c90d30cb0cf4e88b678729683ef011d3b0cc81952b73e08fe617938d20fd1e82bc2f10dbeea5c0700303f2bb0265185e4a00ba7d7f7afa0cd8127632078eae9f01a7f8f9f3e51bc00df44c6d37017af3736514a607bd98e6f18310f4641ccc24824edd83e7a7c70de70397fadb95c2c17e03ed040cb237bf9d6a86ec1e16d9d732066eb60508e05bfe171b380ed6297eb1ef4cc8d940fdc43e3d3d7d82fc30cb6ce8b77f06cf93f4db5d88f2fde9138c109c248b9e3f1549126e0ce0cf54e91cb030d0c39d6fa7480bbce041b50afdf86dfe12d9790e23a52b59c47ebb1209188aa19fc1ad1bf5d4481008b71ed93f13fe00cc5c852b3771d875ac0593244f1efac9f143db03440224bb6ee649615c3d8422fde0a6f5c0343f7cf9dbbb00f951210bf25e133e3652049f417a3faad77b5cf4dbb5831e27d0003daee8eaf22507fadd84deed9dae005ec88949cf26e0b9b9b8bc77bef9edbdde6dfc88c203b471bdaf17e91a0ebf3e90001093162fa95164408702480f68ea18df3f97f15b913bad7f2a0864acb1d8e782c06bbf92970176930a6998e1fb19dda1b1b1c36f774fcfb488d3b2b8a75cf32c2f3791ffd1c313d407acf119444dce99376f5a7072c951e4b777451a73f5e6c9df56fe21b561a40c241a4ae44b9c34353ca8edc6fb2eb29bb75edb7efff2bb2e5f03691006245f2d23206c87733d43a4d157d7a9a3f7687b4dfa5cc9eb4917bf45fcf9f9fbada7fcf9920b00e0c247059ed28694e906fa1d7b3bf6edd8b49b379e9b276906a277a0bca1d600762b4fe2f3032823271ebf7ff6d17da028c1a3ebfbd77a1bf9edeb6dff72a0704c10c1e56558e4dfbedf5ebf86e9278d853459b4abc4e3837451e3474039b806746b39ced9a8ee107a1c90959a922f9736dcd5f8a010500b9760ee3a51f5967a39854457a99846539de9f508dc9371d5c80e32fcedbed88b651497c0de85fec2b5073eb8790132f0d9c179a051baf0e73d1eefc2819393f918ead31b869b24537e9d55bc20e68c4114bb45e10fa03c95e1a380fa616ae23db2af85f0976b8374bc6af9a39ce1ef000568781ba1dd98f2df05ea33f0e9b2261772f1bdbacde7e2eb59b6630096f88330bf783096bb335befb9f31dc433b3029be024375ec54d375fc9df3c03f7063feefb35d4bf9efeef6a7ba3ff6d02fd8a011cdf0eaddc2e3ebdc24c1a059e7f7b5ff8c2f0b0c30f5a7f839047cf5f474e3e78fe3ad47293d0bbcac0fc2c21f25eb6efe1c03a1ee5c63e44c25368bb766cddda9b8f4b7bbdd71c18f286ec3709fcc1ab67b7f9c2d64dfe1de663aecdc9ef7efbe964cfcfaaf042a04663fd7e58275fe9d67cfc04d4c9b9b9d340e796747ffe2ef4bf6ff9abf3b3b67f06bf3eb40c6fcefed7fb00f39c12a29acf3d0bde8df6c17e16d6155e4048577ebb918c3e78ed2a5d8efdf6fd16933e8cf161b0f568e868f86aa2ce327fce4dbca62220bbe3cde772f332e8545f9b3ad4ae3faab651063721e6e707a55ea224bb1ddcba716f3e02fef2c0ef3b6735ee1cfa5f680470d9b6c065fb76e301dc0d41beb7c40fb473e75a65bf52f3bae489e64db97b05639bf0e7f1c8ce27a2f99c22ec530f8cb038a5ee6ebbf866af2cdf3a2465641bf1b53b8482bedd8c37436e388ff67d3211e42180273bba8fe7cea52298997810eddd70f09b8eb90f8ea0ec5d156d86fdee2215687b3e358f4ec5aec3ebc6b32f733b6b00e62f4081c2d75f075840b8f816c95c9583e84ff3a77f034d7dfef173efbd626864f4e9739283e0c975edfc2aa3db0c575dae5eea4b86f775b0d6d800929685fdb5413f90a81347c134efc958806f77cc714e16de0dd3fbb195547f5c9861eedeb2eb2fa3d13b4139a1e3ad7baf1efdadf77ff6a0d2c4bf4e83231f6635bf5e51f41efaf3fdad172f7c1097fe5efc5c0df87cbd7e00534ad7c9f6076d020d78dc2cc0ec9bc02f1ec4043d121be1fdaf570d7b0cf7dbd3ddbb63c05de1692ac2ed356ce90d9493407dbb9f02701efbafaf08dac77e7bf02ef0569d6fbfc0953770bec2b1cb8d1ffac5e132e903263101cb5f328f9798ca387cff04b3499734d16ba2070ad8c7a1e8abdf00e4ebe6fd46f3457e9c64f7bae6a620b03c773eda890aef8a7d7e4d55fd8ab3771eb93ee56de1c81f04f67c6ad1f367a0871ea8c0469f9830cbf9403d5e140ef4bd1b4d73d63a675f247b98f0795f38b3f749f093acd925399517e0590e40c244341c06ceef9531f02a9ba2a96dfac62933dd54f7004596097f6e86e5ce5e28ccfd3f216fbfdfdf8104125064fee324e1a7dc3332db3ac5f82f56993edfde3193d8097df35186fb0da57664f821e4b3976b3b321afe7676abde9ee7361cd6797e7f3b036d4dfdd744fa63c25d52f7a74a9ae8e8f9a387a657c6c17de6edb514408c6734bab81918fb2083f85a1c4eb449dfdfb97bebc160da7db6fd47ddf9800b9f5e4d364c2efa75d3ee868f4fef3e3f7c0e5af80139de9782557ffb85b6dfa561df8f9b378d6d2681552f9591c5d080577ee1bd84896bd7a69da56ff308ba6fbeedb90678e7ac00d037470c65fa0c4e7cbd1d84f8410597c8f8c6b13d6bb34b860f8e2d862fcdec10201949ec3e7af40ec42308e7e9534df0f4f8d9b77bfd7d62ad73aad1f46c33006edaf3694ce0ddddf75e10340f0fe63b1a9f1dbb19e10dae0765cb2cfc9f30ebf6a511e4761abbc05ee776bff7ec2f88a9522102eb26d04d9154cda335177eade07f2289afc11f62692d8e31bc4144fc444164bc5d516d7cd672f7863d6fee77157eae6963140fa6e4365027a37aedc107e68857684613787a844c984cebd06b79363e3a8edd0adbbeba0856f348f27189d0063e8d4d27d9465dac05ce3f60568c2b4497a96802b3a6534f16cac2e3697aace4da8a48927c8a848240af15031d4d9672d055b109d6cd90d962dfa286d3191f266196651d3de2064c8760e8ed8e58d124cbe35b95208d896599831213a3cd60876918820cb2a587d1a36cadb4eb7c4e102b62292e6837dc2929ebb39e49636c3fb00ea55b9b6cce1e148bef607a45a2238ec1b0ad442f8ba1d03298a9e8992d8b1ce87d959b6fc9816ba062c00dcd74dceb509e375066068ab045af4874c36c713b8f11e7298b788b62a8d805ef8efa03d598efd949cc4a828ed085333589ce0cdb1e768b2da904dcd149e36d21ae57d91c6532d271fa3c00a2d46d372657853e76571a339655d66d973d76e3f4e668b80ef67383614d7be870ae3d5b2323a75a69c399dbcd0394674a6cdf0be5568fa967aeddda6265576eed87f37d4608ce460795cf7b931def8db4fde0c04ca24c44fd963bcb7b5be5b0e30ced3820d156adeb531aef99bca1ba06eeedbc0dd9a10444ea0a23a9ccf7477c4cf4d889d31acb044fe43e490df87e7b745c71e862b338ecdb9bbe6aed3b763fcee670ca0731a8169bc376557432d3491026cb7b5ab0db171a3f1689ed6141e3a6ba657c99af94bdd365baeda9b31eb72d8a59666492185ce373abda62aa0818b9e6b87fff5f4f2709796a063ae20488576a1b3713c9a0907845917e69b72d7b6f87490a9d2a208a56fed934dac0d0413944db707cba9d077e9cb7a1e395c4ed46aaf23694bc171f58c9cf40c0fe378a743a2fe01f3a98a3dd2ff01fa27fd08affe1dbb7316ea70f07353f37a3e6cd00c793f17ebee34fa7bcfde25489eb6920778ed7f5ec898fc28aeb59657feec4899bb6a1f0e781c6fb95991267545c9a6c01db7ab96830733bcaf4392f4dd3cef30f8628428046582f0855813ffc3a68f95109a8d02f109b3cdfbb627766ee1525a729cc30d97497573b5b4998de789d1581bc55f8ed2602858d7b341e0b11fafdba69376f9dbafdc0f574acb78a9e3cf4ba73e0f23add71c9935de7846ea79bbdcd1ebc4cf5be4e04430938cd578893e2326708e6491eb852d7259fd2933b769a230bd38f6fd3c24f53c13f03535c1a21091d89eb6c06f088feb3c8409f61bff36ff7f31536e0e3388f1248e0031edcb2f3d3e739e4af19f4bbbfbd4dd71c22bffd60eed1db2bff091c3220f88f8737de8a3d5f7d87e9949b4befe3e5276f5ae394167bba7cf9fe1ec207bdbd2df778d0bf99cd76532e3b8dda3c7ee102b8d1a8d0ab6d3a7475e53d1a2abf2a708d3e00f33f4f93cb7fa5a2f76ffa91fb9fd6d504eddb7a33e018df34d3bb7e1f4ecc7a50295c7e012a7dfa7472f9cff366f293f6fa7c75e7c52c41a41cf98daeb23e1bd17f9e07ca1ee1184e06ec7d7f0813e8b9c7505f69f013d886e38c900f6037ef1a660104e9118251e0e2a17fac59ad8f4bfcacda4dc771369defc0f36f2604c1f557bf3265f477acc8bacdd63d1a40b8999e84bccbae7cbfb40b4626efb4e1fb250fcd68d8addfdfa8954bdcf89f915d18cd68fa5b9b4e49e5db1ccf07031d970904085c317607f363737a5fb4b84d429fc5e34139eb6ddcecf37504fcd6939b81c08f94e423c8cf0f9bf53b88ff6e94a1f36894e151931fabc813e33cc6c1c733de9efe65d3c53f9e19fe681ef9d7bfa78bff13d3c5df9263b167c426881232f3a3f54baf097c68694e43f7a72cc1f5bb0fd2f26fe3d10f78e67a3e28085892e6cda793720671f079a62b1c8d8bd2e2bd567ab7b0ed83b71e0e1b63f7c9e5cb2c8acc8e00665f67d9beea85e1ed10cc69bed11fc95ff4e07fd353fe027754b2abc02fe48ae0962b117ccb61de624257341ea5152c24804899923b846cb02364d395924d1777554da2b83171d8a07aba61351c1f6f8d7821c50b669632db6eb7bb5748b5e7e3215dec354fe3388627fd1eae05ea7ac7c981ac26ae9758c142336945d1349a1dfaae8f4fa7db841499059d535c22a0b81370863075fb53cecfb3416f556e8d91311cb536523b5bad66a59d0f31f478ac1c9cc40f4b959214698d8b3b8db3699ba4eae19cedd9722973b4c08f719cc6fda34e32c7b62a12f8cc6bcda82ae3727cbc7771c296c4098953f85cdfe3227118b7abf64e4e43135f9320a6269060ee4d480ed7709ae86f0321027f59f0cc8a487d8e0b00344b4dd6e8648b337881b378ecb436739c23ad161f0e7099d88424bdc00d52010d9deb6b0f947707b8709c2d9294c119b7c20925528732864b6e815304bf40750e9f905d5ca4a6345e1e70dc15c17dc5e7b414c79501a88fe30e520fe7541dbccb0e43733854cb929e9a3b1c277ad1861b96aa8c296b6643929d9ae858ab89d74b8e41b0126a195dcbbc17057859c591cece0542c2dbee7058016a930aa38c5db73d1bd9626f9ae583a994f4512a1c16fd6cc8b60fbcbf2e672dcc6c65260d3989419c62dc9a90ad239be00322218af68e0b07ae92acdcd2b51c7ba267dc4c9e6878328d8d455baa5ae3de70462fbd6012eba8bd0a30c9136a9adfaccd74e538585c856d7cd1eee4ad556fd89e399dde64e0f31c7d58ad993131dbba557e44e682661e318ef7d8898925a3717b624edaedca420e135a5d0ad8924cb45e8756cd354603057f044ce1fb9aa00aa61622fb51d02b8679ab125bdda386e76cd2c257a532313c6b5dcd50f560cacbf11cefed4d1c9f0983cd70ac09b84bb9ac4ff5cc51b7dd1ab6db9aedf23289eb41a49a328eaf0239988473213fb6c724408b229084901104db9e132c79c409ef4810d69120dbb52b250ac98b7352f608928c547c3ce65dc13890b2efb3c70d6e01eeda7768dc9244423138636ee2bdb20a973d6adba9a876ea91fc80102607829415e280bbf3b53a367c9cf1fdd0dd6e5d7715ad573dce64380294e2498af70945e182529134b7d69254e398053776b891e97298d7a9d932a50780c10eeefec0ee69b30e39f6a0cdbb1a355950a5e176d9446113772feb63b98e92e132e1f7b299c9c66c5da189edc83bd49da1c9b0250fcdaa9aba6be238a337145ed6b944e673372775697b18d07e861fb2dadb558b5d4595bdb8b31eb66aab9255575be1e47c4d5b08e7ae158c50194f5cd283b52ab8ee989411da4a78a90a288f1993fc4198efe812e1b3446999f27abde56aafe3711372b6a493e17c5213039f9ed1d241567d4d3cf08348c683a84e99b94a173c8b4498cab5827ca7e7884a24db60181b3a5b1e8863a40105901db85510db730aa36601db92bd61980bf192c74d63ded35a5ca2e5e94ef5e2909e6a0826eb6144f1c4c2981a5a8126c94206fa67640084784528ecb5b59dd047a5136d63c9ad755eed2f81d159cdd9c85d19332bcd5a1e527a632b54b06938225648be4f9596bfeae333c4aa2ac9f39654ddf3628188362c6eaef53aecb2426b3d17d63ad2cbf5ba2357d2719c45535ba7b070bf58b8bbc24f878c3e16c8742184aab1600fc97e2144bb7497d93bb7580c3babc9826ba5ab501a6581be103bb3ed4e8eb570572c766947ee77c48d86dae9b4ef8f77919d6c3a723b1d637a7b1db04b53122b6444a50cebe68bf6762fae5d1215f5bcebe6dc3297763dbde3ce57349f8d257455a34256aedb0a3af08fe86e67d0987c9404b1631fb5fd54d3b7c3710ff3ea165f2373378e05c15e0dbb7da1ebcdf782cda56c7f8dcc2741ad2fea6c971aab30f4335528941de264fbb9510e0c1b20b0c3949d78e0ca18512349bc22adb1de6b4f09bd1b6ba370de354c21ad756936cf3a99dfdf197d6d936c0ada1a8ccab4d55fc71906841813377dc7b637ddb8e5d5a349bba3b597dd7eda5e8c29c665f3aa0a8822178f9e3bace78b7a73acacc9d0d90c170cb532255cee2fbc70c9ae7a6b55292d7a988c16ec565bcfb66cccaea662d043bbecc634b6bcbb8e80aa9ecced541aa4a93adf449160ac0773aa10eb61573c1a13a993069de888d49de3248e5af6a683ed9d02250c9b49f262e7a325bbe0f35231d2302e8bac2ebd45822d8dc57ab148ad1c318ad840c24e561665df54d241380d907e16177a5c0da8bac82374b731f57cba5a13455916118a3a4b265e7b565c0c9765d5eacff7ba342a63546acf9131b576746a975b4bafd33207ca81a1d2e5b4e81bc7f458ceba5d66c46fd2096aad8f353543a9d9b6f0661301541b2fa61b04b16206b531b3373bfa5cc9abbdc964929aad499a6feaa2cbed6d45b0668b7a65337d64bfb4a2c17453956882f6dba55462e92071cc785821f121b29773e98888334e6e110a66d16d126b2d4476ef64636c26232d421fac62ee30da4e306605dcc3aae82fbabbbde50d6ab335da6287b825b67ac7aadbdd4eece5a22d4a43b27b983893f950dac7618be922529b6b8f8276376b233219bba446e8d594773596585693416b9c0eb94d6b3a3b661bdd310ea8dd21b60289c9ca82d8f684c22d5744a632c9617a903375dcc5b0ed3430b19402cac029b74b04b73c2c622755b727f2bde5d85bd8ecac87553ee31ac89c5d492b47e9d2d2b18bccfb0aafd3ddb488456d8865878e20a9496be763bb999474cbadda9f0dd7a51ec66267e15b4b3accd5bac226feae94222cdf17ede1c0998e7b69d7275bd280c18036673a956d8ca7d55e65d2da48271e974f531d9f73de74cacf2b59c1773bc21079879b5b87e5948c63726cf231e7b715a9603994964cc1c3a6c3c0ddcd573b75c0b343691504f57c1a4ea64bcc23ed3498d422a51dade8b8b3993445391639cce6bb91b89eaa814ed4f22ef1e6fa14d55b698c453a7ae8d7a1b799b4ea657f521c8676283bbc3198ca19bed0274071cabb4db26092a47348c67964850bd4681fd7b130d5e150e65e1a9887e3a12865093beee376bba0734eede9029aaef5c9e28058cba931cad804cbb7756d5bb9d0ab3546e8e94b62570d4b6e870a517731efef8b0566974e864476d0c9dcc580382413a29099ac5f150bb25c328ebd373bad8e35efb880435b9db5b36363256f31eb48c8bcf986c1cc85337293ee781bb23d6b7fc85a7a9757919db1a7cbe57ca6177cd4b737c0f9c136546aecc296b1a2a29e845a3b84b246cb62daed8c82d56682399220950377a0035b3b6dcf26fe50371cfe98238359470d1633456b85323a282656b11caf5aec401978c5603f5b230369b5590e8eddf67cc0ef8b62812f165267b959e84ec1b706b3eeacdfe77765dc0bc1c395d1996e56e3a2ae662ade46c65cd5473b8358eb285d75b650d4ed689df511735ad7ad563bedeead0322496e67b1d58f6ccf972a651c077dc7e4bb6dd3a6e6996125f5209bd263a41ea1e3a5694dd0948cf682a1a4c53cda179b7558f6e7c3aa85589b5d37ce86ca287728ac42664c88a97b493b2c63a3bf9ecc03d4391c7b072bd43b23c71f605d9602719e3ec0d0d9b48b26b34dabd5a7c7730f09566d1f68a23db59fae6642cf9a0907b4a5cd17036f15ed86fd15dadd59d364d84e67f3f9d01ec493d2c8b2d0340671696768c74637ddbe52dad270608d261d6ca86cda9d62694fe75d6bef48fd4ddb6146ed95c31440dff9cee89897037465c6831d3a9c0f6a674453856c855477ed2c669d7dab2b6df7ddf168578d6d77381a9b4adb64bdf56c068c65675b8d2862dd0226ae64a9f5268bb76e6b3a8ffd597732ea3b87581e8e82e301a8f576df6fe765c9d4ebbdb3df2efa23678ae85b25d19d43884ddb9bd5216cdb19deafa33d3adc90b5d76f1d56ee515c0c90c57e5f542bc7b4eaee3e190d67f39632e4c6c3a48d6eb1dc59cc11c1190475340fda431ac7b6c7362b1e27560e433d778d78ea1cf8acb60fe2368ea4709cc2dac0f577a70188e334f08ddac1c06f9a828091b0f641d86614183b3a7c33666d33581104a38c46e8759db6f9230d50d59970d52aabd6143aa113a547efda3bcd6136283febcb7615aef1164b720b3bf0574b655a760a110d25d7a87796b7963b534fd4a9dcf3b77a6c39525daa07ca053efbec60b794ae8d2b0cb0f3409358dd565cecadae5d0eb385bea9975ccdb6d6996e3aba45d471bf456dab95b066da40bde23b667a682f3b6166dbf49c4ab4b2630d16b5b36ab747c0786f47074539b4579d416b2878f3b24ed2597cec3abbcd514f4a23e6c36506f4ef723592bc04196f0603271dd1f658daaed1be19effa79df9cb7282748b3280b0f033f675c97ae22b7af965577392ec70ac66a09a39104976cc2e32aaf284f2b04d214ab3513f48fa968e45bfb98b3d5c477bdc168bee3dc25cfe0ecd117daf3fecc990f2a691c732da5c40ec271dcdeba348be37e9debbd594e581242cf559d9bf4b55aeb6f398172f1dac3bb828f730ea986de76248b00f644647dbb5e27ee4ce4fcdad45d43f02911118a8899ae2a4e7589915811a239988c9828e668c3f4ab3191486393c957c5989fcaa652af0b93c483441568824fa414d5283a5f903917e8c2ceec62b57218746dac16b701a0e6325c10498af6d6f23a3330975c87a1c0a319ef09a8be607b232a8bf72d1a585d5fedb7bb246ac52bfd603ae26cd5ebe80e82c8802f0673891a0ecb717baf00195e6d197158afa96c3b63a71c11b5f8fd6e5b0f4733b11b0f31046bd78e1e54c961a8ee11bbc97110bca2617416f0aeebfefbbfffafc789937f6a4cfb94a6f978401b0e5d5fd5fa3aa7f13cce7db7e0fd3ce2fde575ecbb4906195ba3bece29dd4eb847913f2b27f4784ecbdf39a1bf73427fe784fece09fd9d13fa3b27f4774ee8ef9cd0df39a1bf73427fe784fece09fd9d13fa3b27f49a133299734ea817065a315dd0f45ac947cec271169244ba9e64bba6c65564127a490e78c360b3356eed7ade76edae83c99ad4a23973c0b5a5e4727c92c8a6b6ec8fc9c16684f64766b175827e2be81e0ea33d57efdc845426648a2a871162f52a631b67a395b55ba1ad49a016ac429109c7f4b8aa07f88b9fce74479a1c077b0bd3ec4977c90571bfc5328aa9ce979e4cc8a2a019245b07567ee82d7c515d4ded5ce1117aa3ec987aecd23431e958d562b1a2655b3c8afb2c15560b604d3a247d98acc85e369fb0bd301fd62253cf9491016c7320a0ed64b49d39f4c80f06e8864cc57d804e6a06e352ff38e13ab1be9a0d7410948f06c5663723cb831a212362309ceda8e12ede2894dd9f4836c5b0c361510d67830a61d0a83debc8669c1dbc0d8a394b8e46b5727d885aaae5cd0ec0e32356a5300e9638352ca90e1a1a0b2a328c9ab6f9024074f6dd4d6bd6b710ab5ca65abb3b3b586d3fec1c0a8b196b5817e35a1699a7cb15f0fadd845a8bfabed8fb71e10c06eb9599f3a5c338e5a8334496a6b2e696011673893a5fcf0c52c87a47c116956cc2335279d8adb4a52af36b79e2b6e659a4e151b2607bf571af1c47eb05eec45a8cb349c9251c3e74661abd951352605d551a0e077a5df0bddc9f2a5d23d1899cc0895538eb07eb5ecfab157adccc4fc1e99099076a294724f957e4730ccbfafdc99c66b5c2ef49e584c9fb3d7b1ee66c5cdfb9e46c142464a754e8714014f1990862cf761bca252e6ed83a51696f62a045ba33a2ed1a95427db928c097e93cc02687e19ee8d96357a609fcea438edb2482310b46a2e405c1887eafc22b18b4e35edb4b29335a7816bb08b8b1955aacebae97a967b3f57ebd944b6389459b0af75ab2cc9350f6c9266f84376d0314c26a8a5397a197da9984a1fcc453554b71ab45d2e1485957b4dcafc6e99c9ff7fca492d4e1feb0447d9364fac1702c8a4440d2540efc0882c2f5aac48360c73935271f3c4226983d2eab143717b105b5ecaf24ba2718aee4f509b7b2fb481ec91ad1b57acab1a313781a33b84a5988e77b5e0725027a146c717e111ecc15e70e489963f0be1ac6fc70004cf046157c21d99579bc11ad8822d16225033de61dfd757158ce6bce39f4097ab8e40b6ccdef53dedfd792c14693f11c59c453575d3b88a5afd4010e4237a28b8c94783c653197daadd80965903d6c40758e7a7bd18ea3a9384457fe5899ac054f9875123dc2290b22fe437cf6bd069f7a3acda4b413b29202f099525a0282f10a53b4b5e78dcb60c794432acfe8c32e5ece3d768f47de222c6c629f6cd33945111acd3195c8100a1e1181ea4e3382d11397c4d58aa0e8759bd45577c0aa34e2aae45626c4058ba0dd7a49784188c7096d7932ed1ca49dc899c2d653f22d6dc5f69168e1bd60e8ce2bde634a7fd9b39260e5878966a700ffd8ce10d2b4df1a270363b9c47a553848367bda4602a54cd29064edb4526b74cbef77633a628b7ee5f1299b3a3c398ea68934168c71ddef2c7d5519a1742fdc30c9ae45f465aa28edc2348859bcecb7a6838a1aa79c2f8c403c2b60acbbc07adde2b87559d3f500f63ec4e900e2540d6a8853ecc88ca5a56279aabf481693719e2a9a981c342338d036309f33129f2f4778a74723dabec40551c27561ade9a44f88256104aa2cb04316658eda12e8165c2b70993109215cc8c9c495155bf7e490e4783b97817a2510928835715a8ba41d27a43327e92591f3c02ece455c0aadba83116c3e24b02a24f5d12ce94ff9a08a40f0b40b7671a966c661e7c0987d626c137f898df9dd809974d80c8d44d1143491f37997b3a3c3a0066e663e8f72b1578f7d618f0922b9da39078de469100ecf2434c3a71c1ee50ed12d67092eb45a6cabea0d6d4b9f092db1ef4df854767bc39e1daf384b6654b553f6352fc8698906fe01e704342937f9e3fca44f1adce2c4d4940f7494b2c264775c9abab2d0e4585fbb1d83503d94d5163427a3863ca5416d26d58b8b7419e8f2b6c373bece252ec53087318768b55c31a52baa53869bf14ee12c703ad127c4c69cd08c17cafe8e4d3b0babd343702d0835a96b9338d6213bf4125868d23e92041105f5825b8c89a5d51d8fc3112f4f395eb5d49847e694407a64a5f1db6429ce0c764709461c1bb998f497b188f55105031eaaae54658654a9bbd3e9812468518b919419e76d09be16f4c25e961c214abda322720bce731cd34db615c9743a03bf178793788d1d0b6592c7d3a0652c5a09bf1e2c06d1a03fb302b557648269b9886e22c5dc140268d83ec6670fe0334885dd767754cd543116c14a5fca74ed475587504920d62195789953f4cd542003acf62d4c94f8b98173811d08ac1c2c0fc02fd87b42ae0c7025f28b005f536b85db68b2226f9744c52b47d2f347a41212e6baa3493d17692f2402c143736fe2ebb172d067162d33ebc5d0342b051b2f6b9a47d075a4889398efd4e43a45d6986fa572e901831b91a800902118b92653014648785589530f550a6587957239d30596e365a0bbf08a75fa1cc2afc4941c928360b5a4084e62c45aed5182882f174b9c5de7b825ed9658692875a00afc54170cad5bcca684dea34a019de07397f782192f0235249016b33dccc6742cd40c497934b4731881070244e9e464f95c885b1c9f1f69d1e381d648fb391a7301d0a63cba0c009ba6c14259ee7672e64d54ba1c893a2f08a34347cf766b61b4f4c930da279ac10c5d4e56259be9d0594f9498b8a72a2a852bcb2cc1397aee76fc45558eb76ba213accd4e546565b512c8911be5fc2af4d9da6cad7c8ddc1c4607cbebe453d51283549c13a9b1228eb9e3252616624336c20ef3043774cf986abb6d40b9e4521ae3da84aca613631e1df3cab0e89debca953b2ee57ccc253a399645517665b6dc2c68b39ece18dc14297cade143cc5e020e705445262d53b491a33debc0e46e3509f9622601147546a00bd6ec484c976ad4d9643ce1f7b03c51f02510fa2093b943a07af2a85a7863b22265f207f8cd6ef1bb6374065d70c4d2d372de9827c14e231362d7a2071dd01efbb0d3e6c9041f2c6a06e1a903277b6d71b19889458726f5d031b73a3f8a382131e6614754b8104b7aa426aca65574c8482e26859db92cf6060836d5b577c0d58344f148c9f98a486d3984b1ba48dbe7500dc75855c5346a8b867d29d9b95317b03b506a84bb661c84a176823b8e0ffa68ba1a8e33773db6c6a93996b5c90a57d19d90d292e20e6c5c9c006e9d13865f6b6b0674feb8c4f118dc63268b7a02987822909521ccb5894b579b09def3f8621aa884b4e3e6f36e4dbbce24258a23dddefae504e9292ca8be5a7aaaa7002fad1e133ff0050627df4add01df2a3df08207ec56a8e2d06e91cba0cf0b21bec38dbd371d698136ce7721dd07acd231158b94873ecd3947663107d11ef002f45597435547f7c91d1b60d69c5679db98e221191e733edf553e5ff9bb98c93668ac8e8288335d3adfca076be273e1d8f6807bb735b8edd11bd949a46e75a5e5a779b8e49409ee8ad45441a9e94e48dc39314a498d270c9722564a7f45203411705c6e2839cb8a225e2714c0fd782ef0beb6a6590a3f8ec9118d93a6c6069ccb1cdd4a47e45c25ccd5d897f7d3ca05ce52e530399253c7a2a7f609a157af81604c8f3152c68c4d1ca784bfe5a20ee5462eb666e42a27c56dda49f8e1e4c0fd481f54ff2df855b3fa2c0b79d39f4dc79dbeaf0b5238ee0bd161c94c5d77ecd1f41eea531c91462c91d364df88bc7861d295b1a770e3c8561c658c3b7e6aac278436275957a6f0a1648d8f0893ee0035aa7cb2c337905f39bcc72c054b9cb0d69aa5ddccf0ddcd1c997273c27431b99acd7bf52453a6faa48f97323ed3d4c1a69ea4c9d2b7d6085fd493b1e08186f0c47cecce040b3a05ffdd7501c42dd09d144f2afe2ae99029bba2f8a9b65db7d67e3aa2bc79c2e33d85985440beab05e528ee86c08ddd2ed13b2b421ce7553e2eea8281f8dd19092bb938572be986c15d6726abbb74e3b2c44ea33a15b1b28151ece06bbd33e2f9e9da1d77840aef69c45eae561a51cf760b6a34e9e69b1425a400adf77b66c65b2d9121a5fe1808bbe04a20e4428482fe912ee8137fb62e58739468e0cc5917d014ce89f59ad96553cd90963dba37ddac4d7265f8c48276b5898d48bc51d7c53ac8b71e2a4d029d535d0a58e371e105a9d68b96fd4da8f8eb489f865e8f5f06d48e9b541a4bc4747fbea637a46bef3344eab8e31e5e0cdcb1afa48c3191b26c371c03dcf2f800c197b5cc8d3bad7dbe0626eca8cb3372b420a5805a6a1e1b943436ab79a9f235a1a73993e334a47a4bb8970220ce28ae673e66b5b66b6de7e09e7708a64cc52ffd1ff95a331cf85a61aaede2ddd1307d3501bed64213198351ab309d92a6b80ee9ac41a9184b1329190ab99e8b3a57f03447718c1a4c583991e792c7e58ced29558592f244609062cd0a6bd56d1ddc5ce74a69c707b9e06e1c9703319094a02607e2d64587e8727bc927d6926c50eabc703caf46001fce803fccdb486b13f55c6ce19a6cb29b9af136daee28d58a3d974e8cc8ccf57235ed184bf93014f06a8a97f3f59aadfc4185792d2143547e2832be974a9bbad5a3b3dd805813e531b7fc71674be2c7447542245bf899b4515621418493558b98212b7e82cfd8e33cc04b7cbadb20cb39868f0753d322238c18ce5da55215811bcb8501e4c5ed403f765a5d2719fe9a3937572994cfaeeffc45136fde8e75eac3257b779b99c1cdc85e9a8d289a2da4e046402f797a3ae3eef555e4f608b8776bbdfab77b2dfe6a0e88c1710de8e3035001042e7324b4b77805f33be698a8029e54399ff3dd043821f9849211891ab66788422bf48251b48e345ff0aa162ec0475f2ec28eb55ac2d96c58b98989ca1c2b8835f67a36a7d21eb764bcb50dae221ed82135488d6598969ba80ffe00b5b8cb0cb4c8ec6e01429e72120100bb7e99958372d06aef87a049508de633aa1acee91ae6a972675c0fb7dc418cf9839909877c303d16a081975cd6effd5cec0dc50199ee1972970fd72b25d449a26bac94846399dd7ae5e51b9409261108e9a22128379ccc8385a62112a1d1da61b2c5295c7ed3ad0d6e719c0d355237294f9c721ec745e68127547ab7500e7d9ad03c8ec5297a7d98afcdb1a793ee5c8791b343706e2eeba49a0ec97a28716b81dcd0e18a673871a5891441dbabee3015697746118a231c0a87453d7e5c272b5689348eaf5ca146f5882f2d3f55236755cf9d24a4455647b4fee820ae5a8ab80bc9c9068fcc98a0f4ad608a711f35c663826340347b58077ece6f1cd453e402b8f486b5a9b59078c39179b1c91a4ec8b8a74002cb1a43ac019101c9959e3df601c91bde11019140cca902fe219162a20ef793e31a95b6497fba85bcc41032c0824a8322a1a22d186bb540954067f5488f3ac56639da6fbad2d1ec622d271eb59dde9987d60771cbb3a020603f7015f1a815eb7d3bde4d0164c05e938ff8e9001af0339efabdfc64c8155f5453ae3641b77d811273865327ca8a5fdb73624f709cecf2ee745cf3de285be3b61049d446af48e052edfc3127628aeb138c37179607520bac3149d7abb8da4b9aeb8c4154281e5a8c8e041dc15f2e022066e29c5df3babdf679d693fde17115976385d2f6825fc4bb4339933071e7517628770b2a1f13d4ee682fedc122ce262d4b1af44b21f197797c280bb3ea3a3be15005d7b40d6e692b03d1f770a01080c8ab500f243bc187b40468dd4205006969020a417a56c319858c80b7d79a05409dd0124020d41521af2e009999505f4235b084045b84faaa1e3a9c40ba89c17a106c0268cab5665b0cd215a8131dd215d214d053b0e31490241ffc5ebaae98dafc80b6d21c7420d651e7473436f48aafaba9a000dabafe86523491931575cc71bd54a5fdb55a0df94a9014340fc3714505a2a1071362aaa92c951caa4249fb20e4e0f9a12993a477049aaf9a323d1ac7e5a54a22a9d8e9c92e2376f520e8f0bab5d2533714297213f26e2ae96a201fd0a976c453a12f51d2baeeac922a9d681cea6e0972374952f95076e40c25a6ba89edb248db0d555d18f2f6d19831d38d3355d52e2ee8f13cd5b8ce8191aee89cbca333fcfa23fd9f67c211ea7f40dbed231b009109e5f7620b6a73c55e6c0120c1ea620ba694db7b6f0f20bd7fd51efc0ef9cddbb3e3e8426767d519fd88d6862ef31de0ed1c2428c3c7ed26b73959555793b5ba653a6c82ca3ddd9d6a87c24bfbd3b938a9a925b76307ab6a1d0a34cdb307c633727da872bb718d2f2dc0b222e5d964b51619c45b884c6fc12efaac41bb08cf9b4188d3548c0755c487096e880c85a9b1b1c6e6224ae4f2715df0636bbe508342de1ad42e4e534113b302115aee76b79a46bb9dc1524cb2586a02ba17e5ad4a196497100cbabfe8bbc8e14657273fd0d5c044138ff435a03544f3f122d7577a9a81b486f4857a1a88e812e8e815d4cb508e2fbab99cf83da89f4939e02ffa19a8737d6744e9c18caf75f5003a167f92aefe353a1b0d9d497501e99c6dd7a2b3561dbd33493440676dc9b0628dee56121ef323d1aa77c7f51649e66c3030a69e951d044e518e63ab96d84a63b49d38f72c1aaf1446f316f642d4980e4ae99a0b645919ebb2c845f8b00e75dd8a7417044e5e4b3bb21355ee0155c0d092da0bcd0e02c923003ae37e578f8440e4209d9de34e9b4676b252d3631d8fa9955a27c7f912d755cc9dfa3b5bda017d60869c2c5f623a82b9f13ba0cfe0265090a1a04227092a58a0b72b481c20c732105c0de8ee35b4aed8741e003a27407f57407f2340c67b5078c0ab0aa420146cc83040774325be80c4dc6fd0d1d0191f403502d0df06946e50c50e0a3d54d8903980d2ee3b31d6028f59f04880561fdcb2e1e86206a80c19ad045ff659bf55e71b16e8f729e00503f0820d78c1c7a0460005002f9480170eedfda00d78816abc51606d002fcca17201fcb019436b02b80ef043060d0554568d76025e29e00947075c079862f83363feff97cf78b72618379952d3638bf63985f67adc7ed2e376421251d2712a6e132e10f829251e6d697b00c104b75c2aebde80e70592db96a4745c52d2bc4f4b88c4705e6eed30ed381dd8738ec89dc9da5f64a918d5fa0c4f39b9bd4dfd80a8f61a33df2bdbfe7c41d4b87e4c5c3ba66c24a8659626b633e9d0aa83833c277010bf06f8719f4c42d7a369b7c69558dd4ad3d98ac3139ce9b11b3a0874dc9d8846ba53741a27890ed799294b3d113a3c811f3d62861112e9caaff1f7d43dc7df40c7014160a0c782bbc09e0166819e088c46a036821a0e0a06d426d03b991d876d282090c1a1f6d0a0ab023f8079578073a077b3012a095a43a02811a8e12058b737a5a0d70a05c283ea136838e8e502e3b5841a0c8637c08aed0a68c70676170a5d090141ae07dcbc8763e920b6a9a0b9855209240ff0320d85a0865275ad86a17e832af82cb4809f17809f57508b02866e3f223e911678bcc27b9688722a3b2905e2207942b13033b7dfd1d359570bfaccb25f97d1ae3ba592bea99a2b49b6246a21d66bf7109b189a239372320b506911d49ab1406a57f3866b4406317c9f678972363ef4c5e502d900c27bbee65a2bb5a8b55a16a9da1784835482a852a1048994562999d09c4a06a2442162ec6e130a9f274b228b781eed1138c209442f4879c424f6c76441e2d856d33886d0c4f9382d48ca0db76f7a0e1fddea390d3a13c09ec9d019b990081a07481e406d0e1a094099006219c41f08443dd47b50df411d071d534849c0010a743a41eca140fd06628f0e502d0cb482802275dbe9b6a08e83d60c52135208701409590650dfb7e02a03a0dca08e8354febd7aecbd0e831cf22b7a8c8d72d236295febae417c590e93198fd259c7025143e64579db56b7c96293b12323b37ad36dda15ea6841a088b43c2efc8d65cf33e32897bdaab5d13bf69c51d2d57c49a8e37aab50d6749e44227fe40edb1e36157a06bf0c91bdb91083b1370c7d7f186f42f1c081988fd3b89e1d00c7987055b96e652b406b5c71c7f811d950de728de3c9081f20237a406c499921f734675043c622737944e216c5fac25af6d6ca1aa15f657a26dfca343434304b01c515ca303436508e21311ad30fe7ab006ac108107a0ac08e8d801d6b4155009108e51c7a230da1a1a002d7058a2f241ef46820d3404f171aab46a6a1c102d4b8183c68b8802d73e063f815d8ac7d7e713f3e92f347320e980acaf97b19ff997c13e9168f63bc174b40a6c9c95ea055cf13462b73eff93d3d9b8d83bc91e9fd72d7f5814c5bfd4a0f65aba01679671d7557d180cd915929ce22d45b9d64ba7396e92e94e92de91ec55e6bbae50c7e067889715bf4b2b75ee1154eade605ba3a221ad0a9c24ce5e60a29da9b4ea5c740ae090f11882312b13ebb225c38f7ac1a8deb1d4fc93a596b885931884c6b9c94d15c60a4e6881546d6953c0fdfc93350ae1c74f820d558389e037437f424a12c03eab810e31055d73e0a10fd05c41c246fa3c60189a11687f20cb10d39039205a2fee2f08238640a9d5e18905ee41a261e206b400a420e812afc2339fe912ff25e86a199792fc7d0b43cf24960be08ca338d001af4ca5e32e197f484d10f073ad3a3607491e72190e73590e7a3a0781da2a3498bb9e04f449b4a813c4f813c2ff4c5fa24cf02a1b2f55625208a71a029b0a9880714de43e5600d683dae795659425aaf41bc3259cd4340eb6a49e2a63223b9951961a410562e4d8b1aa50c2d765b216e2f90f2c908f3e59e24e70eb1eb884a4e55f63810519fcfb7dc52fa414ee17d9c092d2ad0a4d7b109a4b67f118e0beaae629126e67c1f83c0d812bef83e3f04d9c05e85d875dcf17bf28d8f7208d08c5cc71dd05b80b10764b59fe614d64d4e813df230a730f05dcd5fcbc9622c70d31c358ea39a9b7a8b32df84bbe2e8f6a7111a2f3c3a5e912acbd7aea2e76547d949d926a62b89f22cbe53f4e56e25afe684a82afa5655681ac810bd05749ec8a882bba4368f23491d2f0083aadcb297608cc74de905d2b30e96c9c84399eeae5df360692ba2d591bda16ed3c30387ee24a6474c35722ab15ee84ee7d36a5da3dda91992227a70a6f309a35deb6bf7637d0de28ff8465f5fd076d1d9f3007bafb72f4273a3b781b47ea4b3a1be86d48420a111877a1beaec1b7d0dc9f857e96bd8992b9d4da4211e77cffa5a98446200f43545accdbdcbad3965da3392ce585e732869e51d0539e0f431de6cb54d15a724b9147b014164d3d1282fe6599f77d72c43f2d644752b27945906e86ee073d9ba16e854658a26ba98ceb7e28ac26d274893648b712d108f465c0fc97c5a8ec675ee021d3e803a18089c976e17dd15cd155abc1bc8713e58cead3cdde8faccef04ba39f2e4ad8fae16e379674c86b3ad55ac341a9f567fcd18cc79a4e32f1c7f817bf53f38c0fb727c77127e098dd8fd9f1bd3fc5f4fa1fffc7abdf36fae1de3e6d20d839beb207831326373732f3ac6f0fadbfbed469b1d22533bcb7d23bedb8bf47cfffb0588196c3e0602abf44db801b36fde41ba7ef80a6ef383266decd83542ff0ed0f9fef9745940c997e6c0b817cf8f8b9b3dbddf36477cdb9cf2bc9f21f676f4c469adf9dd51142fbfb223e183512ce0404cf0c979263302645207faa403f30f4e8c410d0f8dc50ce813682d2ca07ac640a11b4096a5fd06851afea2981b8b75fa4c5eff40a526671aa7f03b59ee61582c49843be67189007ac2d5f345b5e35894a3e5f5ba5a1dd070d716dcaeb4dbd9ea82dc91248e0ffe0aa96988b02bed1c8ac2ef979d5f9c67febae779bf8719e70d43aff6c786676e64cdce95ef8ec87adbb9f3f3e5ccdc775c733e50f49fa1365e24696b706cb1e4b24a975827518be330dbf40ffa31331ca6bb89154c3ac6439930136ad44980618aaeed329cb7def1248d24e8f54af19674479e51a39ec9325b035d201ccb873a1a963375b22f07439f63c360a6f22b4943aaf98aa0f4a597aae3f4a02fa4fe3c54b676546ca74bd99f1d7bee6cecf66db6536d4080bc5689de665997e631ed81f73d9d1df9fa3c85d7850eea9d1c3817786dbdcd8a408c23e2cb4b65bf8e3417b687a3a5bd09be4b6aaf9a2cc54adae2aeb4a54b712e22d06e4e48fc2052743539e287c9913e4ce634887fc4c3748b57d0cb3afffa331f1f9a91124d439e56fcd7f61c74763de222386887f7278751d7ea9aa57514cb4d978f013c9817dc8b14b707a6af80ef4f561206d0ead964a7340fe21bdc40094d543a18b00fcb51c98df940dfa6c04e8f3a168500a7ec0d07a09fd27c8ef80608d64d2ad94f50ec3889986083f2e1240222a98e60d4b117619fd14ed1e087ede49b58ec9b5d45d597376d06edc04e3855b1ed0645f636cb007c001c91a3e3621c56ba3a52f595b4b756fc565f009afaa2cf8dbd62c362c769ec1526f58b6d39b5a39a6b487fdee553c81beb654d6f50a903e85c5a744803fa82fee1a50e7805d0e030a570e042988848016c51eb1e70273029901159938fca96033454484993ab063f0d5ed21fc0e309096118792e57f23664e5235d2bf41a53a89090e70a31a5e48308dc683160a82b78fc269690f512dbeada1b3c63790d4f627f0d1ede3f8f8befcd5001aab31a71c109571c43249b2eb88f7a7b932428eda8b9f32590a325d6ece5c16da14c005cd31da9e1952844f5a5c29ad1a8e0c612a2458b681a8525a0afb789a450d5e41107694362200c93fb4a2076952d5d4b47b8169d0372e002bc061d25581032a213535aae812b868981e6bfc10372d45d143a68c315bc00c2033cdd0372f31e1eaa500aa150122b6ee5ae44731d85c2fd099467720465a5afb08be31ad0de1c2be906edb538aadabfcad5b629d76b788aed84164bc3e76d7b4c786bb4082d920837116c07077504d16e0f46edd9bedf72b6ddd17e850cdb937a386d9703fb98f5cb38c15a9b109bcefc9e4d39dda26ba2a34c472567d9b180f41463f9381c4847712f1ccc2d70ef5674359c10d5a4d5da6f0e83328b7ac5c000c2333de41b729fedd07cd7dfa53bc18e520344903bd68db1be15f3a511e9fe2a4c975a80094ac081f87f7d98f849c4793d038609a4bb26da4edc19dadd14b3c7166aad94a31933d506c5800c153b63e9c57ab408d628efad9991bd5ad49b6518ae171d7db16024555b1033402a5145525ea52d56d1144a0e181ce06034a3f2fe740ecce55643c423578be4b09ca85526f841c21fd621e03e9f537167ec21265b273a4b984b4691e7b447cb54d593283c1748d91d132e70502b0e1a6f985738ebf7eaf2071a735ae892b56a84f9746aebb522af3b0742087c8fe15083a277bea8b804cfb222359452635f27e3a3b18b8350def995fb97f9be3756fca531893fb4e5ef2d69b38ffbeda6dd0fce11e93bddab0333801ff6343ceda1fd347c3bfceb6a9b6ecc32474eefd659831bd77f2efc347fdb3f1a0282bf9ddbf3133be8f524a7d713172f87707610f8793d3af44b735457689f81bfdcce7aba6beb479dbb3efbf2071daa5fae36e27f7ff8eda509469625d58333233f3ee5eb819742c9b8848b8013674e7734da1cdba37d398adad391b43ab487b36894efd351ea58adf56439ea7557a3c93c6eb58ec8a8bb9247cb581c4d27d5286d9ba3f55c032a633d6acfd1114a09233eb35b86b36d65fb5d5b3aee47d936186db27064ce8ab63ed9b4d8cd64244ef2b63edeb48489d7f2ef7c5a09c711f06721f40856d489c074d1e5b21312b450070b9c99039320e355a0ae3d2e7489ae27cf79794c6f88c4a27da38e38fe30f638b6aa161c4b27b8bb63753caf389ce3f06eb46a91f3e5b472c6b835b20aff1c35be9dbff4047cb6e648a63ff538a82bba7d2c3e0f1a01bde3f36985f0183cefb4373efc7ee185dc7ebae18a4ba40279fcea78b8472e36f2db537306e2f7ff33b22ddf78ca4d78cecfb7a727af88c2e74d621dbe5d2a04c51e1c247fb3977c6ec439684d0638ede6dc9fef0da007271574e1cf9fb39757b39693204fdcd377d262d1242a570ab31c2bf30daa2316ca1c7499204e7e18c16f964c0c7dadf552c14c330c670d04e5b2ae9ba9e6a725a4154f75a85665b332d5c3672662f4177653cb9fbe36776f9b45925d18061e01f902fbfdc315bacda98a9f4c806e7846e6cde6fcc8db9115cde94b7f2a9ee10c6252b63a33fb8fe1d9bbc3b3bba506cc915697ce766db915105bbe17ce73a3fecbf6b6bbc5f74925fffee5d00fb4c525463dfd79397c744af2b545b0fc0c34a7897b8bec7428d02b075c84f0e169e577072eff93c4cd4fc4c53345d3d03f445c2abd6c98b9d86ac11480e5aa8402be64786479ab27f263564d082e0a187a3eeb0f486b125a9a3510c8be3374f6dd569a5bc363bc2934acee62bd317086b7d37ad0df0fc446ee6e0ef2fbab04cf31ac3fb0cfe149f5fe841deae6cc0c98e83b11f7ea0cf897f7e7053542fc98fa7fcbf09f27c3bf4837a86acfa4fbe8bceeb3c545aecf57bf7aedc9c3bedd5bd1d3d1b820ec290eb3242b42bb787708e1a7b4c9c426b111feace2cf03ac39b0fbf50558e50db4eb67657895643d6547df37ef8a119f6e5a72cad0c6f6cbc545f8dc41b19b030aef8adf9e0733b8e2f6a60fcd0931d7875735251e1cf1f6f40982804714fb6e93e67b8095b76643d86873d4cca70649d7ef9d1a7b3ab3f8aa29a7e20d594e1c36077001269fdfee88765c823bcd01c2efc8f5eebd6f5747369e717582ffaed89f27dce549b889686bcba33f24dcf4c511c2c279410b2e8d8be2bedddeb6a7085787e31189f72574a92938de9e8e438cb59778a56963c214168311c614737b56a7d1a25b8ccafd50efb6cd682f0e87fbe36693e18bb6255bab966de4dd7f852355189b97e6f8a53f5b2fdc2d9e398b0a3cadf51de70039bb128bfb87d75ef6cf04f2a22f6e2034275b5f09dec3028fa4f5e1f95e3f71faff7a579e084e1c4c71f31ce9fe312fa43e73f020f48b1c6e372b56193518b464242bd864311a662d91664ccf7383ac27c5fa61d3dd04ed89d83e88e4d61ff7aaa4c8dbad96b756bafe6ac22f961aa176f062eaa34ef5af316790734fa7e7fda5fec8430d7bcf40ff717d46e1e900b7778542ff736e87e0dab6fe3c654604cd8a259cd82f5047fa639ecae2c20a5675de184826a9f9dcb1a8de72ca63738ee8fa9b11fd2ff2522059cd32cbec2674fe095def2811fa4fc6e353f95e257b747558e1d5d96befcf2ffc731dcabf6dce9f6a734e2ec9af8f7b7e38bad91c01fa888bfee3e95d5ef6ae10746d3e62b60b33416fa9f3196ddca587efc36aae1ca05f55204fc6f38f1e363959a867ce58e8369fbbd1dfc61fbb8713dbd543f8cdfdf7a00d0c1b62c39bde41dfefdb4dc47e7d2cf79f2153c4faa4a5f026e60dc5ee50fb4332858fe439a33070525194ee8caed5b5e034b3613b1e8cc8e3d86c54eb02d1026c0e2705b52b6a50b818dcf81e17839096174a0f8d78b792933511ecd6be4eebb8e7eb1aa350f592f54d7a86f76242f1a41037d77212a40b38d64bf5831242c00facc8c88b3d165ae6bf24766f32a02f5652c52fbe99c4bf5ffaa0cbf3d4874772ff48f26e64edfb13cc6f7e0671dbc71c021e9e18e83510bc0b24befdc91cf4b756fe13b4f2fd34ad1fd3f0674ed87500fc7209143e82f71fef209eb07051691fb6a2f758615fb1d7fbf3a17fe02b9cd47b77f01a99df1ceafcf5ea7ce63b050983e30f8cc7293982f6de06349a80f8a1fafe5b18fe5b0bc31dc17fe6d33c7aebde157957065e4650a5deef4c7133b5cf0c6d2383d5797723a74f1fa9e937e037a3c93d289d1fbef31f8fdf32ca2281e776fffcb5e7fa3c39323ebc00c9086e2bef9e8f9e7e7bf53419edadd61fa2ab7c9426fc68e4e0faa0f06640da0ff7af47634305701e9046ee3213575330df74d30fcfad07405ef309ef75e13dc5ee7a758f3400e0d4ba77f9ba0f5e00d796ed1865585cbd8abc471f88731fb4f75df3bede64531ed4fe71a0f676eafde3fce61f76ed2ff5fe549e3e72b4ef1ffe1e471ba67b732080a67797747e7b749da67abb797f2ef8d7bbc3c3df8a3f39c0fc3cbf5d5e9f36fec659a79c72ef9468fd94fb511adaeaa9ba7787c89f72f5bdb7b1960e7ced164ebf318b77ea07b2d1e525c0c34f77e2f4a951e6f8edf48fbf7a104f3e5bba757b3d71ff90a523f58ba5b3fc1d0dd367b2cb5123acddcd5b26e3f6484a3ee26ab00a7b5bdfda67e4ece8e083b4c46b0c5d76d2f85f61c14ec4ff83a9b19f0fdbd6776cf3141a1b3bfcf67435bb01cec938f1c7399b7a3d8a7bf7fe894f3f1ef67dfcc2172731cbfc5b52165087bc3980f7253f03a6366d2f09e11a82b3c08e9acf47a0bf00876e13f8c54b73f9f27bdfff74a201d7f4eba391a993049fa56cf438a5fcce0545dfb9a0b777ce335c4e37afd172ed8f7e7d4fa63ba12b3223066a17e6e17e46874d096a8ccfbd259a8b07ddbd8cf9fdf63a0a7842c07d377fd2a7f799ba376504b3ef577d7c671a7ed4c553a8f1b35e3df991fbedba86474af5a5fbb672e23c1af173c0ffd180be807b0d7c5223b63f1ad4ecf4af97683477a0bd3c63197c3d71cbf76b508d356c76200bbfbdc36de7f363117df06a138fdf873b6791e8359f2b338ebe0f99de8f9e9e4632cfd43a7b2037847c3feaf961c3e0d7663ed5dd38eddb10eacd0c8253e3fe0cd3c29d863dce93ac524f89833f665ac2b369e9770e22cd43d3528ba4d45e3959fbc0e506ee4cf99a44b5f96ca9f61dccc5094f9bdb16711c38ec4c4d626ed6fe57989713c2ffc918e987b6e7a7447e343eff4f39ddbf52e3472385f75aec556761d7fae975daace75b961dff7ed63eb501b8b0376ef02fbff6de63453608323c2b1c27498ad7e57557331bae3dbd2bb91efc3de7e6bf70de5cfd40579f08f84fcac58311f51bd86f53557e60bcb147c6bbd1f23781d20df79f99ff5cd1f96f93a9ceaf67a29c33caa0cf4f0f8a373e5afe6e3ec11dccd849ee05b9f78306dcce20b88fbe6ee25df431a053d31e43ca2e81f21d20181b86899b7ce005bc9cdc801b2ff27a5e5cf3f8fb19c6fbc0f7a3f2bf5b67dfaee47d1cfe828e64a09589f9ede96dfad775e2f52a3df5bac2f76ac3d45756bbbef9e7a91f8f3cedfd79c8f100690cf1eb51c74433e553c509f6b0cc5ba7677a252f9b519b46cd7032a1d2abe234a814f1130591f1f69ee4da64e30444aaa6100b7cbb5aa384bb9e6dbb712b68e3d564e4624c558743162e0f4fb356e2462e37974bd595f18eece393b69b0c9b49ffe40251161eb23e6f6b3a592a9ec56ab8b8c5aba98a545312fc2ee47a3a4f2a699e20a29a5722955422b99ea245d3bfd0a2176b8bedec75368c6cb513403838c581724121522ef80d35711ef4454aeb4b149d89140ebe13d8be7f0cffd8e8da5faf5e2147d9c07f0772f517cf62fa7ee15e28bf4f7702fc501566af898fd73c3efa414eeba1267eacb4ff66f9bf59fe4f61f99f4ea2f8fe74c5f45f1c3f03ec687a7e68ddba888d7d3997339edfbe7e314c9804fc20cb7b972bbc4debde66817f6de8eb2e561c3569d1d7f6348304d70d3ca58e3e5c147f2df35749df3f712aea9d04fefe7091b864228b2a0f781cce2bd852ddf1205a39ebc425655fb6cbb83fd4d1e52c4054794c19edb45efd4b42c42b4efd6766e8fdc807fe85bcfba7ab765c7b5e574ec8c3340e5c2176e592dca7aecde6f368bee708fefc7f61e9d6b65519ac4c0df1d9fee0247af8af668b9fafe0baa6de53b36636b78bcff0667e0a7e6ef27177317de7a2017e04e2f5e60dacb721be7ba2dfc20c6dd78e5f23ea7ef3f9855a4faf7d8e0c3f9e9c20bc5b897005a0b0bebd4b027f3067f1fd6b9fe162453820f452f8e9b737e5589f8e2978c518ccac3ea16f01daa35e34c3abd54bd387975316337f3bdfe07ddd8f4adf8c45bd36fb343fee539903b59b8007cf6f5f19d0f26f1f8ade6bdd4d5ef84cf2cfef9659bc01bb1ad5444f798dcb726298773f7deb21e741c3d76583b741628362188092e7c777038ec69d413925a36fccdbd5e2d986d81fe5655e8de845b518c60081b74fb6ece726ccf89c17e5e6f2fa6080a2dd2eb819dbd5f3f5f293e6cea5d4c6802bbc4fa52eedba2ffdd14cc0f73972d0cec2378df03c3a1cf99615dadfbdecdbd5c0e00584613c50a7cddd13c057b96ed815793afdf9fee4759e3df4d9eb3e7bbd670f7bf6fadf1e0f285eb908b7b9eb0ff373d7698d47598dcf9d01cc829d74c52595feb6701db6fdc458cde407af73c52f9de1f03770e7e9b36df9c5459bbd3dc6bae0297a5d1e43e09d8fcaf707e0e915066edb74d7f14d125aa0fc35fc2e0a217c047fd0ffed01e6be7bbd6b109d3e00d1fb08c4f00310d83508b828ccc31e8078f752ff1a307ca7ff51b51d147b58ef6df1ab0c537a4970c19c1064330cfef97aaf09d2db619bddb7eb15df733fb2f3e77f347f9e24bb7a5292c888fff17cbd08bcc9d0f9c068fae6f727a02a9fcdc4b29f8be239d858cfb911a5e7f1d433c8288993266e7cfe079994996f6710f03fbec3b71ead216f1c91ef00eeb59abede5fc132720ff8b49f50a7ef189b1f0fc35ffc9a77e96f808626e1f80e3777216dbe2b8dec35bd08776e0398459e3a9f6fd3e77741ef1ff19a9ae9c01289af9bacf04c50b93fe65c1797a511d2764343e79aab0647a56c575852121a41db634a4465d6c787c1744368939231f98dba9286f3c150ddc5a91016a7f5c2efe6f63eece43f97682ec3d02e7e3eaff77bf28856ef89d2bd1e687d4494c668bdad597c558630f3597c7baf67be3e2a165eafedbd32e0afa59ad110ebc3d69e2783ddbfd74c372a8c4d68bf572b778ede95a63e4bc09bdf0879b311fbb7c423bc7e9fa33d298257072fb6736813dfb6287c42cedae30dccf94ef3e2d9777c75c36e17798eb0dfbe3b572ed04d82fe3bb4fa40a48c6f57a1cc2b20888553ccfaed9d0506f806de16086b9f3f37ff0127ad32b218bcf5002d8f4df259135cedf2f2aed110fc1330c99f4f7fdfe500be3ef6d96fa9756fad1aa0f0bfc22f42fb04fbedb279faf9f6e9ebe5b7abf969a72cf5095a199e0ade0c99fc34057793fe7f373be36ea2deb99eabaa606dd70c02fdeeef6fcd4f5cf7a6fdcdf5152b8f7abf9da6b53526abb158cf0dbb5fddf8768a5c4f299eeb65bc0fe668bdb5a4e1cbd3caa7b3bff5fdb69ea74b08716db75e8bc0ee5eb7045e7fbb4bf0375f7fd08cd7463c210f9ad1ec7bf8a8150d460aaf8c36ef9512f63a2d02fa603f9e06f20ae4b48dd1bd3c5c871ddddb13dd3e14931bd27dbde3c4f73ee77718b23d9d9b0199ee7133ae8b99467a170bff7046663369e6837edc725a13c6196eec3b879bf5e057553d46c2fb47d790ced32a2f57d0897ab709d6ef867ea2ff8f99ff2a426c3c0f68ee4ee37ea7b77fc0b0d7af36af9c5f47be83c69f88706af3036259cde7fbe71379d5222bcda2ccec777340aff5f0b582c190b77d564f1133f66eefabb3427bfa0c235de06ce60dcfdc73a363da83cd83ddb51cc7c010e4c6f9fbc0827f412f76f1ebb5c56a6e3c8ef39e3ec120514ac023fbc1fcf47b6178bffce2d5da7d028c61846748b7227ecaf43e014f09ce760bf27fc68e5d3925b0576f19c0735754104ddfe669b6659482f270e384774fce2904f0caf3d5f7eb986ed8fbed9d605e65324eee71ef8cdf4b086fc19feba0122e24fc9cc3334b8023f87ed1e2e7135aaf5d847bcef9b773a9a77fbb9baf7fcb79a719fc9f9bd4d1f3e90f78e756619c0c40f3ecceff6ae2f4f7fab90f6877095cdf3f83fb3b7f6a461ec6b60169f4ed669ec1c3a929b78f5e59e4de71436f7cad4e7306e7fb490bdfaf52414fc667803a3b8b8df0f9e6f6ffe565b6f3f4fffcfb3fdc24f500dfb5dbfff8bfaf04f00f8530cdb5700a614849cc5b7f6c4d0ef33a537974ec811086a239b9c374fbc1a0c4e8812eac6c4d9ee124dfad84812625c1a25e04a3601ccbe3c1663df236d481f2a495bb4d95c98e09939e88b2ae73e0c7de76375cf40cd7c9dc99bceaf2052fb39bc489c8b18bb7635c08f2168f6f99bb84f2798ec069f0e9e9d1ac827f3e16ba10a959d4f01216d94fc2a20fda044725de0de59e579e3ca03c6c70de10fef973536d73e3bf0913709725fefd627bcc0517c165cf4746911fe50c3f218fa9b426596123745dbc70342edc1a642290a4cee543515ca0fbd6817487b9bf0cbde1715a6cbd2d8dd34c6473494ac9c53c9bf312ad73b5b73ce4bee468139ee1b7d4918d3746db208a5eabc24be248b50ab76f0cd545b0727a2c3d1ff5eb88aaa5e3ac3be2f6747b36a38a157758a46b3fde777a38c620a1c10f9335e3dec7cfff0a2682eaf35fc03791e18745f2e5956d4ed77f0edf10cdfa68a23d9684e91fe21b8a68d647b7cf1f9fdb31a3fd06ed97597a301d0a7c1d60f66a8b5adb45abbdefc1b315fab6e3277dd6dc09f63637fabba143150b71b4e3e4461b356ba9719a8a50b6c9cd4c9b690263cf264cbaa602bc62394a99f4ba52ca4f8bbe31f2446be187b3a11b84bb7c2cf251d1dbd9079b43ba89a44a0199e19cd61eace7cb4d9522c7632f9baff471cdb4476bbc838de76cafd59318454a1c8d10c52941487afc5fc44f90b0ff027e8aed2affef647fc697145a5f0a685a70495c56e668d5a97c5fabdd0051057f6ef7fd5122d8f28af204558fd638af08f014b06dbb4d7169ab3fc567fcb86fae7845d577aa2693e1c227b69a402bc3e30adf689ebd6ff5e58127e208db8972a9e012ec587bd9aa5b1f4389ed65c67e2d5684a8e9b99013f96a2b733841cec761eecc57e576589152778ecac4b6302bf9c12c8e7f057b40bafd0bd8c3699af8aa6dc0e59fc5270de2e26965feb16d11e9fa755bc403e0930aeeed208e87dda48d4ce6fd8019efe4f52eb0f76c67cb71f3bc1b18b21bb7f0018e8eca6d5c619290e5c68ccce6b64b1099221ed7f62a8007525a81ae54f96c296a116db5c8407517f62245a7c17f8d1a707c984afacbe9ec67e689ce77eeab5fdd173a3103b8fcefa2345e17928f101a699406b1c4f76364bef25daeab9ba6dc1e8e471dbade0952862f87db41c0b0e840dd8b87a32c8ef261e595444c4b96ac862123584b66c990482795e5cac3555134f062b5e6445935cd3662d5eaeac019b35d473f1e993e3fcd05623e9e9223af76b7893cd93868a1b876b0140203c3558f50ed746f949afa5fe2dcc2127f1d03bd06382726f93ffefd1f9f13d77dc447ef4a4d59f6174a45bef50ba5448efa3558feaf01e37e055adafd1560b35f295519fb5f28b5c417bf022b327e059688bf8ab1515afe7f4307d25a0d77078919d86bf158e57596672376381b67519fcf8a416904fc228afb53a26395463194641f5b1f3dae7700ea1b19b872663c7620f98b0329996a4d6984cc701b65800edcb0de0b61d71ae7dc9864693593384e190874c7933b6242a9a42f7a3ce5d72ab55cd05ea96f6cbf9d3b6d7eb7b16274d8dad66bbb570e4843a25a29462218dfdfd09dff12816fe8f92f96f8e897245efc8552c6fe5784145ffc9a8cdabfa28ac419fd4bba28fd3560ecab64ed7dcbfe9324eb34a18f4c963ae1fd21c9c2f99324cc469b40151ace5cd1a72da9563e2a8972c288b2cbec37a93bd6b6d864cff48541cec82b81c9a77685b2edba3c84113b8bfbe87233e86b2de330cee71b2ace6451cac6d06d22bd833fe822c25ee8c8da7241f506ee3121a72211ac66aa9e716519e5f6b2ed0b5adb162c7654af08a383fcd7f8550d6dfea552925ace2ff0cf8c627e52eadf4eb03efd423100ec578a0168fffbd7a0fdef57deb612b38428ffef120e60af5b091d02103652b848584cbbd519d0795b0efc24f749425356dc914f123df1a2ca5ef5dd2a0a489b6b4d77264a7698781f33a8bd0de5b5861413a13933da6987c345079dfb83d2631897da76461b6c4857ab72770a08fe0b42bf0beaff54ee7d7ae0f83f0a06decd2fecf63777d3e56ed701de73d4d5bb37253ea7991f17e745a5eff73b295ee060151cb278861706b87f73e33461f3cf60c6c9699b40a2cea7d5ee0f3123fbe6c52868a98b116b61598a6e92dd5e640eeaa88cb5f96a996182dc96d0286ecfb21ecabb9d9e9e1761df1822c2a8bb5af98b2459c8d86011a79378d9333a46b7af8bd980acdc34c2662bb61a0ca3696bda763bc520c6a6591df48fe25e8ced419baafaad6381097dd7c21f7a41d6c50b1a9b2983bb624dc3d30d75cf8be459bb8d6ae6085974688ecc2665e123eb5d7c982ad966a266cbd9986f97413cdc04c74d162fa8b658a55b79ba6911a877d86f647b40cc7d76a847eb9d369db8218e646466f275ea9347a4070fedc5473a478dfaeac1a3e807babf19b087cb59ff1ae1814cf333c1b96fc2b5d0bc1e6e793dd0dc8c91351303e0f49b13d7c2c91890d5cbec9f1a607c3751e67a2ef1fdf8e8d546f97079f7367fb98cefbe9f770c25ef1ad6fd1ca5a74fa6f152c6955198de6788b26778e3edf2765a76b3ace7dd0b7079cfcd2b4fc6a3a5c0379b8e3c5a708af6e16640d7c375dd6678ee6634efe97a3146d3c72748b67397ee67eafe19cb2d4e830de78d45c950a6ddf11fd218d5496324d2a6ddda67185aac2696396b87c5a47dc885a23bca6699756cd705351fee275595f1756265edfdaede1ead381bee07adb8d8b4cb72d5f68783f6a1982f46cea67b2c8fada13dd55a4e363ceec7ed0a3cb7cd79db03a2bb1dac8810bc138dc0f5f0d8de16e396391c039858379cb4a7fb5d0719ed379df67e90d543b2f4cc39524ff83029ba6d7436690766bb8d8da46e3e6a832202bb990cda91e4808bee0893d44904dad79e1d0726a8afda4c397db06f1f367ad09f1e8f2928e79bb3123123d41dc6ed7414b747cefcb8373a49594edab911c955d96de7a6e339d9663bb4dbbb5e6b131f26bcdc2fbbc5ae00f29c6dd8c16c8c39e6b18d5883aa6a65eda3594efad38d3772066d2fdfb7f3612b6bd968560d7834db74c996b3457d737ee84c07ed6db69f76f2566b2f1eb4e3f0c826666cf45b593cdc5345381186c6a4dbb6862ba0c3f78b81736cef332308c50ce98e62b190b6bb74346827a36e1f780c526fbf01754b835ceab6f7ceacbdc9a976c79a489e80b60e139b0bb2cc478756761c1429260de6be80f6dd6ce5778b6c6e023aefcb4d3bb3da80f6edf64e1c38077b2c1e8b6887cde6c3b25f206da7db6acfbaa320a7aa6038960b713eee3a713bb0c69047d27a83258875cc6389eae7f96a732c632cb3b2126d511ed6dae7c7516c58595677ecc9b1e54cc441fbd8ae069d63bb7d9cb9e2b13db497595508f3d13e1e6e3733d219ecf38ed44d4ba3036cf12ae94c21ce9d65355d611d73815922e093223aa0c374e84c564acf76ea911dede0d1f6c7d17c73cceaa49a4c67986d60037033dea1f5615027e02be664595c65ea6c345ba1adfd7e702c8ed5deeaced0fd18cb46a02ded552f16b33097002e26bb516560476fe0f881e5b48b72323a6ed2a45bc472a76c07f5309bb4dac761b06bf55bfb091bec841d70d9da89983975e90cebcda2da4df6aa37d8ef86b359372ca8be3504f81e486e3db076d58629da33f6100cb7fbd1dee91e275ee2ec0eedca9aed0ef6dc44f663c0dddda006f8f407d3763d1cac9051947572e518095db26bc5f271b45a4593bd0bfad62fcd41729ca4bbc1745002dc9a037b9f1c9c791bb4b115154e7b64a3d8d1e48b817d4c2a71c596c3586ccd620c7a0a7013e101175311f48465e26d13e1bf3f7fea0767665de200277cf39b9317b435d67b77866f5addb6690abd42a8fd41aba706f808c7d4655c1ef885caae28df5a9a6a2cf5dbdb855c21adbcdd7688e571e7c7a3dc14b9685f30ed3e5ae6fdcca9a606bd5ecd26fbd54144d3633c6c0d2c9658173d4bc796de16474756d76fa949e5b6adde7c5bae46ad912357f1b83319263b8fcb24c0112364b4985a3389a057a63e5c0f48391cd346349a156db9336d0bd94a322d4fcde392e1f4ee71994e94b62ce271e02df73cde99d78b5d8d449e2d04dbe1b0bbdb2eead1646d7365a0047374d6cdc8c29d91ecdcf127f35216b633aaebeb4287c28ffb7e6fbaa4d0c18263472dafad4e7195406aaf0ac260b8e2a268e287d3b4c579427fc5c8532a230f548bead8e52c193318c250c98cd197b2e01cb9ba2db54733dc2f67dd44a8a2a9b8d6465e550e0bdc1bfbebc2f6ad69b7b7dc2805a3bb1dab8f518bb8d51ffbbc1d75c58c26e6acde2f0c6eb6a3f65247a982bae603c55cd8e2c4dffb355d55b99b4e22c511ca70b7dd45ed2dd1cb90e1fe40a6bd42f47c40e829436ed149cfe4bc81e091694be33b9bed36d4dbfdf5708265fd5934954b36e0e8a38aed1708212e89e554c8483664399b4cb2dddef3ed791861a9b208dc75694cd32d769cac227f174c589b61bd6a3a271425ecd1112fd0bb059f5316d9958744a7bf9b72f3bc274ab6abb689ee749518b18375f3212f6dd61262ce8c98526787ee7e86f08b63bb5728cc221995ad5231ab8d0e4257ab433187a18a31c7ee2ec3f4da0a16f37677d951f243dad9478cdac7d95967bec393f0a80aadd1b62fc83a264a3e2bf47b39cb71d9406bb953ae972e8d4962ec9c6d41cf148b9b59946bf9cc1af314f2602cd90d451d5152906b6b3f5c4f37d8c4248bb8a4db5b99c05d9cc6e590c989792bdc39f2bdb7fe172cf76c9cc5d3262a3f59e979e76c3edc2df7a507a7abf6a143fcde157d541cbb2a7c0bfdb21cfcfec1694dddc3cafb830f2abf82f6abb03aa30fdbf6394c9ad96e77f02e0f7eba06fdc189a6203a93715176702933d072e2f7f654359c4d0ec3729b002f2e1f489b6567bfedb5661b74940fa6c0929b5d69ae01efaa1c9494db93c60a6267bb3ef008dbd6c0eeee8fc3f60cb8aa6df0af98cd91d1768dceb27eab8875d47680195c7546703f7d7b13617bf0787656d987719b443066c14894bc2018d1ef5578755a0fdf92651eaf70e772f66fd366e0971b2d3cde862339503dc35cec8c4d8aae4a61bbb5cdb1a716d9764c599c5b4c159f3c2c555aaf4a0b895ce4486b5eb08e252f5fb7a7d89454f48ca62b777f240377a77bac4f139d4a7315d6c619014f77e6d6e43199ac7b0623d334b9eab4793ce479225f308a18d044b09a788785c4071e4ec25359030a2786975359e5d3be188b418fb4a73d4f93753a61bd1dbb5b1ee5828ec3b542ae4556253022980b32e96a53829d055b82b3644ad81113cfe0b91ed50f11f7108a8adbe71641e44904b7ad9784385ce1d5586270ce5a2f291c51154f2a840342f2b8b6a07153c1653e60fc400754a209025128a567b124d0841ebe65889ca0aa642f240891f80923fbe20fdabf2460fbb1b1ad75bbd34588715cbaa619af2d2b9d6c2de9aaa8e1eb055139c47a23287c55cd6a86aae52d0ee23b9adc8f5d912634c29de9733cddaab53d69d9324b69b95c0506eb11a646acfd98e53096e068a2a259afae16553561dc4419cb154dba1c4e29cc8a7035873eb80e4dd0d43c2ad75c8df30cbeaee283c8e0c46293fae29a55dd1fd1a1d5232d61bbf46d61cae77dcaee6898eeb9bdb519192c12ac4c3a94a9825e06fa4c7445820d1347a6b89d304a230fc7293254698a28708ee495e95e19d0325b6393dc95f169e20a1132f16494a31459e11546e0c6b8d75be1ab20a62b4ca1e55c215c7c4afbaec210809194c4c15dde178844c7dd7c35f74d8d72d7547270a595d63bf7417bd4070cf4a1453384b4eea72dcf25f37c4a2b6ca5cebab60e50c4d12cb0e416cba433714b7a5b2951a8fe8a63092057c988e1ccc4d5e33c0b371359526447a4ed6a2121b4821b063dc2130a508cdd0efa2141cc6bb9a2c23541cb95cd56d58ea6b83159711bd00f9cf11340516d6a919c4128554678da583a04f2ba2f3a9c8c0ffe5aabf172d6783f3c56fbe1ee111fabfee6ec953bddfae0b0bab7bd9f2f6791fdbddffe7f93fdf6df72654d3efcc3ad42ae76b349e1120b3fddbc0072efedd887fb1434eb059ed3d34e0549011af502570583a6e4c063393d8073762c3bb40bfbfed9fdfddbbdeace47aebfcfd67dffc7d7ff17	2038-01-18 19:14:07-08
talkbox:resourceloader:filter:minify-js:95d755dec919121af9fd8c9c3a53b9ef	\\xe5bd6b771b497220fa9dbf82ac914194500448f58cd70654c2ed96d41e79fbe591c633b320d40b1245aa241060a340516a02feed379e9991590590eab1bdf79eed735a44e53b23232323222322abfec9c91ffef11fffb19fb42f6ee6e7ab72316fdf96f3e9e236bb994f8b8b725e4cd3bb8f93e5fefb7fbb29969f7357aa2a66c5f96ab1ccce17f355f16995de2d8bd5cd72be3f2f6ea570f762de2de7e5aa5e76b0c97e9606b9b72e7f653f3fd28447d974717e7355cc579aa2dfd972b15849f95f6ecaf30f2f3f5d2ff3dedbd1dba7e3c7eda7a3d3dbd3bf8c3bcfd2d1db67e3c78fd66f7fd786a4a371277dd4cbcaea7579753d2ba07877f4b6ffbbd3d169378352bd6c395fac6edf952bc83a7d0d9fab657905a5daa7d5faf4e6f8f8ebe3b4b3b61f8f7a97d9b22ae797b3e2cde4124a3e6d9fde76d2d3eaf1696ff8ac3dec3f3ded9d9e3c4b87d0f64d552cbfbec4a9cc271fcbcb0980a2ebd2b2b3e5e2163ebe9faccedf65cb6232fdfccd02809f5f4c6655c109df95d52a1f8db3173f7eff1c41385f7db7984c8b69b65abc8681ce2ff31fcfde0388bbd7cbc56ab1fa7c5d7435277b37a97ebc9dffb45c5c17cbd5e77ac1303fbbbea9dee55f2f9793cfa60c2666d5ac3c2f6a59949ac10a159f7ebca8e54afac021442ebf5c91fc0e51a4bf03af10fbae08389075050059216a0cca8bf6811676c8b77a5756830d64694e77be98166fa09ff40ef3bad26a8e1fa3e371aee506943b2be697ab77f9c9605b73799e27678be9e7a4d53a70030c1a562c1d680f9ad0c57adc8d6b8ddbbaa76f84d2e262df0ea1a2a54dd23b824bee7641b7f8549cbbc1a608232ad16af1dfd1c9786fbd76234fefb40064a47730d2bc2d7943f9db5ddcce8be50b99c37a2dc97d9d558ac3cdfd4668180114a08e64e5cbeaa7d9a49c331eb6fd50dcfc460e62e780fcabe225ac3a7c613b38ccb147a6ee64b55a76cf27b3590d6db2d5f2a6003a53c01e0a9bded6ea86cbe274ce6ecad9f4dbe5e4924a8c1442e30ceb8fd3816b0f6b43ffe7ef8ac9d9ac18e2d78554eb9ecf16f3e207c0be360da56f33d3eef93be80273618d65c1655a57c5f212eac0ea671e8c3c36c47f8f4f97c54a26f1cde7575359c7276382399624a0e38f6e393dc87397af7bc593d12ed0f9a959b44d88908ac9d896e43562bbc76bb7ab025ca649ece3be95eaad56ef2d10cd47bdeeaaa8fc3191ca96aa37d7dcb72bd7009aea9bcf80953f4cae0a33bf8702dc8ed5a17ef7fd2f584dc1d876f91e9e690da08a5abe5b87f9b5b2ae6bb761be8d8963dab4887452f8227b211dd41f8009e6646f8673b719e02e5b126a983bf950d001e07723d6c7d35e13fa499231fcfac949f7f7dd2749c668d63fceaaf2d7c29f030149175c8486560beaa1a11c1d444c0c682d8fb15f40045f747e73e5b9949bab3c9fdfcc66436a5f9a6da77d2cf5f49853a949aa06e8dfa76d001f636c184fc4d7abc9f907df3c6e8f2a9b03aa793ca2c30b498a2c3a6d4eb7aedc27d58315c526bb93ebebd967242b19270bea04a86a7391aa5c2f8b8f4c4ee9581b105132e79c5b2fe81b87872708225d42d0f0cb1f2043a71d7c0e93fd04162fed38d470688a4dee6c29e9261d2cd449da49c7a7a6894320f803302d80907a70e24a9e0180b3c9f2b24ac3cdd3c5a2bccc61316885b6816fe6629e2af4ce60ce7fa24d122e03a5a577709e10f6383e5336b39fa9e3c57038f2937823ecc54d86895d56fce20751baf19700fca3138b5e65dab75f59a7ec9ce03c2eca65b5dab61f8a5fda84dfb349b5dadb51e8889aa2a6b7957298dce61dc41848b005901224aa344b2833c9cc2ef3b9ddf78b72de4eb224c5deae26d7f555dcd6a7231dd7dc65b09b320f376d87bbe64cda04d023f55acca75b67e8f6c77a2dfb1077be6ee33e73b78be5aa3f1a77f16f565d13c4f0937e6d06a14463d85797a14560a3c1587cba2698c121515801f8802e3820028559afef3659999f0849f47942feb269515c8b58b0b8c6b694dc2ccf81efb9fe3cf0dca2344fecea62564ce6b0d9a93a670c6add9f50f783327f62994e2e066746b2200022df5b3f96b8141edbdc2ab4836dc834f2bc7439b4378e8ecac1e662b16c0fcaa742d8cb4e87d895b6cccb0cac1ca70744a96187421d9cf07e39df9782c0372ecf655223cc1b0f1012b9644b124e480182d9e91d92c4727e53d0401130ad166600a3bc854d854a8a3d8e72536acaeb49ec5e0e83d9d60464d55bc0c47408fff69b9a1e8ec67d80a5cc6e8fe69207684643cfa86fc20043acf0333aec0d94080cc06b6c1cd562bcd88468dcbe9b2f40e2bc804d606811769adea9a09efffc682040748922dc8b901f310ab0ef84e8f68d8c6b772ff25d3179c6b44096f2277fb17a535e158b9b55dbb242d9c957008eb0991c79f14148ca71f52ee6b0f18e07b7c095176da0e6b9cb1f016a8ed35da78397d0114b09a1fce60741edf2b258fe71329fce8aa51e45ae95342ad04ea8b504d9c04de60eac08365e49a0309051b0e240e7e8a04579406f5774f49f2f5003b22a92f8505dcad9b8b17527d3e9cb8fa870800916739cc2d6ac7612eb2792bac682563c1d089ed49b9841b1240bd651aa38ccf60358c119f28e1ab0c3f2a9ed6431a7362a9cfcf9bbc9fcb2a88fc98f26ac591f4a3a20d2bd00f87d2c664c8a07abe5e73b97242d81a077a522662e78718e02581b58a500befa430a77f7a68bd7e7cbc56cd66a69a338374e7bfeae80339391c3d35f8f1d40a4fdd1270a20465bccc1c51f311ddfd7bae3847663c4543fbc1daa288d186a1735857b177eacd7f5c60e4c635c779cacd790e03437fc059bfc15acd9f2e364e686c6f04770620920e915a03e3297704a856a2dd75f96986249babda06dce1ff75902d3d48f1f2f92341e0be2c787e2f3008f2af84b271542402920a4e58628afd7dbc609055382eacbabebd5e746a8621fd89f3b12cdaac970740d9122008fb45c8208e61ab9aa2e51025c2e6ef7e1277243936555fcebeb1f7f30a47eb29ad0fa094380df075e03b55e1f7009275621a663929e53a847e5569024f5de8e4ec7191c6aa7156a5d59eec75cd85fd7b30930c0bdd3d3f6b03f4a4e4f4f7b6717f3e56abcbe191d1ffdf3e4e8e2eba36fc777bfdfa4bdcb2cf97f92d45749466fb1fcfc74397e9cac71b26b9aff1a87b33e1a9e4e3bd0e669f774fa381d62ebc5cbf1a8737a34c69c7488ed8d6d7b50e4edbabfce52ac553d3e1da51d2c93a47eb9659f23b05a2df3d125180e6b290c02902e8bdb3dc73725d258d2a1dcb41d897bb45eede4d51c90be9ceed3ca6861a001d97cb1b8b64703c8bbb3c5d964f612ca372c21fe68b59ca2db035f58987740e2eed1a1245826498959dd46c2b2ea7c595e7bfd4ca4704b381b8e38fed125363a4101b5f77ef27122d94642ab6eaeaf812bef72ce4ba20052178415e0529ea332ad1df5f7061a24f51bcf505581d22729902063b0c11901535fc1f6fba6802d55b4b94c4619248551fbe9801296c5d5e263c13d7241598a6981100ad50199938d71994917a7055bade0b3bb5afc19e6b27c3e015c410a3baf25d62464a69a91047ca71401191a9524b8a48a116505e42477dcb9214675d69e6bd2dee5e6e107d58fb8712e86b94e526341927398e9e41142977ca2df9dc1427dc0c38c9626940876b4851cd9d6a6b8ad878f5209ae1f2401cfa6ec1c31821b30f2a61020c3d68049ecf12c40a808faa18220b8d25f3cfa984c07f53b1d9078ee3c63cec9a8fa024aea17dfdeb9b5590199181a46f75748b2482017bd9caf3dc14fe0bbab9bd9aaf25a2a4958af47635e7128a5c2977eab5e9892e144e77381b2727b30d47189ca800cd4b675f030d1618174c95dd8c35e1463043fd47c712bdbf4629a1b6a96ca79347fda9c5cd64f4c2eabdc7e0d52dba26cd03537bbcb82a52ed2522e48b1001cd6caab26c80df2e8041709a760d4564877b2aa002e442e60cb9cd27413bf0771c55e0e6141b7347932bfb93a2b80c171383acb833283f74f6783f738446a95f6949418bd7797212c0fb9e4509c6ca808bfa1aa1d675eaab69d5251250b281a2b4d1d092be71f3d36021236409b6a6c85f601b400c33cd016b903007f56f2e1cdfa3a4dad614aa0bc8a060724c70e2edba37dfb8563e4bdde303c6a1e97944ae8aec3eb291c353731ceb94b3b68645441b4101209c3c2fb3684f34d39ed9f64c0ba7e0ad4a19c429af91f3d3d8c754d80434f2cdf479582ab47df407e311f80c8ec1346547a3ce04a0e65bc0447198daa24ca4983d629a9de16b2fd07d2102a79b9405d0588d7844ea5a96ac048bd396085956ba68bc08369057fd76b9fe7c81b7e743a8ed1e6b16eb29b095de77bb8df000b7633c96f2670a67fb7b87567babbdcce7beddbe2ec43b94a47fba7bd31da2c74c79db4c717aa507dbdeeb55148982057da7dfcb15856d0703adc51fcaa2a8b74bf29efa0875a80c9aa3c9b15c285437aab057516bf96b3997432dc5f7eec6b7d60944d0bb03979ce7762bfd0d76b523c8832195e5f6f1d21f1380128abb50388009b74604d1f546010d0b59d81046d0a5bb22b1f5eb1cfdfa3a6426356878425bb32bc3ca821895683b3a715646da21ebbd5e462b22cb90bace68e10c56c3e78f2c683470f02aea34a753c98e5ac01b472d77b79ac391aecd6d2c44a0ebb338c620899d9dfacc489f546f7a968768de941fa2a2f72145face389070ba3d5eef723fd4a60ad20ea47d5b3a1b667abf246db6927b3e202451c55faa02087260e4e5119f4989de89db4d357ba61ba311640fa5f93c0d1969b0f77bf8f5a64c5b8c9fbc9a7f6ddcd72d6d7ac6c527d9e9f8baa15651e54aaf4550cdb44ac949720b96d662ddd4f01aaa49473c0983fbef9fe3b623e6907503a88bc5008a5aff42e4a080428c1733fc9c9f979515572f07e283e33a79c21d9c9f0e89a54c2ad361eb4eeb4622d8bde597826e8034a01a859b90b3bcaf62071f461ec3a6206dd91752a46d393c3d9f24158273fc0a1814c07bf5badfab126ed195621620b2ee69e15c079634343aae56fbc844f888aa6699f8144c089872c5fdcd5d0553de6aa7d739eba35982f6edde989fa8afd17b0af52d40720f2224eb6cdbe0d6574bcfa210e09e856fef72a08b269f9716b21c88312703a6bf10e8d7b00e9dd6af5795674a76505b2d067e08517f322a10c87af79b2bfbfff7456ce3ff49e3d5da1f1ceb3a73df93bd97fb72c2ef2c3dee4709f5aca0fcf17b3c5b2bf04305dcc1693551f77f760713d392f579ffbdd3ffc6170f86cf2b43779f6b49c5fdfacf649a371788e5bfb6cf1e9b0f72c21a0c03ae6388a66cdca6398ce6447fe84d42e64f63641c10bff15ccc70f4fa1e2159901290196ed2fa8f3a960cc451f3bf18a0da768852df355b6c2ab95fec1f67150019034450e79b7ba9abd2e96e56486e61b073b2a22b47d3d826cbf073015fe6382d5be5e017b7976b382e2542049d30c57e387c5f28a7a98f6e372989d904eba3749325d94dedb63589747ae6d46893dc94eb3f3aafa9696f2e040333529a385fb71dedf3e155a665a8f2ef3f3486ce6d8fbea35d937c038b76237150040ecd05db9c27c8d0950106b0a387b3d29a5015a728adf0f6995f60eb4e99bca599ccfa6059eb42f3f5d4fe6d3451fd91a86c673bc619423c4abe12461bea06c3a8db90e60fdf7d0eaac8f8d6eee51f4e189fa05eabc4474ab490738ef243f1990d581bf5c41d2d3a8cfa30cabcf83adc46d8dcae938a66446dbc8ec1d8366dfd7105e80939d5e11655c3798a8c900bab9aae871584d5a45e48870413d07d56ac9ce2df4ce2bcc4756e87c569e7f489c1dc53e7dd7e874d7ae998c041b8bf82a698cfea0a10595890c1bfd787c0d287b2fed8e0972403b9740b21687a4c7940f84ece13e2123308e87f2c3d156b5acccf7a24ed574d59973c229ac269a01ba0534d1b18b0a2fbf0bf26d169eb56f34ce610a2ba39546edf189637f18a89848dd9653607bfcf73570fe40dcbf8303294f4eae3fc13967efc8e329ba79e90ecda379ba74ec627171012ceb5fa8cb3c7f12351d519e343a760ff1d83dc4a1cbfd270bbb0562ca6beecd4a0094fe03a9cba9d8ec1e90b8f244793bee933a292bdf836f1999bf62461bebc094401615358efe4c713532b9a1011a33b06d0a9b59cc46aee838b78a4ce4a979da2ae4f9dadec6c2919a9bb3ab72f5cdcd19f01f551e42080e0cca4d1a5012459d6db5441002c1025931e5b86031900b99e892b45dabd7cbc57595df254031937e82a7fab7f02b4bce018b2b48a1bf38d184cc3516f3d9e73e192bfc08bf92ec6af2490c3913f8f91dfd04c251cc66c8720086420bf0f19a3fa00d909f810c42138b5b4884b313782c4e811f9c02fc18c9c6fd047ebdc25f09ba52a08a6e2f811fdf4fae81d0e14dfbd962392d96fd843ebea18f8419d142886dc2d3142e31bb41bdce71c6c4fc055e57ded52c5fc8aebb7fb7c9a48dbefc85f30e6bf4ef92e2ea0cc4633ef254d8902f543915f2b521a9abe16628735773d1d5908c843b1ac51745467f34f66c1f1987d33f628430f4b323599077c694ca8c642ee38c66a954803e4835f81c7ff14e99b65a82ef6a3c2a3a40388e1072813014dc03737598e034ef7410e4d6b44c1b73425a30ae1c0abb71e4342e3c7323eb278235ac105db3599b6d2ddfd0aa6f0bcdd41afa18c85569dd529a0a8afd145f1eeafd7a237c86519dbe072c9aa922f57cd18c18ff1fc689104e6eb02e3f558e289a7c60716b6c1a4c4dc7a478d8b4f75445e0eef576f154ae739a8fc3159e96c70f021e77e288be282aa2d476d806f235dc8187c2061599b1b567fb2edcf24e956175eaa2a57048061bca18bbc7d659d8605b5c310cae6fd1780476c0682c5d17d95d83626b92b2f50a0805ab2a8724b27d85f3b60b8708258e4ec6b9fe18a251b77ef493c45d5c84e480d81b24126c651fd9ba8170858bec1bea24074936e2afe331bbb2c434260292b535b1209249091cea8db889506b5453fb4dfbbcb9add3861d3fca703b07ce4b3d4e1f0479a76b223b8226b2400aab072ca8d936e1b27a0455ecfce5a6b8896d15c8bec99d4807f6b212e824b2e5846ceb7572f129493b09b5c1dcf72fc10ab8d698d50a0c847ea19b033a197e7197287b6af52ac6285b9a53533cef67129876fcc2577b621da3fd01a99d16dba60b641de7e5a7c5b3c1d23a04fa3035b28b794e69ddea5d79b16257024883cd0702cc7271b92c805f42855e544c2f9864cf12bb0870e4a5e8deccb95cd0c860a356a7d47f032215f1f078bd1b2952048470b9d5de1bfe1cd85b3edebc903a60e91d61b469d89531b5e271e95e94a16dc761d5686f013fa1b31ff0208461ab45a5a0a38378152238b976785334a00663c543a8674393dce2cc1a1aac4a60f304d5e0a7730bf83474bf80ce16c5b41a61fe78bdc63f7dfc6710e3a61d95748e2089a4493aeec9cede5c373c0c7532ec56e6713e2b26cb7fbb0f387e183cc66c3466d09212986486bc373a9d9faec6bdcb6c6f49fac7bc775a757ad9921b82af25f9525f17e72590c2e52cefa14e6f5d2dcfd72452a2373682a2d7862379b598af495390f6ca6c79013262856adb2873cd07e19ab5666bd4394d4058a13aa4a2e03a6fdb9335a53fc20cd23390a89ef7e8f75a55b8bd86ed84bea7c6b70cd97939e1d57c84af1808417c3639a62a25c33652c70c7e5d6f1109c6039011db311de15d8cf06456b97b22fe7e318f23dc332dfb643a7d8eabe6c7e1d9966dd71abb86583252c23a5ce80d26fb04624a577b6b9b9b0e9a4699713ece4b44d03465cc5446c349254e03eb8816fb6388bc5ae55c9eeda398a7613c4c43d38ddc7a1a964f676aaf61b6d4a81c0f2c67ee01ab2766d7f52b0ca5fb56d30d3aab8211e6c97ed2090b77200940b022e8e4619e1bf5398cfa7c96fb99eae0cf9f9ecf06e76211e3b29d251376e72b8dcec7d85bfaf4982e28a9c74e5e2b432641c17cac81af56a4c367b3177ac289a2e8bf0fad4c875f8859f7a1d67abd85c9fd6f4537b11d35a8a69b221a4cde6e462d632748e919a67d095ef91e3c7a69938de8c53dec42213f1be3ed6eca828c61dd9518b5568bcbcb59236a65640ef0ef682b4c3e1b7a96eaaa6665f5cd6231d3342d6d3de606ff25c86986fc20e4f413f1bf085d779d0b86416aa68a641d5c1b21f7906b3f99c16a1e6a88cf7be22fd5800d95fa4d718b0cec217df40f6892ef261503c12c3c668ca8d030d1b3214135a3dbcfc9384094400c0e8569364d0d3d20f550343ba72692253fffecb27ffe39c9a20a1a00c14d39fcf404822e558649d2bfaf871449851cbf0a947a3c947867e32ef3bed4fbc943880b1238ac27b4e50134c19d191e00cf8e4e3cf22fad31a25c686581f781a7f35b28a7a776c78edad97341955ccca9fa1b51b5502032315166a6ea0af5bddb20f50596f2a22ca6432a44397d67ca62edbca24ef48e562c6f11067c08eb2d2c69a399a1abd01454dd56a990fae6e26511f7a65b916a1f9139821a8be1b11b284dfd3a42b9212bc08f51bfeebf3b277de9c32f3114f02708e73a27583e46f8cb4d414d5165ff736e8a406299167a7323a3927ba81fc209b39cad6a8b8d2dc346328693e6fb770785d41b7d06376b3fce432f89f08a9f9aa63b7e8ad880173e7dbfa24a09db3e29b285e77cb686975e8ce10b5f18297dcfb751fcc197137c441061fb6276fc80b846d5ae90bb82f6470b936f391a687952ab47ffc8879633f886ef0e1d96f54813684edf6ad55687755bb83a1acb486e594323c6b61f004e2c7d961f7b3564bc8f98d085fb48b64b4d8b838de9d5a8ee6f8e1c523bd74c6089faf82ce8fd38a14b1e2a6ba30485557d183448bb3a47737ce64028937709fccb24baae4b43daf3edbc8f80178b09a0dff4036fd1f817c54ca25fa417a65f74952b058bf2f29d14e04b57b9380a854c7f71642cbe9ce8213679d69aa79ef44f6e9f991d8016d964be268e327b46acfc761ea9769840b352df1101723a5aac3e5dcdf2a04744f3f5dadb79fff5fbef5e2cceb909946ff29a3ddd802e51b82d77e9419793dce57a8d7fb64861b40b598f901b8502a3398bb926068a2e7b52274ac690875b6553993c32661c10e496648bc17f435cf2f98149642d29aab521e376f55ac23e6169042207322d5af74a426be98c7013c36c961c01ce515edd95a9080e762ca1ab21564423767246dd3f9fcc0f57fb67c53e5f264f9583972b30a1be5b4f5138c9ae12edd35274b291a0e5d84ef57d196af6df5d5f6eae7a27cc0b34b115f3e6e64c1da5e641b5562bf834fc4398ce8c84573e35817abdf68aa61d4b819aaee1b1b5c33400919bb38d0987e04c065031e6b1c2df3c92d19cc30d665ad4bc0d6da8e068e8c8c2ed59d807852474946bc09ec6a261ead8ad8fe0c9e32186767b7eac82c0c3fa414f4d3f49fbcd39c19a292fe000d7c7d43822154d2a269b4641898924cb5479efb4dbee3ec6189117a8fa9cdf5c7bdb94b9891b75e5dd84476f4f6f4fabd3eee9fa7fa376d3c7bc717777c9e929c8c2ef485c73c706995cdd8178d370215181044097630da6010f20eade02db78d0b55a9474a077c04043a8888d5190f24a4b095e541ec98f67ef5fcd33f71b299a0cb1fb4e835a9892b9240ee46f6ef2b40223b4b6821e34da047fe9b9aebe352a25bc88affaf86e58cfbf17e69e492a21a89929c7cc6ef33785dda19f7c31e9f37950368f3bf3df0c365338b70d35c423629e8d2771105dfe1e580cd1cb46203e413277232e4da6b32ee1907769b2240538f7b82407f32394231548a5b7bda8a65185092909fc1ed1f0284e97e2847cb7c876b987119fb4c94c66dad725ef5b8ca79bd78ddeef788d653761b9d36c588e3eeaafa869543edfddbbb94ebb2e33284661b78e530afcd4d65056dd44b550a6c7d1b8b131e4b57dba038e294b486d317ce0f7d7524cb7aa11561a67cabe048b2e895c84e334f91d54b9dd133695b313af320c48126eaed7ebe0d3dc2e22e4cd625bac370ed04a5fea0e478dc97c43659aaa057351f1dd7b09c5296d32f08b1b4a854bd2e940cfe99df93033730b911ab0e1ba3491a0383d5cb7cd4641cd42b0693a5830f6a29175602d09ed3a16f1254c03da96b16a6be74970bda81e7a10ecfd534800d1239aef0829be510620b14bec7e2ad63180b1310fb46c01848892b6d3e02ca2acccdc181a1b10691008383538b668d2ac79176954d15a08949e1e9668d146a3e384be9d3b3a97b1a66a5c1e18d9e5d72bd8ee98d74df8fe5f1a23351c6a5f880946c65b0619ac2c2f985f27424cef77c396120d34752bed54f046448351058d356b94f0e9f120a44ae213f29bc8a3218ac5edfe9f8acb979faedb49fbedfaf4b49b261d27ac5fb7b7134dc73229f984bae43f8a6d0cd156a40dbfd68fd224dd380c0b68953f57dfd0ca07e1d994d0793f2e747e7fffd495773eeda8fff21074f9e8d18e3ecee836e366c14c7903414f77acb8db0b356291bd179be4370a7880d0fba323f4eddb6cfc7c1e48dffd4c61fbafd7e174f71e36df808ce579781eb1d7f783218282eca2cac52b7deb440d4166b0799accdfcd64992839b4af5eef2ecc0692bd68956126c7ebb52b0ca4a65e402e64b5eb553159025b3bf7879fa698e178f436c79d719035764811cfc79b9f37acda1f5adcde04aa386bfb281446c2ef34729f7e2175a9bbe62431e68e96dac6c9bea9e66128f7dc644a56a80166261ca939acb037661cbcf9cecaeded2edb8570a933b453c748f53eb2e357bced3547d0ca19d7d387b7691c52823352e5cf7ec863ca17af179b6b51b1b45fcfa9339907092a0a65189e911352ca242fc388aa5ca0f8743ebba9ca8f8577ff16a339d9d4abc535c6f59a5c4e580830f0af73099ee8a0ca530de3d8f836bad82305342db4d8425a6c8b88979a2c9aa5a22a0695c4f4c38dffb7eb11955e621019a3d1939170004e923bacd16664cd4779ce1c8e574f5b3ebf59a2e2ea8d69c96c9c9acd60c2196c0c13ed21919f94f1f5b6af0d5a3e997d10099fbcd610626d56cf05ca9d2f32d676bcddc8f1b9636ecf24d4c6eb49540074b982db84c106f964ed52e83a45c7d7809dd7c5b49d92292c31def7210e97b391f5f76de32f8a8b098ce1a7252560d341a45b8b05d96236cdcaea392ac8f258792845d0e195d9360a02c09e680f978e3cf5ff79ca03f3d45f530cf56744735005615c8607bf64443018fabb7599a3ecfa420bce481c56d9ae008a7c4f92fc82d30ddccc076df53942f99b75054c8a6c0714ea20c0862dcd42f2d6561d5ac9a11d1d01a28105e142a5a36629434e27a6ec36f271b89e17e5276e77bd165f4f21034d54800c41904df6543b629651df1512ec4686d9d4376cb3390bbe9c79be57cdb09d4f0e1458750b02ce48520770e5a6fd78f9325d8e890655811364756886e7440b02971f078c0a7483aed817f3d8569d65d4844ecce37c3a297c2619e6db9a81ce69a0c199eaa27c635473799d240ae760e9290685e24231c1bd66322744afad98523ff43d138b76eeafaeae8a693959154da4d886b153ddbc190d46e8c48bb07e3299adfe67f19914e1cfe96a867e928fe319fb03eeb3352c5ee19c1733bc84c04b9ce573a04de8120c8dfe55fefe6dff7cb59c6173c1c62297897df4072e673c8a9fde0121dbbf582eae4469ac1a2c743ea1866793cfc5f2affce76ffb5750179b85ad41b737fb7cb3f957f9fbb77d14a6caf964261d02388abfd2bf7fdb47e872a5258c1e0e133c87f5b794afce974531ffabfcfddb3e6d4aecb05a9eeb0899ccedaf169af0b1848d7afbae28662f8a194c10c4f2f3778911d433a03e35f2a62be8b84f7f6f85c9bc59753aec53cd194cea02e63328666d0225563d2cb0c648c08f4139a0a054d7267f7474548eb96d0cb5750dc4db36ca690373f24b80f63bfb2504cf03cb47f41c789435679a32838dcd483973356aba0fd64d04b6ae4124bfe94cb9bc560c23e899ce86f2a16bdbaf5530f320e4caadc4d8956da03227b92a2dceb7472d41a7e7e83527dbb66c7169b583f10b5a2d7c6fa8a2403fe8a1bd5e63ad568bdca76df2717ae4cb730bb5f236f938355dff2db7f3f95bade7378beb868e29b5a1dfb8b4493d4eeda2d2ce69b5da0260a52e22efb96f14d7d36198262b2564c39d05d462dedc9c94b50310fae29693a9983626b97990d9307efe606ad97410f0a0dab658eb6478d20f539e0cbf8a527e3f7cd23f26cbe29052485cbe97ff2491f9bc85c3a7cfcadef6f97991fe1de9e8b5888b069fa9f6a2eff8cfc5f5269b0167d30fef15bd8a2564eea1109f85fea0749aadedb73699bbb2c1aec48b8f5fdf88d5d8a6633e93313b6753182423f57ebdb596611d13eff56ec5e20646a88b4342dfb2585866a245b4f3beae54dd23ec6e68d5b8116e81955a7b4d1ac26d1035d092b8fe1497e48602cceb2207e19ab7ddc338f13f8886ce939bdb56ed35e420b6cf74e813f89aecea2e6a3ccf83524d455848c1ff061e01f864dc157d6ed8e092a8923b49d14d11eb4c2977bdd4e4db183414453a910b26a7d01bd833dbbc7a8991d6e8ba411f96f13c60d30b98dc3ed662dd283e0f02ffc8fd86c34acf3640e6c0d9e3e55a7460ecd134430c91d165ebf56a72759d73fc2bb2a475feeeac991ab868303cc26f1148264226e34554e80d546d4796be7656f609c71010fdd860afae1bc87d1f1ca621afc382ef0442d3861ac8e3140aa1dee52ac440aaec9a459c79c320eb2c79bef75bc719f586036d100d501d8efc3907f190d5a29136c9090d43de214e581033cda8f79fd557a66f50246b82495460c7086c492603b7258c64aeec5c9312413570757e90346e7c8bc685547175c0e45dcdeaf29a759d183806658d5cef05cdf00e37d014d602c61a9d0a397d1697e8e7104fe9efee2638feeeae16375581cbb4ec27f41b68e132c9e8e7ac98c0092cc937ab64e34f424457946b222e40f566983dce9bcea16d6c03b495f16b02a4ad758fc4291cfac142d3ad59da78f03474620fd32feb87837af225ffae083b51877bce22820a3502c2de0eb953b159d14701cdc9f2710bf05897a9d07fcdd17dccc367c62da2507d2963905ad1937ed339157003dedda5bc9a60e01fd54ef2050e06a7aa501923638b834cf8d006329e3ac247260e7e3ec09b5fa3bff57fda94d05ada4c086d936f17cbe903e7043cbd8a0b7815f8d597cd3188faa0bcdf4e966907fe26114818431bf03388e5244f52c19c10b1abbca7eecbe2dbccdba057665cebdb72b642952b00151dd802c6c75ec929a8c92ba1f0ee13c67b8a3c030ce4d5ff99dd0ac40f556299d55cafc4bbe50a4e93f29aac505d9dc0bcf9d9d1899a86a15941615d66a2c10706aad206ec70d19e1e2529461e094d899a3725dac6386f842de31a184f16225618bd0d01ec40baefd39a719a480556c725760bd86c1e2cec2c07d0f2dc432d9e095f65fdcc6bfd33269185de2ce7f5f6469005ad2e939ff39b0acf000ddc2be9bcbca1cf5b43f3e4ddd118e581bcdb20c186f470050fe4450892490a89f62861c8a22777a32b26bf074727630d7e1d1accea46929d92df5d30d6f7ef74b27dbf381cb0b0ffa5f4e7de5d60ae411b51cc6398521c3724e3c943a66b189c2524280f25922171ab3f23131d454a3bd0cd30a8fbd59356abdd30c5100a69ea53ea1bfcfe69b2503881297ec4f37ae76c07f7e1a5c5786abde9a4de6b3aaa750a803566dc2af8880a56edbe02b2baed1427db2f47df9f4bd8f1a0aadcf079f93b2408010fd1cc1e7dd921f3dc85fc7b507f9b4130dac63b55d96e5dd96d4648d4cdeb0c62e4f921fc17e3e27a3bd8a6ad5fbf8597e77bcb9d41ed036698367e9f895d394fb2b3d9cdb2ef69dfc3f95fc8a9b3bf2262d50c5aa92db5f992abf086950b426ddcdf8211d125077748d1702f9a0e84b4c2d72ed0461b31f577bb08bc5182dac4244bd017d5e8cc4a093fe7c29d88ab4f3d6a5066621989c16573c8757e04cf2b3cc4730c235fb1390a1aacc1d738ab3fa2dce8802f41a2f62ee61c848f0ea9c89f53af15d52f06a7a94c07a95af1219458580bfc076fe60821317f500344b7b3e6dbe4b5b47f31b76709abc312f6d039909138955911c273103e2bb5c393bb9126614078a3c55aaa654b08d3416370289e6e141d6ae712b75a64735bd3c86c5d780529aebc5b74f5e1ffe2491b0ae8e64d208c22443851b1e6512f66d60e99ad7f2faa6cdb41be7fd31d9f7799dfdbacc0aee15d9de3b02b814a825d266943d4b969a943a110dde1501aacf21c4a3d287450c88a7974e488151494200cdbb7358218bbf0cbb95ebff764a3bb2fbc3cdf6b66186953ba615240c4c6fb720d10123e074fc62a70dc7813147c755b2cb4cba798e5c4e39866d0f14696db61000e0eb37d1f85a1972b26d5ea0d8d2a6fb8cff0b94947de1d4af1e6ed1fcac1830a673ead73b215dcea488793f115c6cd446dbd163e896e7adea1cac9c2f347f806a4fcf16615e29bd75549a1b4ebf5546daa002d738ef3c8c34df0fde43abfef70cfbe481336088f3eda695902fbea8b8f3e4f0ef0147f5dd8d81cb41d907cd19b47f60a07e04f1741ba6f735b991fa372baad0c4dc5d14fd396a120957d733e75a594b529ad1f91db4e487651e009d93845bb1c15f49a9c1fab323767fc2614ef6e634ec52141a9746066c50f421d8f7d74bbeedeb6abbf8d394809efd461839d6f128f04d6d62a4b3c16d8f474e0adf06545f258f42304b3a16300edc24e054399b70f5a771332a97a7183596155ee230dca1aef663e0dee649977136f279360a5e78b39008ac9ad3f28b23be75de712fb0ee5f45a57d01a21d3a7faf8f5479f2950ebcbdf0d9f0f34431da89c663b46d27048432b8efd3597a5966ae2d1406206855bd1d6e82322e5726920bbd05f5e9394f13e2bb39958acd3cdf10edb3a673f47dcc0b7251a42f2f5817360723fe4fa39b0006819e5bfb36035b199a3a609144a0373d36c68a0c7ae2f94deec0582598103c8436ed9bd690db16b0ebe91975bd7701eb4ec3cbec8d9e5ca3ce7169811ed7995adeb2113030d6b7bc633654e901aabb1825f0a09a63ae5d84d20f087f13196481fe10a9385b9e013df6807405522028b6b28113ee9bdad04d324c4016e33805170dbe521d5304c249fa445962aebb5fc38d0374669a7f0e2d16f72a9f79ba1ef7e71b8d88d8737d78ce1cd4b4a7923353d8b0c7179a10864feaa4b52ef31e08c0ab905eb8608fcc7c096d3f717bf058cb442ae7dd59e52c80de6181dc6762aa5fefb845d498772d9181d65b8c7c950d43f491f368f8bc3651e31efe283e1ffdb3e2abe8f29ad2412c4db74c4ecd3b9b32fdccebeb239fb283bee03335bfe4a2fcc2c66b37d1628f95997fde9d98c7f241d46305442ecd3af9b6bfe8b52d2bee390f69529daf718bbef5113db618dcf3ecf699faf4af6455bb9af573df8037aa0a82101fb90ed3d9ca13242d7c59ce370d3e141a11a20b3cfaa3b61fa3904c4c6303c1a9e26f8944e24329979e4277c48e740136b3aa67a69b40f1139de5a173989758a72ae0ce29c63e0fb41ba40f1ea2c465e004da2ec960aeaa363ee9b499d13bf2273feee66fea158e6bd36be5acfff8cdeb6d371e7345df38f147f9e8e306b347a3b3a1d8f1f9f8ed7a3c3643c7a0bff3cc65f6bca801f587a8c86ec90b2ffacf31f59fb74747a8ac9eb117c8ed3f669f53883ffd32176d65d9f2ed7a7f3f4710a783ec5d067c7207cbd26f7db9cfdccbcc548577330e0dd8b1b3c3fe8f69c6c0ace261570002699d672749c1d8fd97ade4cbc563630dd3ad647675e97bffe6ae331c4ccb6be840d04804359d357f01cb65af83e17f6fc3cfc6b8c6761ed951bb261905aad86d47fd61da041d17564ce93591382a8dc323f199f8ddb0ffcd015aac5f9d9aed7f0037a5c4e8075bb998b019e0ce3afdf7f975340261d6d9a558b6f27cb5c7b544940108bf97c2077d955be17a451b5146f1b5844e066aed0bf8f06c5e7d0d5e88403fa5f8d9ee0bb1c382c2ea4449aad349caae419800c21fed38fafa51fa5ceec8e6a8ae2eb44add6cb4fd74b3e45f1e0f7af08a06a17dd687f5a2e2822b3e6b8e8fd9993a698abc1f25b1a1b8ea4ecb8cf4825e3108f10df92b35459796582633e823a0893b0372d37f6553a519d4d342787d115bdfeec9fcb38409496e70e0c60635c0408fe3350458f1b024e3e655fbde02b04f7420214dd9a6dbb3a3a19a7fecd6c8658f702897c23d80c6eb2b4863b0c6ae2fb1bcba1ab8e77116d4dc6f7aed11e12b9a2befc56064957c38d008131bcc36a7d41cdc5759b2291f5bd1f2211814dbf3e5a2e1c211e00d3c10519bdff000ed07e77d06c41c1ed8d9286f5a47e1314709d1f0a019dfe20de49c720490a3dc8ed3c1dc63379103d8f41dd3d87bb74c4dc28ea0a2480cf8234baed0e3118520179b1bc5ed0df616153998db2204d8806b5c5f31e6cea8db51d3d8382018004d5ddfc940e8a47aba61b082084a23c012c474183fed66b23e9a07e40ce2bbe5671f5707d47ac0fdf27988e39f6d601c1d31d244400856dd593c6b5e1ed1764568d9bf324b51af281d60666fc4024130df7ed730031cd17caae4b0c8d69d2a2a8d2d8efa49c576d8788be689a86d341ecc164476b7ec3f0b68d647b4fdc95476187155281578bce165d54fecaccd91d9ef60359fb9b79f9cb4df11a190cdf587cd0d60b7ba6426b51f035c8f9119f214379d4b02731bf32d0891263e36bb1a0e9cbd9d53f01b14cabd92784c93c9d9279b5dd071261075111d64b15d67db4f6da2489b81795b12842624361e1a48a8330a4d3e504fdc3746560e867d484a217b11f1a3b75c51a1bb6a6855296330a2f87883ad0236f8de1d349e1e2cbe0ed906b99a546cec5477ce9e17756c8318f413da7fac6f48588b5c0230cf8a813f09d20f0a03d2c827683c099f16f3df6c8f6e2f43411d1199f4e6aebaf303a6deff41425c384493d8d0c4126debbacc50a01861d57e8b628c138a04a5e30c5e426fdd12c41a5b075ef5ac85cc18af922a5355b1f25d64d80a5fb153194707ae23f1bbbc87822d531252be734a46cbe905318dd9de5d0220f4b605881de7eb700f2ef70209bcc3f7fbbb8994f79c26ca080d9ad161feead1673aefca5cc16364b25dca1155b760874b1398e86fd3074d048230cd22772c72573366d0ab42f78e8abe22a0b5148a72507ed176254ae181504c751e0e97ed79d9e8b4441c3db03a1fd5b334455e8506694a728c7edba05e456711deda2b0b1ad68f9fdf4e85f0d7bc5871b77c867909dc2c6df12d813a48de0cb651048fda37304b3b10675c7ec10019c075feaf059fc4303520c29fbf6e0806a70f06d9a57ab4529ba974a8e846be6e26771e747e31ce275765c8961c487160d701035c39b4f7ab4be6608451951aafde47a8bf9c00d4e4eedd29f259e41301d6c2acf290400de4eebf064fa011b44b82f53d73674f7ba9351c6ea2901d5f584e0aabac4dbffe5e23679fd19b88b4fac33caf66fe6cbe27c7139c7d8a0f84a276a95d0c7613fe9409d01fb0be03c556af03aff3b7eed7394bc7a9164c90f5f7fff12febcf9fa5f1221f4fdbb572ffabddfa15662747a7b7a737c7c7e7c747af32dfc77441a8db493f6b2e7df7dfdfa751fc37eee2e87ed4331d22be5a82179bcb30295381df7b2afdfbcf913d63bad7657c0fc61bf7dfa7a98d36f6a206d771f0fd3d3afd69884adc1f4fabdb74d0d9d3e3683dd7bfec757dfc1e4fb6d7ca0753d5fbd5be3fdee9a5e364e8fcee9b15e520fa1ea69bd984ed7a3d3e9bc73045d9ea6e9b09781b48dd5b166f1cbfa72b59e496d6e48aba5dccae994ebb587f9e82d8ce3118ce1a7d72ffffce2476c64d7b4b93e4e7698aab2ea549555a76df8f91881f38446b5c91c75c6a079a8e9fb7e72ddbf6b7a9d367ac1964bb3eab87f87316943d7b05d71e7f969797e968f6511e8b293f806bc500242873c1650fd04bf415ad03846986522d101f584d33577c54092ee9dfea5e705e83473793f2c567159aa4df40b7f90cf0b8b3ca1e567cc32e940d5b39cd4f4c1bb1074f311f0fbe26cc339041db423281737d5eb92033619e353d572a5771b2b7344536103da9d36ab002a9c0e450716cb03babc90743e30a2661de19293000b7a05989ad865c9b3bf6fe906b6e7faba6d5f8c9d6bd1f0f68f81a07f11c37847ed156180222b6fa9fbd36ee872a1be8bebd26082f51b87d9b8fac368c0fde8bb79711fb6acb0aedb96d50a18a892a68753f047a7c3ed7c3bcfa7e5f239fe542b80fab237ad34c7bb9f165435dfb6eea68f1fb4f06023a9edc4cf3fe1e1ea18fd245d1fcafac36cffe3ffafd30da9c717cc7993a14444c7ba672c1a042363ac58176bbef9fc6a5a8bb86c2076d5200a611d27b639b3a9abe1e86adc270d137307cd83da3d1c90b27e1093503f22afa804b1684faf21b65636430bf76eac1e3084deab08a2c30ef91b3204708de2c9c8ccacaf646c37968e36a051e310394854402254905bd90614651c77c99d7e5e1b8c7923f249ff8e79b6b8e57b24151576f0e5236db82e7dd31b4a447da88a2e35290e82c3948e4e392eb78a274c0bd19e07a40e76fd712c4aab75efab6cbdd1e9ea748e41e5834798584ec2188591c460050f759f51d124162bacf8124706a86db010108d801b342fb7c85fb5fa119b9231c31af7ea4c364e48870edca8ec0da44a79af7d044c23f29e73621d3beba374889f3d96da554ec7aac8b0c24e4f9ecc93f5da660013cbe99d13c8019af742689e93f221f778de51a47932f6f5d3816ba98d75f00568fe81a54ed2f4e8584a7c35ce29fdab31246dd4f84da8f2c002670f804132c317a3375167a4f53b1689d0a5f2f73ac242f36db95152d533074e4217c0fd47eeb45abf1f9b5df57b7ae8cf4986b275541c78f0acea8bbf58b1563dbc8954f8a6ac4ed3abadf5baf7f6f43658caaf909975cb213a4bfd367a4ba733f06f7406b756c484b87af10c901f798be31f6cdb9ac10d005edaa471680eb769cde51a5e7f9ac91ce3844d36ed9fa84014b5215e901f63122ad071513799b50aabe1192c1e77c51ce3894d77c951d3921e4699aa518eb0fc6a40f3ae9c4e615ba279be147c60631221417c507755d237ac5c1df5f58c2b45ac68e413dae481eadb5436ba691807f2ca06cacecf51ee86f20506dddddb52be5efcdda40acb66651690e58383189ba9453df7a18562322d96cd1df6de9d4e7b6593732a79347dda322ff6cece73e39608f2313a0b6e29cf8e8451057538dc52c7f92346d5d07f6f4b1572ed8b8aabe7f8962aceb13caac6464f5b2a89f37854859ceeb7d46087fc186205ead3b7400cf3e20a6c55baa506670655ee7556953a3878742bdf8224d6e5dcbda3bde6badbb0871c33bf750eba88d2311ebbcd5a22f3086340ed5233b26713bcea0b2a508ad38c0ff8f996ed5dfcc313e964517b74272e858dcdb60cc4177daafb0d0ff5ec724bf93d5fe1595001d8997b7af0c5614c254ef0972faca1f4ba7f171fc0545df5e402db1a0b91d56f37c4730f8f37bd42d1d38b8fc68645f3fa7f356cd73b6667c5248f430266d1f52cc621a494723e2f966fc8b40a6404fcd1a640ca7ae0074c319ef1c17b84da1d330ff23c5dae65237109b29a442548e69bd4e074d1a33a3862896108b4e70f5777cf75d344acb05f2773afe9d667aecf9c0daadb122d03d972fb1cb6f721ea7e0ffbf49336df615f54795409ffa9a9f264c290135fc40793b6ae12d87212b11a7e54d43b6eea86cee7b0985fd8b1ed859a863d74d8e76b381847ae0c2ad111bfce84ab984ff60d941738e0d1a0037d893251d97d2ffeb1d90f0790297f25ab4d606db41df40c50aa489c846851ce1737d0e83121200144da30e73e260f9a81b505562e891fb0ec74a817809abe4928e373a393399717177938ca230491859a871595ce758fe9e6c5d47f70855b2dfceed1378aa9a49e7bb505a72d6bd5f0ba79a89d28a75e37114b9cf546dd6d63f2388994d404b1fbce46ed26d237347484e24f24df4be3e1f8f5a5f94e93404f475828fbc59b3f24ce72c5eb8435bede60fa3c6c4ce5439df4ae9cc00a8ba14fd8f6ea1e3f9a272aa54e9264860ec17e234e2d570950f9651920f7a114e3204ffafa3b4f86fa1e34b5e0321e6b8e7f7a1af391babb3220810e09f2543004a92fcde65ddc58abc5233a1079a46fc634d43748c381bcad0d648fdb464477a51eb9527267cf1fc29af023bb628d509bea3a06823c1eae4d1d67b67ee7c4b5d0498e12d5dd87e2dc03cef627e1d9ee39b5df74bc6b804731d4cd43c175d0688021681d5f62db18ea715eb75adc2ccf8b4eaf3d3c18bd3d1de1156bcabfdbf03b4d7b52221d341973d8a67bedb7d65c7de8aa76b6746ab529edd36927b56f3dd28b5a379e11c7071fdb9070748ceeb7e4324bca65b558f337e3044167b776479f39953176f2e4fac546875cfe58c2904aad1d0686b242b1719773fd85dcc18682eaede8745b30e42edd24e38158c19030de87d257e3a870ffa455c5620ded6bd6963c914653cb78e4011856010f6a94f1567ac8edd3d98e2bdc23b6d096f38ca1538a53b6a8c46b16909ab9a38ed1a3635406b2825303c0818d835283fde20a0f767d8ae4a74555728c4957dd003c3b635df1645b35e054ceb637894622797e169931067aa5ad2d0f8f4efa27ee21ba7c6bb9f659dafa3d16c6585367c363a8546accfde35d3d0be494e74f78bff20bbf406cb601f03e4099660838e6fb810031356a4030794741dbbf6dd26e92e72097af8a3fa1f3d67d130c5eb2a12906290f9c6450c74c734263c8a302767ced343be34267bb0a0db8253ca25eaf26cb154ce1d826be9c4f39e92c2a77162662394a728bc0597b828fdfa009d464f9f9a745395f556dce7cfde6eb3fbdf9f9cd8f3fbffce1858c36fdb215726e862abee2016a881eb052242959b251a88725910d677951992bf67b1e66fa3d519b8ee7ebe5e5ec5a903cb1d8f827296f0769a87b78df57f73ac31853798483b2cddac9b4fc98a45939cd93ea7c595eaff0688483f8051a3423a7f9a6bc12f30811f7fff8e6fbeff2e4e984f995c3a4534e3bc961ef59c24bb758acb686e71f602eb45215cbd5371474ac8ded6694eca5ab34a0acd14d6f394d852dc1fbe6eeab17c68eedffe4753340676a2e669d6f58fd89f3b8c7a647d05194f29861daa56b6dffa0365d700f8c022800484d40418155c65593249a86d65888471768dd43d1704ecfb43b813798026e3a5a6e76a8a4f52624d84b093b7242568e4c9e02dec5b80ce8ba1b9507f02fb217c57cca8d47a59f2faeb834087a8467507cab5db5f1cdf1280772ed169c53bab1c324a07e7b1edda43dd64bd4ab6b340fb684c7dff037590a84ea06a8de6c16c06383ec06c7890d0223dce4685e971ffeeef0d9d3dee459a200f37b951dae019fc2e4006962acda5154edf9b0caef1281ba9793e9bdfa387aea3db681d99354a666d0ca12985fd0a557a3b87c8d26b631d22d6653f14ee53fd9c3b0d042f27a9fb40bf9e19b97afdf2034af3d34e3013084e2d476d2c5ba0e29ade267b089bd67a9b6a385ec5ec38eb33b9d62c513718be761e88aca5ed24eb5eddc7da46e6dfc9490667becf913384b4b230ecedb873ff0cfaee20b3a28afba5a6a8ba6efed68babeb513a240ed98fcf245856f5d56bc63d92f706121f1599ca3e9b4e4073592f3dcaba5b6e7b59362cbda631dd409f276723aae1c2a3452b86d4d9ef8268dfb8ef37d38ce12d2b525e9c013434af93b8e603b9c6d47f12e6b243f176b8f340897da7179d6ea0de0b24403810758b7fde7585d3a4e71043db3b33aab40594b24fe316a94c4b7d9aa14f64a6bb594725d684160a29d9b76031b7ae2e11936edf4cda621bc9c2aef0bd60cb0b34147b46f37cd3d9e67606bac860a1bbb24ff572e8758877de18ae83eba09630d4807e1a290bca34e212a5a848632086fb9b033ac4e7d4d3711b09ad794ef4ef8ead050d22d8a8750e8555b89f64e0dc4c93f06cfc6989afb1300c859ab45f5790843ff13eaf6c51679c056e41859a1210a7b24b0e494c596d191408e69fde3b42ee2c84d4c983c8cf543baab7019f13471ba627686724103b6c7c3706ce26b3645c5e042e8ca2dca5f62a6e373dc4446503f6eb9f833be66a219a61be938a8437a47dd747c88b83d1730a11661a7d61a9b22ba0a5b022a0c5d3c0560865d00b4d87a76d1701f2ccc83831416a2c0a304246fc9156e029a912fe302afa24f2c9774b1099b5c9d6ce628e927fea154732daf85d82759dbf01eca9a4f9c9988f9031733109015108f238168aadb68fa43306f20b1710286958f41124e6ee6ab7296f7fe8c7f1ef5b2255f3f5678d79cf750eb2e096b4ca152f40bf962284d71c5dd02f6b25e468ae8669db83c27339f2f6ec3bd4631e07eb999ccca8b1240ffa128ae6d381e1324d115f2f67252e812b0cc37b6c560e4e0c03560de112ed9020ba825f6ece2e32179f4c575cbfca67e951afbe1377526c4dc15ca2d49f7deab2e06d9aebeb75fd5ca6b2b65f5babcba9ec973afdbe12a9bc2af8e0e622f3ba0851255bd1ff57d158d7aea8b60a8d83067b98272fdb8f1eada02b5215ef245102dd9c70d53e51ebf0f0642f2ebd504189004fdd228e2b60f8428bcf171447d1a431f4b596f726f2989093d2cd190c9b61417068f5c6d7e9e4bd5f953d3ce5cc3e9d1c85113f05472964e0fb01a2d39a0c06a3417b700e1dce71c46c0fb9607cac2d080511f21a5a3857e6bf445cdd2038e40206bde14708be1c44d3419ee44644c02f67379766d0bec3f289c169a1e372da81d925f4fa63cdcb0833e879fcbc8e62808172d96587f5febc4632016615b61fb65b5bded031752ca3d572e900db0c6f368689cc9a107eb8d56816f8b23a91a4e460aa5811b0b06819128cdd91ef30ff46f51e5771b378d01bbb2a3fbbe869e8c9df879d9e37cbff0356641b5e607d29f8dab544b0a4ed6c8f2dac15442c8d7f82589e1abc0f18cc54682e9d0d4e09f90d3a324343c50a0e254b52eaa1f6494ca36d706ed2325be27adc6903fc86001fb44d3120d1b8c9fb056627362ee241de07c40586240a1026c0c0c74be2af6eb5d6f36b8b23827fbd25ab0ff85dd7c0868ab1a6cab6dc025d9db6e1c7c45c8441d2431e58bc04e9188aa21fcbf1b7416c3557170038bdc0408c917450119d942cbb1912d053b99a1a7ab519d07677578bae981a51b8a4408fb2616c74ce481b453bec881df6df3106dc3d9a7e84352d8319b026904f82c7851b6595240219227e059763f8987ee1af728940f50a56725f0578a455705d0710e820df49c837785278727a465f5a2aca0fd39d9ed6bb890f53a4a87d6317d087ffb01338d3914f57c329fbe2e66c6753c24dd1a8199cc2a39d8611a86358e7a4426ca51e839bd737cc076990e85d6eb2821e0bc4ec230a277cd9e08f645c5c88e51861f3ea518b8729fa89730e3b0184456cd76e28a5520c2cbd33dc6bb35f5b589ebaf993293e0f0a0a6a4289ed75b3d14b481f98abde1b22770267b2b4a1e0e2cd4c36bc7aeabda3f482e0f0547d300bea0fab611fc2678dab178803aa1ec41cdeded189c6fb3e2947b90464ab5231c351739fa2858a604ed0b1ab497bf1ba63df7a2b1aa506482e5c592bc63595b234d84fa1a4dfd0b8bc8aa93a913b5a27ec1eec5140d7dbb3d682e81d6042a564ecbbca8c74f67ce7515f08c61d19c8f5cb2ea34ec1265f1f3c48e538c828fc62752be85935caa26c44a31cfdc737f42549712aa90df7cb405d7eb500b10b15f69ab65750ac174961227119fba58b26f69f39980866104e6c0b64e1fbb90a70533bcc1b54fe578b92f64e52994152e69e57c17e92fa973923efc6e271dfce82469121fc174cb219c95692925bfb8c86b0b5374233a7d3288efc2617bfd69c4f9d860b3ad16a34f1e3ce91795824538b07ccf1e303edc2fdbeadbe2ac6c96a1303789751c47241a5deba282ef4f840e30a828169f489ca36e473220e63febf509e97be63757222e0f90efb29d340eadd5ea74b08e8f8d15c50327ee4d899479762df3c7e7526fca07f3c13c9fd7cdf163030517837dc900b1cf1d2cdd4327b097a08982019df704234ea79d3c418fe669674d119992de65b69c15932974f79777e58a43f6e7bdb7a755a7972d3f61941b0c11d36b3f6d8f4e6ffbe34e3a7afb6c8cb1837acfb02eec9d8be720ce61146652c1b1fbd6727dbe98ad8bab33408077cb757975296f8bc2a03eacaf8ad50463984eaed247bd325baed8b020efb94ea0efd5d9620a237f4a7fb1148e05bed7addf0d4f6f3b0328325ff0a543ef29dbffac9fb201e7fa29f7fc949ffd5c3fad569f6705b6a15e9b3df9c1c191466ff3f13a87dfead5d94da1f00589a938fbc01af762098418a4fd4b1f26d900419ec2835ce2f6a8702779f6b4977420117ea13fdced72724dafd0f0f8faa3932c792a01d1f5f5c3fc507f1d3e0372f1b4c7f9cf9271362b2e815670ad8bb2984d81efe432fe6b0cec352c2b175aa17b2b97909f90bdec8f9eb83c86b214a19fb62834f3555cf4e96a29c597cf1aeac0f263fb7b712d2d09f997cbc5cd35b7e1be4c0b88483c7c3873b818fd18673f4fe51df8d171868aaf64bc190848f1a1576a293709006297cf58e5be2ef0a641bf74143e6142957d7104a96fea9dcfa0906ff1a3bb88b0af8b65399995bf0237ae8575f8394e6e5a7e7c4ab7eb383ffa31769cb7510786eeb2750dc9b741d6ae87b94a95a866174e3b468218a6900e9fda30effb9599cf4a537e93c56b8031f9c0beda260926f85c3018f45006c191ad9cda2a684235fe115f55299f938a55035e2e9021174f343ef178fc225822c003161817640bdc28eb1eb805eff749e354d102cb00c83e5886c515de58256b9c6fda2d7e691fd3db1cf8761fddfaf9960cebcad8149a23baa7ca369417682dcc8532bd03e36f88037ba828213a870bbd480dbcc88dee7e0fdf4e969595453000951579854628ff756b42cd6f5b95ed4d6dd9158e9dcf690fe8175b61e997d324ba048b1c3ee83b3420c091f48d62690c8e5de3dc8a85f29adecd3c6c315202abe6266ed6d02f279cf07b454831815d0d3b967bd2bf9420c5b296259038a07d9826693668c6db86335d5c7d3f9997d79e43263d747c3f247b20b61324d588319714216e23d2e67f6dc7c1de730aad501aa491f013c5fd10d635ba67f7f63d03e5672ca2919ad525d9b67978697089173f1ee9956db2d6fedd6ca42b956874bb7bec0283f174f90995058b9ee9363d19964c180e49f09c29e0c74520effc9f044ec07b3f1050d14479c7d09c82893ad079c83581b801921547bc6293e3063d295e22bea03732b70491923bbb3882947909648bb01d1ad77025edadc9e955750ae7204fcc5fe81bdbdb0d949deceb2b4897deeac82e7cacbdb156d8baf3a3f386b80d8b5c5f06a3ff8c396e1a8f5a994d3c85887a849321a6c008edf4825b74231c1dfa0d4ce97cf11cdbd1678a223b0da6eedc289e297bdcece266c586a359c0ae48a64d223e980f31b54b6df2c011686db37b97274fd1968c783d6484d2010980811d6bccfed1b2b44774fabb97e8ac249c0591d1f336487ec9e1b3d36adc39eda528d01ee6c9a393e4d9a12f55178fb1917108097e32adf6b46e34057d304a9e0674c1aab1d4f3c5f56779c816690869ba1a32f8421e518b5ee5705fe920ba190710785c21b75f4207f5076e66cf03a26b117fa8890ef4dbe12bfafcc852443b366120557e679999c7d86ab52384ad817fbd3ea8af896d035f8f11616bd456e5025b837181f57ac472635a8b1847ec3a8e943da5dd245513e2b50229f9b63ec0b6420fb49a9f438d9668b11de4448b7853ee8fec7fb5f136e94d82164fdc18534ae77b86df16e8dd7d81d49861c06ee26c113e6d9122a3beeb2c1803d78a980ba278fed4dd3989902e1a56b409e37732138d7287c2e1cb85e86670585eb979e6b150ad1103ac491522a5f4c503ec4e0b7c422ed64437c935c8d8e4318ba3114822e66810f1f9f4761c91ad39a91d249b3ebaccd3b985a1959302dc621d01d3063ae91928a9bc6d51389e413bedf3679618d82699eb2363d0dc671123930b4d6050392e6ca5b1d65d5ea285cfd9acc870edce60a881c3544607b784b2a067af8fc7192b25e9cdb48be5e412f7b3c0bc495b44aa473a9b5bad8657ddbf729726754aaa6acd80080633dddb29455a363a9ea60285f1f33f73b30c044e797d4fd01086662379b741d953bb865cd7c008a64ba80eee2f8cb9132d86cfd4abebda1536dd92bb542ffefa2533a7817ff3ef4e51418c55376e3b70fed90d34f4ad9491d9919d162313465e974c1785571328b486fc6e1c103ef244a1745c13aeb8d5e870b081a06090afe17be0a440b8e7f4afb3fe72da03de12c96a99c4e1831b8f495d3d4104c2003482d65391b7181ba0e067f9ec18dfa56510101f8155c4e6c3dd0c7a7884ac585f33528e3a25e075cb658d1f242f2b00715ed3ef983977661834601228c94a68e7a52f4d314987bb4488152b5f0089e51638567744feed7b117b2df5538eccc3a6886eb0117b89215688efbcf34e9bf597c1ad46449c00a8263db8253f7cac3eef9525be88c8e7046f6273157c011e4156cb26dc977aa9bea92ddfd01fffe0774e2bcf5aa7776256264dca53a703fd9476ee36b500325a5fd3e5e9729fa50fdc34bf904eaffcda82236960dc9c4a93e43037a9f1e86f2002738a85a254804dacf55071d8cfbff44c9a2ece73b204aad8a31969e1507fc48a764def3b8dfb80151fe153842ec4c9a5be3fe84e214993e24fff70f2a4d5c221e4ce9fa6c6f34b9506aedf9f86c8ee07e79b564a9166c8c47309dce667ef4c080448d548ea9151a32dc957bb2681df997034d266c93337078e7af8623049116e15a86e01434d07af2714f75c8127ee3a149c94b7d2a8cd21dfb3a372540e4364f086f3c74c1d4bfaeed7c6df356917b82902cb2fa6386f16fd847f25aa5ac524f9996456a3d677aa3e4efd9a547caa15138e0d2f6602ee2db65241c250ce27b31db62a752b1560b5b84fe534bc899fe576038cae89053606df171ffa90cb23088e5d4e1ae99cc6feb22690651a9ec9081aabfb0756391ae10fbdb6418e3766ecc880d17b17f8fe450f294092d1954083c54044ad5dce1773102bdb6a36728fc58b8cd5988e3799b8d026088d4f9c2d6e7d4becf6f98e7c7383d32f8f9e3e881a8a09a02493a8e87f6fbb8ff41177c2400756ab48336b502b46a6b82e3c142674e8415335db4deff682c7d89a8d7891ac92cacb05cb4de5b22e848bbb3b156d69a4a1a99906fbfbbe9d6a10f6b7b8cc23550b75b243d342175f7a833e82aac0e2c457e420c75dcb353b0a54a84d6c5cea662777aa7632a697103af4f144cd97a8dda323e013d071defaa033f0a3d388d828d18a4eaa6fd08480ed530cc833362d4048001099b9839591f2c338f4441448c29392be0c1b5b51cb8da81d53d860dffb9c87e4c216bfc788b54747efad9ac3dfed61d9d1fb71a63c22f4a16975c206acbee66dd1c06b7eaa47e47d6a3c105bb768f104837931cd45cd166c6e68c62320d2d82c84752a7ede2124eb9ecec685c16c186b9ec8a6e248fef4fec14860e17b834bf1e0161220d4cd094d7b6e5db860a6118d90353ae03489ba6d3eea31b7113ebdf7938f13ad9edea964231155a8b27926ba9612ac2ae79235254761d15077cbe65775d571cb04c903e6fe2403422a4749cd5e555a6a967fdc345223f80642d0d23fde1b28c09d56353a69e45e0232b272ca3c912e277d64d575715e4e9c3b0033f89298b158f1f2d335f0ef8b3c42f120f3cb0e85291b587a47166c8238d5720a3b01a5221adda89c52ead44b31f55748834c44361e7ca3e4222a30be0345a477588ee92c18bacc6cea6529dde7c1a49ddcd5389b304618f7e022de0437623e0e4ed80674aa829d8306cb4e7c1a7f3a9fdd4c8bbcf7ebd190dc61d61740328e86b74579f96eb55e006d28579fd7bf2e16576888581c0ddf510e5a064e66d7ef26798ffee05b812986fdec654ba994f7f407e761d6c56c3159e53dfa834d4c27d5bbafb999a3f66872f4eb38eda1480de8512cf3bd5e7bf4f5d1ff1a6378cf259cf9d79ff2dedba3e1e9b4838ecb9fd2219942a2392927f7b2f3aa7afd6e719bdf5d4b1801e0a1cfaac50ce092641fcbaa3c2b6730a2be3e77818f5dc0390d0967b3c5f907e0a8a185bf9453384147c977c5c50a4ee23fe17cd13eafaafe487387ac378b6bc8f966b15a2dae200b76e2f3c5d535f4327d8d769326241a9fcaff5e16b724dad552bb71dd8c2c2fbf2540c5125e5551fa30d15f493ff1c51360318004cc90b6850698b0fe367a2c7f0229fc338259dffd312eb5e7361201f1a97239200d4cce315801cbef3ebbc11c24b39577dea52941b9593e7ffddad7adebf80dff875c9c20706078ce3188f3e4fa53e2a43502536d4c812fb172db54b4bf731ee22116df763704fffb27374337679a920b877f8bd896acd7facdfb0b4f3138602a5e5951193f3dd65b0dd316298a09e9a86bfac9c34037ac5cef457c8d064e43366aaba58390048e35c20f5363bb5da403395b7eebe6a651be9acb18b393e3b493e0ab17c90f931f926102184a04a2ade52544f4e393e36332c087b6f624fa31f7c11fcec6c26284badad27b03035b3c676ac46820c192871223cfb1e254249381a47df9e16434db5eab65bf5cbce9c4cd023dd2876db3444af6248686a98d8c7cda83f92264fa22ac30290cd09680efb7f3604309f88f9f82239866afebebe3b24822f2cb25a79d9bbe1e85a4ac09bfe1543c2f38fc161bd2df83a2c417403f1946dcaa7221be19c80be7eff2b0f250e96adf9151af550512f8973fd2bddb2caec60adb8b0b981e573709d20c9e8e3864ac754641ac12af43b57a191a5716d97ac86ca1eba3dcac6613f25d4fa6c834271dd65b9285c57a7dcc6cb08ee06ab2bc2ce77cfdd8b9af45295c6b501ebbba7f48325f6aa093108412dbd0c6180619281e504031017b7007d9ad6e271cac811735a3425e8ff1fd64f50e38d14fede38c7e2e31502b6efdba61714ccab33dc22ff2f8a2acad28e89453594cd8c46fff8b6898185e419fc8afd3192bbe49ba63fd8b39b690234409de389885e0a8e5dd4727c1a6f6ac34760e94ef24e1b7171fb8d949478ab317d2237ff439386c37d8c4ca19c6fc030788d8d26142e9492369219e2b4b8e1e9d2469f42620f1ff9e67c91bae514c3647bdf3dfee04642b178e1b15704b3bd821c10df4bc6103e260aa08952009ebff040b0b22f0678a44daf65c441d3174b1b821583163edd180343472c7613d843063b3b5867805d547d166b89a1c2481795e5e45bc658201438affe61161607d393af167b6ac9071152dd4cd7c555e15af5deea039b93e482eed9bcdfdc4f1a51910125e97bf1688e6c555d2c7e100c1e109ef71adebf25331c3a1748811334ded1a088f3e8a5a9021558ac8057ba9549171015a93983b2a8434058de4c2e91de4cbf9e8898aeca83821974abae1c2db56565f6ceda7de9876cc378a5ebd844e864ea961834879b1d324765970690a664627661e93fa8c0febbc766e66d587f2dac7a46e7e906cb574848d9ba71765a449fa7d80cd0cf1c8e95389672eff99cbe5f73d9ace2f11bfe8219964be98178965c7cdb44976b3114f79dee2aebf1d50aa8762b2f3be3acf318c4b0a9b84d424ce0faedd5d9f56e9e3e1698fbf9ff52e4b72d52bce293a17ba56e5bde8cd35943ec9472f4777acc5720dc27e41ff2052af8bab49395bf338d657b063dead597059eb2b77eb2506315f57c56479fe0e9a9d51d36baa7db39cad6f8be20374f2be5a82849e9f0edbadf52314a37f6117c5d3213afd5579af7d3a5cb7d29ff3ee635704aaa377e1e96da79fc2ac4e41947e7bda1bfe8e3d059f1ce7bd7f78720c72f5cf7020b8885320fae1674370254cf61b101acff6c81bd1ee3f2fa841fe415e8f98417d19ab15286674ea0791f187b9e4a19d7d71914305cf8aeff31baa908ec1a1d460461ca8a12039136336f6a3ed0e102e3ef73883fc943ba03760927f79f92691dbacc955b5c5dc4d32bd0546ce2903fe93379a734a9e77fc22231b4c920ee84bda165bf7eee4fde4d36b10d7d163bfbbc2771b7100c06e0d78b83ffdf8fa0d9e5ace5c8800662ab7ef60b67d5c30acd0773a29144ffb09de4d24f4ddd7e55c60d8b095917f977889be9aac6e4435463fe9d6e386d4002018f8b4f96275b59862cc2ebc3ff2e648ba321a7884a3e9f69e25ceda0dba81d3b4ba06f2498a6a7fb4f28e443bd9340cae854ad6b0925e072b4ab26d2532ffce386b14d791c9a1c3332b45a31b4610a3c521b1c13326583a426057dab9259816286d9b834d64891e9887899e57ddf6bd2e38c8e64b4c7429ab87eab2cdcde9cd6bde70fa946baba55e496438b05eef45e44ffc74ad250b08194c004d1ea94451b1120701f227d547a72b166b3a48683ba8632ebf5245ef97bbddc7f34551c343e11abfbd48871f2ea21c71bc2c2f7aed0d5a41e20d6b7f67aedc026fcc4d2ce25042bb11dfb3d8e75f8b6bfaf15cf60c7dbcc4d705399ff707ffc62b7fd2f4af88726506300b7b5fbf3097f517e1aa9d21ee2fb28be6300897f6ed52dcefa4b0f73689743dd348cdc8a026bd2382c217265a6be0e81b961990529d695b88fe4c6888c01001cd94e61065a18108b1e8bb01392284d5c8eb0b66c0b662e13cfc6e0e3bc535c27c7e285a9b75f71fdce0bfbefef1871d60d9d66608bbe47db59873889845f5df03e5bbcd2e1813d5ff6d409603e5c6b0d37b951c3086e3249c6a38833257d6b745df7d3a67668bf309b64991fbb3cbd9e26c32a350bc99410ef1f9e413086fbd4aaed4fb74747b7b7b844f421c4163c5fc1cc80c19cf506c5cba99a2b626d5e7f939fffcf46ed99710a87ffdfebb3fae56d77f2a803baaf02d48497763a278a5c0a81dd0539933e87cbd3e90425f9f6354dabf4aa0a8619d6ee22b298d1db58318c541947c532768bf9d7c5f9e2f17d5e262458dbd79f313629789909fa186fd7a0550fd74358b807435cbc8851c7f25ecb5c297987c9833fef7e37bcd6cdf3662ee3b3344eeb00b4c913e6c41f2a8e776e1642ee7890f2b903cee3d4e36fc64f0f772fef7ef3659b19a5ce25fc4140f24b4a979ed708e58973cc43c5a5ba8d7848141ed01b3f58bf9b51ee3c1867c2e062cb60edb5c3aa6ca19c9b029625ee93db1bd1c41be870c0f5b2d8c28e6f0d187e5a1dc80e9e5a490b9e3b42c62e536ae79b9342082739d38961a9370eb887b1a88031286a78b2c3476057f3b799b05039b374c5a491fa4f4b403097bd4ec7a9d28782039c98756eb71c0e3c08033a617a15d32234918f29f0ef5c01d6c6ddfcc8e89e9963927b06d15d0b501acd7b59903c5c22e73e9fab9f4bb5eb705841d10f93a1db380f12c3ad6bd0ddbcf921c6b41e50efab5a53878141ae8dfdd25ed2c65d3487ce611151be7c1d77aedc3535c5dcb9d353ed522641cf04eb971f81936e4af7390dec80d6f50c4d213983dc6e148eff0dfc05aa172c6d90d2b2273409cd740f8a488bbd36f09624e15b504a5f1bef0684bf255c5b2b77bf32b842808b21980f16780e9aa02803e218022e4a16ca72daf7c0956efc4f484dbe853f871b373c3213d64cf704d69844f33ef003a21928eb6088179006cffcb4b60bd3db3988880092400608092b9dc11516fe4a7bca25787d1baa54d7f472763baffa35f40556a67d87acdb94f82dc77c09e20aeef6d5b480b02547f62cf62a40598e1afad9b4d4bb08c58d66f7df38ba839eb56b6bdaee23834fed1ad96e7bcaebc4b39f5f93b54b8afd41807c412facea37cb13d438cd790fe73c54ba9b998938ac37dc160a69ff1b028a04d7cf12eba119a923f91a823a8f06b2c2c6e123e01e1882d038bd298a77b172d8a68546470ddb8b71f3a52367fe1cd0cbb92cb59e7bc1dfb1b3638e506f661c21b508635f7aa5f59f3a6258ee7850731a6020b06ab02fff2397900bffcfd1bade80df4486af83bc8eb2e40dca7532da345877f899fcb7cb90c9deb5843a6b7533b2a4211a4816ea3afd7f79df6cc7bf26800878491fb230001f7adbc797f8465809d0aaac884ca0b65722cb36f999f110d71bcad8f5717475af2e875393f878e763462fdc890a3728def6d6dfd0758a3237a6ed7b56c6bb2dddd811280e666fe7a24093048f6164c42d617095b73d5af897d45e82919c2434498da914f1d0f1b533b49b68f1c65dfe53afbd6343ad72a71a844011bfbf05fac688c38411418b22ad5738a355a9eb41f1d05c47d37695f5c2b0026678be5ca6b30ecb1c84da35860eb9203c088c63296d3a161bb13d2efa0576585cf352e6e38b2156ebcf51aeb0474e81863eb4a39244b3456e124cd8646636f478f3676a713d982d2b4afb70cc999ca2eae2d33699a69b5a02a90d5daf87e1f8d6fc53f1372848a46f180de4515d9d8e4d0fdeaeb21fe0eb059f43434c16152a0fe0631cf6f72773d83a57f58b8fdd9a605149ec16a3efb4e374a14129afcbeba1c342a4f5960b492027642beeddcfa9eee8aacf2b8bf5ca2b107b595d0cdf492873de0ae72f8234e7a5fa0ad3527a93fa5368175001b32928aab5df15e62a98bfbc5017a2c4253ccc695bdb37b86b7095372cc1005d3861fc2963bbdafb170eeaa0ddcafe8f0261cd5f24c003069b0a9634d5b77026ad3229242a3416a2243c6371b2a7e1c15bedab53ec910cd6ca5a6dedcecd1d9dab52c87175351147c8541230d0f8720a7cf3fdbaf172fbf7bf9e6652202589f2fc7fd1cb6ae1569ca8a80f3d8b0cc27e06f18b7f5b17358c154533e9195969fcd2497455ec6135e8d1d9451b0d41047dfbf1f370f40bf492091df3ba83edf61ecea5d15b9b6fbbffb80f0e3d76ce261d02f2dbd6b3b05c4704ffdaf6ae1d7a9f1b45bafee7484305a7adbc3adb8f1e30fb6a9408ea805828d7e30cc0255485027029919f343879c38cdb882362bc61ccc8ae0d83fce0c25f683a7fdec356a07b44f6858ad564d26ca8d5eafed4b3ecb9f1c1fd3f123094fbf3a3e4ef9a474a4f0abe3df4729274f9e7c15251d5b42119ef55974340453a08b4eb6d530dc1d91b34b649df82e4a79a7efa08ce30e93947468dbcabe843cbe06b52d3bac0c984964fc729bc2a6611496d5b288540e7f59ecda05a963997ee83a80f366665d0c6756db26210cf6119666d3ceecd3d52c576a876acef5fa60454ce4f9ca5f0063069a611281c9e16bc8cc05b70eac6adf7ed31b5b48aeaff0c555b4cadff6481b766a0f550f1ea2a5611eef0d3c2bb0cd6fd9e093cf739b44ea7f7117d83326cd54307adb6f6515628d33e7fb08baf68e748c5581371e6df191b637d0460fd0dca67181a196f54a8476fd4bbca253cf6b410bd68d64a4d9b4aff459dda668774764d06432421b709b71cfc577185383ef04513538910733c23804136beee99e842019937e192bf0c091f47a0943fb84163d93f48e5ccb7fa2ebf13667649311ff181b705412a8bc65148acb27c759d2494c048186c61667efc33b239e152687b381147b6ff891b1c5c366bdee9d8e4ec78f7aaccde2e6539eb8f4f551675a1f472719251d676a6fec149c29b6bb834d8725a97c9371422ddac07f076640207c9fbd67af1da7298794c00662eb043fe004b70cf383eb5ae763e68880b3c72e667d283eabf9be8d0b745fb89c018aa56c3a0234912ea4fefca757c826009f375f61b3a8e24e3a0d797b2eb68e38dbe065b3183ce13b4bcb8b4f08922aefad169797b3625dbd5bdca2b950818e329fd8ada53dea1c8df374d81e9d4e3b47dd71276d771fa78f7a19f28fcb57d3ece2137afec00e1ba959b69a15b38f0aff164f1567c3cc79f2e1dc58466275adb5c401863ffe248d4b25c9932ff5911939e3caf1b8c18a0867683893eba29886f6439404fc07fec9cdabc7f2a6cbbcbc02ceb47d59ccbffdd44eb0b524fb2acda2861a9dc21b03a8a8c5601c3e83dc0921c399a7b920626cc5a8ab0845c813c16fde73718ba116ead66d125b4a0f1a1be48c1ec1951afa6cad7c8e347f8c2e9edc7563b6b31c97c0c5ced826e968994e62ad6ede2cda12ac76601ba669f8e1f3b3d29ced67a229e23ac52ea23efa55e300739de0e63e902b2868273b77dde3ec43b092ef9f7e18bcc795a426dec7eb53ebe47db4aeb47a617034e065600b7e0996eeed46536ceebf0b4d91fe2ed0571afe39f04b752fb07762efdfb5046ad519c1f867a6797d4f23382193746f0333cf2ee64f1806678bc54c1eb5dabf98b3bfc7029d56ed0e3414fd629e3ad54d90fc4443f6c930c4f7968c126dac5d3dd3b0333cc4d66becb031dc9f703aa4d4c242c38bb9be55c6364e25eca8beb81daaf10e678da8d690e9599ff165dc8e03fb4558c50327bc1210c541fe2e80bb7eb3881179b5a81bbf48944ce253fd189908283dcf8ed32e0eb02d71aadd78eea4447fb5d8d4513c93627e18e85622e58a09beff105b705fafccd36254b0dd5c3c58f49718f750cc2bb08ba6f86adcb4571b04101b492e709137ee1e739860c5a4bf9750322c4bb4e05029325d80939d5b4ab3eb4cacb59dd19c7f94643b6e64de8e1377dd3572a134a33bb534cfaf1fe010760dfb9f2f5db0b258a1d3cfebb13e21a89fd75492586b4922372f44c4564b0c98d726873015232c509683f402efe9023d0c47ad237fc76be339068d791faf9403ca30dd48f1818f987e2b5932346980c5e0a0414797dbdcd777694d7282cc00500351413dd45f125ae5b594f5fa6e93e284a5dae804002530d0240c618b1dd9d11cc82579c3a072f53b1e6c085637cbaf617bd41188963b303da45d5373c995a036391a1a2925fd84e6b1178883e2404bee40cc6aba688718ed64448696b95292210f2d2443c8058f793f19de422eb2894775416253d4172d577981d3e2903ae882c6a6d41a7f0be6675ddaf40e3bcd6ee6e58aafc0475f8de154468f11a88ac9788ec1a718f35a9f8a3634b75e9fa41d2c36e0eedb9ad83303491f53e6a0d6022573755cc63dbd7207f0c048dbee321ee1749427c3a393fe49fa18f2d20eb7b8c15e2a609fdbf49d4116cd45c11565a3812a9925582b637af196cc84570b639687e11896ff866427bb5cac162fa153b6a340cedf194cf117b946b9f2827b44b2da2394511b0f2ccf7970233e0c4a8961504a0cf682022665229b2ae16e6853638e1b962ba2419ba5417992b8c40789d5ede5c0d722f3e38287191f5f91e9ed5d35037c7cb1b89df703eeff24cd28e7cfd7fd80ddd2f437cc4e448726e4e2e9f86ade77a717b7c7a7e68f372b93410dd65e8423efc85d81b622b6b18941640fcbda99d960dc4b65e2a35cce437c9b4e8f22caf04669c2a0aab03de466eebc8d3f90f5838b79ab5508c5ab334b540548347739bd5992ceb56f47d0b72df05f1b26dd35c559a996dd100dd7169d0bca27f4521a1ef7555d60cb78d7ffa14deffbba342e3acb5deed887ebd7fcee9e5e27f33902bcb53dbb06f623ba61c22cc2d80377851c1ce5069f1b7952e92fe5836e319b0607e566e08f520cc6cff0bdc3c81b13a3d3bfcee61cdbf3871b7c85eec21b8a6b6a07531f5f93eb5cf090dad6aaedf61179f49e2faaf6f563faf9d3abb4f724ed1c77ff903ec6a21dad881c3c6ff13e46eafdb4c5358fb916427949529fba81735b2079933fb1389dac2cc670c92e9a6fa477f68b8ca30d818065a52b00d272dedd5c4f037ed3c7dfd436aa55110d8b92fc4274397c0b336db7fa0a48db6011141fb9318708862d39630559d7525f55a4295a3e28480df921ef42a802874be8d6646ff2a9365213bb51ebcc29b68c1faf6ae4c4c6c9c68d88124c25b1fdabfba598326226d4e4b52e2c9c012db334345077162e5bade5b3a39363f86fb8ec6f757e6f68491cde333e6e1d24f6da17cbc5154a3d742a2b530667315ee68a41a24fccb1b420273000ab05ff26ee04ff1100f14f6252144b72df8860f3a2726940458e07a18b96bf14f4c7a87bbf84b894e2dae5c081ca9bc54d9cd4e96d2fdeca814b11ab5614988cf5837236bfc218ebab577390f05091efd175559e7fc84ebee24be9403b17ed100a3a6bb02108abd2b41e83708361541ee274d8c98899a206ec8fb6846c94e149ff38939acb761ac8cfd4b10aa783587df39f3b0d6c7bcb3468602025131f57183e2e64dec4ff746a2d6ba4044cfd591e74a7475827445b9993c33a40d5469c3b11ec258ad88ea622c28705068dc77185287736d5a813546daa4463547ea0c3986172cc2bb28b882b0a190b242643e542f9ce2da14a78aa16db8bd55bbc8675056e1305854243f8bfdf34ae06bd6e779bdff24368743c7dc4a6807d1054c6f4b68fc71e9497fd61f795e7e4afb7afd91644bfceeadbe39a6eb5c2666a527d571cabc36b702722cef3d55188b4038398f35e239a33890ca4f270b2364b4ec9c63c7b2499d8154d6d2adfeaec2be9bb4b5c13c8c2f807846166c0148d709b05c54791e220e86fdcf63307e6eb383bc91a679f369d251d611c608b1b78a68f751c69b4c53781501987b672743fbb43c2df8f94598d92a50dc9583e0d2445ff329617005395069df07774c4e29f2f17878c27b66971dde653281082319c2bcab5eee8d2736da0e71a9b8bb11455f5414e8443ec1f8f8f4190ab56fd27f0c33929fdfef85868b313ee3cc3f429da223026a122aa008514581ba4efaec5a03aea893f1902d06a059f23665395fb824ddb989bb7e5973d124d921e8826108f0cac2f7f3bf097351a7cbfc0ddf80eb8980401fccd712844869d36476470fe944be062027cca8c66df9516c502de14226fb3d117d450163651a25086279312100245e63d7b1f47df960b51099e299a7d9252385d1dffb18dd49a07405b4437c674c530f00a1ac8205a9c5c16ab6f30de116ceae7b3b298affe845235868fdce20d61f403127bc383cb850a099e19458d224b999cb9f38d10699c5b462bec1fe997bc0020425899eadb1e12b4eea01ebd278ad023b78f79de14e887e3fa86cb2c23c02c19829c0e7c6bf389db69041ff142e7f95ebda78c8203638c78fc81a55e520c5a4888c09c9d53736f608748a9ae4bc12b9be967fb7d2cc5294a4e581e93820a9c00ac27340df3e8c2df0ee957bbd793cbe26f3c5927fe69282a28f9fd625acc28e223355f9d2f17b3991f8efb4e8fdcc8328a7f83bde00fd3cd5fbfb01b330b9fa01d51741d7190474abb928efbf8cf66b009a381fddf8ab7617e09d494e33788f71aa7ffc4e1f14d641d4ec168ff1f7f8c8b109a37607910be6a279647fbc1c4e3a2d2fe9b06f07c5b88ade103c36df56b31a1681b98e93aa43569845f1c31dc47ef353e4a7b29c763034901a7e13e64e2d6104af183d1bdfab6fc544c7f92b8aead566d8e5d8df9ca76a09fc8a6fd6c594c3eb055fa7f323006008c238922a5bb7980d00812091c1e2f2d9aa4b8ff3a113ca9854e0da035a04c1745f5c362f5f574fa0d85000489bfa184cbfe76b17c83513ebe9e4f9f17b359d56af5deaedaf4facf74fd2e7dd42b4d103cff148d0cd1e861c2606b1c7e10864da1a64803c3e3bfa706cec957d9d4f64bb09b766f36ab66750873b65a4ece57959bfb8f223202c4fe9d0349e18305765cfef22e4f24d654f2df38fb70b30695e4567617b22f8bd904ada8f15e7567419441ca739d189d1031e699440ec4f6d0fdb8f7b00d493d3be6b5763e66d1f128a3da52014798c5079d7bcfa5f9780b2693df79da1e4b434a6efdf141912b26200a2eb7fab6d2a30a193da8f0a2fc9851301dfcc1cfadada634daefd53e6f7b784feace1af2b9a09e14f121e7f8491c1ef3d005bbd658d7489bfa8c8df0875b811f8c7efd3f5c7fda8772e574ff77c7c7c70331e1837c1237fa27d79f062c65d0cfc367d8d5b3a73df32fcde6bfa7f7fd73a05752283f3ce66f7cb240be61304bf87f0a43e37f96f80fbf011149bf6ef52496686390701a3ba3cc71a663cf64ecc7190f3281a12512594f3e1a828b6fd0d346bbf46f6ce0fa0d08696b4f3550514668eb8dabe894fbe6cce3728a63b916b399aba94f360f59da77346c69ba918d8e96bcad3d74f71cb5003af987d497df7ad0e4edd5d4d3989c6ab9e6aa904a088dc8a27c643a9227c74ed9de487fcc206d6f4f8ed7ebc68c931de368ea3f718bb0cda4238b0af86939f2ace3bfff78da329d230b7328fd6a4ec1cf999ebc9a7fe3f8d8bc1d1277e1b61ce1491901ada7b8c32dcef3b8967bf4534c93470c45f9b28d590ebd4233cf657b4aeb1f896109cb8e59e5a1f03cdac1996f6392b642a97ec03f9408d70ffaed35d952da0465de713c654e18da72a55a1283dce3835cecfcc3ae596ba5d887ef809860a48d58c911796f962fbdc9f09e3cd003a98250922fa06d53963bc130fc7bd328560e6818179e44ef1b627f76579b798849bd66fb4e9536ddf570eef4d51aa2352bfd1c340c07052b27f06b0bb8c78f5c39fc4a3b3c3f5e1d578ef87b5f103fa9e477b47ca823ba41956f12849c95ba946346c61624226f2b78f19e4133369b06137a776645512b44086f88b56c65f490996635b449816515bec864b5f52138c184de5bc4ee351e634e6eb08de843e824420cefec81bae9db82aefdc1c2c1fdde88e78dbb71e197e3810dc49bd2ceb0bb9b2a4473d520ec2a076c6df51e92b1a559272cd8760d0531a08be7c040b7b0a98d67b30734c7f6fcc0d8943525480d954c881844175109d812687f701f2e794472aa69dc21817c68689d957160e36d1329230152d5bc41623dfaa37b1006916f6c1db1d8cc16617255acde2da6e46807e248d221b35a6f23c6d9c64accdb70da4d7a5bce07aaf7aaabb8a0ce41d30b2a0dbab6f40e9aca31843f4586f2d628904c794ed26a1f94e8f9a426eb986f642a2001dbb2dfe0bd8d35547793fc88ce7ace863d1c08abd95c64e9f910bd2a9da613c9277631847f46e53031bad6a41f141cabe9575d278ab3dba697d731aed741297a8f4db248e1a31ff22a63f0608599885a50250a129c00e6c8d303ee7d587acea2ef942c620dfecffcca85d144496c78deaedc535f6e58438cfca3ba7c3189d88295789fb1c7f1eac3b8fe1e331362f21861c7793311c0b770634711c056ba91a1d1f92732d23ea3abed6171b36ae881c9f117f6c39586fa7e46dfbdfb51ef965ef0326699c02a36abaec3dd86e56c145ab2d969b6e8a3267fd36bee98c203a44682f7dc4d1ebde4e6d41a0fc4328fd5a84d9aa0d337b900c35173f29c5292a85e6d93247c63204b2638196e96b048bf5d43edd45f5406d59bfba018c1d2b225a19251abdc50862b332ddf5d392893f679c53d5db528c83641e8bccd76228496888e6a68cb75d58b7b88dffdb6e3710943f079047a09412c7c253028f7228101bb8f0441a080842f4d07b12d30f4718544d99803affcdb5ef07b4f10f7f0b00f5fb0e55fd3b0dade2db9f7f6b4eaf4b2c343bccdc6f6c87f736b83f7b707cd3dd2f66ecebf458dc2d6d65000863fede3ec240dc36c764cee49861f1ab57d9315d5f9e4baf8d3cbedcdbac1b447a7a7779b767abaee0e1f778ede3e42a7687a442e393de5908e99380cf9d63ef226fd5090d50fb93f27ebf5470ea0449fc7f2cd8e601fd54588c3b288cbf4a1439f434f1196f214ed47ffbef1713dd7b6c2f6da876cd8034342b39e8fdec6974f82a081281a05edf9651c6e7cb25cbe79472e6ecbaf2f41b6af38709424cbe80e729f1d47e397e6439390b0bab30991e45139c69626f3739c1d0d880596475d3b4853dc0c0f1f7d8c3b774e79be06b043619db84a6814e3f6de55312d277f293f94e840e3e9f5234685ef5efecbd7cffff6f3bf7cf7e3375f7ff79a8de398c7ab2a6041c8d382de1a51aee07be0915d58198408398057b924e6621b37e4defb68c53cc0a77b9df1325e40c54f75c32f3cf4e22716f65c6e802f3ef5918911ef5235f6263ff76ede49e19574e582b594e223970b101e33c38fe1b26db21fe9c0bfdf22afc047af2104e367ba79689f903000f43d8fe32de6cb6bcf07cd9b50b3ddb88230e6cd9d3565d796ac6a5e32ff5460d37c83fd4dbc01ee70bf4c77c180c6b9877135363b6007289d0f88beff1700650b70e5c9b8788ac5a7b25a550db3b4f3032a55354f0d50abaaa356a5a6636d3bb93200767def071b59df16169b696e64bf8cd6cb6e50deb9c0735e671810822297146ce3447530f4f864951fd2c97d3850c93787fff9036ae57844b0f99dabae4ec9262580f87034eedb0d693a4684e2611988cbbb207bde6bc38c34dcb33e27d8b4d10047d1b78b69618a94e3c805ab61607af6c731531552822b6d05965bc1c3a7871d4dec1c3e3b9427573036b7ab7b2926205471208e860ec2e104065cd5be13d23b7dd43e9d76f09cb73c02ba485d61d426a6ea14efc6ab1f2907958c47272a8e520972ba75bd0d2d98307bdc3f7c74d8a1cac6500c87b36d3dabc091a809db2cb1f13c56737b187e7d7b7b98fb45edc53bbca6fba9adebc06cab3f57c532b2b3278f543c0f03a11924ccc9aa783515055239cd0f0fc52da280dfc7274fbefafd1ffef17ffcd33f7ffdcdf3172fbffd973fbefad7fff9ddf73ffcf8d3bffde9f59b3ffffb5ffefae67f4dcece61535dbe2b3fccaee68beb5f80d1bcf978fbe9f3af87c1ebd14bd8195f3d91f38b6f8f2f660b28c08f16e2c3c857edf431f6eb78cc72dac92981395084d6325b764efc59564ec593929cb0ebd072fc041a1f5e949784d187b79708205462217b2c7740b00450f5d5d4ec719512350719a4c587b2681ffa763142aeaf7c48ba1c770a68454b79d66b932ec1bb5d825d91c103bacbdccfeceeb0f8745dc2e17e4822770648bc7a77d83fec1d7a49d50f49a75d4ef368ba730e833259114cf9128715177a4e9363baa0cbd63196212cca1808a59b7d194d7bb3ab4d7cefdcccf4ab7ffc43385183178219b345401b65de8c0e6e53849ca59a70439f5482b7931c3ebc55ed7eb2e9beabf838f3b0f0a9311760a8ab3d9c4c000c736054efca8b957b2cd4541df9638306a967ac03a6ce213e721529aeaacbedf3a8ed2c694dec7a6be9267c4748f4647530e25cc8edeb63a39740e09618988928d21992769c1b7e704808f978bf38abf477755361141d205e4e3aa0009a263af6a3abc9f203f4f968af7d8861b651453c2167e1fc4f45b5b8599e17dfd1a85e7c86c4f29c2c67aaf1a1219c2227b527d9194b564e523b7b908076168b668f7ce43496b0f00877bd201f7fd6287961df2c6e9ddd2b65f9e1f3b1f4efb09cf0f503b9ef92153f0885f8ea812b773d99e214b3736d7834797a723c3c3c3eec4cfa90a11f677d28a31fe7fdf331c75d23e503397bd06679c1fe10d3aec46df55de2cbd3c7ba7747d8eb1409f59fdf3cff1628c4df8a09fa7169d2f7f86c5f3bed9cb8146e38cd0edf1c66b6f21f612d2b5bb39cdfac0a9bf2ba003a30ada8f2ff3ab4c376305816e7d00aec9ec5f46656e093648bd9c702430ae84fbbb51569475cbc261dadde2d17b7b42b390aece19fe71fe68bdbf9feb420b49d9f7feeef031b43b553ab85885beeba1a6541bcad8e9824ac5d6577e6b62dd1de59f2c08a16bb7b1cedcc1e9b604673d81ef3a73b8bebd699fbad33e7ad53abb667eb8de663b77a782d7574725ff5b8b659f203ae5f5bcee7e5f2fc664644e7a25842d502567605302aa67e5d3b87fb47cfe0ebbe0ee9d866ecbb776c4d784904807f8ff4871333b8a1812faede411e2082f2a645721b325b83921fb835b854209092ee8692897e2b125c01125c3de50c5ded2b8dba15a1b21dc1e86a6cde7f254cda8a38d2adc0d34b5f115c3d0d958235ad899f9655991cc8905068d1b573d47ba45ed902259cfb363283b142bcde86d290af89d0eed51c64eb722a83d9d71337202586fc735c29727fab329958a019a19c604e92c481b12a99c00ce6a581442d34aa98ec458bdc009bad0b2278ea4984682f681cbaa47ba4bb68c29f2a40a0ada40dfa1d37a9b2b81b54f8845938f311fe138d13dbd100ed18e5a7a11771b8cc73d7f6bdcd3924c422660362a01f38d1049e7fd739f43d2fc9bb49b53f5facf6cf8a421707c8d874ff731122936e821a5dd2c91dfaca0fefee177eda621f5dfe41d02d405c597e2c96bfa177642b1971efeb5afd68a7fb52e737cd1538cc7bfa9acca8144f951fa979e849cf56bd5693d85cc4b19ec2e1cacb1b862547ab0e7d9ab47d48950e337ec1f0905e913bafaac34d8633882a3d2757eee67ed334ad91c5ed9310ea8fee11cd85f66bb7136e6befd1a82ce18846f2774e3da3f27dfaf78bc130a2b26382c6aee57412a43d0aebc219b2c9f59e34575e29a88f84dfcee60bcaccb58a874823f60aeeba63f33dd0cef74f51a272d1248570aa3422a78754ccb028c698b40767da9c6a09941660e12c645f833c14156938c29ebc471ee4fdd1919c08cbf014b1db74e976e821efb7c3a6798c6422c842f98ae16cb6e6a4774a8297641de883d1fbf59c2d2edb872f3fe19b3948b38946ccf7cf3e1b76100941a14b9b0ec2bac5f6b5a380e70f59bb1a4fd7b83e078e298e1689fad9b2481c817dfb226d2cbf4804be6d3bcd08fa99bc7ee02fd362e9c63122a16011ca1118d5c2f26fc7e30039b6081951951dd24650b2a1d4387f58a3cc5892f0aeba1169e1d98942d6afe238bf3bb4b50ffb0e75fd919ed9033773e75fa6a83fce429416acef33f80593faf46733d80440beafb7a8e98772e0015ac6e20ce977544aa38f11fdbb834fb7bb06b537dddbc5f243f858ca62b962639f8568762101d8efbb0d29c226ca9ecaf5fe82a38b75e1f4fef176fed372715d2c579fdb7c8732e1c03eac78df4cba153f9d23d561e6f0ef53550be1074e99fb1b4d46f00dece6427f79f52c153043a660ebcc4554a23ae31dfcfd44a28f4e964b2b3bf930f951398ce38559b8990ed1704462b71f760f07d0064fe7bae36a69387dd1896487a9d72263794e5e1f6a284384b6d5b3ea807e0158fcf2d42edee01777d1b8274b1becd3f5daed22cdf6943c602b0314d2b219290a1577e86344ff3adcd192482f9a0670b7b57fb7af88b0392524cec5291e5b2ddb9b8c40f183159955015bbafa50ce0ffbcd171494079b743681beb694e14b8cefa0c40d9c1a587a5a9cdd6c2dce99e966609e0d745ad3cbe5e2e63a303f3883653b7b6a67323853119c4a7b5227200620510641a34d3f110db969d831fc63447fc6a4a30e5246c1975b2b6ddc6b50e396f9fd7ad665c2a05d31f87df9b4a9d1c1a5e09f9b4134109889b4f74cfe4227d2c1fd75003504c4dfe0423f725662875200e87783fe557bda6467142fd8b4f11ddb283d92178b25d545e490926e3167e555b9caaf6e236c0975dbdf4f3e1129e4b60f33d82b5c390f3aedfc33379fa385fb2f7892d56d541a61ac51d2f7f0799b17e8f18397bc21d0ca313d87f34ade3b014a2477cc4ca86a859d959a6d3315b5ffc5ae2ab64247667af679455e72700078a249935c8e87dc9e4ca6f355bf3e70c9a1877e10e0cf8e512ca3da0700a3566bd6f13d3ca32240583a9d81144238d6814dc115dab5f1f0cb7bf84bc9b25cf204694cc379e8e960d6c9fd00fcf6a1a57c8a3575a9966c52c41461a43fdc0e34082c4a89c37ec3b1a423dd648a9fb011dc9d4d8d0794276ed171f6d073b06e707608f100c7b93fc84daa20c2f23cdf462f11f35f937c749876e00cec981de55bc13175f2ad8223d70f2447ff4ecf6106fdf7e1ff0d5b5eca7949fea51ba23813f4ae6b7eb8ee51fb104d650ff52588b683159a471ea7ac5572d6beb7cb12e50e536623776a7a461a936ee6fa85c604fc5a46387d8fa2f65ecd2c3e701c541f5d8d03b6bdc69de920adeeb659b72a4d3588ca5153b51b48cecf6c0f1bf30c6ed0cb811d6d4d91231acbab9b0a9555fb937d31632115d204c4b7a0ad9dea9cbae557735faa302a513f052b5eac228d514dc7073c05722987fd5016a0053ed4e8bd7c78fbc90e29414c0642316334cefc99a5c66bfc1d4e62e88c77f414eb1f6f8c5678ab3077cfb551744b146147dcaa2088b3fefdcd1764f663a09b4a976155db55f262337bb0e31378b3f2d7496c8c779f42f6befd11a014f77810cea986475ccae0ac16ae61ad7b92da5e017c9e45468aadd65e9c199b36ba0cb759eba322155fbc91f61714390cead407478a3d3b360be378885b8a6c1f8f2de98735df369a607d1fbecdddc0b628ecfecb8882155ca0e5065512bf0ccf7f06110298cdeab655932277abde768b1ab87261541ac01a10fbedda535b859aba5fb1d7b4dbd37bb2bd8a2fb810507ec4a76ed4682830c67c80ae2b20540716b05bf2b71f53b664e31e9b90f03ef95cc3eb60ce9bbd07d0ee9da4baf196365413ed5ab17081b62a919b94c74e69ec9f0ad2d659c915b5eee474df6c93bad3a939c3d5dfbabc0e1f70e3c54746c59e4b359eab71f54dd67ffdc237dee4da8b6dbd5575b2d8ff48a104be35daeff58048d4f2ff49f32b2c605fd3f4d72ec4fba22996e77d21e1e9ac9c7f80359ea117179a60bd2b8a5542ae9379a275f1ed34acb582ce0edf811c74e82eb4a3e73ca297376bacbb23705ac0d263122d9852fe3d92810c8da5032f0fd4387f772037b1fc2e7387bb91bb70971f639fa4bb714fe1b473276a210fd5bb46a8d6369996df620fd74043ab68c164035d2eac5ad1dbf771435bb5be36b8718d63c3d4878a3c5e97dac0a5514bedab40c43012c616339007307b5bce71fa5727a73aa9687a669fda7e5b2dc7cc37dc9ffaf569d04dd506a36c7ee4bb3378d4762eaf727b17986423b5766feba46a394b4a80c800d49b389093e173f1156ae3d3e6b725deb1c1aff349552487495ffc195abf3bfeea9f0787034c3e4c0e5df22f378b95263ff5c93397f8cc275ebac4964f9c5c5d0f0e35fe360fc8b8de788f47eff7303a4c9e3e6b8d7b9759387e87977f9adc062107dc0b41fc14aab8fd7059ba737e70e9229652f6e8711c24905526ef3a57fa0830fa809039b7623b1643bb787a6717ab00bc3bf9211c179ad339cc13711ce1b9b5a9dc48f3c76907806f793bed343200f7c96a050f1d0131572200a217a640425353d634a993dbe1b8397ae2a4499643d565a0fa5aa02ba0bcb722ad0907fe797ada1b4d8e7efdfae8d7b144ff095b4b9bb8f9dbe0f0e8efbf9acd8acbc90c5fe3da5f4d2e611702a870119ebff8facdd7a84ada32ca87b42dc66108c37d034469f5f0698f91809c803cf0cd0ec5b19d932136a4b16941e0e78001d0ff7c1d714c928a16bf053d6d270983fa4d1dfe691ff26bd162fb7fe85c421fbd570f6cf511bdf567f0a07e003049be4bb8b9a49f10ddc14773b1e42d947469408692c1ff0b	2038-01-18 19:14:07-08
talkbox:messages:individual:Watch	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:26-08
talkbox:messages:individual:Unwatch	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:26-08
talkbox:messages:individual:Watching	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:26-08
talkbox:messages:individual:Unwatching	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:26-08
talkbox:messages:individual:Tooltip-ca-watch	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:26-08
talkbox:messages:individual:Tooltip-ca-unwatch	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:26-08
talkbox:messages:individual:Showtoc	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:26-08
talkbox:messages:individual:Hidetoc	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 17:09:26-08
talkbox:resourceloader:filter:minify-js:24a7c889561bc4d914f64f8e8bc3b5a3	\\xd57d6b63dbb6b2e077ff0a59714532a224cb49dac632e37573d2d36cd334b776cfb97725c54b51b44c9b1275482ab2d7d2fded3b3378f321dbdd7b3f6c53db2430180c06c060663000b3e3576f8edebc3e6ecec369e4ff33ba8dba71e24fc3b41bcd9771380f17b9ddbcf9d72a4cefbbc17518dc4e92bbf3ebe82a7f1f47c16dd3bd5a2d823c4a16f6813b5f3b0fb67a771e6efe8d8a5d2d2a4a7a12300fef72e7e19b9f369669f8ed3d87f416ab381e60ea01bee5d75136c0a76e80a55535a1f3105dd97ac97d8fcab65a6137c3ea7e0def9d072a9a41d1d0fecdcfafbbf30828c4b468310def8cf28eab6584dddc4f6761ee382e2be7df3db35cbbef74fd3c4fed076242383d16795d9e706af107ebd8b2b6ce606bf041400f20270df355ba208e0cb69060330e3b83c1d67dc0ff9dc153ba318ee07577d71d70286f11ae5586e8a6e42a8ac301f64997bf781a0cf4477ebf0c932b01e9799eb502b65c450b682443b2bac5b4db45b25e58d4cd779e75c79ed6513cfd330bd3b31910907943ebf76598fa966b7df6bf45333f4f5278fe0d705d45613c85e75f7fb9f8ed13fc7d7f9d26f3101ebe7c3afb8ff38bb38b8fbf7f6ebcb2c6847525305ea4fe228b7d2416900f7bf6cf511a5e25779bdfce3f7ed8102e770443e5361c657f874e4836bf260be45c923a3dd7b2c6ee90d7d438f7affc3452356396204616a2549d5c5e1fa5eb4dfa1ce659e02f191ab309d0a4736888cb9af22d4c33a0fe0ba089ee42e450e0c3804e002c102cb8e295b8d642a075f7e4f3f7909e70ae726cf0742b4976adf87e8185e75984d832d1d06526f8c98b9dafae8008cfb247a3de66341a9c8e46d9c6b1877ee7ff1c76de8e46ddd1a83d7e79ea40fe60330dbf6dd2300638678370070eebf1853f7f463376d029da24e98d96c994fe5c270b0498c43e4cab304def8dc62001e6b860e9b17f9fac680cce702414ea2e54ba0e27b7516ee9250b63cd287d7b9dcf63ea6b8e274fa3298c4f4a123841146479628d75a4ff609c47aafc254c6e5eafcb6964a04ba8f52a49e708b58eb077e77e80fc8a162b6458b65a2419fe4d62e054a67864162f36a0580c081333bf9173d8d0ce92551a846eae15761e009d8da823ef70109de879dd385cccf2eb41d46e3b0facacc7fe74d3102801a1ad830fa3f1f070ec1693fa63109d5c42b2d220238d99ef2dc46cebca3477eee7c1b58b03c05bddba8cc3ea898f724c102cc167917c3700614718505036fe08671fee96b6655b6d5388756f125870ac8de5b42dc772bae15d18d89206c77950342a2e2a1a2b6517b45695924fddbd3cf994acc3f4bd9f85b6534b1f4db947c922b6288a081330da2dce17a0a5ae223e851ead8a73bea2b2f2547ab43a31458c5a4720a2400c4ddbb2fe8af1d035d827e9121dbef4d32cfc088b29a3ee68bc831439052bdbaeea1670a5aae588ab604ad504dd414b61c930296a1bb2bca26f44eb59edafc6540f8e812ea5d83d266f7b4eabc541dfbd3e3c54e5aca3eea1250ba13ac0e49b02f7de767f54f0aa37387e9e01fd37c455a53b7ee9f42207f8b0d9f40f5161627ac68385f8ad63fc0da28e7ace3a667fc53b1f1a2299630649cb196a1d8b27b5341e4b28fef0137491756cf337d038ef4e91e1e720c2173391ec74b3d52403cdefd0ed3bc7a01f8ad29f57735882a03c8da69f4151cb4519b77fe86c3687dd43672b8599d0b7b64ce3ca6145f0f6a4be35f797865ae671ad9be96f423f03498030d328e5f9b63549a6f73018a3ccb6ba691e5bcea9857f8ead384fad8152e2a08221941bef63b74d6ec220b7369b42de9057d345ce8f8bfa1e6f479eaea01162b9f5aacb0ec43211248b6944eb4ab4a002ac95c9d2c397a1ccc6b58029247e5ccaea8fb12198e379577e9c8592187a1b6c43f8dd506d25482ba36eb44893ddb74348b42d41a41812ed64d9b69a3075fc18ffe274353157a35eb0aedf859a8f0eac00b22b106f0d7e8215e00c0eec6912ac50cb7760c9f4a7f7353abb77501e1707b6459a089829d3e9fbd8cf604030a00ec830ad6f1e05685b5a823653761664d370278898900eda407fd9ea4992db282c593d62b650aeb2626ec37b17b8bf0add64c9f517e83130c488c9426379d76fb56c02f398d129270625c28c69b219d3845ee488c4fc04ab375c4c6d6880a8810f5589cc79d8e35900bc044538f33a7d92a2bc9262ae3ebe68b6fbf799570072f3620a2d157fc3c5c519e4dd2ccce939efcef893d3463c52b792234df06c182e82641afef9c7c7f7c97c092a24301dd807e2ceb344dbbaa9bf3e15d2119be81c579432001cb740e7a93568089271761899b076fe79f19e2370c08e96a59760b66351fcab95c3571d6c9accfd688180ec490365093a701606ab344460f68486fb98afa9200a065bd1d7d494cde68129a240e72acedd69882df774d6c87197c9d99e0db6c70c52e7117701d80c95b9ca9f1e7fdd0c1ab09cd77448dbf2ece1d701ac9d42072974a5e39cb21a397a54a98fc90fb37dde5c239dfd3a8921f7a91e22ad88ee4b10a20e17bed00755a0e0672017842ada6a59da9b052b876a22c8c53cfcc029652ba93ffb8c724d54c316279d120283897096c3c89aac603618f8d9a27a102d96a0b9f275158bd054a6b2623e5bb8666a091a1698e60c8326028d4ab08cad17186c798149bc4aab38a26a751eb4040dc7607795b8ac742711c827eb0a189835a669b26cc0209a266b5048fc2c0783b5e083e318affdac0a2381845d945c4017a2b3d04397a4d12c5af8f1876fd847533ff749a1bd42b6e4e9bd4efd2e602eac7cdb426f620f6a0693175a1190fa18de05214d36e7afe1434cb00aa521c2fd2dbcf2616ed80e531e748c96257b260de7c9b7b08eb54c91c325add53ab0e50b298cf3282f74e9638ce5f9a44b58ce6355e3ffcf5f44296f4d79fe62b6f267e595d42ebccfd71216147358cb832f9ffefce3ec9375acb97ee7b8b6b3f1235eba7994c761ab25df414b86599a833ed16a694841682d40c9c8bfc024003dc940a18af095daf30ec52cc75e620ae60a0ce70a844c012bd0e3a2b6253db0b564d8d24024f48e2bb1ec299a989d56412ca8b24ae455668b55181be15a46d51a5fa96e976c4fa669d2e366c3acd14a8ef075a540bee7f59d532a05751fb307d0a9b7e4987a5f533b81b90cc1c3fa1ab54cbde2139ec3d296abec9a650f75a08eeecda10cadbdc27e923532adc78d16793843c9814dd6bb680af39c3910c864f627b13204585936247203c47b04050a79bd4ac93b86d2412d8e1e2aab9a2fd1c9289d6268e5e4050a016668a60da3f1d88b06db02a100c80d2baa81a941208edabc466e4f21efc229e31e0a2bd323a797353c7238564d2a745024c97928606f7b8f94e0c2b354ac003790c60e67f4a936408da2ce712101c74b45a759a4d06812d09562eff9b270954771490eee9504a1c485f0200ba30598a77e1c65b8e543569d4b69da88566bb906ac8cd8520ed98207cfb0fa68d34c996ed22543721be9048d3a89f3687916046196fd1ade33df1158c7b8a9d609b3a06329fbb9808bfbef1f4566174d3c288b7eea532bc8d3b8c354e40ea8d77e0c06a153ae4f9443e704bab95bad02257c2740a51b5ea0776f8ebe7fbcc5440b51a008d8af227d17050e988ad5399b4d0d1754062fa0b60f9c27525ddf45626745d1ab59ec907ff484a1803c61c301351fdb224564483a9ed8f11d1f2f92dcee2e1282cbc218ac61b43fca3bc26c50eedb4fd4e05965e47891356b25c75087f66ab33517205fa0df0b96ae1cb75a1c2ee854530f0296e5954015270fec3deb859fe65100f2e41114128c4bbc4aa040d5a17679997bc7f4fdb816588bab3466169e262fb21c9619f8e5e1531bd5c03c11d6b0405861166231b9c7d2dbefcd5cebbba3bea5a5592ced073d6d64b3c41f8d448725be35125fb2c4333df13f29ed870fd85cd74241fa675d8b74f34f6f7981f0ef8e0e11e7a55ecb77afce30edd8483bfa19d37aac66b47dcecf0d75544422645edda8cbf27beacd8c9932ccde08b2cc8294348c3d06905d87614e4ed4ac4b09e798003da4bd75a1d40594f610051f1d59d75f2ec3c5f43d684d53bb4003027fc6c6638136733448103058388dd94ff717ccb0b59bd7a13f6d3aa0bb1978333924801e2465b3c94457fc3dcce368715bd311ebd97998829c68af67676c607fc1a808c160eba06fb9d45946af120a623950f905d5d97fa0bda4d5413aae0bddeb3cc02f0f7e4ee1e758b62e4e02dae2e85e83e4e1be14c3f931fcfa62fc72d83a1d5bed836e481bc57f7c6068b9dfa3f5821c1f5478eea521dfe5802a698f0c4c0be9d493cd2dfb5ff6ecb9b1d1c8bc23ae552d21c5c255ce07bac3bba575dc1b0d6d12d4cea98da0f087095478c02516fe749dd1f8a0e75aabe51407410151a6abc140eca728e363f8005f336c9c4807252acbfd4580be436efe3d30284f802821a79071900395a49bbe3564d94caec5abf9a2039c6bf86ee3c57cddc101299e97fe228ce965d9899359d2f071483f865488fd4701637f12c608289c3bac1d053752c49805a53d6689f3681d8bac3e8bad49fb904db667e56ac8fa928d2748870509b1c18f9c17bb4bbad6d06aef5e6adbcd8337e326faeacb24ba582733ed5d4b2c2b4ccd2519f72549012cff64ceea254b757142b92850dc68eaf2ca5d9f6a471ff80272906d95eeef93579a6983f380861d8a0f5cd54efc77273dff9d25a8c59a2caa0f162740cbc42d79ca58b530d2b06ca1713c6fb0cdd6113a73b2db6801f6066ec0e1609efa2928d1f40aa32d992dc209899603bbf9e25f2b502b267eda74b8f8b3790557604d038193b4d17ba74608231d25a97de8ec0d0827e82db91fcf229f61cc423f0dae5145039c13d09fd290e1946f56a3f5a27ff47ad0b02ad10ea6cc7d744cace29d403a80d5e66fc41291258d7565adebbc5ec59e84bc2277dd0a3772c27f61558866151b1874cc0c7e1a7d932a0c8391009c67d6c92a869e845f5289a9c4019576fa4e75a9dd846e2b2835da2a8b1abead70becceff9e896aed83c9c7b8ce1ebd48785e1248ede9d64206a8018fe07525039f4535cd0d50399f35374a7010e3e08a3a905f38251282785394e65b2a5a60d0827366cdb9ed580c92d33dad698ed833f6dc8ebb5b65ab2cc6ec947c3916db6f3c9db6a8927de58d4223c0f59ce4625aad072a6cb718d7c103dce7b88ba4e411ac306b2c52cd34b5614a35e2f56235654c67e3e5bb620d2be81898b4dfd30f723ddcd84af392a6c14f340cfdce55d9a27e955f0e6d5d1d1a58f22c7db6bb2e0b4fd1707dfb5ac97edd1a8d3f34ebf5efeef87cdf63f9b2e00f70f5fbdbe8ca7d797a8513745285ba7e9626cdf9bcb10abbb4c49781b5ac857ab8db2dca8ae6d8d46dd711b72fe87ccd5f1c390c04cfbf418e0aab39d97007080215a52a8d8d838307a79c3799c44993c54bbb603d303418e03dbf9af7181c4e1cc0feebbfe8d7f57f28480393c4dd6dd0c332fa7e16435bb9ce3c863c68c919b8660d866f92553aafffee1c21a944b17638671692e22770c83093b3ff42a94e49fee3f820cd20af3951e16bab056f75f0250d80d50faa07aed19e521279a1692b0fa4955f59a8ecee330d0b70b044c60aea4594e7abaf33081aecac234ff894d95d035b2f9049b18ba7d881dce74dcba6690b81ecc9f6c6a38d86a1d785eb051cdaec2d175c9b6bdf59d3c8d3182f11aa4ed34023f8ec369b7cb45f9d900f77fce687efdfb6f9f7ec9f3e51f6c90d86a63876d1231a033a8e95bf8efbf337c7bd66fd9dd3c3eea62d98b8b2fd6530a59bf45419a64c9555e2e96040e962199b245e9ba7f5668d4fb64154f1b8b246f3026a2cb7511b2d848d64a6c9b90736745be4d934b6481e2193e5c522813285e99cb03ca495d8ddc3b77c1821bd388056c82a272895b580348f1a49d66dbf018a4d132e73105a732012db7b6d5a378f5eef21a06f7b1c80293e9d427223c248d19b2e579ca262acd43a89445beff7e655ba796e379a00b3c2029f003d852dcb3af7040c8368ad12c8bb49e52043dd8cc7b8d2c32bcd63a22cc1c8eabd1515e84269d6421ef65a247255a4f2068073d0a917c7a066ddb3baf62ce90c8ba731efc1884846d9dfdcfb37fa7f197ad96a83161f0d5c07420e1c8bfeb2630972b3a140cf088ef73a9b90255f061aa8c706800f722625a8cef96a0a2f91fc90aa45e9aac4172352600709b152670234f1a5a4917c4c87d6395458b59c307c3de8f1ba206dcfa012bfc5b18274b144f3d0c7ec3fd09b085b6f93554d208f748d7a91c9e5f7e3fc7f17987512dbcee5f425ccb60a687f9358586234cc36ad35069e094eff5bb7de05b5521ee0bec5cdc531c3a465f478c27bdbbce7abdeea065d0915e2a64ffb60acf97d49fcd31bc3b005b34f4eec3acae42ccef60b5691263107cd2911b2b54245950b817182979185cfb8b59f124c61d8b073b47807defb50a753044571a0621c8c169c3b6da400700af3260877ab9204dc6a19434cc607c66b448382a50d0e6020a7dcb9c040c3fa044fbce29c6da69e03caa90ed79b0a3313c3403323f7efef22717328218cf3bc2e8520ecaf6de4db278f85d7da10824738aea52a920f36c14a1ac1358351bb4f47bcd304d93b4f9ee03fe396eece41863a85e0370f1a407c8de59b88e506d7cfa4efc6983554cc3de58158e695efb0d196c0f008c6d480067a5585b6065d17b57ca2720078679c393c3bd47cb062548a1c40622e8eb5a4a1db6b51fd16cc4756d1a82191636eeaa5583f5d5399349d919a0f20afb547cda568a38c8dfcbf4b21cf8142b60bb67a26e9e239d9b5a2915c1d45ca3646b1e37ff497fdde66a2152fee44f2e83819609306a645701b3ac3fe50bcbe4065a27f03b02e5d9744adeebc6d29f8528f7ee513a526e1c65b9594851f207d9b95ac9ab349917cb3e5747c7e7499467757a3adb23fcf2beea9884199b2e7a35ca2ee9cc89d7a33f3d8a4db6051ea7d5daefd129970d0cffe42a4c37e210cfa8f7c3a87b5884d7d0b2ad31af9870090922911d7bb91431e30a946d3e96122ee77e609a1e1c030b981754889073ed680d1e1b98b69d1e093bbd90649da258a291da907e46c7d907bda8d52a03710631c5a9c4076ab67cab2acf4a64ac82413587e4d6b9de04f266977857ae40ece8ee7b8fb7c06c82c67df95681608fb63c19fead2a7d7575e4f5f85ee5a8373ceabc1d6fe6e230dda8f7aa6e0c41b94b10579956f868c7784370ce64787c328779c9bb7e7f4749c82d95a2cd76aff07e89a7bd30c8ac94f1f68d48a2f7ef59d3f4a41fca496fdfb03436e661e89649e37bfefba4ad17a92309fe1889940a135d199068227ea6ad8762d9aa824f2907adefd1134cc4b7a3eef00d0e82611f7ee36990b153d7af3aaf4a0d185470cfa4145aa59130a862ad4ed69b321d721c87df17baa28767fe1a749a65fcd077b7431087f878e86e010d6d254834fbfc3cb3765a84399cba077de7c4fbbe8b8e5d51035b7679bd5330237e5fe0d2f04b92dc7af24c06d90da23d94ff33ae08991c037a2286290984fe74aae193cbc835bc1130f3c998d53a0f3ab6e19efec62da4b1273170054cbedbe4c0127c9ce382ceed596df370c60f8770d397f2c1e8247f6ab5658565d4be7083ef1e17b68a23b6576cee29476c53196c376e21a7feba1590c1417bc137fe373f230a2ca188e8640315682c3b4a35a2957bca7233efa1b2b1504ab597b64981cf46c121a48e0baecf32001b1e8fec7033e2718b3b33229fb334b0688fb69493337ba8d87e500a77bbbe7037d0dab53d3d2872436eae17bbdf64b50443766b23a2bacb822c6b3d7fac38f5c415bb8b3958d9188d6b194ffbeece202e4516c4e5c8829876c271a39c76af19fab84b0f1efd7e2c36a086f9b1647eacdac701cecfab6e6da81b497bff9f054b3c6934aac337441b9e22d9d70fbbb55ab83f89f15bc9229980106396abb612c17bc51895d8da2071da88031ee8de83ef7fa6039bc835cd86d656ade722fca11e215fd69e8bf16d2546a1813d03dbcf3f1f19a8d0b163ad673f418fdefe8c51d0190684b141d96a092d57cfd7fd5579b2dce7da865cd8204dfab13c2980d93bd4271cb2d7c9fa22092e92d9ac74b545cd38e3931ba6f02fece848eda6439e0422b680b627ee227269e1fefcae42480a9710b8c6aa9a361b1d8579962501f19c9e2ffd45bdb4874c402901f5ed0da494ea653b19ecd9a473af800e94c98182a31d118d743d4bab07637bd3851f1bf924dfac17d6808ea844c1ed2ffe621a635cbe84d14ea07c0379c132a0df54c8db6d14c71fbee5948f271f34fc4f911dcabc9e67331010d134049e90ec570c7b0a226b68d59651343d1beb18b1aa91f0b4428d1d8564fd0e8f19c763615f125dc45392b4209a9c275e9386a52cf00e8dc462a1e0da4fcf7205d4fe910e18181db755da1ef36792d4571d1dbb8b707d21b6ffc298f9e85882fee67130258fc258db3c6bb58cd72e6e4c53501a61a9ca500825817c7479e630845f1efc6c361c8a4e0dc9373a6ba4394d01b270b2c8d9374f4f9721804d98988130fb9226a09ef84c3cf17511f3020cf38a7f5a4de878404524e9400a44cefba24f0e3a95ce41eeed12645c86e100d80d56b3e462108838bf5d255e1e1383801be32244417c0e98d6d09d4619686cf7782616af35711ed470d24548ed141f945159b49b610d0ae3da9393e0b039e06c2b88514b9c77780a0db8fad4d340ada927a15f47027612004dc385553716e6eb0fd328ff6995e7fc0a1c99fe7e05836d5e9dcba22dff6d9580f15ba51f9a919a4dabe93667202d72a1cd49d53a0ddde6686435517a1b4546a3c52385164d15e5ac9183ae7b1e66b6ad22975cfb8f926cb5ac5db5b7fcf9725022da6aee2ef42f20a0a2d4c9ee5271559977bbcbcc78197eaa0c2598e0c5deaec07ed2c885030485f4338e8348475f6d39c331587ddc433b6c6178425b2dcd156afa38d9798e679de328a0b6e5fb6653f697711765a75f95a99dce2087da238498ec026db91ede3867210577552ca9f7e4806231066ae2c8d4b45081c0c82e33c6182531ee4e82b8810ec01bbc64c42fde38c5e27dd91345fbe28d5614eb6b158ebe99882a90d7ae096649da2d47df889eea3cd405cb1960356b1445256fb775281e312a65b8f25f2c5f8a622e1cdae3dd61841a9059c150797b02024fd38948679e5938d9ae453c53bcf3f3e39c77c437ef8e6b160465150489f866e58d30629a3547d073439a49d427495e3bb6f488dc7d84ac882d5cc59987593b341c76c51c548978005e1c3438741e30d583243ada4b2a02a5d4596b121b2ceda236d25359c88a3936882ae5561743a4dd8e682a17b2617c90b27b41a1137dbcf8aa5045b900b3d08b80ad563185107fd6ee8b9a46df7a9153aec33046a8933857a8ee8accad9049859e61b44a05c87c55ce3cfbeba6e1e871c4766373e0f4dce6c1519333dad0472bacddf8a9c6240fa58ba5712bcfb2644f30d0b3a251c8c27ca9b731e679afae7c8c41a32ca459f76a918dc7239e29174cf5685a0c742662cd49f9ff18ef5c81f1a961cf751294e2f8d2d4bf673c7952ec331b32946c8458222b9484d0a6a4c13d1eb22c7ccef0a6742a10031fa511aad9adfabda8a171cb94505c63fd6e1f02a9b8448b4381912a262b99b2a624c7a88d4e0623ba43c131b4abca6e1492581e2b216ac151cbc39ef4d25ab280d40c7105271399b0c4786a8b7993820c96217dd78f39c70329a74c6116f3db21d92190c01057ec3848a37f8cf1d25e8e4109aa0f18ac3398a093900e75345e314085840c7c0e2103d1014633937dcde2f1615ce65ae74e938f308b34bf053bda0ae690da7113be461f1d0bfc6adf522ecc8bd5f2fd8ebb929d873d0d3b5064e093572693d2913d1678cc551372b07114baa32db3191acd76aa835404b2226e96fba908d0668ff4077a928601343acaae3d4a6b1fbd394441c4d2de3104f24c2d873452751d8850c0f060704afd0926bc0cae52484630a13d08d0dbd98319d0b2ef5982afd666833eb236c0c9050303bb1ca5e8378cd3cc0db17f8e47afa285b8e30e8485a7fa4a90ae52860030f682c9209830cc1e24949c9dc1c40d2a38cea6276bf449816530882ea27998ac8c7b641ee96497e1c23364182637d89646b35e4a936b86582b882c198343ce2b22795f5dcabdd918835748282391df7300dc31c3ca388329aa9101f12bb4d97a8a83c2154342dea300584e74ec6250aaec767fc0079c0e27b69b08d8c8e0c00a01decf561e9c1e2785342f6d0480f4e1647ba231b424bfdba392b0f431be9a4592050ff434e22cab61c8a1fa248e6acb971215efa502253b3cf910cf617aa75c8ab88984e1569b9fa67f106281c653ebb31e2d8a886a6a2b849072ac9f7d0cd567b8bd1da56d9d24da5594d402de976a292de0543d770d72eafaa4902d66f035bf12a5903dbc1e8ba05553b4789eaabf70c3eb438957c3528a8c9028d7a796aa5229364320597642910bad16b1d0c72301e2e9b8cc55b158a8d24ce7a41ad1fda4785dddcf0dad37f4505f7375d7800c4bb6a29a61459a6492ee3504dd7e34ca9c665b438e73435d4ed0e9cdd079d8693aeda6cdee23c7b8721e94fb5f5c7565bd7b46c5b463c779cfce0efd86e652989d69b6dd0d30ece644eb5ac1b01b649828ee6900c39bf140c3c4b60304ba5b40777b52dfb0c12d1feffb550cb91db3902751ad5a326174eb75324fb3d0b0f0a093ca7cde3c900c12a3df2ec16a1a4b1a4ea31446dc45f233c6dc2367d4f91a9ec2240cbf36b922f495dbac6718c7f9cf70f26b2120944782d2970b28f71fd57745f7c7227e54c19cbc3e3a543bb6dbaab3163e2c3074aab13247b481fb6a290c97167b157f55b84daeba02c58bddd5d03173a51c80ae1dcdfd597849b76bea7bfa41329f278b1ee5663dab5460b5040b08ec0d78e8cea2ab3200de34c841f0b11a08374338103e1681c2559a2c433c240e6ac27ac60d964ffc4e2f50fa70334481fb31ed43e7e1659aac2ff138799a9911c300c46ea8ba94c7302e73ba828b74ef12141dc2f4f6f44c24164b6414e75edc758ba65012a62479ea08ccab59e58472ef5a044777f233cc962367778ee2358f4e182a31a57371add73e4b1fe62016d111a0bd9a263a9e8396f8598b2fa3e9a5d5267a1dd46cf061b085a6cfc13c3ae7a0b6c2a8eb9405286d0b865d7cc66c8434cbff48d6b4946072178f14814e249f35379a84a1933302885e8aa002af578419d614eaf4856bae50940a1d7227d8bec854d3d95ce2447e3708e3382bf96b31d53361b8e9c2ac1148a8b747560bd1370d71f4eec0c622da717cbf414ea7e68ba638c68265aee9a051136ab040672463b309bd93869879c1ba902e3435760c9bef009e4ed5ebb8400e276b9615cd678d2c0dbca6d5364444db98b96dabd98039e7355b53283b68f6d4197dff9d88ffa999973058b50c3e70cc2156ef89e18d31dc04903ed04b6b2c5085630cb0912e3b78ebee55dbd6cc6b27b7b6a704ab1c502c35f5f26931916da06006f6df4752d4a53080a55b8767772b524eabb52f66002341ce816a9d940b0d87cf793ea235dc5b291ed4803666a2b803c4eb9b00b51252187839937ce6b57c36577f00f339d9594f9ccfa787c77da691e2316a983a9947de0489c73b94a57f4aa65158fe10899e694c4b81b1ed1930a4432a1aa8d502f4a4c41f4752d2672d8cf2b979f7a20090b4e8c8e5058c4ae2a0d5a88990776cc4a017775ef27d55141b32785446a000fc28c5f4eb70948deefcc3711bbf73a4c53dcbf403ca2065239fef935a22743ae6df832973b54032684d06f5294ca3801d50066c69824edb2445006d405240fcd7d174341d8e7add46678c5f0f3aebfcaff1c3ab2d4fc14cfc77c063eca17afc40460127f30fe3b2f26b78afb657156e86483d3d8272efafe0fc6b24da5fed6167b43a3aea1f8d1b2f9dd3e1687578e8bf3a80a4433fa097d7f4fbcd78437f8f0e9c9d1505ab142673705f5159413fd985459d39e0f333c49df6d0a30d84820f19bb1cb46d5c812c54d9c4c657b8a679a99b87dc4b934741294bd9397262dc544c8c1bb170a6e67a7ca3d6cc94ceb43d65c93c3964b86ec37b16645c9846a95c92d5e4b9b205b4a71cb9ce834814b70c27f19484b86773d69d766e8e6f9cc29408a79ece7981faf953d31970760ff95fc33e653c86d6b87ad5aea0d1519e2ede3343f55883885d5f7ad3119d856bb0a81a396c339120bd06c91a836e4844337e90f5c752bda7280e38b2ca8a8325dadde5686dbe6596550e51bc4d4dde66b4f73c02564b55fd4a56bfb3323e1b0a1a6189b74a1bc441adf502288292a74bfa8821000c8fc6eea10b0f25c466d7cb35842685181ef40dadfae981b44f923c4fe652a33417c14294bc8116c7c07f2f45fb7f8122a1b6d55a5479ea32bd8d9b3a382a345b8a771a62303f588629b8bceaa7c5ffaa020c52834692c265cc99bfae0c9755aeea4f36e2cd21786d629ea40570ddb7bfd9d8b580c06e7458b45aebd9dfcaf72fc3a8257706ff420902bc6726049e8573bbe3e6a05e85d43edaf3500fc5bfb6e1674114797bbbe8a4d994dbcd512e76fbf1520aba50b9be58df2c660e0faad4181eb5740e656574ab3795a4980a467835f70a34ebf45681ffb7d32a3b1183bf0e61e6f4e1e7087ef09b95afe1e70dfce0d7267f809f1fe1e72dfce0bfd1a8cb3f3538f7ef88f44fec32b1bea492f0d2bde87564390fac6e768b3c3deb2b23fc77307a396a8f4e47dd913d72469bd1c3683b1a8ec6a3ceb8a74e0fc88fae0055563b1b6c1d5adf193eae659b543a0f05aa755866b79a0078a96861c0635414279f7f39c665af0e8b9aa0515e2c6317ca6cb4420ede2851f43de96ee9af76b3dd1c76da5ccd3ca5d3a734edc62f6dbc7d8c3d3aa7f6871a28e714306c4c2ccdb622b0dd6c7f8720ce41d36d464dd3a2d6347eafccfb4656b863402f6a68cddac6bbf876c41e3ec9ebe8fa7d192840e9fc336cafdc574e7107862e79bcf1f1136f381493057e24e8b06f69e102d6553831b38f8cecb99f9ad9af8c6c7f59c87e5d287d6f66bf31b26f5605d2be2f64c766f60f66ddab9999fda3919d854b33fbad919d04b991dd3f34b217c93733dbe4da340ccc6cc935b16ba5f7cd0fee6ba74d906d3df9d03dd24e94999dccdd7e052f6fe1336f3ab2efb18e22f6b6394244754f2affaa589e915b4def8f4c00dca79e89f388ddc52ff60aee53e7e40d340de0aca343ab7d9f728230a1ff962554b59bee6d1264dfa74f21546f68a1440d6bc4d7470ef97f96314b95b168cc6f8a0291a41dee7613ed8b0ee4a6e3e715ba4bdc8056853db29a60f15a9e481d6c890b57e065e274d1921d447a64dd60982958a866c50b644026070da0f964aa7e4647379107b46987f2b52dbea1db18e33961cd526b3279d974ad8e0ae7b523503d3fe307439cd3cec705c609e4f7c7e452d7195bb2e5abe4a7d10106315fb963016478d7e5749915e8de1a85db77276ab31c74899309fc3aedf48ff1e51dbde0f3d1b833815f0642a98c56faf6e991a9eddc76aff6a2e6ec6ec44185c7aec25f2731934f418342e5bca682d4720a3bab1243c9d30066322d7282e83f98bf418b2b65ba161a2ec2f3a12228349f1fdb7355e88a5bad2a67783bde275dba9884113515c9c914e36ef47adb9e018356156a0995f47b4641fbe6bb23cf3b3c65751d33dcfae6df4df65ba6ddc9390fb30c0c1b576d01f3cb202a63ab8b5fb5a4958261f85bf46daffe08d87cddb9c93a1c941f865505f16b2be2f9910b30f5b3bcc54af83106f95d06ed2c631994c38032fa288c196caa48759f50b474f36763770b1e275d7e9b6207e9ea3317cf265d152d5f5a5af8a4a94257b5f158ec721dbaf2801edd752347612d728229e2ef586d55568fc8e5f99e1ec5c27660b40af0236d32a415154c2d8f5f5ecdae5055c90673b474e3c655962c3f22a2a094a380270ecccfc3ca2b2a1648f2f992e0f5dd30ea30bce49aef6b3180da8faecc67148c4e5074bc1b98c75f3bb81d2cf3d0fba10202f68a1101028c76ecc50bfa42c433bf90a3dbed527f8a1322189b7d1e4de26831c3a3ba2c51ed5b99a394e372ab0a8bc3b26514669c3c61d09d29ac1b4b9cace5608500d319c642d478350fa2f51a39fab0a92267b5a8ba9287df55a05fc4b3d9ecd7c98b4a21a1164aed0b99852b856890d506e6e37edfa026a8192c3cfec5cce2a78bcd0889e2ea5f717d105bfe8d5b86a2b17171903f9d964357f9d0f7f3dc0faedd6b1e59fba00d362846e7b5f1fc5448fd5397639b58985bdcd10f9ff37204464535642ad1b6f0dbd20592b486e0bd4804685ebe44a198da2d4caabd3cdec7ad8032e3baabc37b398f247334c422cfa2b001cbdd53e49a53a5162bcb36386f14ace17d45a66da22ab15fdc871556705f4b64dc2f9085dc976cb72d1c64966bcc3ab6211a16ee7791d73d5584457dfcc0ee39b9a16b4e8ceb466c79077b931f046f1ed353d31587bc21019ff002c8e6e0ff02	2038-01-18 19:14:07-08
talkbox:messages:individual:Accesskey-preview	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Tooltip-preview	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:pcache:idhash:1-0!*!0!!en!*	\\xa5566d6f223710becffc0ab31f5ae924d8174848ccb2d529ba2691424275b4f7a1aa22b36bc08ad75ed9de9034baffde19b3700bb956b91e42ac763cf3cce379e58ec6090d66cc586eee6a57d52ea0c988be587a428372ce9f5c30b6348ecf473448ab2c5d64535e08f6593c08b266962c3857c4d679cead5dd6523e13a1ac6352f2a29f868bac9386605565175ad95a3ae2d69ca48cac0d5f4e82b573150dc3923bd6df006289d07d6d5621be85575c56140c1d57ce062497ccda490094b8514c1287e488e1721228bdd452ea4d90fd0ef7f8d992cb5a143c0d594696da0025f82d99135a11f8d656a89567826e88d54bb76186f73dd74eba4eb2d4564ced1d16c2599ea37590fdb9271fc22d1f16fa2909d7c03314aae04ffd6a5dfde284937c326542ddcfd88affc4ca6accbcf904a1fc7b83378903b2550f3ec21169c4945c72e7902484d2385e04195ae27dfe4a43e49691038ae5a6b7e6ac9042f18088621234f6f77bfb6344d2e0a4215cb793d6324ba5c85ea566b3d9f47d5630525f333365aa661273b314abdaf8c8dedbad87b766eac098ec8c8914d65f14920184fe07a95f3ffcf646065f2b196cfecba705a7c8cb1e5569c9842c99f2675863e19e558f29a56b95f3efa602079c594e101bf375148f1032d5e9a4dd5e8f746ef966360385122ac7f04a1bd799c1d3686c46287ba50b4e72a0e128198471e43f9d99b6aec79f20f90534462e6b50b2e26f4e491426d1f9283e49c8e2d971db99f3b292cc71c2ccaa2ea109ff45efe353c595158f9c547e8e9025dcdc67b5711ea1f34eafb763fe893d7274bed3cf59ee9bd1adc9037f264d63d1cacba92860d0ac69dc8bbaefbb51b7cb55f73d41f60e5201e55c56248962f8246751321c0d4e097af2636b0833ec86a9550d7d7823d4830dc68c46f4e50b8e3438bb80dbadb411bc7d10e1e0c3a6dc4dbf731a603713ec667c3f45d423346fd4c4ab2d4f5af2eba27502f3b4bc2e01b1ad8d7c3f3685b2f730c4693c84a3ef1a97634163e07a724e7fa8971b9861f44618ecbec6e674407fb87b3c144606b7d1355ccde0f9b75209cdf0a919d2e3058dc68dcd15ec816f1c61ba6ef525ee29f37c20bd82397aed78d9c23f03f15417b57c95d9edc6bcd2ba4d07225e7e66466de3d796362cbc34a62f02bc32407ff12e9cce257fe4729f391a34efe08c06093ea108fc8c6f6e77bc25b6b5a9ea72c14d6316075b28bf9eda32e0b334baf4dba755e4f7bb22c760607bebe5128ac1933a1d6d1d3095afb53922b15f35e32fbb94cc8caeb87107dd85b19cdf5d5ccda73708004ef09100eabbf69f9077906c203cd352e4cf2dc541f44af183ffefc18bbb6a1fdb0186149b691b0a5c8ddb642c7c64915c7ba93762a05603ae8479b1153574ffe0c67a351fc8b87fda1fee0204030426d41c8a7a376e0e279197263b3d989302abed16a5d8ffd8ac10737b278b295b89fca010e7bbe976043d8acf0627f108e2fc0f	2011-11-28 18:47:36-08
talkbox:pcache:idoptions:1	\\x458fc10ac2300c86df250f206d9d73a647f128bba8f76e0d33e03a592a2863ef6e3b19e614feef4ffea4c603c2d1b577ba704f803b9c042b84fe46a3f010c04ad2406fca4d917bad12fbfbb3522018a553994a9962bf2d17d5acbed3fbc9e3072c6355164a65b6cf6c08d17190fae1cfaee3166c836a1dbc0af9fa1953be8075b8c5897f30658557dfd07827e7397492f7ea4c3402798e426d5cce663476f9e425343e5ce8c0cef317	2011-11-28 18:47:36-08
talkbox:messages:individual:Viewcount	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:47:36-08
talkbox:resourceloader:filter:minify-js:260fd63b6ef730ba3609fe218f936508	\\xb5596d6fdb3610fe9e5f91095b6b038e1d3969dcca33862e4bb000e9962d6e0b2c0e0a5a3a4b6c28512329db699affbea35e6cc5a2e538c9f2ca239f3b1e8f77c7232d9d5ef76dcfb1a644ec5279ccc398283a6630982491ab288f1acd3b3a6944644a7da2b8689338fe0442e2489b461eccff9c345e7fb83c3b79ddfc6130d8b35fbd8a899070ca3851662e1933aa0a9e2bfbbaf9f351f34e804a44b43b214c42ff3ea7944890e86bd5a422427d8ccb5a85e051f299ded036cee581680bf0a954201a575796a40aac96651f74bb878747bd23db6a5d5db7b2eeeb168e6b79496c82e4231a9548100648da5d8cb779ac1592065c2ce8941413ded048b6a7e0a2352ad02520e4111f737e530391348c5975714b801b50b74e40c8d15a519d00ceb81fc1982575d3441c4dc57c4aea745524f288f08c90afff26206e6b86da44de466e2d2051fc84311a4b5ad9800213503f60f8ab8630575699db0dc0bd19f3f9654027ea98adb35a81661422558be08c115405c36748c6558f78085de3070b00bfa166f3e7080f18b905ef578c42136ca7c0c13cd69b804a9d5260755bb162aa1a60cc880b01679e213e4a30c65dc2e8b7da65c8c4f7411a43c8b8cb655e45c6673a07d5c957b8944b6090a68d5a20caaff5c684e2ae88ca620a3f5e81cea8e743ad111114724c21eb96bd14b2c21573cc631b5683304f10dfd7fb5e3341bea0aa469b74f0048fe31713de32aabd32a50049bf6d3ba561824c8b15e1327591ff4d3a172f2b7ba7d44b5ce4f50cfef008e92b7aea4873b93e5faac7e796ba2e9c74658a71a2d44ba8eae1c91a63caae66a05559ab8c94e0f1f6ccd52d56610eb73a972f45afc9b757635d701f07e5986c5ce7669b49460d19fb251c5c19cebb2df583c90423503e3ac716f831339c8046a1466e8e15e55a5fdfc88e4541a5887c34b3cea1abcc3b8fe6c6739d6125f7e4d927bc5a0c3c9a7951293c59429c3049d667998dfc124b8b677007e4e619dc3a8e9eccad0489e4647d1c5605a4579d195e758c27fe62b49d28cad6493516bbaba5ada1bc5b9982a47514eebfc48b4ca55c2a0119f8c4bd5d00cd629036974815e494c2ac2db4c7a5ba9f6c669431b898ea3183021a1b30cacd1579954302116eb001cc48e427c437d7b6153390af64a54add31c1747b4c955c355749ca8ca8aa6e5b4b1a63695eb9ed6c2d054b05bcb05e08bae65e64608826b47af66e3baf4727936d84b4d63bb051bec92db75612a280a0d3792efef3abbeb7b5bc4787dcd3d71da8904db8089fadebd9c9299dbfc09a4350040bbdca13c3f68266f93df3d992743ad96661ad9d1a3baf9d42a7bb1750952b3c499e2dc79c0fb717131001e6f7870a16cf9e6de049acdf009fade172d3d60b2ad2fe7a09b1ce87a6dbdef5f575b3bf7cb6cc92215a5735eeac997f8e2bb874058d95e5581d45983eadbb9d0058dcd1ab6bc781ae163d1827bee5a42fa5adf4990de18b7745a96e19c444055519e98b1c4266fe47c12ed035f0a6c724e202a5e2d1c8198d3af8f35d5372494eca6354b84bc2e7710062492b6011a8251d4565d61917cc9b61a5beec0a09658a23fd3d82999ef2bb9c4625f9b4242c0c973aa56b782f1475195c18979a3e4c6b7b757eb45374665723b8347e325710e9376a04e5d62e866ae6d0113ef33f114149a41ea895ef112a9be65edd89f6d62fc32816c414ababccfa4ea7e3c114188f43acc330597958fd916caf2488f3c2e71c0ba2b4f79847a8aaaa0ee48fecd861b7ed5e7b3fed3c89b437bebf38b31cfda4beecfa2ca87ad87f89ce23f48bfd302d5231470d534f76ae2c1465a5aaff46716b6ac63f108a6bf56148951eb134bd7b91954a33ff14798852e0fd41429031d165997367ed753552c706a2f66c242eb36a0cc97da4742ce1bf21ee013635f863f6387f90377755367498a370a776f3fd7db3d255408fb0ff94a671dacb9bc5d0db429bcf59d5fdae4c17205b2b368410cbe5ec226397e80548ebfa7ba6887d90b717835adb6344fbf9c9fea64467a07b6db485adcebcd45a6912b19cbd2e467c6e2667cfc60d70f65b56cae6d8f9e7144e376b7cc9ba0fb27134c597d43acee1c38e1cf6a6654db4659ca3ac9177f74a1585e5bc2d5139e01d4a2b0ce2d8fb4b2a1fb751ad6c5ebb9bb58a0154cc2d0ce1d8874baa00a04a344c9dfd286f154aa526ba4457d6664203aa87db8f3e872b5804b70e412b8e7415ea535d467e8dfdf42ff8b97fff1a3d909305f882ffbdc48c2dcd8907969368497f83e48970e13cfd80ea0399ffa5af57e710f99a79cfbe6ff6effb74d2287ff0d66836ef3cee26692698e9006d58a3f9812bd33cb42b853b18ad3b1e7e490f87419a7746f3ee1109e3be3eb006101564c8bd84811c6437bd9f7ac78b1d2c103c62b7836c3659f4e9b363901d3245d734cb3483eebe8d5fdddeb07b80dffbff8cb4b6a035ee64423469e1423dd0af8a0f3e64ecf7adfe7f	2038-01-18 19:14:07-08
talkbox:messages:individual:Newarticletextanon	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Newarticletext	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Red-link-title	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Revertmerge	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Protect_change	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Unblocklink	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Change-blocklink	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Revertmove	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Undeletelink	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Undeleteviewlink	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Revdel-restore	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Hist	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Diff	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Pipe-separator	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Revdel-restore-deleted	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Revdel-restore-visible	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Talkpagetext	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Editnotice-1	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Editnotice-1-Main_Page	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Editing	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Anoneditwarning	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Longpage-hint	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Bold_sample	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Bold_tip	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Italic_sample	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Italic_tip	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Link_sample	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Link_tip	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Extlink_sample	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Extlink_tip	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Headline_sample	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Headline_tip	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Nowiki_sample	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Nowiki_tip	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Sig_tip	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Hr_tip	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Copyrightpage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Copyrightwarning2	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Summary	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Tooltip-summary	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Accesskey-summary	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Minoredit	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Watchthis	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Savearticle	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Accesskey-save	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Tooltip-save	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Showpreview	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Showdiff	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Accesskey-diff	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Tooltip-diff	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Cancel	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Edithelppage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Edithelp	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Newwindow	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Editpage-tos-summary	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Edittools	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Create	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Addsection	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:56-08
talkbox:messages:individual:Vector-view-create	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:57-08
talkbox:messages:individual:Vector-action-addsection	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:57-08
talkbox:messages:individual:Tooltip-ca-addsection	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:57-08
talkbox:messages:individual:Accesskey-ca-addsection	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:57-08
talkbox:resourceloader:filter:minify-js:ef2af7a5c42999eff3883facfbbd3bdb	\\xc57dff7fdb3692e8effe2b64d515c888922527691bcb8c9f9b26dbbcb669ae7677f79ea4f82889b66953a296a422fb59bebffdcd0cbef38b6cf7ee3e6fbb8e48606630180083c160006687af7aaf0efa87cd79388b827f443751374e82599876a3f9320ee7e122779ad7ff5a85e95d777a154e6f26c9ede9557491bf8ba3e94dd3bb582da679942c9c3d6fbe76ef1dfdeede5fff1ba15d2c2a307d059887b7b97bff35481bcb34fcfa4e40fa8b551c0f30750fdff2ab281be053778ad8ba98d0bd8f2e1c1373d727dc562bec6658dc2fe19d7b4fa819a086ce6f417ed59d47c021a6458b59786be1bb9e911176f320bd0c73d7f5385e70fb4cbc76dfed06799e3af72484707628f3ba22e198890776c8d8833b78b0e420a107909386f92a5d9044060f90e07009bb83c183778fff77074f69c63882d7ed4db727a0fc45b8d619b299928b280e07d8265df1e21b30d01ef9dd324c2e24a4effb6c0562b9881650494e64758369378b64bd60d4ccb73ebbe54feb289efd9985e9c9253090f943f6fb324c03e6b14fc1d7e832c893149e7f035a175118cfe0f9979fcf7efb157edf5da5c93c8487cfbf9efcfbe9d9c9d9c7df3f355eb231515d498a6769b0c8e2009905e2c37de743948617c9ede6b7d38fef3744cb1b4157b90947d9dfa01192cd2fc9022597a4eebec7d8d81b8a921aa7c1459046ba64cc92cc28244a35d915e551ba59a54f619e4d832527635701aa740a15f17855be866906dc7f0632d16d88129a06d0a113009b4a115c88423cb69064bd1df5fc1da42742aa821a3cdd28963d16df2d10799e45482d93155d66529e02ed7475014cf8cc198df637a3d1e07834ca36ae330c3affb7d779331a7547a3f6f8c5b10bf983cd2cfcba49c318e0dc0dc2edb9bcc517c1fc19d5d8c2a7ac93e2375a2633fab94a16083089031856619ade59954106ec7ec1d3e3e02e59511fbcc49e5028bb50e83a9cdc443933310b7dcdc2beb9cae731b5b5a093a7d10cfa2725499aa00ab23c616393e8dfb9e491ab6009835b94eb091e39e8124abd48d23942ad236cdd79304579458b150a2c5b2d920c7f931824956919d9e8c50a14d1803139f21bb9800d9d2c59a5d3d0cb0d64f71ec839483af27b83e8c8ccebc6e1e232bf1a44edb67bcf717dfed34d43e00494b6093e8cc6c3ded82b26f5c7a03a8586e4d8a023ad91ef2fe468ebaa346f1ee4d32b0f3b80bfbaf1b884f593e8e598204582cf32f97600ca8e28a0a26cfc115ebebf5d3acc616d5b8975af139870d886b96de632b71bde865347f1e0baf79a472d45cd63a5ee82da6a2cf5d4ddc9935f937598be0bb2d0716bf9a321f7285b2416cd115102417bc5f102bcd4152486d0a34509c95714561e4a8f1627878855ea085414a8a1595b955fd11fba96f8145fb2c197419a851f6132e5dc1d8cb7b0a2866065dd75d912ae54b4ea711542a91aa05b78294c1936476d4b9757b48dac3d2ffde598cac13ed0a514679febdb7db7d512a06f5ff57a1a8f1d747b4c21a139c0f59b06f7df747fd0f0ba35047d9101ed37c459a53b7ee1ee472ec861b3e9f7d060e276c63d43faec10ff0555472dc70ef9af7c175d43260bcaa0698540d9a17cd253e3a182120f3f4213b14347bc81c5797b8c023f0515beb894c96e375b4d32b0fc7a5edf3d04fb50627f5acd610a027cea4d1fc050cb258ed7efb99b4dafdb731f943293f6d603b7b8729811fc1d656fcd83a56596f9c2eae6f69bb4cf401320cc2c4a45bec326c9ec0e3a639439ac9be631738f19fe1cb2384fd9401b7150c010f0c6bbd86c93eb709ab3cda6903714c57451f2e3a2bd27ea91a72ba8849c6efd6adc819c26a6c96216d1bc122d0881d73259faf83254d93817708324884b59fd315604737cff2288b35031436f838710fe6de8ba1224cba8191959b2bb4e08890e934cca2ed14e966dd684a113c4f88bc3d5a65c4d7ac19b7e1b69d13bb000c8ae20fc60c9135601ee60cf9925d3155af92e4c99c1ecaec666f7f7cafd62cf616489c03265367b17071974080ed4011d66b4cda3006d66241823652b221f865b41e48074710df497573d49721385a5558f1c2d94ab573137e19d07d25f855eb214f60bb4182cc448c8d26279db6fb51c02f3f9a2530d0c4a8411d3e423a609ad2808c9f109abde703173a002b204d1551531f77e476401f0120ce1cceff4498b8a428ab966ffa2d11edc657e01c8cb8b293455fc84938b3bc8bb5998d373debd144f6e1be928db4af53429b361b89826b3f0cf3f3ebe4be64b302141e8203e50773e9375eba6c1fa586a47aca27b58816501b85e81cf6336684896717458993077fe79f64e1070611dadb097b06c4754fc35f0f0d5049b25f3205a20207f32407982099c85d3551a22307fc285fb58cca9a00a060fb2ada92a9bcd3d374481cf559c7bb3106bee9ba251fd2e53a33d1b3c1c72485346c205e07052f62c7f7cf8653368c0745ed3206de63bc32f03983ba50d52684ad73de6250af268521f921fe6e179638d6cf6ab2486dca77a880c14d39720551d4e7c6100a640c1cf402e088dda6a31e38dc1cca1ab087a310fdf0b4ef94c1a5c7e42bd268be19393c90981c14038c9a1674d56301a2cfa7c52dd8b164bb05cc5bc8a28349409578e678673a69160508161ce29182ad02a04711c1361f0201026f12aad92882ed5bd37120c1a83ed45e2b4d29d44a09fd80508306bccd264d9804e344bd6609004590e0bd6820f4e50bc0ab22a8a0412765173015f488ea1872e49a3cb6811c4efbf621bcd823c2083f602c592a77726f7db8085b20a1c86dec47d281996bc508b29998fe1ed34a4c1e6fe357a480966a13444b89fc28b00c686e372e3c1a4c8986a99349c275fc33ad172430ea7b4566bcf512f6430cea3bcd0a48f0956e4932dc1dcc78ac6ff3f7f12a5bc35e605c45917de1f73213aec9bf5f274359f07291a9ae40465f3e0f6579a3b9977f0bae776a14fa18f232b7a74c3eefa2a82758ceff7369bb03bbd0ad277a835e57b9ec6bf8477f818c4b9789a877940dede92c109d3b5af1b4a7915f687a355aff743af033fdf7ff8305afdf4430f5f7efaf0e1c378ffd2632f5e90400d680140d0ef7bf4f2414323b874665c38f0f4f6e0d5f7ee7dd8dd29f79ebf62cbe8668883c5e52ab82c1b344ee17dbe56b0b03e02936afaf9d73fff38f9951d1a1ef8399a585cf0f2a59b47791cb65aea1d162ba02c7330eb5a2d8328cc1d0bb0f5f2cfa08bc05cb54868142115683dd93a3858b89dbf5ae47e05416e0717f8f1b04d9523bc960d47add389bceb55b0c457cb1519b0a0d05da8325bda4258078f59251b62a5a23df200707b9f1e371bee13a8148898dd0bdcfb7edf3d262c28fb903fc0cae681dc83ef6a4a27308f13b887b104b6be59f091c8e169cb5576c5b3872650c7f4a95186515fb98a552572dbd38b16797889fa1bab6cb6d00cb42d77e390e32298c47a39c671798fc82d10ff111238d0cc2295ec3849176d697aa82c6abe4457af724de25a332f700830433b6d188dc77e347828300a8083871d5adf5211dc1a8559a12d8a14cb5a145e38e3e2c339c3768c9ab89663143babcd86098a3cb9f705ea6dff110c318795d00a7003b5e614923e367aa885ea1e1612b0c354b41a23bbd298883ca5f69eaf0b5779143fae071529040755182da23c0ae228c38d375a5b7b9466f4686d5119c0da9550caa10967ef196b6fdabad40b68e51823b58d7cc2ba2689f36879329dc22409931bf7e0f98cb6363b6136ed30edc528d012bb288f12738a0b6dc0c5dd826386d36c872f543ab0c881a9b6c3dc7279120f5d44b8d9d06a153811fb313addf2c5bd7d7df0dde335265e8803cdc06e15ebdb387061c15e9db3d9d448416770841d6317c77d22dbf56d2437b834c386e304f20f9ed0175028bc3fa001ea30b20787646acb8df7f1e122c99dee2221b82c8cc3698ecbc0f2c63cef95bbce131752bc30f27fa9920dcc319461bc3a7cd245d310dd8f3077e5b8e3258d265dd5bd29cff24ba05a929815a479340575f208050526145e25d05417a1f7dab90d697be03c066bf6551af375b6a12fb21ca619f8c7c7a7361ae379227d129260c5e21cd1b495b98ba6e4b7077dd3f2643ced7b336de4f0c41fac449727beb1125ff0c41333f13f29edfbf7585d8fa11efdb3ae46e622dcac7981f16f0f7a48f3dc2ce5db9727987668a51d7cc0b47d5e32ae404f4f2d6b54c683647e5da7cbf23b6acd8c2f28f9aa6f9a650c52d230f6394076158639b9b2b32e259c6202b490f1d605ac33c0f69184e81d597727582ec3c5ec1d984d33a7c004427fc2da23469bfb7b1408ac1b0593d98f7767dcbfe034afc260d674c178eb9a7433d5278021e465b3c9645bfc2dcce3687153d312ebcbd330053dd15e5f9ef09efd198353a484d95e9f79d45a56b31209923970f919edd9bfe36ac828838c5c0fdad7bd877f7cf83b86bf4355bb3899d24e53f70a348f7069593ea8e1976fc62f86ade3316bef7543daafffe33d272bdc4fad6fc8ff44c8733f0dc5661314495b95b0b450be5555ddb21bcc995bdbbddc47e5b16a052927ae723eb01dde2ed9e1fe68e8909e768f1d04851fae4fe101a758f8e9baa3f1debec756cb19f68102a1cc348381d75fa34cf4e13d7ccdb06e321d6ca82c0f1653f4e08ad5df3d87f22588d6719a9800d9d349a603a2862d87ebb578355f7440708dc06b7c335f77b03fcae765b008637a5976e2e4326904d8a31f232ab5fea3807130096304942e365e8f82332fe2c2026c9ffb43a4bb80167d8c4f49bb904d4bcfcac990b725ef4e900ef31152833f352c24e64e35aac786acbd7daa6d37f75e8f9bb86552e6d1c342f9aade63725ee1662e29b9cf490a60f9aff6a85ef2540f0794870ac58b669e28dc0ba874dc8a58400ecaad7217e2e8a5b1b6c18140fd0ed5074e6b47c1dba3fde0ad72c060498cca83d909c8727d4b0e4b5e2c7435c42d544ee40d1eb275843eb5ec265ac07a03f741b137cf8214ac687a85ee965c2ec209a9963da7f9cdbf5660564c82b4e90af5e788022e60390d0c4ed2c6fe5bdd4538eba8499d9e3b209260b6e4417c19059c601606e9f40a4d34203901f3290d3949f5c61aad6ffa07af060d564d75c6dd30872429d1066403b0b6782389c82cb558d7ab7553d4abd8579017e4345de1765af82f2c0ac9ac628b824999c3cfa2afca84e1300a40888c1dad626848f84719319534a0d04edfadc6dacee84305a7565d15aae5610ce7cbfc4e746ee510cfc3b9cf05be4e0398178ee2e8ed5106aa0698113f9082b66190a23ad70fb49c9fa1531368883e18cd180c0bcea11a13763755c94c8f1a776720ba6ddb670d18dc2aa7cdc63c1ce1695dde2cb6d55238db551ff5471ef320066fab259f446d3f91431365cebb259ad06aa4ab8e8d82904d2e9a88da4e435afd06b2e52833312bd0a8d98bc5c82995cb5f0c970750695f618d8b557d3f0f22d3cf84af395a6c147a42cf62e7a13450d28be9eb970707e701aa1cbfc9430477bfd9fbb6c55eb447a3cebe7ffce5fc3fee370fffd9f400b6df7bf9ea3c9e5d9da345dd9401859da6871196afcf432ced3c25dd6d19215f581b55b9555a9b8d46dd711b72fe97ca35e9438fc04ce7f810e0aab3dd1700b08781724aa938583758f48a7a8b6895327b68753d0c6c0f04390e1cf7bfc703128797c1f4ae1b5c07b72547082c8767c9ba9b61e6f92c9cac2ecfe7d8f1f862c6ca4d4358d766f93937aafff6fe8c0dcad8c5c86d9c9a8bc45d6bc1846d1ffa1536f28f771f410719c862a687792eacb5fd97001476a7a87dd0ba86f5b84900b2a2996f2761f993aaf20d1b5d84c3a073173898c05849b39cec74f77e026d958569fe231f2aa167658b0136b16cfb105b9cdbb875f5207d3d98779fbad470b1da26f0bcb048b5db0abbd7398f3e3037540dc148c91b908edb9806711cceba5da1cb4f06b80d774203ec9fbffdfa739e2fffe0bdc4d1fb6b7caf8e039d40495fc37ffecee9b1dfb2db797cd045d4b3b3cfec6938d1344db2e4222fa32553177148a53ca072dd3d29d4e95db28a678d459237b80cd1e3ba0879842aaf24564daab993a2d866c9394a408b0c1fce29a00cecaecc1361fd64ae46deadb7e021a669c4c366c15039c78dc401a4f86a99e638f0384da3652e223b8e55022edcda6c9f4e0d749757d0b90f6516ac988ef96e9b8facf1856c799cf2814ae3100ae5e70f7ebf70d831737d1f6c817b6405fe805a8a9113150e085547d999154aeb2928e8c0e6ce6b1491e5b4360961e6705c4d8ef2225cd229118a56267e76742a7b02475b18d284d4d333987bb8f52bc60ce9ac5bf73e88414938ece47f9ffc933a60b65aa2c984317003db83845dffb69bc058ae6851588047629f4b0f162842f453bd08870a082f22a6c5f8ce2417cd7f4f56a0f5d2640d9aab3101809bac30801b79d230303d5023778d55162d2e1b012cec83b8214bc0bd1f58857f0de36489ea691f6310717f02d6420ff91514d208c9d4a9ec9e9f7f3fc5fe798bb145a2e89f439ccb60a487f91505e8234c83b5a9ab3470c8eff7bb7d105b1592700576ceeee83400c6c0475c24fbb79df57addc195414779a950fa0f55743ea7c1e51c83eca7b0160dfdbb30ab2b10f33b586c9ac4781421e9a87d154249161474078b943c9c5e058bcbe279985b1e95778a00bbfe2b1d7062a9ae349c86a007670d87b5810f005e65200efd7246968c4b29699841f7cc688e7075b8a6231414ba96050b18044289cead5b8c7834c0456c27dff3e0079444800c647efcf4f94fa1642433be7f8031be02944740d86c8920c87aa40834738ae61220eed898dcb551046347306b3668eef79b619a2669f3ed7bfc396c6c151997a8590288f1681f88bd653891506962f84e825983174cddde9a160e695c070d75e60100b8dc9001214b39b9c0d46236afd24fc00ef4f386affafb3ecd1b94a09412ef8960af1b2975d4d64144a31127b65908ebb0b0715b6d1aac2f4eb94eca4e80945fd8a812e3b652c5913fd6c415c0c75800df3e93658b1ce5dc34b0742059738d9aad79d8fc07fd7acdd542a6fc299e3c0e0335936054c9ae06e6597faa179e2916689d69d091244f6633725f3796c165887aef0eb523e5c65196db489a933f68a16b605ea4c9bc88fb5c23bd327246b4cf7495e2c2f003c65c85335f0551cbf60b66b31f57790e1681769dcd81b10f511c7ad9320c6767d1126c94cbdf616ac1df777192414e80fc9c917b09c13fce709fe43d30c2a98900807b2672d9a178f098222fd2a824268b6287aa50264a6587b27826cba724ce091aeb92174056cf1495242a395f7f24735bf3e79b1e6a3c10438b556e832153b5367634a72505c274d7d10c16c9072fc5eb55185d5ee5fec18178d70b0a365f77b03b4c82b4838d35211ec8fca245b112214784e586990cf3202567e9d44847b1898226498aa1853df11ac43987939214e9e485a8cca1cd0bec2a5992fa6c99e09e3c46ec5366b298dac76b814d92262c7432cebf6c1ff9c25b8697a41a84a6141968bcb76b05f4b75a2aa30b13e1f4e6848ab281f00ca991e930dc0004697659dbaa94de176aec5f7acd4ed3758bfb6d03deead6e2876a5bb3009aaf4f217979c6dbb0a8e544d3d6af470580588b8ab762143e5102394d123c81f9c8da1201a10a812429f1d4a6a54d9bc29204086e1af1069f451908ea0ea4bcc0737ae208812a99efe942355bad729a18177fa069e2624c97495d02817592e62af6bc70e8c00e52b19587695fef9447af2344e85958dca02e927db7caf2645e477c2bed122a2fa1b287e821617833eab5a679a6d91e0b204b39122e16e44f3f95e22cc0d9aa1d86909dd0459f1cf616fb1418985ed105469eb1cda680007ac767ebe5196fcb3e7365c8a54eb119721818c4c1325b61409b4a651e46058686da5e866964ea6648c1f58152e20f7a33874601efdbd8b355c7c3814e11adf722d7b79917f61da263ee730690244878148b47a64918f3e92d3b25be8577cbe4e9e903e4de44930f822b03b990d3cda6b03c88cf12711e0bbada29a5f88f6328ab5c81a23baa960e666a64588271997429565b186b292d43b6d7144085e07c02a7fe32a09810de3f4043e3161134b8caf6453fd9690bd4b6ec1734410af9b75a1c03ed27d22be60a96629c7011c0f17cf960442c2c304280fc3436198761247030c519cfeb284411ae2838926a75a091dfe366c71654551297135fd3ffd7fac0e330be6ada415d07a869721353afe8442fb015fa66539d0ecaa327ce099196e05d4cc1aace55d5b73224f039c9fc6ad2dce1bb985542404ba84e27337954363f2d89c13292bec789b8955dd242ae25d5f32431b72d7a6ea9e3b6eb9079f19e9d2d3b8cd1db959a2bca58962d8b96b3599554ea80db76af964be3671558a0d12ef4fe6a7e44e24eb1751f4a9dc4d73d08a674b936ae6834be59c07971ef6537d053cd40e96f3e5fcbae2dd9c7117c923b766d3a7d9c261bcc2028f2ad6e50c419a8e64764f402284f30d5842c89a4b4480e4572adf9684ec07cb428316dc1e1d2cb93a540c2623e6010622d8e9c63b95129e15b2dc160ab65e82214a17ce3ddd8bd1770462b1640060fb0dcfc3958cce23055f4f1e6083ca3621cff01b9db887e89349d3a79185c25c90d1db671182e94996749da2de7db967c0580c14461edfcf4f679aea877258276e3697fd082eb49715a398ce7ea021f3ca1028b424198138ae7f6d933e970830ce97cb3ed416298fcaa04020f9b0de3a7b5393886e02a6b09ac539d2a427654791ac7c7a0569ecded59bb4c49d2c02dc81a78217a5230e8a7a066c238a57081c1f7b559e28419f384e8a4e75b0e7d8d98e7c1f48a704d723a1596989c045e7762740cd526844a5db1ce9c173e05b2b8311e8402e8b07b2669671575500a22977705fe2c23d670fb5d26f19df3ae8803fa07572cfa903648e14990dc0c10936f7d67b748f1c12625f4f0977793f17912e559adb38aa2d93fbfabba56a5d06be5b22b3ba73b6afc7dfad9a7bb0c1c490716a6bbfb742bce265b26c945986ee4a53fa3fdef47dd5e11de20cb83b8fd62c23924c8447e4dceb9bc634283f230f952c2f93c98da9be48202bf60437221afa830aee2c16b46666d779fba8889a444a7395664d4be9d79a70f8cbd4e1fd68e25202120bec5579203555bbd19f83b8a0047c97809836a11a9431e661d28f0b224bc3287f2f0c1aeff7815ec3a18e2576f550430389f937fd0c8171707febe08aa1fed0f0f3a6fc69bb9bc7c6bb4ffb2ae0f01def964759919c8075bfa1b820b21c363157795021698b7fdfe164cc82d61d192c92fbc9fe3c949d46aa58c37af6512bd7fc7ab66267d5f4e7af39aa7a9a5739935713a6597f6958bdc91c9f6188b940a035d7b6cd19df78982648bb855884fc183daefd3130cc437a3eef0357682611ffec5db63c66e5dbb9ab22a556050213d9b53a895c1c2a04ab4265bafcb7ca87e1c7e57688a7dbc23ac41b7df8ceffbdec310d4213ef6bc07204341af8accaebfc32f4034ae97e1b151ddbdbe7be47fd7c51844590437b4d772da5984bf2f706ef8192c2d63ff01ad155921caff805342a63a81998827ea244198e70c7a6a1e413b8e80f98ac02e16676c4d6d68be889976ec2b026239a4dee964adea1173dc79129117c61ec2a530cf449006e5b7d93177b9578600208eeda9c6730e85430d113fd5609f7e88f8f187366b89588e3458b7a664c2d1a985ebe06b9011074c7ab34db6810b0ceb30b64768e69ef1dcccbfafac2c60e9fa523c3f1e47361187903a2ec4e8950178ef78e42c06671e0f6364d64d0960ec323a4c50cac9f9ce7db1feeee0113720c6adb36de728064569a86320c5e6b745adc050dc468fa86eb26996b59edf57dc7ae68acdc54301791f8deb04bfc3e884883b884b8760e2f2219898ce6ce0910e3a67c1e9c75d7af0e9dfc74eb1d4483f56d28f750505c0e969d535afffff8ef5fcb79eea79526fd40b0de20d6f9d29ec0b60203d9e344c16c9049418dfd7316622dc662cf75145ad0d1aa78d34e081ee49fdee035df08652335651c6acf55c82dfd71314d3da7329bea9a4282db06750fbf0e1c02285eb3ab6befc115af4e603ae88323cb9c8fb64ab258d5c33df744be7c97257581b6a5e83341570e52b05ccdfa13ce930ba4ad667c9f42cb9bc2c5d855bd3cfc4e08611fc33bf6aa6cef9b0c3f2642a8fc1904fe136a2e02b3c49b26d131379111a02e7585dd4666392b01d1009e8e7f474192ceac72864024905686e9c23a7542e8fb9e5cf369f056ab4a3a3c02874d7e0dccc328aa10def45105bf9a4ded8376c4057da44d31be9b9d230c68d355f415ff00c68377d38f3268ae3f75f73cac765b441ff29ba432fafe7d92528886816824848f76b793d85101bb25a1ccdd3b3a98e91aaee084f436a6c4152e5bbe27203bc460addfe859ba5d40aa22964e237a9572a84b7b8462c22096faf026aff405761580d67b86d79e41d697dddd0b1b708d76a0f378c7930194f30df7c0166389e6223cabbd5b25e69b7f6efc28f5a9da1092a0645eff2ed6e08fff8f0b7b3d90830f253a937726d19f17d005ab88ac82db8b0ca1020274ccc409b7d4e13b04f02ae9fc4c48879533c9118ffb89a4c94f3bd1084a134a2107e39ae624a17a76d514953a1c2b0036c07ab9972f1b892bcefb14abb3ca60581361ee09188f83cb5c32b7c155ea1bb93a9426a87f8a04c8a51d82d1b14fab5af0641af3910522b6851262fe6780a0f38fbd4f340b5a967a15fc702361200cdc205abeb0a563c07aefa547a2916c3c8e5c782ff6d95c0e2b7ca3cb48f143759d36b5e82b6c8a535a74ceb34f49aa3116ba2f6b65046a3c523488ba63e8f6fb08331a6e23ce44315bb1483fa28cbacc5b694bed36c05f3e5a0c4356b6ec36ab6fe051c54601d6dc78aab70de6ec7b91438e2022454617af0d7df40c103e484030495f4332e2e517ebe5a3ccb2f587d3189712d88e5096db50c57a8ede2e4378f3cebc691026947bd6f36b52eca4ebf2ad3b846841c6a8f30628b0bace57a78eb42909aa6e3879efd271f7d975da0e6c0a31e16fac83a8acb3e0d8f9a18e3e841dd4003e08dffea6c3ade50cf4fa6f3273a978e37e0d3a97456b8a4c9265441bc764eb03129460c7d2366aa7b5f77aad302ab99a3e8fcfcc3c34e1d8d475695ea64fd5fc42f1db82f5c2f25dac38aabe35b95444add4180d73ec933f922af7013a671369f4ee63fff44fe9683f8db0fe04b86b20a86e4417ced8cb00edf1b8ea0e79ebd27559f24796ddf32cf8eef2264c521d8559cf998b5c5c2e19fa48022910ec01bfb8b98ea431205be9189402975cb2b450da676591ad9a9fc7095dd35882bed56973da4dd8e682817b2a17f90b17b46877cfa78517ea18832025fa117015bad628a0e86149b6bb3e8eb7ee496cbb01623d448422a547645e683d4498596e1bc2a03c87e55fd7567dff9b269b8e69177a7b1d973f7bde6de415348fab1e56efcd4d5a438f419abd5adba75257bc2023d2bae0af981746a6e3c9e5f871ee3f1667ef8def46ad11a4f9ccde761ed333f9a158fe413aff6a0ac3c99fff483f915149f7a3ebf4e81d289d3340deeb8489e74489f77194ab6ce02a328b4863086a41daccecfd64b9f33bc69930ad4c047b50835d6ad66cc7168dd4a2f0dd7d88c6320908a4bf705142c52e560a5a5acadc9f1785127830edda1f81dda55b5a2c01fc790a560a71507f44c6c2359421a0b710da71245586f4e3724926f218369c8dcf5e3cef1a9d253b6328bc5d764f86d25534b5df17b4b1afd433cd9efe71894a0db806077c02a98a09790ee1f69bce4909a0aadf00584ba3201600c4b3930963c0174ccdc68dd5982c7470cc705bf840dd643a5133fa8f1d4b7c04ab9194647bddbf27135f7de200e0c59e4d427d6c8e67834085b5826e46013244c475be67032c6daa90ed238bd44283c46534407f247fa8196a46e00758eb22b1edcd83e78dd4345c4d3de7202ea208580b4524d13884840f7e070dafa994e040ece52c8c67422a2abc44331248a49b9b2cd067d646d805313069e4074b5a1dfb0aedd6bc8fd738cf88916f28a625016be6e2bc9ba4e1902c0d89f4e06d309a7ec4342c9d9399d78d30a89f3e1c92b7d541019f4a1b3681e262bebdee9471ad9e3b4f0b2233cd0397828756613cbd06b965a2ba82c158343be2b6279577fc46fb3b13aafd45056a2b89113a4639f0c1202a6f3b71c487c726f47c7337bb24fa82b3f81cc91495ef64a9dddee0f448f33e1e47e13015b19025813c00f3a947ba72f5821d3cbe802a07d04dfbeac0dcdc96f09519d45b131928538926c9d08ae862187ea93246a4c5f5a55bc5306946af0e47d3c87e19d0a2de2250a46acda8234fd83084b32be9e9fcd73cd48a8a6b4c2616741f55380974a70dafe166cc76489761515b740f7859e4a0b3475c35d819eba3a2a64cb117c25eeee2d640fafc6d5119ebeafcb2f7c11eabe24ab612945454894cbd33355098b8f1048568d509442ab45220cf0f20af9745896aa9c2c34363739a944f43e695957b773c3680df350ba3dbb1b40d642b6a298e14e45a29292e93604db7e34cadc66dba08e83439f4ae9e00945bc82c86d371dfe01c3a62b4fb95795fd5f29faf17269c34ec613d32537bfe17229cc4e8cb5dd3508ecfac8685a29b06b149844f70d80e1f5786050e2bb0192dc0d90bb39aaafd7e046f4f7dd2a79dc8c79c8932c564f99d0bbcd32b9a7591a5878238fce7cde38500292bddf29c11a164b1acea2147adc59f2016f8740c9e89b60440ad730e2336b15a1af62cd7a82719cff0827bf1402424524281deda2dcbf577f5bae3f96f1a31ae6e8d5414f6fd83e545d0a12c0fc42d76f55e6c83a085f2d85e1d264afc3af0a5f9fa82e40cb627b31741fa2360ec0d6a683bbe7f4351e734f7f9acce7c9629f72b37d5642582d610504eb0d78e85e46170a604741e0a749040c3e5a500a08774304103e1681c2559a2c43bcce10ec84f5a558b1fc2aae9f07ab0f7743347810d346741e9ea7c9fa1c2f3e4c333b641880f85deae7eac690f39c6e8b27e3bb0445f7855979c82b226474214371d32d9a01220c497e7800c1fc9a594e1af7782c1f2f60f798a4cc5c35ba7354af7974c449a9d341f2fef95d9e3ecc412ba223c078b597e878639fa2cf2b7c1ecdce599bf875d1b0c187c103d47c0eaba35301ea688aa64d598032cfecd215fd7c8d9066f91fc99a9f8580e42ede7d832720e4b3e146533074c78b04a29722a8a4eb17618635489dbe74cd155009a9279c60bb32d33844624d7132bf3b0de3382bb96b31d5b761c4d285af4620a17e3db25ac8b669c84ba2f61c44312e8e0c1ae4736a7ed394f7ad20ce155d89d3841298bc69a009ad93869879c69b903e8064ed1836df023cddff68d2023d9cac795634bf6ce085094dd6b654447bc71ab96dd66ce07d09cdd60c9007cd7d7d9d64f0560600d58c4be8ad4686e839761fab77c588da587e02481f98d8860c34728c0136ca6517f31b482bd6d6dc69a7b6b66704aa1d503c35f5f35931916fa06006b6df4732d4953280a9db84e75f01a19c566b578e00ce821a03d536a9501aae18f3a2471bb41f947a289c302a8cbe23bf6f03d42a48b9c0cbb9e6b3bf1fe108f30728f3838f4f1ccfc7bdc33eb748f1600d0c9dcc276f82a2e3f714f68fc92c0acb1f2e3633ad612929b67d0b864c48cd03d55a821e95e4e32a4efabc86513eb73f122201142f2671f5a510ad7170d168a890b7bcc7a017775ef27d55a00d393c1a2380007fda2efd321c65a3dba0376ee377d1ad0f2589f43dcae037a7cc77c92c91361df7efc188b958f838ca694ebec41361d194dfa507e4d204bdb6498a8c1a3d9222e2bf8c66a3d970b4df6d74c6f8b9f193ceff19dfbf7c10299889ffed89207b281fbfa85ba0c91dc438affc12dee9fd554d9b13d24fff0324ff1a39e78b33ec8c560707fd8371e3857b4c5fb20a5eee41522f98d2cb2bfaf7f57843bf077beed682f889b2e95d456105f3641b157de4408ccf1077da439f36100a3e646c71b0b671066268b1c98daf704de3d25c1e0a274d1e4d4b597a9da306c675c5c0b89613676acfc7d77ace4ce94cdb53a6cca31ea77513def120e3c2304ad594ac07cf8523a17dedc775ef65a2fc1c5612cf4889fb8e10dd71e7faf0da2d8c8870e69b9297a49f3f34dd8110f750fc5acb532e63a88d6716ed491e5dede8122d33d48f1584769012ffd2ce7547b616cec1b26c14b1c37582721b246b8cba211dcd0542cb3f9eea6fb11cac7541d97060b2e25d41d6115b6659651fc58bffd5c5dbcf2b7fb5d4a5af54e95bcb12a3a160119664abad41ecd4462b8021a8448a972386d886c383b1d7f3e0a144d86e7a3587d0a090dd23c2ef2cd70f0fe47d92e479325716a53d0916a2e42db26ee97ea1ff6e8e76ff0247d26aab5d51e5a9c7ed36b1d4c15e61aca544a32105ab1e9482d3ab79ade1e3dda8dafe05ad413d49d3b286cc5fb785cb265721ae9dbbeb76f08e5bfcbe479ea40570d3b7bfd938b580206e7458b45aebcb9fca1f0a835e4bee0cf145630478c797107816ceeb8e9b837a13d2f8c8f77d3d94f83a6f904d237e676f1d9b349872a739cae55e3f5e9e4a5ffeaa47ebdb6876efa032adde51cbe65015469f9f234c0aa9907c5709afc0b3c96f15f8ff38afaa0d31f6ab0703a70f7f07f0f712fe5ec1df6bf8fb0efebe87bf1fe0ef0dfce17fa35197f1b5d13cb825d6f95744c14a965c125dfa805f1d5bee3d2f9bdf7648cfe6c408ffdb1bbd18b547c7a3eec819b9a3cde87ef4301a8ec6a3ce785f1f1e50df6806ae583b1b3cb8fcb620a2278c6c9b4bf7bec0b509cb57ad36007efca6d0df31284ab02f3e34edf15797074da80bb54c1ca780b331905cbcf3a4e479329cd25f9c667ba739ecb48599794ca74f69d88d5f38784f3e7f748f9df73550ee71b3dddcc09f91df6c6b0edbcdf6b708e2ee35bd66d4b417d486c1ef9785dfc80a770c98a896d56cecbbcb8f9ce283fa6c42bfafe204289ddf1ae3bcf45ebac50d18fa1ac935a87cfa72c83c59e037c57b7d66040bb08b7062671f58d9f320b5b35f5ad9c1b290fdaa807d6767bfb6b2af5705d6be2b64c776f6f776d9ab4b3bfb072b3b0b9776f61b2b3b99e65676bf67652f92af76b62db55938b5b395d4e4a695d936df7bafdc3641b6cde49e77601c28b31b5978fd0a3e5ef929c78a32bec3328ad4db760f91c53d09ff65119fb35bcdef0f5c01dca5be4df3807f34526e15dca5eed16ba81ac0b1831e6bdfa582214ce8bfe10955f5a65b5624db77697be7099c9a35059427c8467e27b727fec7ac51aa178bd6f8a62810c55b6fbb9b6857b6a0583a7e5aa1bbc49baa69610993d7f24899604b9cb8a67e260f172df939a447e60d4e9862856a66bca98ac714a053a83dad543fa19f9bb803d68c23f9c606dfd06b8cf985772aadc9d565d3631d1dcceb4460797ec22fdbbac79d8f0b8c12c8ef0ec9a36ecab5b494af529f96fc2d66be08bf02a8f0ae27f8b20b307d359a76e04df45e39d8124713f8e7b8d33fc497b7f482cf07e3ce04feb1082a5bb4d2b54f8fdc6a174bf79a5b22f9373c06150ebb0a779da24c2e05030a6df39a0252e6163656158592a30156c934c749a6ffe0ee0623ac94db5ab86e918e0f1d4061b8fcf896ab2657dc69d539c39bf12e99d2c5240ca881e49d627a32c3b81bb3e0b66fc1b4f9d568d515f02d44e7fadb03dfef1df3c20e396d73f3ef3afb2d33be1e330fb30c16369ede0216774154c65657ddbf2b28fc147dad3f01365f77aeb38e80144761351e7e16b84ca3f2432de651de6221e21483fa80a87194b10c2a608cbb1d6b61ec5853cdaaf704d4d2176a1adb6bf038ebea23aa5b58d7df637d36eb1ab5fc719dc265c49a5cd5be63b1c94de8caf37974d58dea84b5c409a648bfc3da1ad70cc815f9be19c4c237608c02ae82ec9d8a684503d3c8135f59e39ffad1c996708c74d397b123d2d5e76e3598761488c4da1b9291e7d325c19b9b61d462f83936b1adc501b65fc02ea0e87837484fbc76703b58e5a1f7a33e204042d17ebd7c4157887c16f77174bb5d6a4f79400443b34fa3491c2d2ef1a42e4fd4db56762f15b4bc2a647954b64cc20e93270aa62f8537634990b502ac5060a6bc78849a28e65ed6de60c7ec3655ecac165517f288ab0acc6b78369bdd3a7d51a924f444e9ea1dbec28542d4c76ae3f271bb6f5013d20c0b3cfe9934c593cbbfa9e2d80112c5d9bfe2f6203efd5b770c4563ebde207def65b9e7f30b07bd2b11587b6f74b68a5b0f6b721c9b0a778a9b971e4a3cebcec372e20ede79c8da059e8c9aa80b33edbb972814d3b884c9b8e893237a1550765c777578af1092928e7983a8c8631436c00c6eeda1524b94675b92b7106b645f91e9d8a44ae297b7618515d23712b9f00b6c55de736a8d3abe1f1a16ae7751b73d5528c18feff93527d774cb8975db88a3ae776c8a73e0cd437a6a7af28c3724e0137ea8a439f87f	2038-01-18 19:14:07-08
talkbox:messages:individual:Userlogin	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:58-08
talkbox:messages:individual:Userlogin-summary	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:58-08
talkbox:messages:individual:Nologinlink	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:58-08
talkbox:messages:individual:Nologin	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:58-08
talkbox:messages:individual:Loginstart	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:58-08
talkbox:messages:individual:Login	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:58-08
talkbox:messages:individual:Loginprompt	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:58-08
talkbox:messages:individual:Yourname	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:58-08
talkbox:messages:individual:Yourpassword	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:58-08
talkbox:messages:individual:Remembermypassword	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Mailmypassword	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Loginend	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Anontalk	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Nstab-special	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Tooltip-ca-special	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Accesskey-ca-special	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Tooltip-pt-anonuserpage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Accesskey-pt-anonuserpage	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Tooltip-pt-anontalk	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Accesskey-pt-anontalk	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Tooltip-pt-anonlogin	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Accesskey-pt-anonlogin	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:50:59-08
talkbox:messages:individual:Double-redirect-fixer	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:13-08
talkbox:messages:individual:Usermessage-editor	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:13-08
talkbox:messages:individual:Proxyblocker	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:13-08
talkbox:messages:individual:Nosuchuser	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:13-08
talkbox:messages:individual:Loginerror	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:13-08
talkbox:messages:individual:Gotaccountlink	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:22-08
talkbox:messages:individual:Gotaccount	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:22-08
talkbox:messages:individual:Signupstart	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:22-08
talkbox:messages:individual:Createaccount	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:22-08
talkbox:messages:individual:Yourpasswordagain	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:22-08
talkbox:messages:individual:Youremail	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:22-08
talkbox:messages:individual:Prefs-help-email	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:22-08
talkbox:messages:individual:Yourrealname	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:22-08
talkbox:messages:individual:Prefs-help-realname	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:22-08
talkbox:messages:individual:Signupend	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:22-08
talkbox:messages:individual:Editnotice-0	\\x2bb63234b25252f4f3f7738df00c0e71f50b51b20600	2011-11-28 18:51:33-08
\.


--
-- Data for Name: oldimage; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY oldimage (oi_name, oi_archive_name, oi_size, oi_width, oi_height, oi_bits, oi_description, oi_user, oi_user_text, oi_timestamp, oi_metadata, oi_media_type, oi_major_mime, oi_minor_mime, oi_deleted, oi_sha1) FROM stdin;
\.


--
-- Data for Name: page; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY page (page_id, page_namespace, page_title, page_restrictions, page_counter, page_is_redirect, page_is_new, page_random, page_touched, page_latest, page_len, titlevector) FROM stdin;
1	0	Main_Page		3	0	1	0.11736669113000	2011-11-27 15:35:17-08	1	438	'main':1 'page':2
\.


--
-- Data for Name: page_props; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY page_props (pp_page, pp_propname, pp_value) FROM stdin;
\.


--
-- Data for Name: page_restrictions; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY page_restrictions (pr_id, pr_page, pr_type, pr_level, pr_cascade, pr_user, pr_expiry) FROM stdin;
\.


--
-- Data for Name: pagecontent; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY pagecontent (old_id, old_text, old_flags, textvector) FROM stdin;
1	'''MediaWiki has been successfully installed.'''\n\nConsult the [http://meta.wikimedia.org/wiki/Help:Contents User's Guide] for information on using the wiki software.\n\n== Getting started ==\n* [http://www.mediawiki.org/wiki/Manual:Configuration_settings Configuration settings list]\n* [http://www.mediawiki.org/wiki/Manual:FAQ MediaWiki FAQ]\n* [https://lists.wikimedia.org/mailman/listinfo/mediawiki-announce MediaWiki release mailing list]	utf-8	'/mailman/listinfo/mediawiki-announce':36 '/wiki/help:contents':10 '/wiki/manual:configuration_settings':25 '/wiki/manual:faq':31 'configur':26 'consult':6 'faq':33 'get':21 'guid':13 'inform':15 'instal':5 'list':28,40 'lists.wikimedia.org':35 'lists.wikimedia.org/mailman/listinfo/mediawiki-announce':34 'mail':39 'mediawiki':1,32,37 'meta.wikimedia.org':9 'meta.wikimedia.org/wiki/help':8 'releas':38 'set':27 'softwar':20 'start':22 'success':4 'use':17 'user':11 'wiki':19 'www.mediawiki.org':24,30 'www.mediawiki.org/wiki/manual':23,29
\.


--
-- Data for Name: pagelinks; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY pagelinks (pl_from, pl_namespace, pl_title) FROM stdin;
\.


--
-- Data for Name: profiling; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY profiling (pf_count, pf_time, pf_memory, pf_name, pf_server) FROM stdin;
\.


--
-- Data for Name: protected_titles; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY protected_titles (pt_namespace, pt_title, pt_user, pt_reason, pt_timestamp, pt_expiry, pt_create_perm) FROM stdin;
\.


--
-- Data for Name: querycache; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY querycache (qc_type, qc_value, qc_namespace, qc_title) FROM stdin;
\.


--
-- Data for Name: querycache_info; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY querycache_info (qci_type, qci_timestamp) FROM stdin;
\.


--
-- Data for Name: querycachetwo; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY querycachetwo (qcc_type, qcc_value, qcc_namespace, qcc_title, qcc_namespacetwo, qcc_titletwo) FROM stdin;
\.


--
-- Data for Name: recentchanges; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY recentchanges (rc_id, rc_timestamp, rc_cur_time, rc_user, rc_user_text, rc_namespace, rc_title, rc_comment, rc_minor, rc_bot, rc_new, rc_cur_id, rc_this_oldid, rc_last_oldid, rc_type, rc_moved_to_ns, rc_moved_to_title, rc_patrolled, rc_ip, rc_old_len, rc_new_len, rc_deleted, rc_logid, rc_log_type, rc_log_action, rc_params) FROM stdin;
1	2011-11-27 15:35:17-08	2011-11-27 15:35:17-08	0	MediaWiki default	0	Main_Page		0	0	1	1	1	0	1	0		0	192.168.24.5/32	0	438	0	0	\N		
\.


--
-- Data for Name: redirect; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY redirect (rd_from, rd_namespace, rd_title, rd_interwiki, rd_fragment) FROM stdin;
\.


--
-- Data for Name: revision; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY revision (rev_id, rev_page, rev_text_id, rev_comment, rev_user, rev_user_text, rev_timestamp, rev_minor_edit, rev_deleted, rev_len, rev_parent_id) FROM stdin;
1	1	1		0	MediaWiki default	2011-11-27 15:35:17-08	0	0	438	0
\.


--
-- Data for Name: site_stats; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY site_stats (ss_row_id, ss_total_views, ss_total_edits, ss_good_articles, ss_total_pages, ss_users, ss_active_users, ss_admins, ss_images) FROM stdin;
1	3	1	0	1	1	-1	0	0
\.


--
-- Data for Name: tag_summary; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY tag_summary (ts_rc_id, ts_log_id, ts_rev_id, ts_tags) FROM stdin;
\.


--
-- Data for Name: templatelinks; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY templatelinks (tl_from, tl_namespace, tl_title) FROM stdin;
\.


--
-- Data for Name: trackbacks; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY trackbacks (tb_id, tb_page, tb_title, tb_url, tb_ex, tb_name) FROM stdin;
\.


--
-- Data for Name: transcache; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY transcache (tc_url, tc_contents, tc_time) FROM stdin;
\.


--
-- Data for Name: updatelog; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY updatelog (ul_key, ul_value) FROM stdin;
\.


--
-- Data for Name: user_groups; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY user_groups (ug_user, ug_group) FROM stdin;
1	sysop
1	bureaucrat
\.


--
-- Data for Name: user_newtalk; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY user_newtalk (user_id, user_ip, user_last_timestamp) FROM stdin;
\.


--
-- Data for Name: user_properties; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY user_properties (up_user, up_property, up_value) FROM stdin;
\.


--
-- Data for Name: valid_tag; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY valid_tag (vt_tag) FROM stdin;
\.


--
-- Data for Name: watchlist; Type: TABLE DATA; Schema: mediawiki; Owner: talkbox
--

COPY watchlist (wl_user, wl_namespace, wl_title, wl_notificationtimestamp) FROM stdin;
\.


SET search_path = public, pg_catalog;

--
-- Data for Name: boards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY boards (id, name, fid, created, modified) FROM stdin;
0	main	5	\N	\N
13	Place's	9	2011-11-05	2011-11-05
14	actions	10	2011-11-05	2011-11-05
17	Toys	11	2011-11-06	2011-11-06
18	Food	14	2011-11-13	2011-11-13
20	Verbs	15	2011-11-13	2011-11-13
\.


--
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY config (id, key, value) FROM stdin;
2	path_pics	http://localhost/pics/
6	recall	ON
3	record	OFF
5	recordorder	0
1	vol	6
7	voice	voice_kal_diphone
4	recordseries	20
\.


--
-- Data for Name: folders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY folders (folderid, orderno, parentid, title, name, url, img, pane, type, isopen) FROM stdin;
3	3	0	Admin	Admin	blank	../img/folder.gif	none	none	
6	6	0	history	history	wrapper.php?url=history.php	../img/cd.gif	center		
4	4	3	Phases	Phases	wrapper.php?url=cake/phases	../img/globe.gif	center	\N	
5	5	0	sayit	say it	wrapper.php?url=talkbox.php	../img/question.gif	center	none	yes
7	1	0	Boards	Boards	wrapper.php?url=boards.php	../img/folder.gif	center		
9	1	7	Places	Places	./wrapperboard.php?bid=13	\N	center	\N	\N
10	1	7	actions	actions	./wrapperboard.php?bid=14	\N	center	\N	\N
13	1	7	Toys	Toys	./wrapperboard.php?bid=17	\N	center	\N	\N
14	1	7	Food	Food	./board.php?bid=18	\N	center	\N	\N
16	1	7	Verbs	Verbs	./wrapperboard.php?bid=20	\N	center	\N	\N
17	7	0	Storey Board	Storey Board	./storyboard.php	\N	center	\N	\N
18	8	3	Edit Voice	Edit Voice	edit-voice.php	\N	center	\N	\N
\.


--
-- Data for Name: history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY history (id, phase, "time", type) FROM stdin;
215	Lego	2011-11-06 01:31:48	main
216	 Montreal	2011-11-06 01:32:17	tts
217	 Montreal	2011-11-06 01:32:17	tts
218	 Montreal	2011-11-06 01:32:54	tts
219	 Montreal	2011-11-06 01:32:54	tts
220	 Montreal	2011-11-06 01:33:01	tts
221	 Montreal	2011-11-06 01:33:01	main
222	Canada	2011-11-06 01:34:38	main
223	Canada	2011-11-06 01:34:42	main
224	Canada	2011-11-06 01:34:47	main
225	Canada	2011-11-06 01:35:01	main
226	Canada	2011-11-06 01:35:11	main
229	he is gone	2011-11-06 01:36:32	tts
230	he is gone	2011-11-06 01:36:32	tts
231	he is gone no where	2011-11-06 01:36:48	tts
232	Good Bye	2011-11-06 01:37:26	main
233	Hello	2011-11-06 01:37:32	main
234	Ouch	2011-11-06 01:37:42	main
235	Good Bye	2011-11-06 01:37:47	main
236	 Montreal	2011-11-06 01:12:53	main
237	 Montreal	2011-11-06 01:12:58	main
238	Lego	2011-11-06 01:13:49	main
239	Lego	2011-11-06 01:13:55	main
240	Lego	2011-11-06 01:14:03	main
241	Lego	2011-11-06 01:14:33	main
242	Lego	2011-11-06 01:14:42	main
243	Lego	2011-11-06 01:28:52	main
244	Hello	2011-11-06 01:29:50	main
245	Hello	2011-11-06 01:29:52	main
246	Good Bye	2011-11-06 01:30:14	main
247	fdbrtbhn	2011-11-06 01:30:28	tts
248	fdbrtbhn	2011-11-06 01:30:28	tts
249	fdbrtbhn	2011-11-06 01:30:36	tts
250	fdbrtbhn	2011-11-06 01:31:29	tts
251	fdbrtbhn	2011-11-06 01:32:17	tts
252	Ouch	2011-11-06 01:32:28	main
253	Lego	2011-11-06 01:39:26	main
254	Lego	2011-11-06 01:39:31	main
255	Lego	2011-11-06 01:42:45	main
256	Lego	2011-11-06 01:43:06	main
288	Hello	2011-11-06 01:47:07	main
289	Lego	2011-11-06 01:47:25	main
290	Hello	2011-11-06 01:49:55	main
291	Hello	2011-11-06 01:50:04	main
292	Hello	2011-11-06 01:50:34	main
293	Lego	2011-11-06 01:51:47	main
294	hello how are you today	2011-11-06 01:51:59	tts
295	hello how are you today	2011-11-06 01:51:59	tts
296	hello how are you today	2011-11-06 01:52:05	tts
297	hello how are you today	2011-11-06 01:52:19	tts
298	hello how are you today	2011-11-06 01:52:28	tts
299	Canada	2011-11-06 01:52:39	main
300	Canada	2011-11-06 01:52:44	main
301	test	2011-11-06 01:53:02	main
302	test	2011-11-06 01:53:02	main
303	Lego	2011-11-06 01:53:15	main
304	Lego	2011-11-06 01:55:22	main
305	Lego	2011-11-06 01:55:49	main
306	 Montreal	2011-11-06 01:56:10	main
307	Hello	2011-11-06 03:10:57	main
308	Ouch	2011-11-06 03:11:06	main
309	Lego	2011-11-06 03:13:13	main
310	hello	2011-11-06 03:13:51	tts
311	Ouch	2011-11-10 17:12:33	main
312	man	2011-11-10 17:13:44	tts
313	test	2011-11-10 17:14:00	tts
314	 test	2011-11-10 17:14:05	tts
315	Good Bye	2011-11-10 17:14:05	main
316	Ouch	2011-11-10 17:14:57	main
317	Lego	2011-11-10 17:17:22	main
318	Lego	2011-11-10 17:17:26	main
319	Lego	2011-11-10 17:17:47	main
320	Hello	2011-11-10 17:18:38	main
321	hello	2011-11-10 17:20:18	tts
322	hello	2011-11-10 17:20:20	tts
323	hello	2011-11-10 17:22:16	tts
324	Ouch	2011-11-11 06:44:41	main
325	Canada	2011-11-11 06:45:23	main
326	Lego	2011-11-11 06:50:31	main
327	lego	2011-11-11 06:51:17	tts
328	lego	2011-11-11 06:51:20	tts
329	test 1    2 3	2011-11-11 06:51:42	tts
330	test 1    2 3	2011-11-11 06:51:54	tts
331	test 1    2 3	2011-11-11 06:51:56	tts
332	test	2011-11-11 13:53:26	tts
333	test	2011-11-11 13:53:37	tts
334	test	2011-11-11 13:53:44	tts
335	test	2011-11-11 13:53:51	tts
336	Ouch	2011-11-11 13:55:22	main
337	Canada	2011-11-11 13:56:31	main
338	test	2011-11-11 13:56:53	tts
339	Canada	2011-11-11 13:57:03	main
340	test	2011-11-11 13:57:10	main
341	testing 1234	2011-11-11 13:57:15	main
342	Hello	2011-11-11 13:57:39	main
343	quebe	2011-11-11 13:58:20	tts
344	 Quebec	2011-11-11 13:58:22	main
345	unix is cool	2011-11-11 14:00:41	tts
346	unix is cool	2011-11-11 14:00:44	tts
347	how is it going	2011-11-11 14:01:11	tts
348	how is it going	2011-11-11 14:01:23	tts
349	test	2011-11-11 14:03:47	main
350	how is it going	2011-11-12 02:26:36	tts
351	how is it going	2011-11-12 02:26:53	tts
352	 Quebec	2011-11-12 03:02:48	main
353	 Quebec	2011-11-12 03:02:57	main
354	Canada	2011-11-12 03:03:10	main
355	Canada	2011-11-12 03:03:11	main
356	Home	2011-11-12 03:28:48	main
357	Home	2011-11-12 03:28:57	main
358	Home	2011-11-12 03:29:03	main
359	doge	2011-11-12 03:29:26	tts
360	Toronto	2011-11-13 09:03:56	main
361	Ottawa	2011-11-13 09:04:00	main
362	Vancouver	2011-11-13 09:04:03	main
363	Studying	2011-11-13 09:33:52	main
364	Toronto	2011-11-13 09:55:43	main
365	Ontario	2011-11-13 09:55:49	main
366	Vancouver	2011-11-13 09:55:55	main
367	British Columbia	2011-11-13 09:55:57	main
368	 Quebec	2011-11-13 09:56:05	main
369	 Montreal	2011-11-13 09:56:14	main
370	 Quebec	2011-11-13 09:56:17	main
371	Canada	2011-11-13 10:02:15	main
372	 Quebec	2011-11-13 10:02:18	main
373	Ontario	2011-11-13 10:02:22	main
374	Canada	2011-11-13 10:02:23	main
375	Ontario	2011-11-13 10:02:26	main
376	Canada	2011-11-13 10:02:28	main
377	Canada	2011-11-13 10:02:33	main
378	British Columbia	2011-11-13 10:02:35	main
379	British Columbia	2011-11-13 10:02:39	main
380	Canada	2011-11-13 10:02:42	main
381	Lettuce	2011-11-13 10:13:38	main
382	Pizza	2011-11-13 10:13:42	main
383	Corn	2011-11-13 10:35:47	main
384	Lettuce	2011-11-13 10:35:50	main
385	Pizza	2011-11-13 10:35:53	main
386	Pizza	2011-11-13 10:35:54	main
387	Banana	2011-11-13 10:35:58	main
388	Cherry	2011-11-13 10:36:01	main
227	he	2011-11-06 01:36:06	main
389	French Fies	2011-11-13 10:36:06	main
390	Carrot	2011-11-13 10:36:10	main
391	Corn	2011-11-13 10:36:15	main
392	Corn	2011-11-13 10:36:20	main
393	Juice	2011-11-13 10:37:56	main
394	Juice	2011-11-13 10:38:46	main
395	Juice	2011-11-13 10:41:51	main
396	Banana	2011-11-13 10:50:22	main
397	Banana	2011-11-13 10:50:47	main
398	and	2011-11-13 10:50:54	tts
399	Juice	2011-11-13 10:50:57	main
400	Pear	2011-11-13 11:00:18	main
401	Juice	2011-11-13 11:00:22	main
402	Corn	2011-11-13 11:00:26	main
403	Cherry	2011-11-13 18:20:17	main
404	Cherry	2011-11-13 18:20:25	main
405	Juice	2011-11-13 18:20:28	main
406	Pear	2011-11-13 18:20:35	main
407	Corn	2011-11-13 18:20:41	main
408	Lettuce	2011-11-13 18:20:45	main
409	Pizza	2011-11-13 18:20:49	main
410	Carrot	2011-11-13 18:20:54	main
411	French Fies	2011-11-13 18:20:57	main
412	Lego	2011-11-13 18:21:13	main
413	Ontario	2011-11-13 18:21:32	main
414	Canada	2011-11-13 18:21:36	main
415	Vancouver	2011-11-13 18:21:48	main
416	Home	2011-11-13 18:21:51	main
417	 Montreal	2011-11-13 18:21:59	main
418	Ottawa	2011-11-13 18:22:06	main
419	Studying	2011-11-13 18:22:23	main
420	Studying	2011-11-13 18:22:27	main
421	Lego	2011-11-14 00:03:30	main
422	Lego	2011-11-14 00:03:41	main
423	Lego	2011-11-14 00:03:49	main
424	The	2011-11-14 00:04:01	main
425	And	2011-11-14 00:04:12	main
426	Juice	2011-11-14 00:06:10	main
427	And	2011-11-14 00:06:15	main
428	Banana	2011-11-14 00:06:20	main
429	Juice	2011-11-14 00:07:53	main
430	And	2011-11-14 00:08:03	main
431	Banana	2011-11-14 00:08:06	main
432	The	2011-11-14 00:08:21	main
433	The	2011-11-14 00:08:30	main
434	Home	2011-11-14 00:20:36	main
435	 Quebec	2011-11-14 00:20:41	main
436	 Quebec	2011-11-14 00:20:47	main
437	Home	2011-11-14 00:20:48	main
438	Home	2011-11-14 00:20:52	main
439	 Quebec	2011-11-14 00:20:54	main
440	Canada	2011-11-14 00:21:02	main
441	 Quebec	2011-11-14 00:21:05	main
442	The	2011-11-14 17:00:22	main
443	The	2011-11-14 17:00:27	main
444	Canada	2011-11-14 17:00:33	main
445	 Quebec	2011-11-14 17:00:36	main
446	Home	2011-11-14 17:00:42	main
447	Ottawa	2011-11-14 17:00:56	main
448	British Columbia	2011-11-14 17:01:07	main
449	Ontario	2011-11-14 17:01:12	main
450	Toronto	2011-11-14 17:01:17	main
451	 Montreal	2011-11-14 17:01:22	main
452	Lego	2011-11-14 17:01:32	main
453	Pear	2011-11-14 17:01:42	main
454	Cherry	2011-11-14 17:02:05	main
455	French Fies	2011-11-14 17:02:36	main
456	Cherry	2011-11-14 17:02:39	main
457	Banana	2011-11-14 17:02:43	main
458	Lettuce	2011-11-14 17:02:48	main
459	Lettuce	2011-11-14 17:02:56	main
460	Banana	2011-11-14 17:03:59	main
461	Cherry	2011-11-14 17:04:04	main
462	French Fies	2011-11-14 17:04:08	main
463	 Montreal	2011-11-14 17:32:21	tts
465	he is gone	2011-11-14 17:32:27	tts
467	Good Bye	2011-11-14 17:32:43	main
228	he	2011-11-06 01:36:14	main
468	 Montreal	2011-11-14 17:33:11	main
469	Studying	2011-11-14 17:34:14	main
470	Lego	2011-11-16 18:05:17	main
471	Hello	2011-11-16 18:05:31	main
472	Hello	2011-11-16 18:05:41	main
473	hey	2011-11-16 18:05:53	tts
474	hey	2011-11-16 18:05:57	tts
475	hey	2011-11-16 18:05:58	tts
476	hey	2011-11-16 18:05:58	tts
477	hey	2011-11-16 18:05:58	tts
478	hey	2011-11-16 18:05:59	tts
479	Ouch	2011-11-16 18:08:51	main
480	hey cana	2011-11-16 18:09:59	tts
481	hey Canada	2011-11-16 18:10:07	tts
482	hey Canada	2011-11-16 18:10:20	tts
483	canad	2011-11-16 18:10:40	tts
484	 Canadianizations	2011-11-16 18:10:41	tts
485	testing musi	2011-11-16 18:11:53	tts
486	testing musicians	2011-11-16 18:12:01	tts
487	he's a musician	2011-11-16 18:17:21	tts
488	test	2011-11-17 21:19:32	tts
489	test	2011-11-17 21:19:34	tts
490	test	2011-11-17 21:19:50	tts
491	test	2011-11-17 21:19:54	tts
492	Good Bye	2011-11-17 21:19:54	main
493	Ouch	2011-11-17 21:20:03	main
494	British Columbia	2011-11-17 21:20:33	main
495	British Columbia	2011-11-17 21:20:38	main
496	Ontario	2011-11-17 21:20:45	main
497	Studying	2011-11-17 21:20:52	main
498	Studying	2011-11-17 21:20:58	main
499	Ottawa	2011-11-17 21:21:03	main
500	tezt	2011-11-17 21:21:17	tts
501	Ontario	2011-11-17 21:21:25	main
502	Banana	2011-11-17 21:21:42	main
503	Studying	2011-11-17 21:22:24	main
504	Studying	2011-11-17 21:22:30	main
505	Banana	2011-11-17 21:27:50	main
506	test	2011-11-17 21:28:17	tts
507	Juice	2011-11-17 21:28:22	main
508	Juice	2011-11-17 21:28:28	main
509	Pear	2011-11-17 21:28:32	main
510	Juice	2011-11-17 21:33:43	main
511	Pear	2011-11-17 21:33:48	main
512	Lego	2011-11-17 21:33:58	main
513	The	2011-11-17 21:34:12	main
514	And	2011-11-17 21:34:16	main
515	he	2011-11-17 21:34:20	main
516	Canada	2011-11-17 21:34:27	main
517	 Montreal	2011-11-17 21:34:44	main
518	 Montreal	2011-11-17 21:34:48	main
519	British Columbia	2011-11-17 21:34:55	main
520	Ontario	2011-11-17 21:34:59	main
521	Toronto	2011-11-17 21:35:04	main
522	Canada	2011-11-17 21:35:09	main
523	Lettuce	2011-11-17 21:35:51	main
524	Canada	2011-11-17 21:35:57	main
525	Juice	2011-11-17 21:36:03	main
526	Pear	2011-11-17 21:36:07	main
527	Juice	2011-11-17 21:47:38	main
528	9:30am	2011-11-18 20:57:49	tts
529	9:30am	2011-11-18 20:57:50	tts
530	9:30am	2011-11-18 20:57:51	tts
531	9:20 pm	2011-11-18 21:20:16	tts
532	9:20 pm	2011-11-18 21:20:55	tts
464	he is gone	2011-11-14 17:32:21	main
533	9:24 pm	2011-11-18 21:24:33	tts
534	Friday 18th of November 2011 09:31:50 PM	2011-11-18 21:31:50	tts
535	Friday 18th of November 2011 09:31:51 PM	2011-11-18 21:31:51	tts
536	Friday 18th of November 2011 09:32:02 PM	2011-11-18 21:32:02	tts
537	Ontario	2011-11-18 21:32:19	main
538	Friday 18th of November 2011 09:33 PM	2011-11-18 21:33:12	tts
539	Friday 18th of November 2011 pm1118 3009America/New_York 303411America/New_York 3402  09:34 PM	2011-11-18 21:34:02	tts
540	Friday 18th of November 	2011-11-18 21:35:30	tts
541	Friday 18th of November 2011 	2011-11-18 21:37:04	tts
542	Time	2011-11-18 21:39:54	main
543	9:40 pm	2011-11-18 21:40:39	main
544	Friday 18th of November 2011 	2011-11-18 21:44:57	main
545	9:45 pm	2011-11-18 21:45:04	main
546	Friday 18th of November 2011 	2011-11-18 21:45:13	main
548	9:45 pm	2011-11-18 21:45:28	main
549	Friday 18th of November 2011 	2011-11-18 21:45:36	main
550	at	2011-11-18 21:45:42	tts
551	9:45 pm	2011-11-18 21:45:46	main
552	Good Bye	2011-11-18 21:46:30	main
553	Ouch	2011-11-18 21:46:33	main
554	Hello	2011-11-18 21:46:36	main
555	Juice	2011-11-18 21:46:47	main
556	9:34 pm	2011-11-20 21:34:39	main
557	9:34 pm	2011-11-20 21:34:49	main
558	Sunday 20th of November 2011 	2011-11-20 21:34:55	main
559	Good Bye	2011-11-20 21:35:04	main
560	Ouch	2011-11-20 21:35:08	main
561	hey it is jef	2011-11-21 15:46:43	tts
562	hey it is Jeffrey	2011-11-21 15:46:49	tts
547	at	2011-11-18 21:45:20	main
466	he is gone no where	2011-11-14 17:32:33	main
563	hey it is Jeffrey	2011-11-21 15:46:50	main
569	 Montreal	2011-11-22 01:07:50	tts
570	hey it is Jeffrey	2011-11-22 01:08:15	main
571	Hello	2011-11-22 16:29:17	main
572	Good Bye	2011-11-22 16:30:41	main
573	I need to go to the  Bathroom	2011-11-22 16:30:42	main
574	4:30 pm	2011-11-22 16:30:44	main
575	Tuesday 22nd of November 2011 	2011-11-22 16:30:46	main
576	I need to go to the  Bathroom	2011-11-22 16:31:35	main
577	Good Bye	2011-11-22 16:31:37	main
578	Ouch	2011-11-22 16:31:40	main
579	Hello	2011-11-22 16:31:41	main
580	Good Bye	2011-11-22 16:36:05	main
581	Ouch	2011-11-22 16:36:08	main
582	Hello	2011-11-22 16:36:12	main
583	4:36 pm	2011-11-22 16:36:14	main
584	Tuesday 22nd of November 2011 	2011-11-22 16:36:16	main
585	Good Bye	2011-11-22 16:36:58	main
586	Ouch	2011-11-22 16:37:00	main
587	Hello	2011-11-22 16:37:02	main
588	4:37 pm	2011-11-22 16:37:04	main
589	Tuesday 22nd of November 2011 	2011-11-22 16:37:05	main
590	Studying	2011-11-22 16:37:38	main
591	Studying	2011-11-22 16:37:45	main
592	Lego	2011-11-22 16:37:48	main
593	Banana	2011-11-22 16:37:54	main
594	Cherry	2011-11-22 16:38:17	main
595	And	2011-11-22 16:38:25	main
596	The	2011-11-22 16:38:29	main
597	Banana	2011-11-22 16:38:34	main
598	Cherry	2011-11-22 16:52:10	main
599	Banana	2011-11-22 16:52:13	main
600	Cherry	2011-11-22 16:52:20	main
601	Banana	2011-11-22 16:52:23	main
602	Juice	2011-11-22 16:52:45	main
603	Pear	2011-11-22 16:52:47	main
604	Corn	2011-11-22 16:52:49	main
605	Lettuce	2011-11-22 16:52:51	main
606	Juice	2011-11-22 16:53:10	main
607	Pizza	2011-11-22 16:53:15	main
608	Pear	2011-11-22 16:53:18	main
609	Cherry	2011-11-22 16:55:44	main
610	Juice	2011-11-22 16:55:45	main
611	Pear	2011-11-22 16:55:48	main
612	Corn	2011-11-22 16:55:50	main
613	Pear	2011-11-22 16:56:45	main
614	Corn	2011-11-22 16:56:48	main
615	Banana	2011-11-22 16:57:05	main
616	And	2011-11-22 16:57:11	main
617	Pear	2011-11-22 16:57:16	main
618	test	2011-11-22 20:47:36	tts
619	test	2011-11-22 20:47:38	tts
620	test	2011-11-22 20:47:39	tts
621	test	2011-11-22 20:47:39	tts
622	test	2011-11-22 20:47:40	tts
623	test	2011-11-22 20:47:41	tts
624	test	2011-11-22 20:47:41	tts
625	test	2011-11-22 20:47:46	tts
626	hey it is Jeffrey	2011-11-22 20:47:57	main
627	Tuesday 22nd of November 2011 	2011-11-22 20:48:03	main
628	8:48 pm	2011-11-22 20:48:08	main
629	test	2011-11-22 20:48:20	tts
630	Hello	2011-11-22 20:48:20	main
631	Ouch	2011-11-22 20:48:24	main
632	Studying	2011-11-22 20:48:32	main
633	Corn	2011-11-22 20:48:37	main
634	Pear	2011-11-22 20:48:46	main
635	Juice	2011-11-22 20:48:52	main
636	Pizza	2011-11-22 20:50:40	main
637	Good Bye I need to go to the  Bathroom 4:30 pm Tuesday 22nd of November 2011  I need to go to the  Bathroom Good Bye Ouch Hello Good Bye Ouch Hello 4:36 pm Tuesday 22nd of November 2011  Cherry And The Banana	2011-11-24 01:16:56	main
638	Good Bye I need to go to the  Bathroom 4:30 pm Tuesday 22nd of November 2011  I need to go to the  Bathroom Good Bye Ouch Hello Good Bye Ouch Hello 4:36 pm Tuesday 22nd of November 2011  Cherry And The Banana	2011-11-24 01:17:18	main
763	he is gone somewhere between ottawa and Montreal	2011-11-24 06:02:28	main
764	ottawa and montreal 	2011-11-24 06:04:06	tts
639	Good Bye I need to go to the  Bathroom 4:30 pm Tuesday 22nd of November 2011  I need to go to the  Bathroom Good Bye Ouch Hello Good Bye Ouch Hello 4:36 pm Tuesday 22nd of November 2011  Cherry And The Banana	2011-11-24 01:17:46	main
640	the Cherry Banana Juice Pear Corn Lettuce	2011-11-24 01:18:13	main
641	Cherry Juice Pear Corn	2011-11-24 01:18:24	main
642	Cherry Juice Pear Corn	2011-11-24 01:19:00	main
643	Banana And Pear	2011-11-24 01:19:42	main
644	Banana And Pear	2011-11-24 01:20:18	main
645	Banana And Pear	2011-11-24 01:21:21	main
646	test	2011-11-24 01:22:43	tts
647	test	2011-11-24 01:22:50	tts
648	test	2011-11-24 01:22:56	tts
649	test	2011-11-24 01:23:03	tts
650	test	2011-11-24 01:23:47	tts
651	test	2011-11-24 01:24:24	tts
652	test	2011-11-24 01:24:34	tts
653	test	2011-11-24 01:24:44	tts
654	test	2011-11-24 01:24:58	tts
655	the Cherry Banana Juice Pear Corn Lettuce	2011-11-24 01:25:32	main
656	Banana And Pear	2011-11-24 01:25:38	main
657	Banana And Pear	2011-11-24 01:25:43	main
658	test	2011-11-24 01:41:43	tts
659	undefined	2011-11-24 02:36:54	main
660	undefined	2011-11-24 02:37:02	main
661	undefined	2011-11-24 02:37:05	main
662	undefined	2011-11-24 02:37:08	main
663	undefined	2011-11-24 02:37:16	main
664	undefined	2011-11-24 02:37:19	main
665	undefined	2011-11-24 02:37:21	main
666	test	2011-11-24 02:37:28	tts
667	test	2011-11-24 02:37:33	tts
668	Good Bye	2011-11-24 02:37:43	main
669	hey it is Jeffrey	2011-11-24 02:37:50	main
670	hey it is Jeffrey	2011-11-24 02:38:08	main
671	hey it is Jeffrey	2011-11-24 02:38:40	main
672	hey it is Jeffrey	2011-11-24 02:38:47	main
673	undefined	2011-11-24 02:38:52	main
674	undefined	2011-11-24 02:38:57	main
675	undefined	2011-11-24 02:39:00	main
676	undefined	2011-11-24 02:39:45	main
677	undefined	2011-11-24 02:41:33	main
678	test	2011-11-24 02:43:06	tts
679	test	2011-11-24 02:43:08	tts
680	test	2011-11-24 02:43:10	tts
681	undefined	2011-11-24 02:43:27	main
682	undefined	2011-11-24 02:43:32	main
683	undefined	2011-11-24 02:44:46	main
684	undefined	2011-11-24 02:48:58	main
685	Banana And Pear	2011-11-24 02:49:12	main
686	Banana And Pear	2011-11-24 02:49:19	main
687	Banana And Pear	2011-11-24 02:50:03	main
688	Banana And Pear	2011-11-24 02:50:33	main
689	Banana And Pear	2011-11-24 02:50:52	main
690	Banana And Pear	2011-11-24 02:52:39	main
691	Banana And Pear	2011-11-24 02:52:47	main
692	Ouch	2011-11-24 02:53:04	main
693	test	2011-11-24 03:10:59	tts
694	test	2011-11-24 03:11:03	tts
695	test	2011-11-24 03:11:04	tts
696	test	2011-11-24 03:11:04	tts
697	Ouch	2011-11-24 03:13:10	main
698	hey it is Jeffrey	2011-11-24 03:14:09	main
699	Good Bye	2011-11-24 03:19:24	main
700	hey it is Jeffrey	2011-11-24 03:20:04	main
701	test	2011-11-24 03:36:22	tts
702	test	2011-11-24 03:36:27	tts
703	test	2011-11-24 03:36:43	tts
704	Ouch	2011-11-24 03:37:40	main
705	Ouch	2011-11-24 03:37:47	main
706	Ouch	2011-11-24 03:42:44	main
707	Ouch	2011-11-24 03:42:45	main
708	Ouch	2011-11-24 03:44:53	main
709	hey it is Jeffrey	2011-11-24 03:45:09	main
710	Ouch	2011-11-24 03:48:40	main
711	Ouch	2011-11-24 03:49:26	main
712	Ouch	2011-11-24 03:52:12	main
713	Ouch	2011-11-24 03:52:17	main
714	Hello	2011-11-24 03:52:25	main
715	Ouch	2011-11-24 03:53:59	main
716	British Columbia	2011-11-24 03:54:27	main
717	Lego	2011-11-24 03:56:02	main
718	Juice	2011-11-24 05:24:32	main
719	Juice	2011-11-24 05:24:50	main
720	And	2011-11-24 05:24:56	main
721	Banana	2011-11-24 05:24:59	main
722	And	2011-11-24 05:25:05	main
723	Cherry	2011-11-24 05:25:08	main
724	Juice And Banana And Cherry	2011-11-24 05:25:20	main
725	between	2011-11-24 05:33:49	main
726	Ottawa	2011-11-24 05:33:53	main
727	And	2011-11-24 05:33:59	main
728	 Montreal	2011-11-24 05:34:04	main
729	between Ottawa And  Montreal	2011-11-24 05:34:37	main
730	between Ottawa And  Montreal	2011-11-24 05:34:42	main
731	TEST	2011-11-24 05:35:01	tts
732	TEST	2011-11-24 05:35:01	tts
733	between	2011-11-24 05:35:41	main
734	Vancouver	2011-11-24 05:35:43	main
735	And	2011-11-24 05:35:48	main
736	Ottawa	2011-11-24 05:35:54	main
737	between Vancouver And Ottawa	2011-11-24 05:36:32	main
738	THE TIME IS 	2011-11-24 05:37:23	tts
739	THE TIME IS 	2011-11-24 05:37:34	tts
740	5:37 am	2011-11-24 05:37:34	main
741	5:37 am	2011-11-24 05:37:40	main
742	THE TIME IS  5:37 am 5:37 am	2011-11-24 05:38:06	main
743	I need to go to the  Bathroom	2011-11-24 05:58:35	main
744	I need to go to the  Bathroom	2011-11-24 05:58:51	main
745	Good Bye	2011-11-24 05:58:58	main
746	hey it is Jeffrey	2011-11-24 05:59:03	main
747	Thursday 24th of November 2011 	2011-11-24 05:59:12	main
748	he is gone	2011-11-24 06:00:21	main
749	somewhere	2011-11-24 06:00:25	main
750	between	2011-11-24 06:00:28	main
751	ottawa and Montr	2011-11-24 06:00:47	tts
752	ottawa and Montreal	2011-11-24 06:00:48	tts
753	ottawa and Montreal	2011-11-24 06:00:48	tts
754	he is gone	2011-11-24 06:01:29	main
755	somewhere	2011-11-24 06:01:31	main
756	between	2011-11-24 06:01:34	main
757	ottawa and Montreal	2011-11-24 06:01:38	tts
758	he is gone	2011-11-24 06:01:57	main
759	somewhere	2011-11-24 06:02:01	main
760	between	2011-11-24 06:02:03	main
761	ottawa and Montreal	2011-11-24 06:02:06	tts
762	he is gone somewhere between ottawa and Montreal	2011-11-24 06:02:21	main
765	Juice And Banana And Cherry	2011-11-24 06:04:41	main
766	And	2011-11-24 06:49:08	main
767	Lego	2011-11-24 06:58:56	main
768	Lego	2011-11-24 06:59:06	main
769	:q	2011-11-24 07:01:33	tts
770	:q	2011-11-24 07:01:45	tts
771	Pear	2011-11-24 07:01:45	main
772	Juice	2011-11-24 07:01:49	main
773	:q	2011-11-24 07:04:18	tts
774	:q	2011-11-24 07:04:24	tts
775	:q	2011-11-24 07:06:02	tts
776	Juice	2011-11-24 07:06:26	main
777	Banana	2011-11-24 07:06:54	main
778	Juice	2011-11-24 07:06:59	main
779	Banana	2011-11-24 07:07:06	main
780	Juice	2011-11-24 07:07:09	main
781	Banana Juice	2011-11-24 07:07:22	main
782	Juice And Banana And Cherry	2011-11-24 07:10:52	main
783	Banana And Pear	2011-11-24 07:14:08	main
784	Lego	2011-11-24 07:20:22	main
785	Lego	2011-11-24 07:23:25	main
786	Lego	2011-11-24 07:23:49	main
787	Juice And Banana And Cherry	2011-11-24 07:24:30	main
788	Juice And Banana And Cherry	2011-11-24 07:26:08	main
789	Juice And Banana And Cherry	2011-11-24 07:27:58	main
790	Juice	2011-11-24 07:28:17	main
791	Juice And Banana And Cherry	2011-11-24 07:28:30	main
792	Juice	2011-11-24 07:28:47	main
793	Banana And Pear	2011-11-24 07:36:58	main
794	Banana And Pear	2011-11-24 07:37:04	main
795	Juice And Banana And Cherry	2011-11-24 07:37:34	main
796	Juice And Banana And Cherry	2011-11-24 07:37:38	main
797	Juice And Banana And Cherry	2011-11-24 07:44:34	main
798	Banana And Pear	2011-11-24 07:45:54	main
799	Juice And Banana And Cherry	2011-11-24 08:00:42	main
800	Banana And Pear	2011-11-24 08:06:32	main
801	Banana And Pear	2011-11-24 08:06:40	main
802	Juice And Banana And Cherry	2011-11-24 08:06:49	main
803	Juice And Banana And Cherry	2011-11-24 13:26:57	main
804	Juice	2011-11-24 13:27:13	main
805	test	2011-11-24 14:37:09	tts
806	Juice	2011-11-24 14:37:22	main
807	Juice	2011-11-24 14:37:37	main
808	Carrot	2011-11-24 14:37:45	main
809	Juice	2011-11-24 14:37:47	main
810	Carrot	2011-11-24 14:39:25	main
811	Juice	2011-11-24 14:39:28	main
812	Carrot	2011-11-24 14:39:37	main
813	Juice	2011-11-24 14:39:40	main
814	test	2011-11-24 14:39:51	tts
815	Carrot Juice	2011-11-24 14:40:03	main
816	Juice And Banana And Cherry	2011-11-24 17:37:25	main
817	Pizza	2011-11-24 17:39:35	main
818	And	2011-11-24 17:39:38	main
819	French Fies	2011-11-24 17:39:45	main
820	French Fies	2011-11-25 00:13:02	main
821	Pizza And French Fies	2011-11-25 00:14:25	main
822	Banana And Pear	2011-11-25 00:14:30	main
823	Juice And Banana And Cherry	2011-11-25 00:14:38	main
824	Studying	2011-11-25 00:14:57	main
825	Ouch	2011-11-27 21:41:43	main
826	Ouch	2011-11-27 21:41:50	main
827	Ouch	2011-11-27 21:41:59	main
828	status	2011-11-27 21:42:14	tts
829	status	2011-11-27 21:42:16	tts
830	Hello	2012-01-29 23:10:19	main
831	hey it is Jeffrey	2012-01-29 23:10:24	main
832	Ouch	2012-01-29 23:10:30	main
833	Ouch	2012-01-29 23:10:30	main
834	Studying	2012-01-29 23:21:52	main
835	Lego	2012-01-29 23:22:06	main
836	Juice And Banana And Cherry	2012-01-29 23:22:26	main
837	Carrot	2012-01-29 23:22:34	main
838	Good Bye	2012-02-01 00:06:43	main
839	I need to go to the  Bathroom	2012-02-01 00:06:48	main
840	12:06 am	2012-02-01 00:06:53	main
841	Wednesday 1st of February 2012 	2012-02-01 00:07:01	main
842	Hello	2012-02-01 00:07:08	main
843	Studying	2012-02-01 00:07:56	main
844	Juice And Banana And Cherry	2012-02-01 00:08:02	main
845	Ouch	2012-02-01 00:08:18	main
846	Good Bye	2012-02-01 00:08:21	main
847	 Quebec	2012-02-01 00:09:05	main
848	Canada	2012-02-01 00:09:09	main
849	test	2012-02-06 00:08:35	tts
850	test	2012-02-06 00:08:35	tts
851	test	2012-02-06 00:08:43	tts
852	I need to go to the  Bathroom	2012-02-06 00:08:47	main
853	Hello	2012-02-06 02:43:40	main
854	Ouch	2012-02-06 02:43:45	main
855	jeff	2012-02-06 02:43:56	tts
856	jeff	2012-02-06 02:43:59	tts
857	Lego	2012-02-06 05:14:01	main
858	Pear	2012-02-06 05:14:28	main
859	Hello	2012-02-10 00:28:24	main
860	12:28 am	2012-02-10 00:28:39	main
861	test	2012-03-27 10:08:47	tts
862	test	2012-03-27 10:08:57	tts
863	hey it is Jeffrey	2012-03-27 10:08:58	main
864	I can go to the coner	2012-03-27 19:49:38	tts
865	I can go to the coner storr	2012-03-27 19:49:46	tts
866	I can go to the coner store	2012-03-27 19:50:27	tts
867	I can go to the coner store	2012-03-27 19:50:29	tts
868	hey it is Jeffrey	2012-03-29 22:08:30	main
869	hey it is Jeffrey	2012-03-29 22:08:36	main
870	Ouch	2012-03-29 22:08:40	main
871	test	2012-03-29 22:09:02	tts
872	test	2012-03-29 22:09:06	tts
873	test	2012-03-29 22:09:50	tts
874	Good Bye	2012-03-29 22:09:53	main
875	test 32	2012-03-29 22:11:56	tts
876	Ouch	2012-03-29 22:13:18	main
877	test	2012-03-30 23:53:58	tts
878	test	2012-03-30 23:54:02	tts
879	hey it is Jeffrey	2012-03-30 23:54:31	main
880	hey it is Jeffrey	2012-03-30 23:54:48	main
881	Ouch	2012-03-30 23:54:50	main
882	tester	2012-03-30 23:55:15	tts
883	tester	2012-03-30 23:55:18	tts
884	Tuesday 3rd of April 2012 	2012-04-03 10:30:10	main
885	Tuesday 3rd of April 2012 	2012-04-03 10:30:19	main
886	Ouch	2012-04-03 10:30:31	main
887	Good Bye	2012-04-03 10:33:07	main
888	6:38 pm	2012-04-03 18:38:51	main
889	I need to go to the  Bathroom	2012-04-03 18:39:01	main
890	Ouch	2012-04-03 18:55:41	main
891	Ouch	2012-04-22 23:37:14	main
892	Good Bye	2012-04-22 23:37:22	main
893	I need to go to the  Bathroom	2012-04-22 23:37:34	main
894	Good Bye	2012-04-22 23:37:39	main
895	I moved to Vancouver in March of this year following a long term dream of mine living on the west coast. I have no regrets. I love it here.  I have cerebral palsy but other then that I pretty down to earth. I like going out on the town but staying home and watching tv and movies is ok some times as will.   I love all kind of music but mostly listen to music from the 1980's (REM,U2 Bryan Adam, Corey Hart ). I hoping to meet my Best friend and SoulMate	2012-04-29 20:59:24	tts
896	I moved to Vancouver in March of this year following a long term dream of mine living on the west coast. I have no regrets. I love it here.  I have cerebral palsy but other then that I pretty down to earth. I like going out on the town but staying home and watching tv and movies is ok some times as will.   I love all kind of music but mostly listen to music from the 1980's (REM,U2 Bryan Adam, Corey Hart ). I hoping to meet my Best friend and SoulMate	2012-04-29 20:59:27	tts
897	I moved to Vancouver in March of this year following a long term dream of mine living on the west coast. I have no regrets. I love it here.  I have cerebral palsy but other then that I pretty down to earth. I like going out on the town but staying home and watching tv and movies is ok some times as will.   I love all kind of music but mostly listen to music from the 1980's (REM,U2 Bryan Adam, Corey Hart ). I hoping to meet my Best friend and SoulMate	2012-04-29 20:59:28	tts
898	I moved to Vancouver in March of this year following a long term dream of mine living on the west coast. I have no regrets. I love it here.  I have cerebral palsy but other then that I pretty down to earth. I like going out on the town but staying home and watching tv and movies is ok some times as will.   I love all kind of music but mostly listen to music from the 1980's (REM,U2 Bryan Adam, Corey Hart ). I hoping to meet my Best friend and SoulMate	2012-04-29 20:59:38	tts
899	Ouch	2012-04-29 21:13:30	main
900	aww	2012-04-29 21:13:50	tts
901	I moved to Vancouver in March of this year following a long term dream of mine living on the west coast. I have no regrets. I love it here.  I have cerebral palsy but other then that I pretty down to earth. I like going out on the town but staying home and watching tv and movies is ok some times as will.   I love all kind of music but mostly listen to music from the  1980's (REM,U2 Bryan Adam, Corey Hart ). I hoping to meet my Best friend and SoulMate   	2012-04-29 21:14:30	tts
902	Lego	2012-06-13 00:29:52	main
903	test 132	2012-06-13 00:30:16	tts
904	this is a test	2012-06-13 00:31:12	tts
905	this is a test	2012-06-13 00:31:16	tts
906	this is a test	2012-06-13 00:31:25	tts
907	this is a test	2012-06-13 00:31:26	tts
908	this is a test	2012-06-13 00:31:26	tts
909	this is a test	2012-06-13 00:31:37	tts
910	 Montreal	2012-06-13 01:11:16	tts
911	Canada	2012-06-13 01:11:24	main
912	 Montreal	2012-06-13 01:11:30	tts
913	 Montreal	2012-06-13 01:11:52	main
914	Canada	2012-06-13 01:11:54	main
915	 Quebec	2012-06-13 01:11:58	main
916	Vancouver	2012-06-13 01:12:02	main
917	he is gone	2012-06-13 01:12:23	main
918	somewhere	2012-06-13 01:12:39	main
919	between	2012-06-13 01:12:43	main
920	Canada	2012-06-13 01:12:48	main
921	Ontario	2012-06-13 01:13:04	main
922	Pizza	2012-06-17 19:59:44	main
923	Banana And Pear	2012-06-17 20:00:33	main
924	Pizza And French Fies	2012-06-17 20:08:38	main
925	test	2012-08-06 17:30:11	tts
926	test 123	2012-08-06 17:30:57	tts
927	test 123	2012-08-06 17:36:59	tts
928	somewhere between Canada Ontario	2012-08-06 17:43:35	main
929	Good Bye	2012-08-06 17:44:12	main
930	5:44 pm	2012-08-06 17:44:16	main
931	 Montreal	2012-08-07 22:15:59	main
932	he	2012-08-07 22:16:04	main
933	this a test	2012-08-07 22:16:32	tts
934	this a test	2012-08-07 22:16:41	tts
935	this a test	2012-08-07 22:16:52	tts
936	this a test	2012-08-07 22:17:08	tts
937	Good Bye	2012-08-07 22:17:16	main
938	Canada	2012-08-07 22:17:37	main
939	Ontario	2012-08-07 22:17:41	main
940	British Columbia	2012-08-07 22:17:46	main
941	Home	2012-08-07 22:17:52	main
942	Ontario	2012-08-07 22:19:43	main
943	I want to go to bed	2012-08-07 22:33:49	main
944	hey it is Jeffrey	2012-08-07 22:33:54	main
945	10:34 pm	2012-08-07 22:34:07	main
946	Tuesday 7th of August 2012 	2012-08-07 22:34:13	main
947	Ouch	2012-08-07 22:34:19	main
948	Hello	2012-08-07 22:34:24	main
949	hey it is Jeffrey	2012-08-07 22:34:27	main
950	Lego	2012-08-07 22:35:21	main
951	he is gone no where	2012-08-07 22:35:38	main
952	he is gone	2012-08-07 22:35:42	main
953	somewhere	2012-08-07 22:35:47	main
954	 Montreal	2012-08-19 17:55:37	tts
955	TEST	2012-08-25 00:01:21	tts
956	TESTU	2012-08-25 00:01:31	tts
957	TESTU	2012-08-25 00:01:32	tts
958	TESTU	2012-08-25 00:01:48	tts
959	12:02 am	2012-08-25 00:02:16	main
960	TESTU	2012-08-25 00:02:24	tts
961	hey it is Jeffrey	2012-08-25 00:02:25	main
962	 Montreal	2012-08-25 23:37:22	tts
963	Lego	2012-08-25 23:37:31	main
964	Lego	2012-08-25 23:37:32	main
965	 Quebec	2012-08-25 23:38:00	main
966	 Quebec	2012-08-25 23:38:01	main
967	 Quebec	2012-08-26 00:00:41	main
968	 Quebec	2012-08-26 00:02:40	main
969	 Quebec	2012-08-26 00:04:20	main
970	 Quebec	2012-08-26 00:05:41	main
971	Canada	2012-08-26 00:05:49	main
972	Canada	2012-08-26 00:05:49	main
973	Ontario	2012-08-26 00:05:53	main
974	Ontario	2012-08-26 00:06:14	main
975	Studying	2012-08-26 00:06:36	main
976	Studying	2012-08-26 00:06:36	main
977	Lettuce	2012-08-26 00:06:52	main
978	Lettuce	2012-08-26 00:06:58	main
979	Corn	2012-08-26 00:07:05	main
980	Pizza	2012-08-26 00:07:08	main
981	French Fies	2012-08-26 00:11:54	main
982	Pear	2012-08-26 00:14:00	main
983	hey	2012-08-26 00:14:51	tts
984	hey	2012-08-26 00:14:56	tts
985	hey buddy	2012-08-26 00:15:29	tts
986	hey buddy	2012-08-26 00:15:34	tts
987	hey buddy	2012-08-26 00:15:42	tts
988	hey buddy	2012-08-26 00:15:42	tts
989	hey buddy  	2012-08-26 00:22:39	tts
990	hey buddy  	2012-08-26 00:22:39	tts
991	hey buddy  	2012-08-26 00:22:40	tts
992	hey buddy  	2012-08-26 00:22:41	tts
993	hey buddy  	2012-08-26 00:22:42	tts
994	hey buddy  	2012-08-26 00:22:43	tts
995	hey buddy  	2012-08-26 00:22:50	tts
996	this is a test	2012-08-26 00:28:00	tts
997	this is a test	2012-08-26 00:28:35	tts
998	this is a test	2012-08-26 00:28:40	tts
999	this is a test	2012-08-26 00:28:55	tts
1000	test 	2012-08-26 00:30:03	tts
1001	test 	2012-08-26 00:30:05	tts
1002	test	2012-08-26 00:30:49	tts
1003	test	2012-08-26 00:30:54	tts
1004	test	2012-08-26 00:31:06	tts
1005	hey	2012-08-26 00:33:07	tts
1006	hey there	2012-08-26 00:38:58	tts
1007	how are you doing	2012-08-26 00:39:09	tts
1008	i am doing fine	2012-08-26 00:39:38	tts
1009	I want to go to bed	2012-08-26 00:42:22	main
1010	Lego	2012-08-26 00:48:15	main
1011	Lego	2012-08-26 00:49:16	main
1012	Lego	2012-08-26 00:54:24	main
1013	Lego	2012-08-26 00:54:26	main
1014	Studying	2012-08-26 00:54:44	main
1015	Studying	2012-08-26 00:56:17	main
1016	Canada	2012-08-26 00:56:36	main
1017	Ontario	2012-08-26 00:56:58	main
1018	 Quebec	2012-08-26 00:57:35	main
1019	 Quebec	2012-08-26 00:57:36	main
1020	Ottawa	2012-08-26 00:57:58	main
1021	Ontario	2012-08-26 00:58:02	main
1022	And	2012-08-26 00:58:22	main
1023	Home	2012-08-26 00:58:27	main
1024	The	2012-08-26 00:58:38	main
1025	Home	2012-08-26 00:59:19	main
1026	Vancouver	2012-08-26 00:59:30	main
1027	British Columbia	2012-08-26 00:59:33	main
1028	Home Vancouver British Columbia	2012-08-26 01:01:02	main
1029	Home Vancouver British Columbia	2012-08-26 01:01:17	main
1030	Home	2012-08-26 01:03:21	main
1031	is	2012-08-26 01:03:29	main
1032	Vancouver	2012-08-26 01:03:35	main
1033	British Columbia	2012-08-26 01:03:39	main
1034	 Quebec	2012-08-26 18:45:41	main
1035	Canada	2012-08-26 18:45:46	main
1036	Ottawa	2012-08-26 18:46:02	main
1037	Ontario	2012-08-26 18:46:09	main
1038	hey it is Jeffrey	2012-08-26 21:00:45	main
1039	I want to go to bed	2012-08-26 21:00:50	main
1040	Good Bye	2012-08-26 21:00:54	main
1041	I need to go to the  Bathroom	2012-08-26 21:00:59	main
1042	test	2012-09-01 16:52:55	tts
1043	test 1234	2012-09-01 16:53:09	tts
1044	test 1 2 3 4 	2012-09-01 16:53:24	tts
1045	 Montreal	2012-09-01 16:54:05	tts
1046	 Montreal	2012-09-01 16:54:08	tts
1047	Good Bye I need to go to the  Bathroom 4:30 pm Tuesday 22nd of November 2011  I need to go to the  Bathroom Good Bye Ouch Hello Good Bye Ouch Hello 4:36 pm Tuesday 22nd of November 2011  Cherry And The Banana	2012-09-01 16:54:27	main
1048	he is gone	2012-09-01 16:54:51	tts
1049	4:55 pm	2012-09-01 16:55:12	main
1050	Good Bye	2012-09-01 16:55:13	main
1051	Ouch	2012-09-01 16:55:20	main
1052	Saturday 1st of September 2012 	2012-09-01 16:55:24	main
1053	hey it is Jeffrey	2012-09-01 16:55:31	main
1054	test=	2012-09-01 17:04:08	main
1055	I want to go to bed	2012-09-01 17:04:29	main
1056	HELLO	2012-09-01 17:05:03	tts
1057	test=	2012-09-01 17:05:08	main
1058	I want to go to bed	2012-09-01 17:06:02	main
1059	test	2012-09-01 17:06:24	main
1060	TEST	2012-09-01 17:06:44	tts
1061	TEST	2012-09-01 17:06:48	tts
1062	TEST	2012-09-01 17:06:50	tts
1063	OK	2012-09-01 17:06:58	tts
1064	Hello	2012-09-06 23:38:03	main
1065	/hey	2012-09-06 23:38:36	tts
1066	I want to go to bed	2012-09-08 21:26:04	main
1067	I want to go to bed	2012-09-08 21:26:11	main
1068	I want to go to bed	2012-09-08 21:26:11	main
1069	hey it is Jeffrey	2012-09-08 21:27:14	main
1070	I want to go to bed	2012-09-08 21:27:17	main
1071	test	2012-09-08 21:27:21	main
1072	hey testing	2012-09-08 21:27:47	tts
1073	hey testing	2012-09-08 21:27:49	tts
1074	hey	2012-09-08 21:29:30	tts
1075	HELLO	2012-09-08 21:32:58	tts
1076	HELLO	2012-09-08 21:39:49	tts
1077	HELLO	2012-09-08 21:39:51	tts
1078	HELLO	2012-09-08 21:39:56	tts
1079	HELLO	2012-09-08 21:39:56	tts
1080	hey	2012-09-08 21:40:11	tts
1081	hey	2012-09-08 21:40:23	tts
1082	hey	2012-09-08 21:45:29	tts
1083	hey	2012-09-08 21:45:48	tts
1084	test	2012-09-08 21:58:42	tts
1085	test	2012-09-08 21:58:49	tts
1086	do	2012-09-08 22:03:37	tts
1087	dofn	2012-09-08 22:04:00	tts
1088	dofn	2012-09-08 22:04:09	tts
1089	hey	2012-09-08 22:04:47	tts
1090	hey it is Jeffrey	2012-09-08 22:16:47	main
1091	hey	2012-09-08 22:18:41	tts
1092	Hello	2012-09-08 22:22:00	main
1093	hello	2012-09-08 22:22:14	tts
1094	hello	2012-09-08 22:22:26	tts
1095	hello	2012-09-08 22:22:33	tts
1096	jeff	2012-09-08 22:22:50	tts
1097	jeff	2012-09-08 22:23:04	tts
1098	helo	2012-09-08 22:23:40	tts
1099	helo	2012-09-08 22:23:45	tts
1100	helo	2012-09-08 22:25:06	tts
1101	teswt	2012-09-08 22:31:13	tts
1102	hello	2012-09-08 22:31:49	tts
1103	hello	2012-09-08 22:31:54	tts
1104	hello	2012-09-08 22:32:09	tts
1105	hello	2012-09-08 22:32:46	tts
1106	hello	2012-09-08 22:33:03	tts
1107	hell;	2012-09-08 22:33:21	tts
1108	hello	2012-09-09 21:57:12	tts
1109	hello	2012-09-09 21:57:17	tts
1110	hello	2012-09-09 21:57:22	tts
1111	r	2012-09-09 21:57:34	tts
1112	hello	2012-09-09 21:57:38	tts
1113	hello	2012-09-09 21:57:51	tts
1114	hello	2012-09-09 22:09:03	tts
1115	test	2012-09-09 22:17:54	tts
1116	tedst	2012-09-09 22:18:03	tts
1117	test	2012-09-09 22:18:10	tts
1118	hello	2012-09-09 22:18:17	tts
1119	hello	2012-09-09 22:18:21	tts
1120	hello	2012-09-09 22:18:26	tts
1121	hello	2012-09-09 22:18:34	tts
1122	hey it is Jeffrey	2012-09-16 23:48:32	main
1123	hey it is Jeffrey	2012-09-16 23:48:52	main
1124	hey it is Jeffrey	2012-09-16 23:50:09	main
1125	test	2012-09-16 23:50:27	tts
1126	test	2012-09-16 23:50:36	tts
1127	welcome home	2012-09-16 23:50:47	tts
1128	wec	2012-09-16 23:51:17	tts
1129	welcome home	2012-09-16 23:51:29	tts
1130	welcome home test	2012-09-16 23:51:37	tts
1131	test	2012-09-16 23:53:29	tts
1132	test	2012-09-16 23:53:31	tts
1133	test	2012-09-16 23:53:32	tts
1134	test	2012-09-16 23:53:32	tts
1135	testing 1234	2012-09-16 23:54:47	tts
1136	testing 1 2 3 4	2012-09-16 23:55:02	tts
1137	test	2012-09-16 23:57:31	main
1138	test	2012-09-16 23:58:21	main
1139	hey	2012-09-16 23:58:29	tts
1140	hey this is a test	2012-09-16 23:58:42	tts
1141	hey this is a test	2012-09-16 23:58:45	tts
1142	hey this is a test	2012-09-16 23:58:46	tts
1143	hey this is a test	2012-09-16 23:58:47	tts
1144	test	2012-09-16 23:59:15	tts
1145	test	2012-09-16 23:59:17	tts
1146	test	2012-09-16 23:59:17	tts
1147	test	2012-09-16 23:59:18	tts
1148	test	2012-09-17 00:00:11	tts
1149	test	2012-09-17 00:00:12	tts
1150	test	2012-09-17 00:00:15	tts
1151	hey	2012-09-17 00:04:38	tts
1152	hey	2012-09-17 00:04:38	tts
1153	hey	2012-09-17 00:04:39	tts
1154	hey thi	2012-09-17 00:04:50	tts
1155	this is	2012-09-17 00:07:09	tts
1156	this is	2012-09-17 00:07:10	tts
1157	this is  hek	2012-09-17 00:07:54	tts
1158	this is  hello	2012-09-17 00:09:27	tts
1159	this is  hello	2012-09-17 00:09:32	tts
1160	Ouch	2012-09-17 00:09:37	main
1161	Hello	2012-09-17 00:09:43	main
1162	I need to go to the  Bathroom	2012-09-17 00:09:49	main
1163	hey it is Jeffrey	2012-09-17 23:35:24	main
1164	testing	2012-09-17 23:35:39	tts
1165	testing	2012-09-17 23:35:43	tts
1166	testing	2012-09-17 23:35:49	tts
1167	hey it is Jeffrey	2012-09-17 23:41:49	main
1168	hey it is Jeffrey	2012-09-17 23:43:26	main
1169	I want to go to bed	2012-09-17 23:43:32	main
1170	I want to go to bed	2012-09-17 23:43:36	main
1171	hey it is Jeffrey	2012-09-18 00:06:57	main
1172	hey it is Jeffrey	2012-09-18 00:08:28	main
1173	hey it is Jeffrey	2012-09-18 00:08:32	main
1174	Hello	2012-09-18 00:08:33	main
1175	Hello	2012-09-18 00:08:37	main
1176	Ouch	2012-09-18 00:08:49	main
1177	Ouch	2012-09-18 00:08:51	main
1178	Good Bye	2012-09-18 00:09:47	main
1179	Hello	2012-09-18 00:09:51	main
1180	Ouch	2012-09-18 00:09:56	main
1181	I want to go to bed	2012-09-18 00:09:59	main
1182	test	2012-09-18 00:10:04	main
1183	Hello	2012-09-18 00:11:34	main
1184	hey it is Jeffrey	2012-09-18 00:13:17	main
1185	Hello	2012-09-18 00:13:22	main
1186	Hello	2012-09-18 00:13:26	main
1187	Good Bye	2012-09-18 00:13:32	main
1188	I need to go to the  Bathroom	2012-09-18 00:13:37	main
1189	12:13 am	2012-09-18 00:13:44	main
1190	12:13 am	2012-09-18 00:13:51	main
1191	Tuesday 18th of September 2012 	2012-09-18 00:14:01	main
1192	test	2012-09-18 00:14:09	main
1193	hello how are u	2012-09-18 00:14:25	tts
1194	Hello	2012-09-18 00:14:34	tts
1195	hello	2012-09-18 00:14:50	tts
1196	hello 	2012-09-18 00:14:55	tts
1197	hello ho	2012-09-18 00:15:00	tts
1198	hello how are	2012-09-18 00:15:09	tts
1199	hello how are	2012-09-18 00:15:15	tts
1200	hello how are	2012-09-18 00:15:17	tts
1201	hello how are	2012-09-18 00:15:20	tts
1202	hello how are	2012-09-18 00:15:48	tts
1203	hello how are you	2012-09-18 00:16:00	tts
1204	hello jeff	2012-09-18 00:16:14	tts
1205	hello jeff	2012-09-18 00:16:18	tts
1206	hello, jeff	2012-09-18 00:16:34	tts
1207	Hello Jeff how are you today	2012-09-18 00:17:07	tts
1208	hey it is Jeffrey	2012-09-18 23:04:32	main
1209	Ouch	2012-09-18 23:19:18	main
1210	Good Bye	2012-09-18 23:19:23	main
1211	I need to go to the  Bathroom	2012-09-18 23:19:28	main
1212	11:19 pm	2012-09-18 23:19:44	main
1213	11:19 pm	2012-09-18 23:19:52	main
1214	test	2012-09-18 23:20:00	main
1215	I want to go to bed	2012-09-18 23:20:07	main
1216	Ouch	2012-09-18 23:20:23	main
1217	I need to go to bed	2012-09-18 23:20:45	tts
1218	I need to go to bed now	2012-09-18 23:20:53	tts
1219	Bathroom	2012-09-18 23:21:07	tts
1220	Bath room	2012-09-18 23:21:18	tts
1221	Bath room	2012-09-18 23:21:23	tts
1222	Bath room	2012-09-18 23:21:35	tts
1223	I need to go to the  Bath room	2012-09-18 23:22:25	main
1224	I need to go to the  Bath room	2012-09-18 23:23:59	main
1225	11:24 pm	2012-09-18 23:24:04	main
1226	Tuesday 18th of September 2012 	2012-09-18 23:24:10	main
1227	hello	2012-09-18 23:24:26	tts
1228	hello how are u	2012-09-18 23:24:39	tts
1229	this is working better	2012-09-18 23:25:10	tts
1230	this is working better	2012-09-18 23:25:25	tts
1231	this is working better	2012-09-18 23:25:40	tts
1232	Hello	2012-09-19 11:22:50	main
1233	hey it is Jeffrey	2012-09-19 11:22:58	main
1234	Wednesday 19th of September 2012 	2012-09-19 11:23:15	main
1235	Ouch	2012-09-19 11:29:43	main
1236	Hello	2012-09-19 11:29:49	main
1237	hello world	2012-09-19 11:30:03	tts
1238	hello world	2012-09-19 11:30:08	tts
1239	canada	2012-09-19 11:30:30	tts
1240	hello my name is jeffrey	2012-09-19 11:34:35	tts
1241	hello my name is jeffrey	2012-09-19 11:34:59	tts
1242	hello my name is jeffrey	2012-09-19 11:35:00	tts
1243	hello my name is jeffrey	2012-09-19 11:35:00	tts
1244	hello my name is jeffrey	2012-09-19 11:35:00	tts
1245	hello my name is jeffrey	2012-09-19 11:35:00	tts
1246	hello my name is jeffrey	2012-09-19 11:35:14	tts
1247	hello my name is	2012-09-19 11:40:18	tts
1248	hello my name is	2012-09-19 11:40:25	tts
1249	hello my name is	2012-09-19 11:42:37	tts
1250	hello my name is jeffrey	2012-09-19 11:42:47	tts
1251	hello my name is jeffrey ok	2012-09-19 11:42:53	tts
1252	Yellow	2012-09-19 11:43:09	tts
1253	Yellow,red	2012-09-19 11:43:20	tts
1254	Yellow	2012-09-19 11:43:35	tts
1255	ix	2012-09-19 11:44:09	tts
1256	I X	2012-09-19 11:44:18	tts
1257	test	2012-09-22 22:19:22	main
1258	test	2012-09-23 00:17:51	tts
1259	test 12342	2012-09-23 00:18:17	tts
1260	test	2012-09-23 00:18:42	tts
1261	test	2012-09-23 00:18:46	tts
1262	test	2012-09-23 00:18:51	tts
1263	test	2012-09-23 00:19:51	tts
1264	new car	2012-09-23 00:23:26	tts
1265	new car 2	2012-09-23 00:23:31	tts
1266	new car 2	2012-09-23 00:23:48	tts
1267	new car 2	2012-09-23 00:24:11	tts
1268	new car 2	2012-09-23 00:26:05	tts
1269	new car 34	2012-09-23 00:26:31	tts
1270	new car 348	2012-09-23 00:26:47	tts
1271	new car 348	2012-09-23 00:27:11	tts
1272	new car 348	2012-09-23 00:27:48	tts
1273	new car 348	2012-09-23 00:29:56	tts
1274	new car 348	2012-09-23 00:30:02	tts
1275	new car 348	2012-09-23 00:31:02	tts
1276	new car 348	2012-09-23 00:31:14	tts
1277	new car 348	2012-09-23 00:34:06	tts
1278	new car 348	2012-09-23 00:36:24	tts
1279	new car 348	2012-09-23 00:39:18	tts
1280	new car 348	2012-09-23 00:40:46	tts
1281	new car 348	2012-09-23 00:43:47	tts
1282	new car 348	2012-09-23 00:47:20	tts
1283	new car 348	2012-09-23 00:50:10	tts
1284	new car 348	2012-09-23 00:54:06	tts
1285	Ouch	2012-09-23 00:56:05	main
1286	Ouch	2012-09-23 00:56:07	main
1287	new car 348	2012-09-23 00:57:55	tts
1288	Ouch	2012-09-23 00:58:58	main
1289	Ouch	2012-09-23 00:59:02	main
1290	Hello	2012-09-23 00:59:05	main
1291	Hello	2012-09-23 00:59:07	main
1292	Good Bye	2012-09-23 00:59:10	main
1293	12:59 am	2012-09-23 00:59:13	main
1294	I need to go to the  Bath room	2012-09-23 00:59:38	main
1295	Ouch	2012-09-23 00:59:56	main
1296	new car 348	2012-09-23 01:00:03	tts
1297	hey it is Jeffrey	2012-09-23 01:00:03	main
1298	hey it is Jeffrey	2012-09-23 01:00:07	main
1299	Hello	2012-09-23 01:00:12	main
1300	Ouch	2012-09-23 01:00:15	main
1301	Good Bye	2012-09-23 01:00:18	main
1302	new car 348	2012-09-23 01:00:23	tts
1303	new car 347	2012-09-23 01:00:34	tts
1304	new car 347	2012-09-23 01:00:42	tts
1305	test	2012-09-23 01:01:23	main
1306	Lego	2012-09-23 01:11:19	main
1307	Canada	2012-09-23 01:11:30	main
1308	Canada	2012-09-23 01:11:33	main
1309	 Quebec	2012-09-23 01:11:36	main
1310	Home	2012-09-23 01:11:40	main
1311	Ontario	2012-09-23 01:12:36	main
1312	Toronto	2012-09-23 01:12:46	main
1313	Home	2012-09-23 01:12:51	main
1314	 Quebec	2012-09-23 01:12:57	main
1315	between	2012-09-23 01:13:14	main
1316	he is gone	2012-09-23 01:20:17	main
1317	Canada	2012-09-23 14:39:49	main
1318	Toronto	2012-09-23 14:41:33	main
1319	Toronto	2012-09-23 14:43:13	main
1320	Toronto	2012-09-23 14:44:14	main
1321	Toronto	2012-09-23 14:44:17	main
1322	Toronto	2012-09-23 14:46:51	main
1323	Toronto	2012-09-23 14:46:55	main
1324	Ouch	2012-09-23 14:47:13	main
1325	test	2012-09-23 14:48:24	main
1326	Good Bye	2012-09-23 14:48:26	main
1327	Ouch	2012-09-23 14:48:32	main
1328	Sunday 23rd of September 2012 	2012-09-23 14:48:59	main
1329	Hello	2012-09-23 14:49:04	main
1330	Ouch	2012-09-23 14:49:11	main
1331	test	2012-09-23 14:49:26	main
1332	Good Bye	2012-09-23 14:49:30	main
1333	Sunday 23rd of September 2012 	2012-09-23 14:49:37	main
1334	hello this is a test	2012-09-23 14:50:09	tts
1335	hello this is a test	2012-09-23 14:50:17	tts
1336	hello this is a test	2012-09-23 14:50:29	tts
\.


--
-- Data for Name: phases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY phases (phases, pic, id, size, modified, created, filename, paraphase, boards_id) FROM stdin;
Hello	\N	12	\N	2011-11-04 23:02:56-07	2011-01-30 00:53:53-08	hello_3.jpg		0
Ouch		14	\N	2011-11-04 23:03:52-07	2011-01-30 20:32:52-08	ouch.gif		0
Good Bye		13	\N	2011-11-04 23:04:33-07	2011-01-30 01:36:52-08	goodbye.jpg		0
planet earth 	\N	32	\N	2011-11-05 20:47:34-07	2011-11-05 20:47:34-07	\N	\N	\N
 Montreal	\N	34	\N	2011-11-05 23:12:44-07	2011-11-05 23:33:37-07			13
Lego	\N	36	\N	2011-11-05 23:28:38-07	2011-11-05 23:28:38-07	lego_table_2.jpg		17
Canada	\N	38	\N	2011-11-11 23:39:25-08	2011-11-11 23:39:25-08	canada_flag.gif		13
 Quebec	\N	37	\N	2011-11-11 23:52:33-08	2011-11-11 10:59:56-08	quebec-flag.gif		13
Home	\N	41	\N	2011-11-12 00:27:21-08	2011-11-12 00:27:21-08	home.png		13
Vancouver	\N	46	\N	2011-11-13 06:01:34-08	2011-11-13 06:01:34-08	\N	\N	13
Study	\N	48	\N	2011-11-13 06:32:52-08	2011-11-13 06:31:33-08	study.gif	Studying	14
Ottawa	\N	45	\N	2011-11-13 06:40:06-08	2011-11-13 06:01:27-08	ottawa.jpg		13
Toronto	\N	44	\N	2011-11-13 06:41:38-08	2011-11-13 06:01:22-08	toronto.jpg		13
Ontario	\N	43	\N	2011-11-13 06:54:58-08	2011-11-13 06:01:12-08	ontario.png		13
BC	\N	42	\N	2011-11-13 06:55:14-08	2011-11-13 06:01:06-08	bc-flag.gif	British Columbia	13
Lettuce	\N	49	\N	2011-11-13 07:12:45-08	2011-11-13 07:12:45-08	lettuce.gif		18
Pizza	\N	50	\N	2011-11-13 07:13:13-08	2011-11-13 07:13:13-08	pizza2.gif		18
Banana	\N	51	\N	2011-11-13 07:29:12-08	2011-11-13 07:29:12-08	Banana.png		18
Cherry	\N	53	\N	2011-11-13 07:31:31-08	2011-11-13 07:31:31-08	cherry.png		18
French Fies	\N	54	\N	2011-11-13 07:32:06-08	2011-11-13 07:32:06-08	french_fies.png		18
Carrot	\N	55	\N	2011-11-13 07:33:54-08	2011-11-13 07:33:54-08	Carrot.jpg		18
Corn	\N	56	\N	2011-11-13 07:34:25-08	2011-11-13 07:34:25-08	corn.gif		18
Pear	\N	57	\N	2011-11-13 07:35:16-08	2011-11-13 07:35:16-08	pear.png		18
Juice	\N	52	\N	2011-11-13 07:38:30-08	2011-11-13 07:29:45-08	juice.png		18
The	\N	59	\N	2011-11-13 21:02:54-08	2011-11-13 21:02:54-08	\N		20
And	\N	58	\N	2011-11-13 21:03:11-08	2011-11-13 21:02:40-08			20
Time	\N	61	\N	2011-11-18 18:41:17-08	2011-11-18 18:39:47-08	clock.jpg	whattime	0
Date	\N	62	\N	2011-11-18 18:44:39-08	2011-11-18 18:44:39-08	calendar.jpg	get date	0
he is gone no where	\N	64	\N	2011-11-21 20:04:19-08	2011-11-21 20:04:19-08	\N	\N	20
he is gone	\N	65	\N	2011-11-21 20:04:32-08	2011-11-21 20:04:32-08	\N	\N	20
hey it is Jeffrey	\N	66	\N	2011-11-21 21:56:33-08	2011-11-21 21:56:33-08	\N	\N	0
he	\N	67	\N	2011-11-21 22:05:34-08	2011-11-21 22:05:34-08	\N	\N	13
somewhere	\N	68	\N	2011-11-24 02:26:26-08	2011-11-24 02:26:26-08	\N		20
between	\N	69	\N	2011-11-24 02:26:52-08	2011-11-24 02:26:52-08	\N		20
Banana And Pear 	\N	73	\N	2011-11-24 14:38:44-08	2011-11-24 14:38:44-08	\N	\N	18
Pizza And French Fies 	\N	77	\N	2011-11-24 16:06:11-08	2011-11-24 16:06:11-08	\N	\N	18
Juice And Banana And Cherry 	\N	79	\N	2011-11-24 16:07:07-08	2011-11-24 16:07:07-08	\N	\N	18
somewhere between Canada Ontario 	\N	80	\N	2012-06-17 19:59:13-07	2012-06-17 19:59:13-07	\N	\N	14
bed	\N	81	\N	2012-08-07 22:33:25-07	2012-08-07 22:33:25-07	\N	I want to go to bed	0
is	\N	82	\N	2012-08-26 01:02:13-07	2012-08-26 01:02:13-07	\N	is	20
test	\N	83	\N	2012-09-01 17:05:35-07	2012-09-01 17:03:48-07	macbootup.jpg	test	0
 Bathroom		17	\N	2012-09-18 23:22:14-07	2011-02-01 17:39:10-08		I need to go to the  Bath room	0
\.


--
-- Data for Name: storyboard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY storyboard (id, orderno, phase, "time", series, status) FROM stdin;
101	1	Home	2012-08-26 00:59:19	18	\N
102	2	Vancouver	2012-08-26 00:59:30	18	\N
103	3	British Columbia	2012-08-26 00:59:33	18	\N
104	1	hello	2012-09-09 22:09:03	19	\N
\.


SET search_path = folders, pg_catalog;

--
-- Name: folders_pkey; Type: CONSTRAINT; Schema: folders; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (folderid);


SET search_path = mediawiki, pg_catalog;

--
-- Name: category_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (cat_id);


--
-- Name: external_user_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY external_user
    ADD CONSTRAINT external_user_pkey PRIMARY KEY (eu_local_id);


--
-- Name: filearchive_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY filearchive
    ADD CONSTRAINT filearchive_pkey PRIMARY KEY (fa_id);


--
-- Name: image_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_pkey PRIMARY KEY (img_name);


--
-- Name: interwiki_iw_prefix_key; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY interwiki
    ADD CONSTRAINT interwiki_iw_prefix_key UNIQUE (iw_prefix);


--
-- Name: ipblocks_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY ipblocks
    ADD CONSTRAINT ipblocks_pkey PRIMARY KEY (ipb_id);


--
-- Name: job_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY job
    ADD CONSTRAINT job_pkey PRIMARY KEY (job_id);


--
-- Name: log_search_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY log_search
    ADD CONSTRAINT log_search_pkey PRIMARY KEY (ls_field, ls_value, ls_log_id);


--
-- Name: logging_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY logging
    ADD CONSTRAINT logging_pkey PRIMARY KEY (log_id);


--
-- Name: math_math_inputhash_key; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY math
    ADD CONSTRAINT math_math_inputhash_key UNIQUE (math_inputhash);


--
-- Name: mwuser_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY mwuser
    ADD CONSTRAINT mwuser_pkey PRIMARY KEY (user_id);


--
-- Name: mwuser_user_name_key; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY mwuser
    ADD CONSTRAINT mwuser_user_name_key UNIQUE (user_name);


--
-- Name: objectcache_keyname_key; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY objectcache
    ADD CONSTRAINT objectcache_keyname_key UNIQUE (keyname);


--
-- Name: page_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY page
    ADD CONSTRAINT page_pkey PRIMARY KEY (page_id);


--
-- Name: page_props_pk; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY page_props
    ADD CONSTRAINT page_props_pk PRIMARY KEY (pp_page, pp_propname);


--
-- Name: page_restrictions_pk; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY page_restrictions
    ADD CONSTRAINT page_restrictions_pk PRIMARY KEY (pr_page, pr_type);


--
-- Name: page_restrictions_pr_id_key; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY page_restrictions
    ADD CONSTRAINT page_restrictions_pr_id_key UNIQUE (pr_id);


--
-- Name: pagecontent_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY pagecontent
    ADD CONSTRAINT pagecontent_pkey PRIMARY KEY (old_id);


--
-- Name: querycache_info_qci_type_key; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY querycache_info
    ADD CONSTRAINT querycache_info_qci_type_key UNIQUE (qci_type);


--
-- Name: recentchanges_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY recentchanges
    ADD CONSTRAINT recentchanges_pkey PRIMARY KEY (rc_id);


--
-- Name: revision_rev_id_key; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY revision
    ADD CONSTRAINT revision_rev_id_key UNIQUE (rev_id);


--
-- Name: site_stats_ss_row_id_key; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY site_stats
    ADD CONSTRAINT site_stats_ss_row_id_key UNIQUE (ss_row_id);


--
-- Name: trackbacks_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY trackbacks
    ADD CONSTRAINT trackbacks_pkey PRIMARY KEY (tb_id);


--
-- Name: transcache_tc_url_key; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY transcache
    ADD CONSTRAINT transcache_tc_url_key UNIQUE (tc_url);


--
-- Name: updatelog_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY updatelog
    ADD CONSTRAINT updatelog_pkey PRIMARY KEY (ul_key);


--
-- Name: valid_tag_pkey; Type: CONSTRAINT; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

ALTER TABLE ONLY valid_tag
    ADD CONSTRAINT valid_tag_pkey PRIMARY KEY (vt_tag);


SET search_path = public, pg_catalog;

--
-- Name: boards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY boards
    ADD CONSTRAINT boards_pkey PRIMARY KEY (id);


--
-- Name: config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config
    ADD CONSTRAINT config_pkey PRIMARY KEY (id);


--
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- Name: id; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY storyboard
    ADD CONSTRAINT id PRIMARY KEY (id);


--
-- Name: phases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY phases
    ADD CONSTRAINT phases_pkey PRIMARY KEY (id);


--
-- Name: pk1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY folders
    ADD CONSTRAINT pk1 PRIMARY KEY (folderid);


SET search_path = mediawiki, pg_catalog;

--
-- Name: archive_name_title_timestamp; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX archive_name_title_timestamp ON archive USING btree (ar_namespace, ar_title, ar_timestamp);


--
-- Name: archive_user_text; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX archive_user_text ON archive USING btree (ar_user_text);


--
-- Name: category_pages; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX category_pages ON category USING btree (cat_pages);


--
-- Name: category_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX category_title ON category USING btree (cat_title);


--
-- Name: change_tag_log_tag; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX change_tag_log_tag ON change_tag USING btree (ct_log_id, ct_tag);


--
-- Name: change_tag_rc_tag; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX change_tag_rc_tag ON change_tag USING btree (ct_rc_id, ct_tag);


--
-- Name: change_tag_rev_tag; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX change_tag_rev_tag ON change_tag USING btree (ct_rev_id, ct_tag);


--
-- Name: change_tag_tag_id; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX change_tag_tag_id ON change_tag USING btree (ct_tag, ct_rc_id, ct_rev_id, ct_log_id);


--
-- Name: cl_from; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX cl_from ON categorylinks USING btree (cl_from, cl_to);


--
-- Name: cl_sortkey; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX cl_sortkey ON categorylinks USING btree (cl_to, cl_sortkey, cl_from);


--
-- Name: eu_external_id; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX eu_external_id ON external_user USING btree (eu_external_id);


--
-- Name: externallinks_from_to; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX externallinks_from_to ON externallinks USING btree (el_from, el_to);


--
-- Name: externallinks_index; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX externallinks_index ON externallinks USING btree (el_index);


--
-- Name: fa_dupe; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX fa_dupe ON filearchive USING btree (fa_storage_group, fa_storage_key);


--
-- Name: fa_name_time; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX fa_name_time ON filearchive USING btree (fa_name, fa_timestamp);


--
-- Name: fa_notime; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX fa_notime ON filearchive USING btree (fa_deleted_timestamp);


--
-- Name: fa_nouser; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX fa_nouser ON filearchive USING btree (fa_deleted_user);


--
-- Name: il_from; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX il_from ON imagelinks USING btree (il_to, il_from);


--
-- Name: img_sha1; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX img_sha1 ON image USING btree (img_sha1);


--
-- Name: img_size_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX img_size_idx ON image USING btree (img_size);


--
-- Name: img_timestamp_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX img_timestamp_idx ON image USING btree (img_timestamp);


--
-- Name: ipb_address_unique; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX ipb_address_unique ON ipblocks USING btree (ipb_address, ipb_user, ipb_auto, ipb_anon_only);


--
-- Name: ipb_range; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX ipb_range ON ipblocks USING btree (ipb_range_start, ipb_range_end);


--
-- Name: ipb_user; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX ipb_user ON ipblocks USING btree (ipb_user);


--
-- Name: iwl_from; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX iwl_from ON iwlinks USING btree (iwl_from, iwl_prefix, iwl_title);


--
-- Name: iwl_prefix_title_from; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX iwl_prefix_title_from ON iwlinks USING btree (iwl_prefix, iwl_title, iwl_from);


--
-- Name: job_cmd_namespace_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX job_cmd_namespace_title ON job USING btree (job_cmd, job_namespace, job_title);


--
-- Name: l10n_cache_lc_lang_key; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX l10n_cache_lc_lang_key ON l10n_cache USING btree (lc_lang, lc_key);


--
-- Name: langlinks_lang_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX langlinks_lang_title ON langlinks USING btree (ll_lang, ll_title);


--
-- Name: langlinks_unique; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX langlinks_unique ON langlinks USING btree (ll_from, ll_lang);


--
-- Name: logging_page_id_time; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX logging_page_id_time ON logging USING btree (log_page, log_timestamp);


--
-- Name: logging_page_time; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX logging_page_time ON logging USING btree (log_namespace, log_title, log_timestamp);


--
-- Name: logging_times; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX logging_times ON logging USING btree (log_timestamp);


--
-- Name: logging_type_name; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX logging_type_name ON logging USING btree (log_type, log_timestamp);


--
-- Name: logging_user_time; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX logging_user_time ON logging USING btree (log_timestamp, log_user);


--
-- Name: logging_user_type_time; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX logging_user_type_time ON logging USING btree (log_user, log_type, log_timestamp);


--
-- Name: ls_log_id; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX ls_log_id ON log_search USING btree (ls_log_id);


--
-- Name: md_module_skin; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX md_module_skin ON module_deps USING btree (md_module, md_skin);


--
-- Name: mr_resource_lang; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX mr_resource_lang ON msg_resource USING btree (mr_resource, mr_lang);


--
-- Name: mrl_message_resource; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX mrl_message_resource ON msg_resource_links USING btree (mrl_message, mrl_resource);


--
-- Name: new_name_timestamp; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX new_name_timestamp ON recentchanges USING btree (rc_new, rc_namespace, rc_timestamp);


--
-- Name: objectcacache_exptime; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX objectcacache_exptime ON objectcache USING btree (exptime);


--
-- Name: oi_name_archive_name; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX oi_name_archive_name ON oldimage USING btree (oi_name, oi_archive_name);


--
-- Name: oi_name_timestamp; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX oi_name_timestamp ON oldimage USING btree (oi_name, oi_timestamp);


--
-- Name: oi_sha1; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX oi_sha1 ON oldimage USING btree (oi_sha1);


--
-- Name: page_len_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX page_len_idx ON page USING btree (page_len);


--
-- Name: page_main_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX page_main_title ON page USING btree (page_title) WHERE (page_namespace = 0);


--
-- Name: page_mediawiki_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX page_mediawiki_title ON page USING btree (page_title) WHERE (page_namespace = 8);


--
-- Name: page_project_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX page_project_title ON page USING btree (page_title) WHERE (page_namespace = 4);


--
-- Name: page_props_propname; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX page_props_propname ON page_props USING btree (pp_propname);


--
-- Name: page_random_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX page_random_idx ON page USING btree (page_random);


--
-- Name: page_talk_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX page_talk_title ON page USING btree (page_title) WHERE (page_namespace = 1);


--
-- Name: page_unique_name; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX page_unique_name ON page USING btree (page_namespace, page_title);


--
-- Name: page_user_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX page_user_title ON page USING btree (page_title) WHERE (page_namespace = 2);


--
-- Name: page_utalk_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX page_utalk_title ON page USING btree (page_title) WHERE (page_namespace = 3);


--
-- Name: pagelink_unique; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX pagelink_unique ON pagelinks USING btree (pl_from, pl_namespace, pl_title);


--
-- Name: pagelinks_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX pagelinks_title ON pagelinks USING btree (pl_title);


--
-- Name: pf_name_server; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX pf_name_server ON profiling USING btree (pf_name, pf_server);


--
-- Name: protected_titles_unique; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX protected_titles_unique ON protected_titles USING btree (pt_namespace, pt_title);


--
-- Name: querycache_type_value; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX querycache_type_value ON querycache USING btree (qc_type, qc_value);


--
-- Name: querycachetwo_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX querycachetwo_title ON querycachetwo USING btree (qcc_type, qcc_namespace, qcc_title);


--
-- Name: querycachetwo_titletwo; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX querycachetwo_titletwo ON querycachetwo USING btree (qcc_type, qcc_namespacetwo, qcc_titletwo);


--
-- Name: querycachetwo_type_value; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX querycachetwo_type_value ON querycachetwo USING btree (qcc_type, qcc_value);


--
-- Name: rc_cur_id; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX rc_cur_id ON recentchanges USING btree (rc_cur_id);


--
-- Name: rc_ip; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX rc_ip ON recentchanges USING btree (rc_ip);


--
-- Name: rc_namespace_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX rc_namespace_title ON recentchanges USING btree (rc_namespace, rc_title);


--
-- Name: rc_timestamp; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX rc_timestamp ON recentchanges USING btree (rc_timestamp);


--
-- Name: rc_timestamp_bot; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX rc_timestamp_bot ON recentchanges USING btree (rc_timestamp) WHERE (rc_bot = 0);


--
-- Name: redirect_ns_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX redirect_ns_title ON redirect USING btree (rd_namespace, rd_title, rd_from);


--
-- Name: rev_text_id_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX rev_text_id_idx ON revision USING btree (rev_text_id);


--
-- Name: rev_timestamp_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX rev_timestamp_idx ON revision USING btree (rev_timestamp);


--
-- Name: rev_user_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX rev_user_idx ON revision USING btree (rev_user);


--
-- Name: rev_user_text_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX rev_user_text_idx ON revision USING btree (rev_user_text);


--
-- Name: revision_unique; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX revision_unique ON revision USING btree (rev_page, rev_id);


--
-- Name: tag_summary_log_id; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX tag_summary_log_id ON tag_summary USING btree (ts_log_id);


--
-- Name: tag_summary_rc_id; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX tag_summary_rc_id ON tag_summary USING btree (ts_rc_id);


--
-- Name: tag_summary_rev_id; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX tag_summary_rev_id ON tag_summary USING btree (ts_rev_id);


--
-- Name: templatelinks_from; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX templatelinks_from ON templatelinks USING btree (tl_from);


--
-- Name: templatelinks_unique; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX templatelinks_unique ON templatelinks USING btree (tl_namespace, tl_title, tl_from);


--
-- Name: trackback_page; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX trackback_page ON trackbacks USING btree (tb_page);


--
-- Name: ts2_page_text; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX ts2_page_text ON pagecontent USING gist (textvector);


--
-- Name: ts2_page_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX ts2_page_title ON page USING gist (titlevector);


--
-- Name: user_email_token_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX user_email_token_idx ON mwuser USING btree (user_email_token);


--
-- Name: user_groups_unique; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX user_groups_unique ON user_groups USING btree (ug_user, ug_group);


--
-- Name: user_newtalk_id_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX user_newtalk_id_idx ON user_newtalk USING btree (user_id);


--
-- Name: user_newtalk_ip_idx; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX user_newtalk_ip_idx ON user_newtalk USING btree (user_ip);


--
-- Name: user_properties_property; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX user_properties_property ON user_properties USING btree (up_property);


--
-- Name: user_properties_user_property; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX user_properties_user_property ON user_properties USING btree (up_user, up_property);


--
-- Name: wl_user; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE INDEX wl_user ON watchlist USING btree (wl_user);


--
-- Name: wl_user_namespace_title; Type: INDEX; Schema: mediawiki; Owner: talkbox; Tablespace: 
--

CREATE UNIQUE INDEX wl_user_namespace_title ON watchlist USING btree (wl_namespace, wl_title, wl_user);


--
-- Name: page_deleted; Type: TRIGGER; Schema: mediawiki; Owner: talkbox
--

CREATE TRIGGER page_deleted AFTER DELETE ON page FOR EACH ROW EXECUTE PROCEDURE page_deleted();


--
-- Name: ts2_page_text; Type: TRIGGER; Schema: mediawiki; Owner: talkbox
--

CREATE TRIGGER ts2_page_text BEFORE INSERT OR UPDATE ON pagecontent FOR EACH ROW EXECUTE PROCEDURE ts2_page_text();


--
-- Name: ts2_page_title; Type: TRIGGER; Schema: mediawiki; Owner: talkbox
--

CREATE TRIGGER ts2_page_title BEFORE INSERT OR UPDATE ON page FOR EACH ROW EXECUTE PROCEDURE ts2_page_title();


--
-- Name: archive_ar_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY archive
    ADD CONSTRAINT archive_ar_user_fkey FOREIGN KEY (ar_user) REFERENCES mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: categorylinks_cl_from_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY categorylinks
    ADD CONSTRAINT categorylinks_cl_from_fkey FOREIGN KEY (cl_from) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: externallinks_el_from_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY externallinks
    ADD CONSTRAINT externallinks_el_from_fkey FOREIGN KEY (el_from) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: filearchive_fa_deleted_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY filearchive
    ADD CONSTRAINT filearchive_fa_deleted_user_fkey FOREIGN KEY (fa_deleted_user) REFERENCES mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: filearchive_fa_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY filearchive
    ADD CONSTRAINT filearchive_fa_user_fkey FOREIGN KEY (fa_user) REFERENCES mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: image_img_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY image
    ADD CONSTRAINT image_img_user_fkey FOREIGN KEY (img_user) REFERENCES mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: imagelinks_il_from_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY imagelinks
    ADD CONSTRAINT imagelinks_il_from_fkey FOREIGN KEY (il_from) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ipblocks_ipb_by_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY ipblocks
    ADD CONSTRAINT ipblocks_ipb_by_fkey FOREIGN KEY (ipb_by) REFERENCES mwuser(user_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ipblocks_ipb_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY ipblocks
    ADD CONSTRAINT ipblocks_ipb_user_fkey FOREIGN KEY (ipb_user) REFERENCES mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: langlinks_ll_from_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY langlinks
    ADD CONSTRAINT langlinks_ll_from_fkey FOREIGN KEY (ll_from) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: logging_log_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY logging
    ADD CONSTRAINT logging_log_user_fkey FOREIGN KEY (log_user) REFERENCES mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oldimage_oi_name_fkey_cascaded; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY oldimage
    ADD CONSTRAINT oldimage_oi_name_fkey_cascaded FOREIGN KEY (oi_name) REFERENCES image(img_name) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oldimage_oi_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY oldimage
    ADD CONSTRAINT oldimage_oi_user_fkey FOREIGN KEY (oi_user) REFERENCES mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_props_pp_page_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY page_props
    ADD CONSTRAINT page_props_pp_page_fkey FOREIGN KEY (pp_page) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_restrictions_pr_page_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY page_restrictions
    ADD CONSTRAINT page_restrictions_pr_page_fkey FOREIGN KEY (pr_page) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagelinks_pl_from_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY pagelinks
    ADD CONSTRAINT pagelinks_pl_from_fkey FOREIGN KEY (pl_from) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: protected_titles_pt_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY protected_titles
    ADD CONSTRAINT protected_titles_pt_user_fkey FOREIGN KEY (pt_user) REFERENCES mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: recentchanges_rc_cur_id_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY recentchanges
    ADD CONSTRAINT recentchanges_rc_cur_id_fkey FOREIGN KEY (rc_cur_id) REFERENCES page(page_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: recentchanges_rc_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY recentchanges
    ADD CONSTRAINT recentchanges_rc_user_fkey FOREIGN KEY (rc_user) REFERENCES mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: redirect_rd_from_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY redirect
    ADD CONSTRAINT redirect_rd_from_fkey FOREIGN KEY (rd_from) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: revision_rev_page_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY revision
    ADD CONSTRAINT revision_rev_page_fkey FOREIGN KEY (rev_page) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: revision_rev_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY revision
    ADD CONSTRAINT revision_rev_user_fkey FOREIGN KEY (rev_user) REFERENCES mwuser(user_id) ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;


--
-- Name: templatelinks_tl_from_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY templatelinks
    ADD CONSTRAINT templatelinks_tl_from_fkey FOREIGN KEY (tl_from) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: trackbacks_tb_page_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY trackbacks
    ADD CONSTRAINT trackbacks_tb_page_fkey FOREIGN KEY (tb_page) REFERENCES page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_groups_ug_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY user_groups
    ADD CONSTRAINT user_groups_ug_user_fkey FOREIGN KEY (ug_user) REFERENCES mwuser(user_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_newtalk_user_id_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY user_newtalk
    ADD CONSTRAINT user_newtalk_user_id_fkey FOREIGN KEY (user_id) REFERENCES mwuser(user_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_properties_up_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY user_properties
    ADD CONSTRAINT user_properties_up_user_fkey FOREIGN KEY (up_user) REFERENCES mwuser(user_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: watchlist_wl_user_fkey; Type: FK CONSTRAINT; Schema: mediawiki; Owner: talkbox
--

ALTER TABLE ONLY watchlist
    ADD CONSTRAINT watchlist_wl_user_fkey FOREIGN KEY (wl_user) REFERENCES mwuser(user_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

