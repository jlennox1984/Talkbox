--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

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
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: talkbox
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO talkbox;

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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    fa_metadata bytea DEFAULT ''::bytea NOT NULL,
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
    img_metadata bytea DEFAULT ''::bytea NOT NULL,
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    MINVALUE 0
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
    value bytea DEFAULT ''::bytea NOT NULL,
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
    oi_metadata bytea DEFAULT ''::bytea NOT NULL,
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.config_id_seq OWNER TO postgres;

--
-- Name: config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE config_id_seq OWNED BY config.id;


--
-- Name: config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('config_id_seq', 5, true);


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
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.folders_folderid_seq OWNER TO postgres;

--
-- Name: folders_folderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE folders_folderid_seq OWNED BY folders.folderid;


--
-- Name: folders_folderid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('folders_folderid_seq', 18, true);


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
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.history_id_seq OWNER TO postgres;

--
-- Name: history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE history_id_seq OWNED BY history.id;


--
-- Name: history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('history_id_seq', 946, true);


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
    NO MAXVALUE
    NO MINVALUE
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
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.phases_id_seq OWNER TO postgres;

--
-- Name: phases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE phases_id_seq OWNED BY phases.id;


--
-- Name: phases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('phases_id_seq', 79, true);


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
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.storyboard_id_seq OWNER TO postgres;

--
-- Name: storyboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE storyboard_id_seq OWNED BY storyboard.id;


--
-- Name: storyboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('storyboard_id_seq', 94, true);


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
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY boards ALTER COLUMN fid SET DEFAULT nextval('boards_fid_seq'::regclass);


--
-- Name: name; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY boards ALTER COLUMN name SET DEFAULT nextval('boards_name_seq'::regclass);


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
usemod	http://www.usemod.com/cgi-bin/wiki.pl?$1	0	0		
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
en	messages:updated	s:9:"(Updated)";
en	messages:note	s:11:"'''Note:'''";
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
en	messages:revdelete-offender	s:16:"Revision author:";
en	messages:suppressionlog	s:15:"Suppression log";
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
en	messages:right-reset-passwords	s:28:"Reset other users' passwords";
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
en	messages:http-curl-error	s:22:"Error fetching URL: $1";
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
en	messages:uncategorizedcategories	s:24:"Uncategorized categories";
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
en	messages:allpages-summary	s:0:"";
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
en	messages:ipblocklist-empty	s:23:"The blocklist is empty.";
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
en	messages:protectedpagemovewarning	s:159:"'''Warning:''' This page has been protected so that only users with administrator privileges can move it.\nThe latest log entry is provided below for reference:";
en	messages:semiprotectedpagemovewarning	s:137:"'''Note:''' This page has been protected so that only registered users can move it.\nThe latest log entry is provided below for reference:";
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
en	messages:others	s:6:"others";
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
talkbox:messages:en	K\\2642\\264\\252.\\2662\\267R\\012s\\015\\012\\366\\364\\367S\\262\\316\\2642\\264\\256\\005\\000	2011-11-28 17:09:23-08
talkbox:messages:individual:Mainpage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:23-08
talkbox:messages:individual:Pagetitle	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Missing-article	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Editsectionhint	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Editsection	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Editsection-brackets	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Pagetitle-view-mainpage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Edit	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Opensearch-desc	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:November	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Lastmodifiedat	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Disclaimers	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Disclaimerpage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Privacy	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Privacypage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Aboutsite	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Aboutpage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Anonnotice	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Sitenotice	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:resourceloader:filter:minify-js:e59a430643ecd8e9d5ccb0b581781449	m\\224\\311\\222\\333 \\020\\206\\357y\\014NI\\225\\313ey\\342Y4\\357\\220k\\316-\\324\\222\\030\\261(,\\3268\\251\\274{\\032\\220d\\271\\310\\215\\376h\\232\\277\\027puu\\271<\\327La+\\340\\247\\030\\30518\\264G3ya\\264;:\\364_\\3770\\316\\025\\032\\215\\012\\204t\\254>\\035\\0307q\\361\\232V\\332\\343\\247\\347\\003X"\\227;\\221Bc$\\007\\326\\202GV\\263\\026;\\010\\3223\\002\\242\\353\\214\\226\\267\\024\\252\\025\\016\\032\\231b\\357m\\027\\372\\036\\235O\\210\\244y:\\340\\037\\202Dht\\333H.\\005\\0377?\\207<*gu\\365`\\033mE?\\370\\235\\2576^tJhc\\223\\333\\016Z\\274"Hh[\\273\\203\\261*\\036\\3448A\\037\\323\\252V>\\003\\345.\\205\\363\\313F<\\360\\351Q\\267\\333\\306\\306\\254\\006\\031S\\177\\000)\\215|Q\\007\\232\\337\\234\\350\\263a,\\307\\244,(\\0056\\327\\252\\247\\270H\\316,\\350Q\\233YS\\031\\006\\321b\\312"9Dk\\002o\\215\\244\\300\\013\\351I\\005\\245\\336X3b\\256\\213PQ\\253\\370M]9\\037\\330Gp\\224G\\276@\\201\\037\\222K\\012\\271\\026;\\356h\\234S\\206\\345\\015\\332p\\340\\003\\256k\\243\\257T)\\352\\376\\270\\220\\350\\332\\000\\037\\267\\324uP\\015\\332\\001\\241\\025\\272\\317%\\233\\250\\346\\002g\\243;a\\227\\212m\\310\\233)I\\372\\025\\250w\\015\\330dX\\336\\302\\215\\316\\276\\304\\245\\024J\\370<|\\026\\025\\306\\350\\02387S\\006)\\22453\\271\\236i\\024\\035\\202\\215]I\\376g\\332r\\203\\231)\\245\\0265\\207e\\010"\\372\\010j\\212)\\344NG\\222E\\273\\324U\\222\\275qo\\370nm\\344*\\320\\215\\202\\212\\315\\2564~\\324\\033\\262}h\\374`\\251\\200FfU~\\240\\220[\\027B\\354l|3\\331r(\\305\\025\\227\\032$wB\\324\\003\\313\\223\\221dp\\213\\220^\\351\\035\\355;\\266\\000\\211\\371=\\234\\016_\\3306\\223\\271xO\\207;\\211}\\005\\375\\020l\\305\\215\\361\\377\\241R\\204\\022\\336'\\361\\001\\307Q-\\340\\343\\024\\245-e\\256\\313\\033\\232\\345\\332\\244\\330\\325+X\\001\\351\\375c\\234y\\011\\272\\0174\\214\\253\\235\\273\\372\\303\\235X\\355m\\300;\\250X\\335\\201t;r.\\310SA\\276\\027\\344R\\220\\347\\202\\274\\024\\344\\265 o\\005\\251N%*UW\\245\\354\\252\\324]\\225\\302\\253U\\371\\337o\\357\\357\\367/^\\032\\240i;:O?3}\\357\\373\\037\\237jJc\\325\\336\\030\\235`\\357\\377\\000	2038-01-18 19:14:07-08
talkbox:messages:individual:Retrievedfrom	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Nav-login-createaccount	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Nstab-main	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Talk	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:History_short	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Sidebar	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Mainpage-description	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Portal-url	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Portal	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Currentevents-url	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Currentevents	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Recentchanges-url	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Recentchanges	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Randompage-url	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Randompage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Helppage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Help	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Printableversion	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Permalink	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Site-atom-feed	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Vector-view-view	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Vector-view-edit	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Vector-view-history	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-ca-nstab-main	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-ca-nstab-main	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-ca-talk	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-ca-talk	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-ca-view	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-ca-view	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-ca-edit	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-ca-edit	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-ca-history	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-ca-history	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-pt-login	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-pt-login	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Tagline	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Jumpto	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Jumptonavigation	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Jumptosearch	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Personaltools	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Namespaces	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Variants	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Views	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Actions	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Search	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-search	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-search	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Searcharticle	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Tooltip-search-go	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Accesskey-search-go	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:24-08
talkbox:messages:individual:Searchbutton	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-search-fulltext	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-search-fulltext	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-p-logo	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-p-logo	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-p-navigation	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Navigation	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-mainpage-description	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-mainpage-description	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-portal	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-portal	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-currentevents	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-currentevents	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-recentchanges	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-recentchanges	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-randompage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-randompage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-n-help	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-n-help	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Toolbox	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-t-whatlinkshere	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-t-whatlinkshere	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Whatlinkshere	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-t-recentchangeslinked	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-t-recentchangeslinked	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Recentchangeslinked-toolbox	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-t-specialpages	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-t-specialpages	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Specialpages	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-t-print	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-t-print	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Tooltip-t-permalink	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:messages:individual:Accesskey-t-permalink	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:25-08
talkbox:resourceloader:filter:minify-js:f349fbe50bf30512b127ed6177ace7f7	\\265Y{o\\3336\\020\\377?\\237"\\023\\266\\326\\006\\034;r\\036n\\345\\031C\\227%X\\200t\\313\\026\\267\\005\\026\\007\\005-\\235d6\\224\\250\\221\\224\\3554\\315w\\337Q\\017[\\261h9n\\262<y\\344\\357\\216\\307\\343\\335\\361HK\\247\\327}\\323s\\254)\\021\\273T\\236\\3600&\\212\\216\\031\\014\\374$r\\025\\345Q\\243yO\\375FD\\2464 \\212\\2136\\211\\343\\217 $\\216\\264i\\344\\301\\374O\\277\\361\\372\\375\\325\\371\\351\\353\\346\\017\\203\\301\\236\\375\\352UL\\204\\2043\\306\\2112s\\311\\230QU\\360\\\\\\3337\\315\\237\\217\\233\\367\\002T"\\242]\\2370\\011\\375\\207\\234R"A\\242\\257U\\223\\212\\010\\365!.k\\025\\202G\\311'zK\\3338\\227\\007\\242- \\240R\\201h\\\\_[\\222*\\260Z\\226}\\320\\355\\036\\036\\364\\354\\243\\256\\325\\272\\276ie\\3357-\\034\\327\\362\\222\\330\\004\\311G4*\\221 \\014\\220\\264\\273\\030o\\363X+$\\015\\270X\\320))&\\274\\245\\221lO\\301EkT\\240K@\\310#>\\346\\374\\266\\006"i\\030\\263\\352\\342\\226\\000wB\\335:\\001!GkEu\\0028\\343A\\004c\\226\\324M\\023q4\\025\\013(\\251\\323U\\221\\310#\\3023B\\276\\374\\233\\200\\270\\253\\031j\\023y\\027\\271\\265\\200D\\361S\\306h,ie\\003\\012\\314\\204\\006\\023\\206\\277j\\010se\\225\\271\\335\\011\\270\\267c>\\277\\232P_\\235\\260uV+\\320\\214B\\244j\\021\\2341\\202\\252`\\370\\014\\311\\270\\352\\021\\217\\241k\\374`\\001\\340\\267\\324l\\376\\034\\341\\001#w\\340\\375\\212Qh\\202\\355\\0248\\230\\307z\\023P\\2513\\012\\254n+VLU\\003\\214\\031qa\\302\\231g\\210\\217\\022\\214q\\2270\\372\\265v\\0312\\011\\002\\220\\306\\0202\\356r\\231W\\221\\361\\271\\316Au\\362\\025.\\345\\012\\030\\244i\\243\\026\\210\\362k\\2751\\241\\270+\\242\\262\\230\\302\\217W\\2403\\352\\005PkD\\004\\205\\034S\\310\\272e/\\205\\254p\\305\\034\\363\\330\\206\\325 \\314\\023$\\010\\364\\276\\327L\\220/\\250\\252\\321&\\035<\\301\\343\\370\\305\\204\\267\\214j\\257L)@\\322\\257\\333Ni\\230 \\323bE\\270L]\\344\\177\\223\\316\\305\\313\\312\\336)\\365\\022\\027y=\\203?<A\\372\\212\\236:\\322\\\\\\256\\317\\227\\352\\361\\271\\245\\256\\013']\\231b\\234(\\365\\022\\252zx\\262\\306\\230\\262\\253\\031hU\\326*#%x\\274=su\\213U\\230\\303\\255\\316\\345K\\321k\\362\\355\\325X\\027<\\300A9&\\033\\327\\271\\331f\\222QC\\306~\\011\\007W\\206\\363nK\\375\\300\\3671\\002\\345\\223sl\\201\\0373\\303\\011h\\024j\\344\\346XQ\\256\\365\\365\\215\\354X\\024T\\212\\310'3\\353\\034\\272\\312\\274\\363dn<\\327\\031Vr\\337=\\273\\317\\253\\305\\300\\223\\231\\027\\225\\302wK\\210\\023&\\311\\372,\\263\\221_bi\\361\\014\\356\\011\\271}\\006\\267\\216\\243\\357\\346V\\202D\\322_\\037\\207U\\001\\351Ug\\206W\\035\\343\\211\\277\\030m'\\212\\262uR\\215\\305\\356jik(\\357V\\246 i\\035\\205\\373/\\361"S)\\227J@\\006\\001q\\357\\026@\\263\\030\\244\\315%R\\0059\\2450k\\013\\355q\\251\\356\\247\\233\\031e\\014.\\246z\\314\\240\\200\\306\\006\\214rsE^\\345\\220@\\204;\\331\\000f$\\012\\022\\022\\230k\\333\\212\\031\\310\\027\\262R\\245\\356\\230`\\272=\\246J\\256\\232\\253$eFTU\\267\\255%\\215\\2614\\257\\334v\\266\\226\\202\\245\\002^X/\\005]s/20D>\\255\\236\\275\\333\\316\\353Q\\337\\337FHk\\275\\003\\033\\345\\233\\334rk%!\\232\\020t:\\317\\305\\177A\\325\\367\\266\\226\\367\\344\\220\\373\\376uOT\\310|.\\302g\\353z~zF\\347/\\260\\346\\020\\024\\301B\\257\\362\\304\\260\\275\\240Y~\\317|\\266$\\235N\\266YXk\\247\\306\\316k\\247\\320\\351\\356\\005T\\345\\012O\\222g\\3131\\347\\303\\355\\305L\\210\\000\\363\\373C\\005\\213g\\3176\\360$\\326o\\200\\317\\326p\\271i\\353\\005\\025i\\177\\275\\204X\\347C\\323m\\357\\346\\346\\246\\331_>[f\\311\\020\\255\\253\\032\\367\\326,\\270\\300\\025\\\\\\271\\202\\306\\312r\\254\\216"L\\237\\326\\335\\316\\004X\\334\\321\\253k\\307\\023]-z0N\\002\\313I_J[\\3513\\033\\302\\027\\357\\212R\\3351\\210\\211\\232Te\\244/r\\010\\231\\005\\037\\004\\273D\\327\\300\\233\\036\\223\\210\\233(\\025\\217F\\316h\\324\\301\\237o\\232\\222K\\322/\\217Q\\341.\\211\\200\\307\\023\\020KZ\\001\\213@-\\351(*\\263\\316\\270`\\336\\014+\\365eWH(S\\034\\351o\\021\\314\\364\\224\\337\\3444*\\311\\247%aa\\270\\324)]\\303;\\241\\250\\313\\340\\322\\270\\324\\364aZ\\333\\253\\363\\243\\235\\2423\\273\\032\\301\\245\\361\\323\\271\\202H\\277Q#(\\267v1T3\\207\\216\\360Y\\360\\221\\010J"\\365H\\255|\\217P\\3314\\367\\352N\\264\\267~\\031F\\261 \\246X]e\\326w:\\035\\017\\246\\300x\\034b\\035\\206\\311\\312\\303\\352\\217d{%A\\\\\\024>\\347X\\020\\245\\275'<BUUu \\177d\\307\\016\\273m\\367\\332\\373i\\347i\\244\\275\\361\\335\\345\\271\\345\\350'\\365e\\327'A\\325\\343\\376+t\\036\\241_\\354\\207i\\221\\2129j\\230z\\262sm\\241(+U\\3757\\212[S3\\376\\236P\\\\k\\000C\\252\\364\\210\\245\\351\\335\\313\\254T\\232\\005g\\310C\\224\\002\\357\\017\\022\\202\\214\\211.\\313\\234{k\\257\\253\\221:6\\020\\265g#q\\225UcH\\356#\\245c\\011\\377\\015q\\017\\260\\251\\301\\037\\262\\307\\371\\203\\274\\271\\253\\262\\241\\303\\034\\205;\\265\\233\\357\\357\\321JW\\001=\\306\\3763\\232\\306i/o\\026Co\\012m>eU\\367\\3332]\\200l\\255\\330\\020B,\\227\\263\\213\\214]\\242\\027 \\255\\353\\357\\231"\\366A\\336^\\014jmO\\020\\035\\344'\\373Q\\211\\316@\\017\\332h\\013[\\235{\\251\\265\\322$b9{]\\214\\370\\334L\\316\\236\\215\\033\\340\\354\\267\\254\\224\\315\\261\\363\\317)\\234n\\326\\370\\234u\\037d\\343h\\212\\317\\251u\\234\\303\\307\\0359\\354\\250e\\371\\3322\\316q\\326\\310\\273{\\245\\212\\302r\\336\\224\\250\\034\\360\\026\\245\\025\\006q\\354\\375%\\225\\217\\333\\250V6\\257\\335\\315Z\\305\\000*\\346\\026\\206p\\354\\303%U\\000P%\\032\\246\\316~\\234\\267\\012\\245R\\023]\\241+k3\\241\\001\\325\\343\\355G\\237\\303\\025,\\202[\\207\\240\\025G\\272\\012\\015\\250.#\\277\\304A\\372\\027\\202\\334\\277\\177\\215\\036\\311\\311\\002|\\301\\377Nb\\306\\226\\346\\304\\003\\313I\\264\\244\\277A\\362D\\270p\\221~@\\365\\236\\314\\377\\322\\327\\253\\013\\210\\002\\315\\274g?4\\373\\017}\\3527\\312\\037\\2745\\232\\315{\\217\\273I\\232\\011f:@\\033\\326h~\\340\\3124\\017\\355J\\341\\016F\\353\\216\\207_\\322\\303a\\220\\346\\235\\321\\274{L\\302\\270\\257\\017\\254\\001D\\005\\031r/a \\007\\331M\\357\\247\\336\\311b\\007\\013\\004\\217\\330\\335 \\233M\\026}\\372\\354\\030d\\207L\\3215\\3152\\315\\240\\273o\\343W\\2677\\354\\036\\340\\367\\376?#\\255-h\\215;\\231\\020MZ\\270P\\017\\364\\253\\342\\243\\017\\031\\373}\\253\\377\\037	2038-01-18 19:14:07-08
talkbox:resourceloader:filter:minify-css:87f3bfc474324b2633fa334b79d8dba8	\\355\\275\\011\\227\\242J\\267(\\370W\\362}\\325g\\255\\367\\256\\231%\\2428T\\255{_3\\013\\010\\012\\210\\003\\275\\272\\357Bf\\031e\\020\\264V\\375\\367\\216@\\315\\324\\324\\254\\252s\\276s\\276{\\273\\3271++\\005\\202\\035\\021{\\336;\\246\\374\\313\\000\\351\\365\\372_\\376\\361\\177F\\266\\345\\033Oi\\346\\307\\305\\267\\247'\\343s^\\224\\233g\\343slW\\337\\314$L\\262/\\2376\\006\\002>_\\013\\273.^,\\333L2\\243\\360\\223\\370K\\234\\304\\366\\367OEb~\\333$\\231eg_:i\\375\\224'\\241o=}2\\232\\317\\327\\215a\\006n\\226\\224\\261\\365r\\206\\345\\214\\340\\317\\327\\324\\260,?v\\277`i\\375\\3753\\000\\341\\307\\226\\015\\352\\217\\214\\314\\365\\343\\227\\320v\\212/\\250\\0355\\217B?\\266/\\0176IQ$\\321\\027\\004\\274\\365d\\371\\373\\317N\\230\\030E\\346\\273^\\361\\255\\371\\372\\245\\371\\376\\325\\014m#;\\177O\\223\\334o\\232\\233\\331!h\\367\\336\\376z\\202\\365\\005\\371\\214\\331\\321\\023\\362\\204|\\036\\202\\277\\235\\317=P\\337-\\314\\247\\364\\233\\223\\304\\305K^\\034B\\373\\213_\\030\\241o\\276\\025\\201\\215<\\327\\012\\277\\236+m\\276\\376\\244\\316\\246\\256s\\275\\310-\\300\\017\\2534\\001z\\354\\354[C\\003p\\323\\215\\277\\234\\356\\234\\360Pxe\\264\\271\\220\\001\\322\\345k\\345[\\205\\367\\305(\\213\\344\\\\\\367K\\221\\244\\247\\372\\277\\276C&l\\307=\\245\\212\\314\\210\\363\\324\\310@-\\337_\\253\\360\\343\\0304\\342\\236\\334f\\363y\\245j\\027<\\371\\037~\\224&Ya\\304\\305=\\354\\245\\347\\027\\366\\327SG\\375\\243\\375e\\324\\373\\355\\353]\\317\\276&{;\\003\\210\\251\\276x\\276\\005\\270\\343\\273WD\\341\\323\\271\\035\\221\\341\\332\\037\\266\\343\\272\\244i\\244\\220\\0227\\270\\271\\252\\252!\\027\\344\\260\\027\\317\\206$\\377\\322\\320\\346\\243\\216\\334\\264\\270\\301\\012hG\\354;\\207o\\226\\237\\247\\241q8\\311D\\203\\256\\037s\\345Ox\\360G\\314\\365\\003V\\362#\\367\\324\\353So\\037 \\310j>\\337\\237\\012c\\023\\332\\237\\263\\023\\036\\257\\033y\\342\\233N\\3721\\023\\237\\244\\263s\\307G\\360\\316={n\\022\\353\\360\\355\\215\\001\\316\\244\\177:\\361\\001\\021\\202\\007\\257\\035z\\305:\\362\\375s\\2344\\012\\351\\031 \\343\\323\\266\\214R\\300\\275/\\261\\261\\177n\\220\\223\\244\\315}\\000\\243\\214\\342\\027\\200\\361g\\370=I\\275$~\\376\\014\\264Y\\221\\333&l\\3713T\\037E\\342\\272\\241\\335|=\\361Q\\363\\256\\363\\222&\\225\\235\\331\\326\\346\\340\\233\\311\\371\\226\\231\\244\\207\\006\\013\\360V\\350\\177\\332\\373ve\\202V\\027\\360\\302\\330$e\\363\\005\\220\\332\\014\\015?\\2623x\\005\\232\\2717\\314\\303\\363''I@\\177_\\000\\027\\230v\\376\\374)\\252^N\\325\\275\\230@\\262\\3758\\310\\277=\\3350I\\031~\\013\\375\\374,\\351/\\305!\\265\\277\\344\\273\\022\\310\\333w\\320\\031\\200:\\240\\015\\257\\320\\326\\360\\355\\025\\017?\\375\\217\\2477\\266|\\305\\333\\315\\335\\013Z\\257o~?7\\363\\012\\364\\323\\227\\252!IC\\221\\247/\\233\\206$\\247\\232\\032\\225\\361\\306<\\315\\243\\357^\\347\\331C\\237\\275\\356\\263\\327{\\366\\260g\\257\\177RX\\325I|6Ih}O\\237?[\\211YF\\240\\017\\224\\235\\233\\231\\177\\022\\301s\\203:\\015\\307_\\267\\364V\\376.z\\377d\\022\\200B|\\355\\310\\351\\347\\272;iv\\245\\005\\212'\\313\\310=\\373\\334\\320\\257M\\267^\\200\\0123\\355/\\240\\334\\225\\360\\016\\001w\\277*\\227FE^0\\330\\264\\355J_]\\343\\346\\204\\232\\357'\\311\\201\\244\\003/<\\337\\\\=\\025\\326uk\\256\\260vA(\\000\\024\\032in\\177\\271|\\371n|\\273\\022\\205\\307J\\363L\\360\\207\\364~C\\205\\361\\005r\\331\\263\\361e\\357\\003\\271\\265\\255\\213\\361\\306\\320\\233\\016]\\251\\365;\\203\\016\\236\\333\\031$\\306+\\013\\002w\\000\\224\\261\\263\\330\\010?\\303\\322_\\014\\007\\\\=?z\\014\\361\\030\\003\\325\\003:\\337\\024\\372\\366t.\\364\\345\\037O\\377\\363\\037OFQd\\377\\323\\313l\\347\\177=\\375\\003\\374\\373\\376\\311\\015\\223\\215\\021.3#MA\\341\\263\\332A\\220\\337\\256;\\032\\001\\355rzr\\323\\325G\\002rO\\250\\213~\\270\\024~\\223\\207\\033H\\327e\\236^!_1\\304\\327G/>\\031\\317o}?yK\\317'\\327\\351\\333U\\033n\\270\\374\\221\\373t\\303\\314?\\205\\351\\307\\236\\235\\371\\305\\017\\241>(\\003\\315\\302\\215\\375\\003\\254\\017T\\234\\021\\2365u\\004\\364Th\\177\\177\\002l\\021C*C\\353y\\022j\\307\\210\\374\\360\\360%\\007\\020\\235\\357\\237 [I\\011x\\323\\2765wO\\241\\377\\3315\\302\\320\\316\\016\\233\\244\\376\\366\\016:\\320!\\037\\273\\201\\347V\\235$\\005\\005\\232\\346D\\306\\013\\370\\227(9\\276\\370q\\243\\037\\000\\350\\327\\373\\227[a\\002\\350\\\\\\206\\227\\332\\237o\\033rL\\240U\\372\\372o\\267o]\\225\\277\\260\\004\\250\\370U\\246\\340\\367\\313\\013'\\370o@/\\276\\304{\\205\\367\\300w\\271\\001\\361\\265\\002\\335|\\251\\000\\253\\177\\331d\\266\\021\\274\\300\\353\\3577\\215\\275\\362\\342\\356\\201=\\364s\\276\\2765\\276q\\031\\316\\260\\340\\333\\337\\336yN\\357<\\255\\253\\256>\\365@w\\037\\266\\356\\354!X\\276\\343\\334\\211\\331\\367\\302j\\036\\274\\000f\\000\\236\\312\\365\\363ON\\363y-\\021\\377\\264\\004h\\214m5>\\376u!\\323t\\034\\320\\307\\267\\206\\347Q\\323\\277{\\2169k\\34534\\313\\016\\355\\342\\001<X%\\210G>\\204g\\001\\037\\306~\\004\\260Q\\010\\365\\215\\252\\371d7\\237{`\\337\\233WL\\317\\210\\201Sub\\364\\334\\017\\001-\\276>\\346\\230\\207\\252\\367\\214\\370\\312\\017\\374\\346\\333\\265\\331\\274\\374"\\327,\\001c\\255\\023_\\334\\033\\256\\017\\315\\316\\033\\374\\247\\302{\\276\\276\\262\\276=\\206\\375jtN\\006\\372\\372\\375G,\\373\\276%wN\\302\\025\\204\\217\\344\\352;\\320~@\\205y\\266\\001\\235\\331\\213\\032\\006\\315B>wA\\033\\236\\336@<\\237d\\347\\031j\\272\\024\\270\\264/'N\\366\\343\\334\\267\\354/\\306>\\361\\255\\357\\267^\\313\\2637\\270.\\331\\230\\254s\\301\\024Z\\243\\244\\312\\277t\\277&Y\\012\\250\\011\\276}\\377~\\216\\223\\201;c\\3331\\014\\2247\\233\\354\\3310\\263$>D\\300\\353\\254\\201\\270\\373\\2270\\343\\325%\\006m=s\\326\\311\\0150\\313\\014\\364\\350\\213g\\207)h>\\360\\021\\323\\260\\314\\201\\225+s\\340\\217\\346\\027\\223\\215 \\375\\036\\202\\274/\\020\\333\\356\\245\\300p\\003\\003\\362\\273\\002e\\030^J\\000\\272}\\177z\\372\\014\\330\\022v2\\007\\216\\256\\237\\001\\247\\370\\371\\363\\345\\033\\300\\015\\364Lm7\\001z\\363se\\024\\246\\007\\275\\230\\346\\361\\203\\020\\364d\\034\\314$\\202N\\335\\203\\347\\247\\307\\015\\347\\003\\227\\372\\333\\225\\302\\301~\\003\\355\\004\\014\\2627\\277\\235j\\206\\354\\036\\026\\331\\3272\\006n\\266\\005\\010\\340[\\376\\027\\0338\\016\\326)~\\261\\357L\\310\\331@\\375\\304>==}\\202\\3740\\313l\\350\\267\\177\\006\\317\\223\\364\\333]\\210\\362\\375\\351\\023\\214\\020\\234$\\213\\236?\\025I\\022n\\014\\340\\317T\\351\\034\\2600\\320\\303\\235o\\247H\\013\\274\\340A\\265\\012\\375\\370m\\376\\022\\331y\\016#\\245+Y\\304~\\273\\022\\011\\030\\212\\241\\237\\301\\255\\033\\365\\324H\\020\\010\\267\\036\\331?\\023\\376\\000\\314\\\\\\205+7q\\330u\\254\\005\\223$O\\036\\372\\311\\361C\\333\\003D\\002$\\273n\\346Ia\\\\=\\204"\\375\\340\\246\\365\\3004?|\\371\\333\\273\\000\\371Q!\\013\\362^\\023>6R\\004\\237Az?\\252\\327{\\\\\\364\\333\\265\\203\\036'\\320\\000=\\256\\350\\352\\362%\\007\\372\\335\\204\\336\\355\\235\\256\\000^\\310\\211I\\317&\\340\\271\\271\\270\\274w\\276\\371\\355\\275\\336m\\374\\210\\302\\003\\264q\\275\\257\\027\\351\\032\\016\\277>\\220\\000\\020\\223\\026/\\251Qd@\\207\\002H\\017h\\352\\030\\337?\\227\\361[\\221;\\255\\177*\\010d\\254\\261\\330\\347\\202\\300k\\277\\222\\227\\001v\\223\\012i\\230\\341\\373\\031\\335\\241\\261\\261\\303owO\\317\\264\\210\\323\\262\\270\\247\\\\\\363,/7\\221\\377\\321\\303\\023\\324\\007\\254\\361\\031DM\\316\\2317oZpr\\311Q\\344\\267wE\\032s\\365\\346\\311\\337V\\376!\\265a\\244\\014$\\032J\\344K\\23445<\\250\\355\\306\\373.\\262\\233\\267^\\333~\\377\\362\\273._\\003i\\020\\006$_-# l\\207s=C\\244\\321W\\327\\251\\243\\367h{M\\372\\\\\\311\\353I\\027\\277E\\374\\371\\371\\373\\255\\247\\374\\371\\222\\013\\000\\340\\302G\\005\\236\\322\\206\\224\\351\\006\\372\\035{;\\366\\355\\330\\264\\2337\\236\\233'i\\006\\242w\\240\\274\\241\\326\\000v+O\\342\\363\\003(#'\\036\\277\\177\\366\\321}\\240(\\301\\243\\353\\373\\327z\\033\\371\\355\\353m\\377r\\240pL\\020\\301\\345eX\\344\\337\\276\\337^\\277\\206\\351'\\215\\2054Y\\264\\253\\304\\343\\203tQ\\343G@9\\270\\006tk9\\316\\331\\250\\356\\020z\\034\\220\\225\\232\\222/\\2276\\334\\325\\370\\240\\020P\\013\\227`\\356:Q\\365\\226z9\\205DW\\251\\230FS\\235\\351\\365\\010\\334\\223q\\325\\310\\0162\\374\\355\\276\\330\\213e\\024\\227\\300\\336\\205\\376\\302\\265\\007>\\270y\\0012\\360\\331\\301y\\240Q\\272\\360\\347=\\036\\357\\302\\201\\223\\223\\371\\030\\352\\323\\033\\206\\233$S~\\235U\\274 \\346\\214A\\024\\273E\\341\\017\\240<\\225\\341\\243\\200\\372aj\\342=\\262\\257\\205\\360\\227k\\203t\\274j\\371\\243\\234\\341\\357\\000\\005hx\\033\\241\\335\\230\\362\\337\\005\\3523\\360\\351\\262&\\027r\\361\\275\\272\\315\\347\\342\\353Y\\266c\\000\\226\\370\\2030\\277x0\\226\\2733[\\357\\271\\363\\035\\3043\\263\\002\\233\\340$7^\\305M7_\\311\\337<\\003\\367\\006?\\356\\3735\\324\\277\\236\\376\\357j{\\243\\377m\\002\\375\\212\\001\\034\\337\\016\\255\\334.>\\275\\302L\\032\\005\\236\\177{_\\370\\302\\360\\260\\303\\017Z\\177\\203\\220G\\317_GN>x\\376:\\324r\\223\\320\\273\\312\\300\\374,!\\362^\\266\\357\\341\\300:\\036\\345\\306>D\\302Sh\\273vl\\335\\332\\233\\217K{\\275\\327\\034\\030\\362\\206\\3547\\011\\374\\301\\253g\\267\\371\\302\\326M\\376\\035\\346c\\256\\315\\311\\357~\\373\\351d\\317\\317\\252\\360B\\240Fc\\375~X'_\\351\\326|\\374\\004\\324\\311\\271\\271\\323@\\347\\226t\\177\\376.\\364\\277o\\371\\253\\363\\263\\266\\177\\006\\277>\\264\\014o\\316\\376\\327\\373\\000\\363\\234\\022\\242\\232\\317=\\013\\336\\215\\366\\301~\\026\\326\\025^@HW~\\273\\221\\214>x\\355*]\\216\\375\\366\\375\\026\\223>\\214\\361a\\260\\365h\\350h\\370j\\242\\3162\\177\\316M\\274\\246" \\273\\343\\315\\347r\\3632\\350T_\\233:\\324\\256?\\252\\266Q\\0067!\\346\\347\\007\\245^\\242$\\273\\035\\334\\272qo>\\002\\376\\362\\300\\357;g5\\356\\034\\372_h\\004p\\331\\266\\300e\\373v\\343\\001\\334\\015A\\276\\267\\304\\017\\264s\\347Ze\\277R\\363\\272\\344\\211\\346M\\271{\\005c\\233\\360\\347\\361\\310\\316'\\242\\371\\234"\\354S\\017\\214\\2608\\245\\356n\\273\\370f\\257,\\337:$ed\\033\\361\\265;\\204\\202\\276\\335\\2147Cn8\\217\\366}2\\021\\344!\\200';\\272\\217\\347\\316\\245"\\230\\231x\\020\\355\\335p\\360\\233\\216\\271\\017\\216\\240\\354]\\025m\\206\\375\\356"\\025h{>5\\217N\\305\\256\\303\\353\\306\\263/s;k\\000\\346/@\\201\\302\\327_\\007X@\\270\\370\\026\\311\\\\\\225\\203\\350O\\363\\247\\177\\003M}\\376\\361s\\357\\275bhd\\364\\351s\\222\\203\\340\\311u\\355\\374*\\243\\333\\014W]\\256^\\352K\\206\\367u\\260\\326\\330\\000\\222\\226\\205\\375\\265A?\\220\\250\\023G\\3014\\357\\311X\\200ow\\314qN\\026\\336\\015\\323\\373\\261\\225T\\177\\\\\\230a\\356\\336\\262\\353/\\243\\321;A9\\241\\343\\255{\\257\\036\\375\\255\\367\\177\\366\\240\\322\\304\\277N\\203#\\037f5\\277^Q\\364\\036\\372\\363\\375\\255\\027/|\\020\\227\\376^\\374\\\\\\015\\370|\\275~\\000SJ\\327\\311\\366\\007m\\002\\015x\\334,\\300\\354\\233\\300/\\036\\304\\004=\\022\\033\\341\\375\\257W\\015{\\014\\367\\333\\323\\335\\273c\\300]\\341i*\\302\\3555l\\351\\015\\224\\223@}\\273\\237\\002p\\036\\373\\257\\257\\010\\332\\307~{\\360.\\360V\\235o\\277\\300\\2257p\\276\\302\\261\\313\\215\\037\\372\\305\\3412\\351\\003&1\\001\\313_2\\217\\227\\230\\3128|\\377\\004\\263I\\2274\\321k\\242\\007\\012\\330\\307\\241\\350\\253\\337\\000\\344\\353\\346\\375F\\363E~\\234d\\367\\272\\346\\246 \\260<w>\\332\\211\\012\\357\\212}~MU\\375\\212\\263w\\036\\271>\\345m\\341\\310\\037\\004\\366|j\\321\\363g\\240\\207\\036\\250\\300F\\237\\2300\\313\\371@=^\\024\\016\\364\\275\\033Ms\\326:g_${\\230\\360y_8\\263\\367I\\360\\223\\254\\331%9\\225\\027\\340Y\\016@\\302D4\\034\\006\\316\\357\\2251\\360*\\233\\242\\251m\\372\\306)3\\335T\\367\\000E\\226\\011\\177n\\206\\345\\316^(\\314\\375?!o\\277\\337\\337\\201\\004\\022Pd\\376\\343$\\341\\247\\33432\\333:\\305\\370/V\\231>\\337\\3361\\223\\330\\011}\\363Q\\206\\373\\015\\245vd\\370!\\344\\263\\227k;2\\032\\376vv\\253\\336\\236\\3476\\034\\326y~\\177;\\003mM\\375\\327D\\372c\\302]R\\367\\247J\\232\\350\\350\\371\\243\\207\\246W\\306\\301}\\346\\355\\265\\024@\\214g4\\272\\270\\031\\030\\373 \\203\\370Z\\034N\\264I\\337\\337\\271{\\353\\301`\\332}\\266\\375G\\335\\371\\200\\013\\237^M6L.\\372u\\323\\356\\206\\217O\\357>?|\\016Z\\370\\0019\\336\\227\\202U\\177\\373\\205\\266\\337\\245a\\337\\217\\2337\\215m&\\201U/\\225\\221\\305\\320\\200W~\\341\\275\\204\\211k\\327\\246\\235\\245o\\363\\010\\272o\\276\\355\\271\\006x\\347\\254\\000\\3207G\\014e\\372\\014N|\\275\\035\\204\\370A\\005\\227\\310\\370\\306\\261=k\\263K\\206\\017\\216-\\206/\\315\\354\\020 \\031I\\354>z\\364\\016\\304#\\010\\347\\351SM\\360\\364\\370\\331\\267{\\375}b\\255s\\252\\321\\364l3\\000n\\332\\363iL\\340\\335\\335\\367^\\0204\\017\\017\\346;\\032\\237\\035\\273\\031\\341\\015\\256\\007e\\313,\\374\\2370\\353\\366\\245\\021\\344v\\032\\273\\300^\\347v\\277\\367\\354/\\210\\251R!\\002\\353&\\320M\\221T\\315\\2435\\027~\\255\\340\\177"\\211\\257\\301\\037bi-\\2161\\274AD\\374DAd\\274]Qm|\\326r\\367\\206=o\\356w\\025~\\256ic\\024\\017\\246\\3446P'\\243z\\355\\301\\007\\346\\210WhF\\023xz\\204L\\230L\\353\\320ky6>:\\216\\335\\012\\333\\276\\272\\010V\\363H\\362q\\211\\320\\006>\\215M'\\331F]\\254\\005\\316?`V\\214+D\\227\\251h\\002\\263\\246SO\\026\\312\\302\\343iz\\254\\344\\332\\212H\\222|\\212\\204\\202@\\257\\025\\003\\035M\\226r\\320U\\261\\011\\326\\315\\220\\331b\\337\\242\\206\\323\\031\\037&a\\226e\\035=\\342\\006L\\207`\\350\\355\\216X\\321$\\313\\343[\\225 \\215\\211e\\231\\203\\022\\023\\243\\315`\\207i\\030\\202\\014\\262\\245\\207\\321\\243l\\255\\264\\353|N\\020+b).h7\\334))\\353\\263\\236Icl?\\260\\016\\245[\\233l\\316\\036\\024\\213\\357`zE\\242#\\216\\301\\260\\255D/\\213\\241\\3202\\230\\251\\350\\231-\\213\\034\\350}\\225\\233o\\311\\201k\\240b\\300\\015\\315t\\334\\353P\\2367Pf\\006\\212\\260E\\257Ht\\303lq;\\217\\021\\347)\\213x\\213b\\250\\330\\005\\357\\216\\372\\003\\325\\230\\357\\331I\\314J\\202\\216\\320\\20535\\211\\316\\014\\333\\036v\\213-\\251\\004\\334\\321I\\343m!\\256W\\331\\034e2\\322q\\372<\\000\\242\\324m7&W\\205>vW\\0323\\226U\\326m\\227=v\\343\\364\\346h\\270\\016\\366s\\203aM{\\350p\\256=[##\\247Zi\\303\\231\\333\\315\\003\\224gJl\\337\\013\\345V\\217\\251g\\256\\335\\332beWn\\355\\207\\363}F\\010\\316F\\007\\225\\317{\\223\\035\\357\\215\\264\\375\\340\\300L\\242LD\\375\\226;\\313{[\\345\\260\\343\\014\\3558 \\321V\\255\\353S\\032\\357\\231\\274\\241\\272\\006\\356\\355\\274\\015\\331\\241\\004D\\352\\012#\\251\\314\\367G|L\\364\\330\\211\\323\\032\\313\\004O\\344>I\\015\\370~{t\\\\q\\350b\\2638\\354\\333\\233\\276j\\355;v?\\316\\346p\\312\\0071\\250\\026\\233\\303vUt2\\323I\\020&\\313{Z\\260\\333\\027\\032?\\026\\211\\355aA\\343\\246\\272e|\\231\\257\\224\\275\\323e\\272\\355\\251\\263\\036\\267-\\212Yfd\\222\\030\\\\\\343s\\253\\332b\\252\\010\\030\\271\\346\\270\\177\\377_O'\\011yj\\006:\\342\\004\\210Wj\\0337\\023\\311\\240\\220xE\\221~i\\267-{o\\207I\\012\\235* \\212V\\376\\3314\\332\\300\\320A9D\\333p|\\272\\235\\007~\\234\\267\\241\\343\\225\\304\\355F\\252\\3626\\224\\274\\027\\037X\\311\\317@\\300\\3767\\212t:/\\340\\037:\\230\\243\\335/\\360\\037\\242\\177\\320\\212\\377\\341\\333\\2671n\\247\\017\\0075?7\\243\\346\\315\\000\\307\\223\\361~\\276\\343O\\247\\274\\375\\342T\\211\\353i w\\216\\327\\365\\354\\211\\217\\302\\212\\353Ye\\177\\356\\304\\211\\233\\266\\241\\360\\347\\201\\306\\373\\225\\231\\022gT\\\\\\232l\\001\\333z\\271h0s;\\312\\3649/M\\323\\316\\363\\017\\206(B\\200FX/\\010U\\201?\\374:h\\371Q\\011\\250\\320/\\020\\233<\\337\\273bwf\\356\\025%\\247)\\3140\\331t\\227W;[I\\230\\336x\\235\\025\\201\\274U\\370\\355&\\002\\205\\215{4\\036\\013\\021\\372\\375\\272i7o\\235\\272\\375\\300\\365t\\254\\267\\212\\236<\\364\\272s\\340\\362:\\335q\\311\\223]\\347\\204n\\247\\233\\275\\315\\036\\274L\\365\\276N\\004C\\0118\\315W\\210\\223\\3422g\\010\\346I\\036\\270R\\327%\\237\\322\\223;v\\232#\\013\\323\\217o\\323\\302OS\\301?\\003S\\\\\\032!\\011\\035\\211\\353l\\006\\360\\210\\376\\263\\310@\\237a\\277\\363o\\367\\363\\0256\\340\\3438\\217\\022H\\340\\003\\036\\334\\262\\363\\323\\3479\\344\\257\\031\\364\\273\\277\\275M\\327\\034"\\277\\375`\\356\\321\\333+\\377\\011\\0342 \\370\\217\\2077\\336\\212=_}\\207\\351\\224\\233K\\357\\343\\345'oZ\\343\\224\\026{\\272|\\371\\376\\036\\302\\007\\275\\275-\\367x\\320\\277\\231\\315vS.;\\215\\332<~\\341\\002\\270\\321\\250\\320\\253m:tu\\345=\\032*\\277*p\\215>\\000\\363?O\\223\\313\\177\\245\\242\\367o\\372\\221\\373\\237\\326\\325\\004\\355\\333z3\\340\\030\\3374\\323\\273~\\037N\\314zP)\\\\~\\001*}\\372tr\\371\\317\\363f\\362\\223\\366\\372|u\\347\\305,A\\244\\034\\371\\215\\256\\262>\\033\\321\\177\\236\\007\\312\\036\\341\\030N\\006\\354}\\177\\010\\023\\350\\271\\307P_i\\360\\023\\330\\206\\343\\214\\220\\017`7\\357\\032f\\001\\004\\351\\021\\202Q\\340\\342\\241\\177\\254Y\\255\\217K\\374\\254\\332M\\307q6\\235\\357\\300\\363o&\\004\\301\\365W\\2772e\\364w\\254\\310\\272\\315\\326=\\032@\\270\\231\\236\\204\\274\\313\\256|\\277\\264\\013F&\\357\\264\\341\\373%\\017\\315h\\330\\255\\337\\337\\250\\225K\\334\\370\\237\\221]\\030\\315h\\372[\\233NI\\345\\333\\034\\317\\007\\003\\035\\227\\011\\004\\010\\\\1v\\007\\363csz_\\264\\270MB\\237\\305\\343A9\\353m\\334\\354\\363u\\004\\374\\326\\223\\233\\201\\300\\217\\224\\344#\\310\\317\\017\\233\\365;\\210\\377n\\224\\241\\363h\\224\\341Q\\223\\037\\253\\310\\023\\343<\\306\\301\\3073\\336\\236\\376e\\323\\305?\\236\\031\\376h\\036\\371\\327\\277\\247\\213\\377\\023\\323\\305\\337\\222c\\261g\\304&\\210\\0222\\363\\243\\365K\\257\\011|hiNC\\367\\247,\\301\\365\\273\\017\\322\\362o\\343\\321\\017x\\346z>(\\010X\\222\\346\\315\\247\\223r\\006q\\360y\\246+\\034\\215\\213\\322\\342\\275Vz\\267\\260\\355\\203\\267\\036\\016\\033c\\367\\311\\345\\313,\\212\\314\\216\\000f_g\\331\\276\\352\\205\\341\\355\\020\\314i\\276\\321\\037\\311_\\364\\340\\177\\323S\\376\\002wT\\262\\253\\300/\\344\\212\\340\\226+\\021|\\313a\\336bBW4\\036\\245\\025,$\\200H\\231\\222;\\204l\\260#d\\323\\225\\222M\\027wUM\\242\\2701q\\330\\240z\\272a5\\034\\037o\\215x!\\305\\013f\\2262\\333n\\267\\273WH\\265\\347\\343!]\\3545O\\3438\\206'\\375\\036\\256\\005\\352z\\307\\311\\201\\254&\\256\\227X\\301B3iE\\3214\\232\\035\\372\\256\\217O\\247\\333\\204\\024\\231\\005\\235S\\\\"\\240\\270\\023p\\2060u\\373S\\316\\317\\263AoUn\\215\\2211\\034\\2656R;[\\255f\\245\\235\\0171\\364x\\254\\034\\234\\304\\017K\\225\\222\\024i\\215\\213;\\215\\263i\\233\\244\\352\\341\\234\\355\\331r)s\\264\\300\\217q\\234\\306\\375\\243N2\\307\\266*\\022\\370\\314k\\315\\250*\\343r|\\274wq\\302\\226\\304\\011\\211S\\370\\\\\\337\\343"q\\030\\267\\253\\366NNC\\023_\\223 \\246&\\220`\\356MH\\016\\327p\\232\\350o\\003!\\002\\177Y\\360\\314\\212H}\\216\\013\\0004KM\\326\\350d\\2133x\\201\\263x\\354\\2646s\\234#\\255\\026\\037\\016p\\231\\330\\204$\\275\\300\\015R\\001\\015\\235\\353k\\017\\224w\\007\\270p\\234-\\222\\224\\301\\031\\267\\302\\011%R\\2072\\206Kn\\201S\\004\\277@u\\016\\237\\220]\\\\\\244\\2464^\\036p\\334\\025\\301}\\305\\347\\264\\024\\307\\225\\001\\250\\217\\343\\016R\\017\\347T\\035\\274\\313\\016Cs8T\\313\\222\\236\\232;\\034'z\\321\\206\\033\\226\\252\\214)kfC\\222\\235\\232\\350X\\253\\211\\327K\\216A\\260\\022j\\031]\\313\\274\\027\\005xY\\305\\221\\316\\316\\005B\\302\\333\\356pX\\001j\\223\\012\\243\\214]\\267=\\033\\331bo\\232\\345\\203\\251\\224\\364Q*\\034\\026\\375l\\310\\266\\017\\274\\277.g-\\314le&\\0159\\211A\\234b\\334\\232\\220\\255#\\233\\340\\003"!\\212\\366\\216\\013\\007\\256\\222\\254\\334\\322\\265\\034{\\242g\\334L\\236hx2\\215\\215E[\\252Z\\343\\336pF/\\275`\\022\\353\\250\\275\\0120\\311\\023j\\232\\337\\254\\315t\\3458X\\\\\\205m|\\321\\356\\344\\255Uo\\330\\2369\\235\\336d\\340\\363\\034}X\\255\\23111\\333\\272U~D\\346\\202f\\0361\\216\\367\\330\\211\\211%\\243q{bN\\332\\355\\312B\\016\\023Z]\\012\\330\\222L\\264^\\207V\\3155F\\003\\005\\177\\004L\\341\\373\\232\\240\\012\\246\\026"\\373Q\\320+\\206y\\253\\022[\\335\\243\\206\\347l\\322\\302W\\24521<k]\\315P\\365`\\312\\313\\361\\034\\357\\355M\\034\\237\\011\\203\\315p\\254\\011\\270K\\271\\254O\\365\\314Q\\267\\335\\032\\266\\333\\232\\355\\3622\\211\\353A\\244\\2322\\216\\257\\0029\\230\\204s!?\\266\\307$@\\213"\\220\\204\\220\\021\\004\\333\\236\\023,y\\304\\011\\357H\\020\\326\\221 \\333\\265+%\\012\\311\\213sR\\366\\010\\222\\214T|<\\346]\\3018\\220\\262\\357\\263\\307\\015n\\001\\356\\332wh\\334\\222DB18cn\\342\\275\\262\\012\\227=j\\333\\251\\250v\\352\\221\\374\\200\\020&\\007\\202\\224\\025\\342\\200\\273\\363\\265:6|\\234\\361\\375\\320\\335n]w\\025\\255W=\\316d8\\002\\224\\342I\\212\\367\\011E\\341\\202R\\2214\\267\\326\\222T\\343\\230\\0057v\\270\\221\\351r\\230\\327\\251\\3312\\245\\007\\200\\301\\016\\356\\376\\300\\356i\\263\\0169\\366\\240\\315\\273\\0325YP\\245\\341v\\331Da\\023w/\\353c\\271\\216\\222\\3412\\341\\367\\262\\231\\311\\306l]\\241\\211\\355\\310;\\324\\235\\241\\311\\260%\\017\\315\\252\\232\\272k\\3428\\2437\\024^\\326\\271D\\346s7'ui{\\030\\320~\\206\\037\\262\\332\\333U\\213]E\\225\\275\\270\\263\\036\\266j\\253\\222UW[\\341\\344|M[\\010\\347\\256\\025\\214P\\031O\\\\\\322\\203\\265*\\270\\356\\230\\224\\021\\332Jx\\251\\012(\\217\\031\\223\\374A\\230\\357\\350\\022\\341\\263Di\\231\\362z\\275\\345j\\257\\343q\\023r\\266\\244\\223\\341|R\\023\\003\\237\\236\\321\\322AV}M<\\360\\203H\\306\\203\\250N\\231\\271J\\027<\\213D\\230\\312\\265\\202|\\247\\347\\210J$\\333`\\030\\033:[\\036\\210c\\244\\001\\005\\220\\035\\270U\\020\\333s\\012\\243f\\001\\333\\222\\275a\\230\\013\\361\\222\\307Mc\\336\\323Z\\\\\\242\\345\\351N\\365\\342\\220\\236j\\010&\\353aD\\361\\304\\302\\230\\032Z\\201&\\311B\\006\\372gd\\000\\204xE(\\354\\265\\265\\235\\320G\\245\\023mc\\311\\255u^\\355/\\201\\321Y\\315\\331\\310]\\0313+\\315Z\\036Rzc+T\\260i8"VH\\276O\\225\\226\\277\\352\\3433\\304\\252*\\311\\363\\226T\\335\\363b\\201\\2106,n\\256\\365:\\354\\262Bk=\\027\\326:\\322\\313\\365\\272#W\\322q\\234ES[\\247\\260p\\277X\\270\\273\\302O\\207\\214>\\026\\310t!\\204\\252\\261`\\017\\311~!D\\273t\\227\\331;\\267X\\014;\\253\\311\\202k\\245\\253P\\032e\\201\\276\\020;\\263\\355N\\216\\265pW,viG\\356w\\304\\215\\206\\332\\351\\264\\357\\217w\\221\\235l:r;\\035cz{\\035\\260KS\\022+dD\\245\\014\\353\\346\\213\\366v/\\256]\\022\\025\\365\\274\\353\\346\\3342\\227v=\\275\\343\\316W4\\237\\215%tU\\243BV\\256\\333\\012:\\360\\217\\350ng\\320\\230|\\224\\004\\261c\\037\\265\\375T\\323\\267\\303q\\017\\363\\352\\026_#s7\\216\\005\\301^\\015\\273}\\241\\353\\315\\367\\202\\315\\245l\\177\\215\\314'A\\255/\\352l\\227\\032\\2530\\3643U(\\224\\035\\342d\\373\\271Q\\016\\014\\033 \\260\\303\\224\\235x\\340\\312\\030Q#I\\274"\\255\\261\\336kO\\011\\275\\033k\\243p\\3365L!\\255ui6\\317:\\231\\337\\337\\031}m\\223l\\012\\332\\032\\214\\312\\264\\325_\\307\\031\\006\\204\\030\\0237}\\307\\2667\\335\\270\\345\\325\\243I\\273\\243\\265\\227\\335~\\332^\\214)\\306e\\363\\252\\012\\210"\\027\\217\\236;\\254\\347\\213zs\\254\\254\\311\\320\\331\\014\\027\\014\\2652%\\\\\\356/\\274p\\311\\256zkU)-z\\230\\214\\026\\354V[\\317\\266l\\314\\256\\246b\\320C\\273\\354\\3064\\266\\274\\273\\216\\200\\252\\236\\314\\355T\\032\\244\\251:\\337D\\221`\\254\\007s\\252\\020\\353aW<\\032\\023\\251\\223\\006\\235\\350\\210\\324\\235\\343$\\216Z\\366\\246\\203\\355\\235\\002%\\014\\233I\\362b\\347\\243%\\273\\340\\363R1\\3220.\\213\\254.\\275E\\202-\\215\\305z\\261H\\255\\0341\\212\\330@\\302NV\\026e\\337T\\322A8\\015\\220~\\026\\027z\\\\\\015\\250\\272\\310#t\\2671\\365|\\272Z\\023EY\\026\\021\\212:K&^{V\\\\\\014\\227e\\325\\352\\317\\367\\2724*cTj\\317\\2211\\265vtj\\227[K\\257\\3232\\007\\312\\201\\241\\322\\345\\264\\350\\033\\307\\364X\\316\\272]f\\304o\\322\\011j\\255\\21755C\\251\\331\\266\\360f\\023\\001T\\033/\\246\\033\\004\\261b\\006\\2651\\2637;\\372\\\\\\311\\253\\275\\311d\\222\\232\\255I\\232o\\352\\242\\313\\355mE\\260f\\213ze3}d\\277\\264\\242\\301tS\\225h\\202\\366\\333\\245Tb\\351 q\\314xX!\\361!\\262\\227s\\351\\210\\2103Nn\\021\\012f\\321m\\022k-Dv\\357dcl&#-B\\037\\254b\\3560\\332N0f\\005\\334\\303\\252\\350/\\272\\273\\275\\345\\015j\\2635\\332b\\207\\270%\\266z\\307\\252\\333\\335N\\354\\345\\242-JC\\262{\\2308\\223\\371P\\332\\307a\\213\\351"R\\233k\\217\\202v7k#2\\031\\273\\244F\\350\\325\\224w5\\226XV\\223Ak\\234\\016\\271Mk:;f\\033\\3351\\016\\250\\335!\\266\\002\\211\\311\\312\\202\\330\\366\\204\\302-WD\\2462\\311az\\2203u\\334\\305\\260\\35540\\261\\224\\002\\312\\300)\\267K\\004\\267<,b'U\\267'\\362\\275\\345\\330[\\330\\354\\254\\207U>\\343\\032\\310\\234]I+G\\351\\322\\322\\261\\213\\314\\373\\012\\257\\323\\335\\264\\210Em\\210e\\207\\216 \\251Ik\\347c\\273\\231\\224t\\313\\255\\332\\237\\015\\327\\245\\036\\306bg\\341[K:\\314\\325\\272\\302&\\376\\256\\224",\\337\\027\\355\\341\\300\\231\\216{i\\327'[\\322\\200\\301\\2006g:\\225m\\214\\247\\325^e\\322\\332H'\\036\\227OS\\035\\237s\\336t\\312\\317+Y\\301w;\\302\\020y\\207\\233[\\207\\345\\224\\214crl\\3621\\347\\267\\025\\251`9\\224\\226L\\301\\303\\246\\303\\300\\335\\315W;u\\300\\263Ci\\025\\004\\365|\\032N\\246K\\314#\\3554\\230\\324"\\245\\035\\255\\350\\270\\263\\2314E9\\0269\\314\\346\\273\\221\\270\\236\\252\\201N\\324\\362.\\361\\346\\372\\024\\325[i\\214E:z\\350\\327\\241\\267\\231\\264\\352e\\177R\\034\\206v(;\\2741\\230\\312\\031\\276\\320'@q\\312\\273M\\262`\\222\\244sH\\306yd\\205\\013\\324h\\037\\327\\2610\\325\\341P\\346^\\032\\230\\207\\343\\241(e\\011;\\356\\343v\\273\\240sN\\355\\351\\002\\232\\256\\365\\311\\342\\200X\\313\\2511\\312\\330\\004\\313\\267um[\\271\\320\\2535F\\350\\351KbW\\015Kn\\207\\012Qw1\\357\\357\\213\\005f\\227N\\206Dv\\320\\311\\334\\305\\2008$\\023\\242\\220\\231\\254_\\025\\013\\262\\\\2\\216\\2757;\\255\\2165\\357\\270\\200C[\\235\\265\\263cc%o1\\353H\\310\\274\\371\\206\\301\\314\\2053r\\223\\356x\\033\\262=k\\177\\310Zz\\227W\\221\\235\\261\\247\\313\\345|\\246\\027|\\324\\2677\\300\\371\\3016Tj\\354\\302\\226\\261\\242\\242\\236\\204Z;\\204\\262F\\313b\\332\\355\\214\\202\\325f\\2029\\222 \\225\\003w\\240\\003[;m\\317&\\376P7\\034\\376\\230#\\203YG\\015\\0263Ek\\2052:(&V\\261\\034\\257Z\\354@\\031x\\305`?[#\\003i\\265Y\\016\\216\\335\\366|\\300\\357\\213b\\201/\\026Rg\\271Y\\350N\\301\\267\\006\\263\\356\\254\\337\\347we\\334\\013\\301\\303\\225\\321\\231nV\\343\\242\\256f*\\336F\\306\\\\\\325G;\\203X\\353(]u\\266P\\324\\355h\\235\\365\\021sZ\\327\\255V;\\355\\356\\255\\003"Ing\\261\\325\\217l\\317\\227*e\\034\\007}\\307\\344\\273m\\323\\246\\346\\231a%\\365 \\233\\322c\\244\\036\\241\\343\\245iM\\320\\224\\214\\366\\202\\241\\244\\305<\\332\\027\\233uX\\366\\347\\303\\252\\205X\\233]7\\316\\206\\312(w(\\254BfL\\210\\251{I;,c\\243\\277\\236\\314\\003\\3249\\034{\\007+\\324;#\\307\\037`]\\226\\002q\\236>\\300\\320\\331\\264\\213&\\263M\\253\\325\\247\\307s\\017\\011Vm\\037h\\242=\\265\\237\\256fB\\317\\232\\011\\007\\264\\245\\315\\027\\003o\\025\\355\\206\\375\\025\\332\\335Y\\323d\\330Ng\\363\\371\\320\\036\\304\\223\\322\\310\\262\\3204\\006qigh\\307F7\\335\\276R\\332\\322p`\\215&\\035l\\250l\\332\\235biO\\347]k\\357H\\375M\\333aF\\355\\225\\303\\024@\\337\\371\\316\\350\\230\\227\\003te\\306\\203\\035:\\234\\017jgDS\\205l\\205Tw\\355,f\\235}\\253+m\\367\\335\\361hW\\215mw8\\032\\233J\\333d\\275\\365l\\006\\214eg[\\215(b\\335\\002&\\256d\\251\\365&\\213\\267nk:\\217\\375Yw2\\352;\\207X\\036\\216\\202\\343\\001\\250\\365v\\337o\\347e\\311\\324\\353\\275\\263\\337.\\372#g\\212\\350[%\\321\\235C\\210M\\333\\233\\325!l\\333\\031\\336\\257\\243=:\\334\\220\\265\\327o\\035V\\356Q\\\\\\014\\220\\305~_T+\\307\\264\\352\\356>\\031\\015g\\363\\2262\\344\\306\\303\\244\\215n\\261\\334Y\\314\\021\\301\\031\\004u4\\017\\332C\\032\\307\\266\\3076+\\036'V\\016C=w\\215x\\352\\034\\370\\254\\266\\017\\3426\\216\\244p\\234\\302\\332\\300\\365w\\247\\001\\210\\3434\\360\\215\\332\\301\\300o\\232\\202\\200\\221\\260\\366A\\330f\\024\\030;:|3fm3X\\021\\004\\243\\214F\\350u\\235\\266\\371#\\015P\\325\\231p\\325*\\253\\326\\024:\\241\\023\\245G\\357\\332;\\315a6(?\\353\\313v\\025\\256\\361\\026Kr\\013;\\360WKeZv\\012\\021\\015%\\327\\250w\\226\\267\\226;SO\\324\\251\\334\\363\\267zl9R]\\252\\007\\312\\005>\\373\\354`\\267\\224\\256\\215+\\014\\260\\363@\\223X\\335V\\\\\\354\\255\\256]\\016\\263\\205\\276\\251\\227\\\\\\315\\266\\326\\231n:\\272E\\324q\\277Em\\253\\225\\260f\\332@\\275\\342;fzh/;af\\333\\364\\234J\\264\\262c\\015\\026\\265\\263j\\267G\\300xoG\\007E9\\264W\\235Ak(x\\363\\262N\\322Y|\\354:\\273\\315QOJ#\\346\\303e\\006\\364\\357r5\\222\\274\\004\\031o\\006\\003'\\035\\321\\366X\\332\\256\\321\\276\\031\\357\\372y\\337\\234\\267('H\\263(\\013\\017\\003?g\\\\\\227\\256"\\267\\257\\226Uw9.\\307\\012\\306j\\011\\243\\221\\004\\227l\\302\\343*\\257(O+\\004\\322\\024\\2535\\023\\364\\217\\251h\\344[\\373\\230\\263\\325\\304w\\275\\301h\\276\\343\\334%\\317\\340\\354\\321\\027\\332\\363\\376\\314\\231\\017*i\\034s-\\245\\304\\016\\302q\\334\\336\\2724\\213\\343~\\235\\353\\275YNX\\022B\\317U\\235\\233\\364\\265Z\\353o9\\201r\\361\\332\\303\\273\\202\\217s\\016\\251\\206\\336v$\\213\\000\\366Dd}\\273^'\\356L\\344\\374\\332\\324]C\\360)\\021\\021\\212\\210\\231\\256*Nu\\211\\221X\\021\\2429\\230\\214\\230(\\346h\\303\\364\\2531\\221Hc\\223\\311W\\305\\230\\237\\312\\246R\\257\\013\\223\\304\\203D\\025h\\202O\\244\\024\\325(:_\\2209\\027\\350\\302\\316\\354b\\265r\\030tm\\254\\026\\267\\001\\240\\3462\\\\\\020I\\212\\366\\326\\362:30\\227\\\\\\207\\241\\300\\243\\031\\357\\011\\250\\276`{#*\\213\\367-\\032X]_\\355\\267\\273$j\\305+\\375`:\\342l\\325\\353\\350\\016\\202\\310\\200/\\006s\\211\\032\\016\\313q{\\257\\000\\031^m\\031qX\\257\\251l;c\\247\\034\\021\\265\\370\\375n[\\017G3\\261\\033\\0171\\004k\\327\\216\\036T\\311a\\250\\356\\021\\273\\311q\\020\\274\\242at\\026\\360\\256\\353\\376\\373\\277\\377\\257\\307\\211\\223\\177jL\\373\\224\\246\\371x@\\033\\016]_\\325\\372:\\247\\361<\\316}\\267\\340\\375<\\342\\375\\345u\\354\\273I\\006\\031[\\243\\276\\316)\\335N\\270G\\221?+'\\364xN\\313\\3379\\241\\277sB\\177\\347\\204\\376\\316\\011\\375\\235\\023\\372;'\\364wN\\350\\357\\234\\320\\3379\\241\\277sB\\177\\347\\204\\376\\316\\011\\375\\235\\023\\372;'\\364\\232\\0232\\231sN\\250\\027\\006Z1]\\320\\364Z\\311G\\316\\302q\\026\\222D\\272\\236d\\273\\246\\306Ud\\022zI\\016x\\303`\\2635n\\355z\\336v\\355\\256\\203\\311\\232\\324\\2429s\\300\\265\\245\\344r|\\222\\310\\246\\266\\354\\217\\311\\301f\\204\\366Gf\\261u\\202~+\\350\\036\\016\\243=W\\357\\334\\204T&d\\212*\\207\\021b\\365*c\\033g\\243\\225\\265[\\241\\255I\\240\\026\\254B\\221\\011\\307\\364\\270\\252\\007\\370\\213\\237\\316tG\\232\\034\\007{\\013\\323\\354Iw\\311\\005q\\277\\3052\\212\\251\\316\\227\\236L\\310\\242\\240\\031$[\\007V~\\350-|Q]M\\355\\\\\\341\\021z\\243\\354\\230z\\354\\32241\\351X\\325b\\261\\242e[<\\212\\373,\\025V\\013`M:$}\\230\\254\\310^6\\237\\260\\2750\\037\\326"S\\317\\224\\221\\001ls \\240\\355d\\264\\2359\\364\\310\\017\\006\\350\\206L\\305}\\200Nj\\006\\343R\\3778\\341:\\261\\276\\232\\015t\\020\\224\\217\\006\\305f7#\\313\\203\\032!#b0\\234\\355\\250\\341.\\336(\\224\\335\\237H6\\305\\260\\303aQ\\015g\\203\\012a\\320\\250=\\353\\310f\\234\\035\\274\\015\\2129K\\216F\\265r}\\210Z\\252\\345\\315\\016\\300\\343#V\\2450\\016\\22685,\\251\\016\\032\\032\\013*2\\214\\232\\266\\371\\002@t\\366\\335Mk\\326\\267\\020\\253\\\\\\246Z\\273;;Xm?\\354\\034\\012\\213\\031kX\\027\\343Z\\026\\231\\247\\313\\025\\360\\372\\335\\204Z\\213\\372\\276\\330\\373q\\341\\014\\006\\353\\225\\231\\363\\245\\3038\\345\\2503D\\226\\246\\262\\346\\226\\001\\026s\\211:_\\317\\014R\\310zG\\301\\026\\225l\\3023Ry\\330\\255\\264\\245*\\363ky\\342\\266\\346Y\\244\\341Q\\262`{\\365q\\257\\034G\\353\\005\\356\\304Z\\214\\263I\\311%\\034>tf\\032\\275\\225\\023R`]U\\032\\016\\007z]\\360\\275\\334\\237*]#\\321\\211\\234\\300\\211U8\\353\\007\\353^\\317\\253\\025z\\334\\314O\\301\\351\\220\\231\\007j)G$\\371W\\344s\\014\\313\\372\\375\\311\\234f\\265\\302\\357I\\345\\204\\311\\373={\\036\\346l\\\\\\337\\271\\344l\\024$d\\247T\\350q@\\024\\361\\231\\010b\\317v\\033\\312%.n\\330:Qiob\\240E\\2723\\242\\355\\032\\225B}\\271(\\300\\227\\351<\\300&\\207\\341\\236\\350\\331cW\\246\\011\\374\\352C\\216\\333$\\2021\\013F\\242\\344\\005\\301\\210~\\257\\302+\\030\\264\\343^\\333K)3Zx\\026\\273\\010\\270\\261\\225Z\\254\\353\\256\\227\\251g\\263\\365~\\275\\224Kc\\211E\\233\\012\\367Z\\262\\314\\223P\\366\\311&o\\2047m\\003\\024\\302j\\212S\\227\\241\\227\\332\\231\\204\\241\\374\\304SUKq\\253E\\322\\341HYW\\264\\334\\257\\306\\351\\234\\237\\367\\374\\244\\222\\324\\341\\376\\260D}\\223d\\372\\301p,\\212D@\\322T\\016\\374\\010\\202\\302\\365\\252\\304\\203`\\30795'\\037<B&\\230=.\\253\\0247\\027\\261\\005\\265\\354\\257$\\272'\\030\\256\\344\\365\\011\\267\\262\\373H\\036\\311\\032\\321\\265z\\312\\261\\243\\023x\\0323\\270JY\\210\\347{^\\007%\\002z\\024lq~\\021\\036\\314\\025\\347\\016H\\231c\\360\\276\\032\\306\\374p\\000L\\360F\\025|!\\331\\225y\\274\\021\\255\\210"\\321b%\\003=\\346\\035\\375uqX\\316k\\3169\\364\\011z\\270\\344\\013l\\315\\357S\\336\\337\\327\\222\\301F\\223\\361\\034Y\\304SW];\\210\\245\\257\\324\\001\\016B7\\242\\213\\214\\224x<e1\\227\\332\\255\\330\\011e\\220=l@u\\216z{\\321\\216\\243\\2518DW\\376X\\231\\254\\005O\\230u\\022=\\302)\\013"\\376C|\\366\\275\\006\\237z:\\315\\244\\264\\023\\262\\222\\002\\360\\231RZ\\002\\202\\361\\012S\\264\\265\\347\\215\\313`\\307\\224C*\\317\\350\\303.^\\316=v\\217G\\336",lb\\237l\\3239E\\021\\032\\3151\\225\\310\\020\\012\\036\\021\\201\\352N3\\202\\321\\023\\227\\304\\325\\212\\240\\350u\\233\\324Uw\\300\\2524\\342\\252\\344V&\\304\\005\\213\\240\\335zIxA\\210\\307\\011my2\\355\\034\\244\\235\\310\\231\\302\\326S\\362-m\\305\\366\\221h\\341\\275`\\350\\316+\\336cJ\\177\\331\\263\\222`\\345\\207\\211f\\247\\000\\377\\330\\316\\020\\322\\264\\337\\032'\\003c\\271\\304zU8H6{\\332F\\002\\245L\\322\\220d\\355\\264Rkt\\313\\357wc:b\\213~\\345\\361)\\233:<9\\216\\246\\2114\\026\\214q\\335\\357,}U\\031\\241t/\\3340\\311\\256E\\364e\\252(\\355\\3024\\210Y\\274\\354\\267\\246\\203\\212\\032\\247\\234/\\214@<+`\\254\\273\\300z\\335\\342\\270uY\\323\\365\\000\\366>\\304\\351\\000\\342T\\015j\\210S\\354\\310\\214\\245\\245by\\252\\277H\\026\\223q\\236*\\232\\230\\0344#8\\32060\\2373\\022\\237/Gx\\247G#\\332\\276\\304\\005Q\\302ua\\255\\351\\244O\\210%a\\004\\252,\\260C\\026e\\216\\332\\022\\350\\026\\\\+p\\2311\\011!\\\\\\310\\311\\304\\225\\025[\\367\\344\\220\\344x;\\227\\201z%\\020\\222\\2105qZ\\213\\244\\035'\\2443'\\351%\\221\\363\\300.\\316E\\\\\\012\\255\\272\\203\\021l>$\\260*$\\365\\321,\\351O\\371\\240\\212@\\360\\264\\013vq\\251f\\306a\\347\\300\\230}bl\\023\\177\\211\\215\\371\\335\\200\\231t\\330\\014\\215D\\321\\0244\\221\\363y\\227\\263\\243\\303\\240\\006nf>\\217r\\261W\\217}a\\217\\011"\\271\\3329\\007\\215\\344i\\020\\016\\317$4\\303\\247\\034\\036\\345\\016\\321-g\\011.\\264Zl\\253\\352\\015mK\\237\\011-\\261\\357M\\370Tv{\\303\\236\\035\\2578KfT\\265S\\3665/\\310i\\211\\006\\376\\001\\347\\0044)7\\371\\343\\374\\244O\\032\\334\\342\\304\\324\\224\\017t\\224\\262\\302dw\\\\\\232\\272\\262\\320\\344X_\\273\\035\\203P=\\224\\325\\0264'\\243\\206<\\245Am&\\325\\213\\213t\\031\\350\\362\\266\\303s\\276\\316%.\\3050\\2071\\207h\\265\\\\1\\245+\\252S\\206\\233\\361N\\341,p:\\321'\\304\\306\\234\\320\\214\\027\\312\\376\\216M;\\013\\253\\323Cp-\\0105\\251k\\2238\\326!;\\364\\022Xh\\322>\\222\\004\\021\\005\\365\\202[\\214\\211\\245\\325\\035\\217\\303\\021/O9^\\265\\324\\230G\\346\\224@zd\\245\\361\\333d)\\316\\014vG\\011F\\034\\033\\271\\230\\364\\227\\261\\210\\365Q\\005\\003\\036\\252\\256Te\\206T\\251\\273\\323\\351\\201$hQ\\213\\221\\224\\031\\347m\\011\\276\\026\\364\\302^\\226\\034!J\\275\\243"r\\013\\316s\\034\\323M\\266\\025\\311t:\\003\\277\\027\\207\\223x\\215\\035\\013e\\222\\307\\323\\240e,Z\\011\\277\\036,\\006\\321\\240?\\263\\002\\265Wd\\202i\\271\\210n"\\305\\334\\024\\002h\\330>\\306g\\017\\3403H\\205\\335vwT\\315T1\\026\\301J_\\312t\\355GU\\207PI \\326!\\225x\\231S\\364\\315T \\003\\254\\366-L\\224\\370\\271\\201s\\201\\035\\010\\254\\034,\\017\\300/\\330{B\\256\\014p%\\362\\213\\000_Sk\\205\\333h\\262"o\\227D\\305+G\\322\\363G\\244\\022\\022\\346\\272\\243I=\\027i/$\\002\\301Cso\\342\\353\\261r\\320g\\026-3\\353\\305\\3204+\\005\\033/k\\232G\\320u\\244\\210\\223\\230\\357\\324\\344:E\\326\\230o\\245r\\351\\001\\203\\033\\221\\250\\000\\220!\\030\\271&S\\001FHxU\\211S\\017U\\012e\\207\\225r9\\323\\005\\226\\343e\\240\\273\\360\\212u\\372\\034\\302\\257\\304\\224\\034\\222\\203`\\265\\244\\010Nb\\304Z\\355Q\\202\\210/\\027K\\234]\\347\\270%\\355\\226Xi(u\\240\\012\\374T\\027\\014\\255[\\314\\246\\204\\336\\243J\\001\\235\\340s\\227\\367\\202\\031/\\0025$\\220\\026\\263=\\314\\306t,\\324\\014Iy4\\264s\\030\\201\\007\\002D\\351\\344d\\371\\\\\\210[\\034\\237\\037i\\321\\343\\201\\326H\\3739\\032s\\001\\320\\246<\\272\\014\\000\\233\\246\\301BY\\356vr\\346MT\\272\\034\\211:/\\010\\243CG\\317vka\\264\\364\\3110\\332'\\232\\301\\014]NV%\\233\\351\\320YO\\224\\230\\270\\247**\\205+\\313,\\3019z\\356v\\374EU\\216\\267k\\242\\023\\254\\315NTee\\265\\022\\310\\221\\033\\345\\374*\\364\\331\\332l\\255|\\215\\334\\034F\\007\\313\\353\\344S\\325\\022\\203T\\234\\023\\251\\261"\\216\\271\\343%&\\026bC6\\302\\016\\363\\0047t\\317\\230j\\273m@\\271\\344R\\032\\343\\332\\204\\254\\246\\023c\\036\\035\\363\\312\\260\\350\\235\\353\\312\\225;.\\345|\\314%:9\\226EQve\\266\\334,h\\263\\236\\316\\030\\334\\024)|\\255\\341C\\314^\\002\\016pTE&-S\\264\\221\\243=\\353\\300\\344n5\\011\\371b&\\001\\024uF\\240\\013\\326\\354HL\\227j\\324\\331d<\\341\\367\\260<Q\\360%\\020\\372 \\223\\271C\\240z\\362\\250Zxc\\262"e\\362\\007\\370\\315n\\361\\273ct\\006]p\\304\\322\\323r\\336\\230'\\301N#\\023b\\327\\242\\007\\035\\320\\036\\373\\260\\323\\346\\311\\004\\037,j\\006\\341\\251\\003'{mq\\261\\230\\211E\\207&\\365\\3201\\267:?\\2128!1\\346aGT\\270\\020Kz\\244&\\254\\246Ut\\310H.&\\205\\235\\271,\\366\\006\\0106\\325\\265w\\300\\325\\203D\\361H\\311\\371\\212Hm9\\204\\261\\272H\\333\\347P\\015\\307XU\\3054j\\213\\206})\\331\\271S\\027\\260;Pj\\204\\273f\\034\\204\\241v\\202;\\216\\017\\372h\\272\\032\\2163w=\\266\\306\\2519\\226\\265\\311\\012W\\321\\235\\220\\322\\222\\342\\016l\\\\\\234\\000n\\235\\023\\206_kk\\006t\\376\\270\\304\\361\\030\\334c&\\213z\\002\\230x"\\220\\225!\\314\\265\\211KW\\233\\011\\336\\363\\370b\\032\\250\\204\\264\\343\\346\\363nM\\273\\316$%\\212#\\335\\336\\372\\345\\004\\351),\\250\\276Zz\\252\\247\\000/\\255\\036\\023?\\360\\005\\006'\\337J\\335\\001\\337*=\\360\\202\\007\\354V\\250\\342\\320n\\221\\313\\240\\317\\013!\\276\\303\\215\\2757\\035i\\2016\\316w!\\335\\007\\254\\3221\\025\\213\\224\\207>\\3159Gf1\\007\\321\\036\\360\\002\\364U\\227CUG\\367\\311\\035\\033`\\326\\234Vy\\333\\230\\342!\\031\\036s>\\337U>_\\371\\273\\230\\3116h\\254\\216\\202\\2103]:\\337\\312\\007k\\342s\\341\\330\\366\\200{\\2675\\270\\355\\321\\033\\331I\\244nu\\245\\345\\247y\\270\\344\\224\\011\\356\\212\\324TA\\251\\351NH\\33491JI\\215'\\014\\227"VJ\\177E 4\\021p\\\\n(9\\313\\212"^'\\024\\300\\375x.\\360\\276\\266\\246Y\\012?\\216\\311\\021\\215\\223\\246\\306\\006\\234\\313\\034\\335JG\\344\\\\%\\314\\325\\330\\227\\367\\323\\312\\005\\316R\\34509\\222S\\307\\242\\247\\366\\011\\241W\\257\\201`L\\2171R\\306\\214M\\034\\247\\204\\277\\345\\242\\016\\345F.\\266f\\344*'\\305m\\332I\\370\\341\\344\\300\\375H\\037T\\377-\\370U\\263\\372,\\013y\\323\\237M\\307\\235\\276\\257\\013R8\\356\\013\\321a\\311L]w\\354\\321\\364\\036\\352S\\034\\221F,\\221\\323d\\337\\210\\274xa\\322\\225\\261\\247p\\343\\310V\\034e\\214;~j\\254'\\2046'YW\\246\\360\\241d\\215\\217\\010\\223\\356\\0005\\252|\\262\\3037\\220_9\\274\\307,\\005K\\234\\260\\326\\232\\245\\335\\314\\360\\335\\315\\034\\231rs\\302t1\\271\\232\\315{\\365$S\\246\\372\\244\\217\\2272>\\323\\324\\301\\246\\236\\244\\311\\322\\267\\326\\010_\\324\\223\\261\\340\\201\\206\\360\\304|\\354\\316\\004\\013:\\005\\377\\335u\\001\\304-\\320\\235\\024O*\\376*\\351\\220)\\273\\242\\370\\251\\266]\\267\\326~:\\242\\274y\\302\\343=\\205\\230T@\\276\\253\\005\\345(\\356\\206\\300\\215\\335.\\321;+B\\034\\347U>.\\352\\202\\201\\370\\335\\031\\011+\\2718W+\\351\\206\\301]g&\\253\\273t\\343\\262\\304N\\243:\\025\\261\\262\\201Q\\354\\340k\\2753\\342\\371\\351\\332\\035w\\204\\012\\357i\\304^\\256V\\032Q\\317v\\013j4\\351\\346\\233\\024%\\244\\000\\255\\367{f\\306[-\\221!\\245\\376\\030\\010\\273\\340J \\344B\\204\\202\\376\\221.\\350\\023\\177\\266.Xs\\224h\\340\\314Y\\027\\320\\024\\316\\211\\365\\232\\331eS\\315\\220\\226=\\2727\\335\\254Mre\\370\\304\\202v\\265\\211\\215H\\274Q\\327\\305:\\310\\267\\036*M\\002\\235S]\\012X\\343q\\341\\005\\251\\326\\213\\226\\375M\\250\\370\\353H\\237\\206^\\217_\\006\\324\\216\\233T\\032K\\304t\\177\\276\\2467\\244k\\3573D\\352\\270\\343\\036^\\014\\334\\261\\257\\244\\2141\\221\\262l7\\034\\003\\334\\362\\370\\000\\301\\227\\265\\314\\215;\\255}\\276\\006&\\354\\250\\3133r\\264 \\245\\200Zj\\036\\033\\22446\\253y\\251\\3625\\241\\2479\\223\\3434\\244zK\\270\\227\\002 \\316(\\256g>f\\265\\266km\\347\\340\\236w\\010\\246L\\305/\\375\\037\\371Z3\\034\\370Za\\252\\355\\342\\335\\3210}5\\001\\276\\326B\\023\\031\\203Q\\2530\\235\\222\\246\\270\\016\\351\\254A\\251\\030K\\023)\\031\\012\\271\\236\\213:W\\3604Gq\\214\\032LX9\\221\\347\\222\\307\\345\\214\\355)U\\205\\222\\362D`\\220b\\315\\012k\\325m\\035\\334\\\\\\347Ji\\307\\007\\271\\340n\\034\\227\\0031\\220\\224\\240&\\007\\342\\326E\\207\\350r{\\311'\\326\\222lP\\352\\274p<\\257F\\000\\037\\316\\200?\\314\\333Hk\\023\\365\\\\l\\341\\232l\\262\\233\\232\\3616\\332\\356(\\325\\212=\\227N\\214\\310\\314\\365r5\\355\\030K\\3710\\024\\360j\\212\\227\\363\\365\\232\\255\\374A\\205y-!CT~(2\\276\\227J\\233\\272\\325\\243\\263\\335\\200X\\023\\3451\\267\\374qgK\\342\\307DuB$[\\370\\231\\264QV!A\\204\\223U\\213\\230!+~\\202\\317\\330\\343<\\300K|\\272\\333 \\3139\\206\\217\\007S\\323"#\\214\\030\\316]\\245R\\025\\201\\033\\313\\205\\001\\344\\305\\355@?vZ]'\\031\\376\\23297W)\\224\\317\\256\\357\\374E\\023o\\336\\216u\\352\\303%{w\\233\\231\\301\\315\\310^\\232\\215(\\232-\\244\\340F@/yz:\\343\\356\\365U\\344\\366\\010\\270wk\\275\\372\\267{-\\376j\\016\\210\\301q\\015\\350\\343\\003P\\001\\004.s$\\264\\267x\\005\\363;\\346\\230\\250\\002\\236T9\\237\\363\\335\\0048!\\371\\204\\222\\021\\211\\032\\266g\\210B+\\364\\202Q\\264\\2164_\\360\\252\\026.\\300G_.\\302\\216\\265Z\\302\\331lX\\271\\211\\211\\312\\034+\\2105\\366z6\\247\\322\\036\\267d\\274\\265\\015\\256"\\036\\330!5H\\215e\\230\\226\\233\\250\\017\\376\\000\\265\\270\\313\\014\\264\\310\\354n\\001B\\236r\\022\\001\\000\\273~\\231\\225\\203r\\320j\\357\\207\\240IP\\215\\3463\\252\\032\\316\\351\\032\\346\\251rg\\\\\\017\\267\\334A\\214\\371\\203\\231\\011\\207|0=\\026\\240\\201\\227\\\\\\326\\357\\375\\\\\\354\\015\\305\\001\\231\\356\\031r\\227\\017\\327+%\\324I\\242k\\254\\224\\204c\\231\\335z\\345\\345\\033\\224\\011&\\021\\010\\351\\242!(7\\234\\314\\203\\205\\246!\\022\\241\\321\\332a\\262\\305)\\\\~\\323\\255\\015nq\\234\\0155R7)O\\234r\\036\\307E\\346\\201'Tz\\267P\\016}\\232\\320<\\216\\305)z}\\230\\257\\315\\261\\247\\223\\356\\\\\\207\\221\\263Cpn.\\353\\244\\232\\016\\311z(qk\\201\\334\\320\\341\\212g8q\\245\\211\\024A\\333\\253\\3560\\025iwF\\021\\212#\\034\\012\\207E=~\\\\'+V\\2114\\216\\257\\\\\\241F\\365\\210/-?U#gU\\317\\235$\\244EVG\\264\\376\\350 \\256Z\\212\\270\\013\\311\\311\\006\\217\\314\\230\\240\\364\\255`\\212q\\0375\\306c\\202c@4{X\\007~\\316o\\034\\324S\\344\\002\\270\\364\\206\\265\\251\\265\\220x\\303\\221y\\261\\311\\032N\\310\\270\\247@\\002\\313\\032C\\254\\001\\221\\001\\311\\225\\236=\\366\\001\\311\\033\\336\\021\\001\\221@\\314\\251\\002\\376!\\221b\\242\\016\\367\\223\\343\\032\\225\\266I\\177\\272\\205\\274\\304\\0202\\300\\202J\\203"\\241\\242-\\030k\\265@\\225@g\\365H\\217:\\305f9\\332o\\272\\322\\321\\354b-'\\036\\265\\235\\336\\231\\207\\326\\007q\\313\\263\\240 `?p\\025\\361\\250\\025\\353};\\336M\\001d\\300^\\223\\217\\370\\351\\000\\032\\3603\\236\\372\\275\\374d\\310\\025_TS\\2566A\\267}\\201\\022s\\206S'\\312\\212_\\333sbOp\\234\\354\\362\\356t\\\\\\363\\336([\\343\\266\\020I\\324F\\257H\\340R\\355\\3741'b\\212\\353\\023\\2147\\027\\226\\007R\\013\\2541I\\327\\253\\270\\332K\\232\\353\\214AT(\\036Z\\214\\216\\004\\035\\301_.\\002 f\\342\\234]\\363\\272\\275\\366y\\326\\223\\375\\341q\\025\\227c\\205\\322\\366\\202_\\304\\273C9\\2230q\\347Qv(w\\013*\\037\\023\\324\\356h/\\355\\301"\\316&-K\\032\\364K!\\361\\227y|(\\013\\263\\352:;\\341P\\005\\327\\264\\015ni+\\003\\321\\367p\\240\\020\\200\\310\\253P\\017$;\\301\\207\\264\\004h\\335B\\005\\000ii\\002\\012AzV\\303\\031\\205\\214\\200\\267\\327\\232\\005@\\235\\320\\022@ \\324\\025!\\257.\\000\\231\\231P_B5\\260\\204\\004[\\204\\372\\252\\036:\\234@\\272\\211\\301z\\020l\\002h\\312\\265f[\\014\\322\\025\\250\\023\\035\\322\\025\\322\\024\\320S\\260\\343\\024\\220$\\037\\374^\\272\\256\\230\\332\\374\\200\\266\\322\\034t \\326Q\\347G46\\364\\212\\257\\253\\251\\240\\000\\332\\272\\376\\206R4\\221\\223\\025u\\314q\\275T\\245\\375\\265Z\\015\\371J\\220\\0244\\017\\303qE\\005\\242\\241\\007\\023b\\252\\251,\\225\\034\\252BI\\373 \\344\\340\\371\\241)\\223\\244w\\004\\232\\257\\2322=\\032\\307\\345\\245J"\\251\\330\\351\\311.#v\\365 \\350\\360\\272\\265\\322S7\\024)r\\023\\362n*\\351j \\037\\320\\251v\\304S\\241/Q\\322\\272\\356\\254\\222*\\235h\\034\\352n\\011r7IR\\371Pv\\344\\014%\\246\\272\\211\\355\\262H\\333\\015U]\\030\\362\\366\\321\\2301\\323\\2153U\\325..\\350\\361<\\325\\270\\316\\201\\221\\256\\350\\234\\274\\2433\\374\\372#\\375\\237g\\302\\021\\352\\177@\\333\\355#\\033\\000\\221\\011\\345\\367b\\013js\\305^l\\001 \\301\\352b\\013\\246\\224\\333{o\\017 \\275\\177\\325\\036\\374\\016\\371\\315\\333\\263\\343\\350Bgg\\325\\031\\375\\210\\326\\206.\\363\\035\\340\\355\\034$(\\303\\307\\355&\\2679YUW\\223\\265\\272e:l\\202\\312=\\335\\235j\\207\\302K\\373\\323\\2718\\251\\251%\\267c\\007\\253j\\035\\0124\\315\\263\\007\\3063r}\\250r\\273q\\215/-\\300\\262"\\345\\331d\\265\\026\\031\\304[\\210Lo\\301.\\372\\254A\\273\\010\\317\\233A\\210\\323T\\214\\007U\\304\\207\\011n\\210\\014\\205\\251\\261\\261\\306\\346"J\\344\\362q]\\360ck\\276P\\203B\\336\\032\\324.NSA\\023\\263\\002\\021Z\\356v\\267\\232F\\273\\235\\301RL\\262Xj\\002\\272\\027\\345\\255J\\031d\\227\\020\\014\\272\\277\\350\\273\\310\\341FW'?\\320\\325\\300D\\023\\217\\3645\\2405D\\363\\361"\\327Wz\\232\\201\\264\\206\\364\\205z\\032\\210\\350\\022\\350\\350\\025\\324\\313P\\216/\\272\\271\\234\\370=\\250\\237I9\\340/\\372\\031\\250s}gD\\351\\301\\214\\257u\\365\\000:\\026\\177\\222\\256\\3765:\\033\\015\\235Iu\\001\\351\\234m\\327\\242\\263V\\035\\2753I4@gm\\311\\260b\\215\\356V\\022\\036\\363#\\321\\252w\\307\\365\\026I\\346l00\\246\\236\\225\\035\\004NQ\\216c\\253\\226\\330Jc\\264\\2358\\367,\\032\\257\\024F\\363\\026\\366B\\324\\230\\016J\\351\\232\\013dY\\031\\353\\262\\310E\\370\\260\\016u\\335\\212t\\027\\004N^K;\\262\\023U\\356\\001U\\300\\320\\222\\332\\013\\315\\016\\002\\311#\\000:\\343~W\\217\\204@\\344 \\235\\235\\343N\\233Fv\\262R\\323c\\035\\217\\251\\225Z'\\307\\371\\022\\327U\\314\\235\\372;[\\332\\001}`\\206\\234,_b:\\202\\271\\361;\\240\\317\\340&P\\220\\241\\240B'\\011*X\\240\\267+H\\034 \\3072\\020\\\\\\015\\350\\3565\\264\\256\\330t\\036\\000:'@\\177W@\\177#@\\306{Px\\300\\253\\012\\244 \\024l\\3100@wC%\\276\\200\\304\\334o\\320\\321\\320\\031\\037@5\\002\\320\\337\\006\\224nP\\305\\016\\012=T\\330\\2209\\200\\322\\356;1\\326\\002\\217Y\\360H\\200V\\037\\334\\262\\341\\350b\\006\\250\\014\\031\\255\\004_\\366Y\\277U\\347\\033\\026\\350\\367)\\340\\005\\003\\360\\202\\015x\\301\\307\\240F\\000\\005\\000/\\224\\200\\027\\016\\355\\375\\240\\015x\\201j\\274Q`m\\000/\\314\\241r\\001\\374\\260\\031Ck\\002\\270\\016\\360C\\006\\015\\005TV\\215v\\002^)\\340\\011G\\007\\\\\\007\\230b\\3703c\\376\\377\\227\\317x\\267&\\0307\\231R\\323c\\213\\3669\\205\\366z\\334~\\322\\343vB\\022Q\\322q*n\\023.\\020\\370)%\\036mi{\\000\\301\\004\\267\\\\*\\353\\336\\200\\347\\005\\222\\333\\226\\244t\\\\R\\322\\274OK\\210\\304p^n\\3550\\3558\\035\\330s\\216\\310\\235\\311\\332_d\\251\\030\\325\\372\\014O9\\271\\275M\\375\\200\\250\\366\\0323\\337+\\333\\376|A\\324\\270~L\\\\;\\246l$\\250e\\226&\\2663\\351\\320\\252\\203\\203<'p\\020\\277\\006\\370q\\237LB\\327\\243i\\267\\306\\225X\\335J\\323\\331\\212\\303\\023\\234\\351\\261\\033:\\010t\\334\\235\\210F\\272St\\032'\\211\\016\\327\\231)K=\\021:<\\201\\037=b\\206\\021\\022\\351\\312\\257\\361\\367\\324=\\307\\337@\\307\\001A`\\240\\307\\202\\273\\300\\236\\001f\\201\\236\\010\\214F\\2406\\202\\032\\016\\012\\006\\324&\\320;\\231\\035\\207m( \\220\\301\\241\\366\\320\\240\\253\\002?\\200yW\\200s\\240w\\263\\001*\\011ZC\\240(\\021\\250\\341 X\\2677\\245\\240\\327\\012\\005\\302\\203\\352\\023h8\\350\\345\\002\\343\\265\\204\\032\\014\\2067\\300\\212\\355\\012h\\307\\006v\\027\\012]\\011\\001A\\256\\007\\334\\274\\207c\\351 \\266\\251\\240\\271\\205R\\011$\\017\\3602\\015\\205\\240\\206Ru\\255\\206\\241~\\203*\\370,\\264\\200\\237\\027\\200\\237WP\\213\\002\\206n?">\\221\\026x\\274\\302{\\226\\210r*;)\\005\\342 yB\\26103\\267\\337\\321\\323YW\\013\\372\\314\\262_\\227\\321\\256;\\245\\222\\276\\251\\232+I\\266$j!\\326k\\367\\020\\233\\030\\232#\\223r2\\013Pi\\021\\324\\232\\261@jW\\363\\206kD\\0061|\\237g\\211r6>\\364\\305\\345\\002\\331\\000\\302{\\276\\346Z+\\265\\250\\265Z\\026\\251\\332\\027\\204\\203T\\202\\250R\\241\\004\\211\\224V)\\231\\320\\234J\\006\\242D!b\\354n\\023\\012\\237'K"\\213x\\036\\355\\0218\\302\\011D/Hy\\304$\\366\\307dA\\342\\330V\\3238\\206\\320\\304\\3718-H\\312\\015\\267oz\\016\\037\\335\\3529\\015:\\023\\300\\236\\311\\320\\031\\271\\220\\010\\032\\007H\\036@m\\016\\032\\011@\\231\\000b\\031\\304\\037\\010D=\\324{P\\337A\\035\\007\\035SHI\\300\\001\\012t:A\\354\\241@\\375\\006b\\217\\016P-\\014\\264\\202\\200"u\\333\\351\\266\\240\\216\\203\\326\\014R\\023R\\010p\\024\\011Y\\006P\\337\\267\\340*\\003\\240\\334\\240\\216\\203T\\376\\275z\\354\\275\\016\\203\\034\\362+z\\214\\215r\\3226)_\\353\\256A|Y\\016\\223\\031\\217\\322Y\\307\\002QC\\346Ey\\333V\\267\\311b\\223\\261##\\263z\\323m\\332\\025\\352hA\\240\\210\\264<.\\374\\215e\\3173\\343(\\227\\275\\252\\265\\321;\\366\\234Q\\322\\325|I\\250\\343z\\253P\\326t\\236D"\\177\\344\\016\\333\\0366\\025z\\006\\277\\014\\221\\275\\271\\020\\203\\2617\\014}\\177\\030oB\\361\\300\\201\\230\\217\\323\\270\\236\\035\\000\\307\\230pU\\271ne+@k\\\\q\\307\\370\\021\\331P\\336r\\215\\343\\311\\010\\037 #z@lI\\231!\\3674gPC\\306"syD\\342\\026\\305\\372\\302Z\\366\\326\\312\\032\\241_ez&\\337\\3124440K\\001\\305\\025\\312046P\\216!1\\032\\323\\017\\347\\253\\000j\\301\\010\\020z\\012\\300\\216\\215\\200\\035kAU\\000\\221\\010\\345\\034z#\\015\\241\\241\\240\\002\\327\\005\\212/$\\036\\364h \\323@O\\027\\032\\253F\\246\\241\\301\\002\\324\\270\\030<h\\270\\200-s\\340c\\370\\025\\330\\254}~q?>\\222\\363G2\\016\\230\\012\\312\\371{\\031\\377\\231|\\023\\351\\026\\217c\\274\\027K@\\246\\311\\311^\\240U\\317\\023F+s\\357\\371==\\233\\215\\203\\274\\221\\351\\375r\\327\\365\\201L[\\375J\\017e\\253\\240\\026yg\\035uW\\321\\200\\315\\221Y)\\316"\\324[\\235d\\272s\\226\\351.\\224\\351-\\351\\036\\305^k\\272\\345\\014~\\006x\\211q[\\364\\262\\267^\\341\\025N\\255\\346\\005\\272:"\\032\\320\\251\\302L\\345\\346\\012)\\332\\233N\\245\\307@\\256\\011\\017\\021\\210#\\022\\261>\\273"\\\\8\\367\\254\\032\\215\\353\\035O\\311:Yk\\210Y1\\210Lk\\234\\224\\321\\\\`\\244\\346\\210\\025F\\326\\225<\\017\\337\\3113P\\256\\034t\\370 \\325X8\\236\\003t7\\364$\\241,\\003\\352\\270\\020\\343\\020U\\327>\\012\\020\\375\\005\\304\\034$o\\243\\306\\001\\211\\241\\026\\207\\362\\014\\261\\0159\\003\\222\\005\\242\\376\\342\\360\\2028d\\012\\235^\\030\\220^\\344\\032&\\036 k@\\012B\\016\\201*\\374#9\\376\\221/\\362^\\206\\241\\231y/\\307\\320\\264<\\362I`\\276\\010\\3123\\215\\000\\032\\364\\312^2\\341\\227\\364\\204\\321\\017\\007:\\323\\243`t\\221\\347!\\220\\3475\\220\\347\\243\\240x\\035\\242\\243I\\213\\271\\340OD\\233J\\201<O\\201</\\364\\305\\372$\\317\\002\\241\\262\\365V% \\212q\\240)\\260\\251\\210\\007\\024\\336C\\345`\\015h=\\256yVYBZ\\257A\\2742Y\\315C@\\353jI\\342\\2462#\\271\\225\\031a\\244\\020V.M\\213\\032\\245\\014-v[!n/\\220\\362\\311\\010\\363\\345\\236$\\347\\016\\261\\353\\210JNU\\3668\\020Q\\237\\317\\267\\334R\\372AN\\341}\\234\\011-*\\320\\244\\327\\261\\011\\244\\266\\177\\021\\216\\013\\352\\256b\\221&\\346|\\037\\203\\300\\330\\022\\276\\370>?\\004\\331\\300^\\205\\330u\\334\\361{\\362\\215\\217r\\010\\320\\214\\\\\\307\\035\\320[\\200\\261\\007d\\265\\237\\346\\024\\326MN\\201=\\3620\\2470\\360]\\315_\\313\\311b,p\\323\\0345\\216\\243\\232\\233z\\2132\\337\\204\\273\\342\\350\\366\\247\\021\\032/<:^\\221*\\313\\327\\256\\242\\347eG\\331I\\331&\\246+\\211\\362,\\276S\\364\\345n%\\257\\346\\204\\250*\\372VUh\\032\\310\\020\\275\\005t\\236\\310\\250\\202\\273\\2446\\217#I\\035/\\000\\203\\252\\334\\262\\227`\\214\\307M\\351\\005\\322\\263\\016\\226\\311\\310C\\231\\356\\256]\\363`i+\\242\\325\\221\\275\\241n\\323\\303\\003\\207\\356$\\246GL5r*\\261^\\350N\\347\\323j]\\243\\335\\251\\031\\222"zp\\246\\363\\011\\243]\\353k\\367c}\\015\\342\\217\\370F__\\320v\\321\\331\\363\\000{\\257\\267/Bs\\243\\267\\201\\264~\\244\\263\\241\\276\\206\\324\\204 \\241\\021\\207z\\033\\352\\354\\033}\\015\\311\\370W\\351k\\330\\231+\\235M\\244!\\036w\\317\\372Z\\230Db\\000\\3645E\\254\\315\\275\\313\\2559e\\3323\\222\\316X^s(i\\345\\035\\0059\\340\\3641\\336l\\265M\\025\\247$\\271\\024{\\001Ad\\323\\321(/\\346Y\\237w\\327,C\\362\\326Du+'\\224Y\\006\\350n\\340s\\331\\272\\026\\350Te\\212&\\272\\230\\316\\267\\342\\212\\302m'H\\223d\\213q-\\020\\217F\\\\\\017\\311|Z\\216\\306u\\356\\002\\035>\\200:\\030\\010\\234\\227n\\027\\335\\025\\315\\025Z\\274\\033\\310q>X\\316\\255<\\335\\350\\372\\314\\357\\004\\2729\\362\\344\\255\\217\\256\\026\\343ygL\\206\\263\\255U\\2544\\032\\237V\\177\\315\\030\\314y\\244\\343/\\034\\177\\201{\\365?8\\300\\373r|w\\022~\\011\\215\\330\\375\\237\\033\\323\\374_O\\241\\377\\374z\\275\\363o\\256\\035\\343\\346\\322\\015\\203\\233\\353 x12css/:\\306\\360\\372\\333\\373\\355F\\233\\035"S;\\313}#\\276\\333\\213\\364|\\377\\373\\005\\210\\031l>\\006\\002\\253\\364M\\270\\001\\263o\\336A\\272~\\370\\012n\\363\\203&m\\354\\3305B\\377\\016\\320\\371\\376\\371tY@\\311\\227\\346\\300\\270\\027\\317\\217\\213\\233=\\275\\3376G|\\333\\234\\362\\274\\237!\\366v\\364\\304i\\255\\371\\335Q\\024/\\277\\262#\\341\\203Q,\\340@L\\360\\311y&3\\002dR\\007\\372\\244\\003\\363\\017N\\214A\\015\\017\\215\\305\\014\\350\\023h-,\\240z\\306@\\241\\033@\\226\\245\\375\\006\\205\\032\\376\\242\\230\\033\\213u\\372L^\\377@\\245&g\\032\\247\\360;Y\\356aX,I\\204;\\346q\\211\\000z\\302\\325\\363E\\265\\343X\\224\\243\\345\\365\\272Z\\035\\320p\\327\\026\\334\\256\\264\\333\\331\\352\\202\\334\\221$\\216\\017\\376\\012\\251i\\210\\260+\\355\\034\\212\\302\\357\\227\\235_\\234g\\376\\272\\347y\\277\\207\\031\\347\\015C\\257\\366\\307\\206gnd\\315\\316\\225\\357\\216\\310z\\333\\271\\363\\363\\345\\314\\334w\\\\s>P\\364\\237\\2416^$ikpl\\261\\344\\262J\\227X'Q\\213\\3430\\333\\364\\017\\37213\\034\\246\\273\\211\\025L:\\306C\\2310\\023j\\324I\\200a\\212\\256\\3552\\234\\267\\336\\361$\\215$\\350\\365J\\361\\226tG\\236Q\\243\\236\\3112[\\003] \\034\\313\\207:\\032\\2263u\\262/\\007C\\237c\\303`\\246\\362+IC\\252\\371\\212\\240\\364\\245\\227\\252\\343\\364\\240/\\244\\376<T\\266vTl\\247K\\331\\237\\035{\\356l\\354\\366m\\266Sm@\\200\\274V\\211\\336fY\\227\\3461\\355\\201\\367=\\235\\035\\371\\372<\\205\\327\\205\\016\\352\\235\\0348\\027xm\\275\\315\\212@\\214#\\342\\313Ke\\277\\2164\\027\\266\\207\\243\\245\\275\\011\\276Kj\\257\\232,\\305J\\332\\342\\256\\264\\245Kq."\\320nNH\\374 Rt59\\342\\207\\311\\221>L\\3464\\210\\177\\304\\303t\\213W\\320\\313:\\377\\3723\\037\\037\\232\\221\\022MC\\236V\\374\\327\\366\\034tv=\\342"8h\\207\\367'\\207Q\\327\\352\\232\\245u\\024\\313M\\227\\217\\001<\\230\\027\\334\\213\\024\\267\\007\\246\\257\\200\\357OV\\022\\006\\320\\352\\331d\\2474\\017\\342\\033\\334@\\011MT:\\030\\260\\017\\313Q\\311\\215\\371@\\337\\246\\300N\\217:\\026\\205\\000\\247\\354\\015\\007\\240\\237\\322|\\216\\370\\006\\010\\326M*\\331OP\\3548\\211\\230`\\203\\362\\341$\\002"\\251\\216`\\324\\261\\027a\\237\\321N\\321\\340\\207\\355\\344\\233X\\354\\233]E\\325\\2277m\\006\\355\\300N8U\\261\\355\\006E\\3666\\313\\000|\\000\\034\\221\\243\\343b\\034V\\272:R\\365\\225\\264\\267V\\374V_\\000\\232\\372\\242\\317\\215\\275b\\303b\\307i\\354\\025&\\365\\213m9\\265\\243\\232kH\\177\\336\\345S\\310\\033\\353eMoP\\251\\003\\350\\\\ZtH\\003\\372\\202\\376\\341\\245\\016x\\005\\320\\3400\\245p\\340B\\230\\210H\\001lQ\\353\\036p'0)\\220\\021Y\\223\\217\\312\\226\\0034THI\\223\\253\\006?\\015^\\322\\037\\300\\343\\011\\011a\\030y.W\\3626d\\345#]+\\364\\032S\\250\\220\\220\\347\\0121\\245\\344\\203\\010\\334h1`\\250+x\\374&\\226\\220\\365\\022\\333\\352\\332\\033<cy\\015Ob\\177\\015\\036\\336?\\217\\213\\357\\315P\\001\\252\\263\\032q\\301\\011W\\034C$\\233.\\270\\217z{\\223$(\\355\\250\\271\\363%\\220\\243%\\326\\354\\345\\301m\\241L\\000\\\\\\323\\035\\251\\341\\225(D\\365\\245\\302\\232\\321\\250\\340\\306\\022\\242E\\213h\\032\\205%\\240\\257\\267\\211\\244P\\325\\344\\021\\007iCb \\014\\223\\373J v\\225-]KG\\270\\026\\235\\003r\\340\\002\\274\\006\\035%X\\0202\\242\\023SZ\\256\\201+\\206\\211\\201\\346\\277\\301\\003r\\324]\\024:h\\303\\025\\274\\000\\302\\003<\\335\\003r\\363\\036\\036\\252P\\012\\241P\\022+n\\345\\256Ds\\035\\205\\302\\375\\011\\224gr\\004e\\245\\257\\260\\213\\343\\032\\320\\336\\034+\\351\\006\\355\\2658\\252\\332\\277\\312\\325\\266)\\327kx\\212\\355\\204\\026K\\303\\347m{Lxk\\264\\010-\\222\\0107\\021l\\007\\007u\\004\\321n\\017F\\355\\331\\276\\337r\\266\\335\\321~\\205\\014\\333\\223z8m\\227\\003\\373\\230\\365\\3138\\301Z\\233\\020\\233\\316\\374\\236M9\\335\\242k\\242\\243LG%g\\331\\261\\200\\364\\024c\\3718\\034HGq/\\034\\314-p\\357Vt5\\234\\020\\325\\244\\325\\332o\\016\\2032\\213z\\305\\300\\000\\3023=\\344\\033r\\237\\355\\320|\\327\\337\\245;\\301\\216R\\003D\\220;\\326\\215\\261\\276\\025\\363\\245\\021\\351\\376*L\\227Z\\200\\011J\\300\\201\\370\\177}\\230\\370I\\304y=\\003\\206\\011\\244\\273&\\332N\\334\\031\\332\\335\\024\\263\\307\\026j\\255\\224\\243\\0313\\325\\006\\305\\200\\014\\025;c\\351\\305z\\264\\010\\326(\\357\\255\\231\\221\\275Z\\324\\233e\\030\\256\\027\\035}\\261`$U[\\0203@*QER^\\245-V\\321\\024J\\016\\030\\034\\340`4\\243\\362\\376t\\016\\314\\345VC\\304#W\\213\\344\\260\\234\\250U&\\370A\\302\\037\\326!\\340>\\237Sqg\\354!&[':K\\230KF\\221\\347\\264G\\313T\\325\\223(<\\027H\\331\\035\\023.pP+\\016\\032o\\230W8\\353\\367\\352\\362\\007\\032sZ\\350\\222\\265j\\204\\371tj\\353\\265"\\257;\\007B\\010|\\217\\341P\\203\\242w\\276\\250\\270\\004\\317\\262"5\\224Rc_'\\343\\243\\261\\213\\203P\\336\\371\\225\\373\\227\\371\\2767V\\374\\2451\\211?\\264\\345\\357-i\\263\\217\\373\\355\\246\\335\\017\\316\\021\\351;\\335\\253\\0033\\200\\037\\3664<\\355\\241\\3754|;\\374\\353j\\233n\\3142GN\\357\\326Y\\203\\033\\327\\177.\\3744\\177\\333?\\032\\002\\202\\277\\235\\333\\363\\023;\\350\\365$\\247\\327\\023\\027/\\207pv\\020\\370y=:\\364KsTWh\\237\\201\\277\\334\\316z\\272k\\353G\\235\\273>\\373\\362\\007\\035\\252_\\2566\\342\\177\\177\\370\\355\\245\\011F\\226%\\325\\2033#?>\\345\\353\\201\\227B\\311\\270\\204\\213\\200\\023gNw4\\332\\034\\333\\243}9\\212\\332\\323\\221\\264:\\264\\207\\263h\\224\\357\\323Q\\352X\\255\\365d9\\352uW\\243\\311<n\\265\\216\\310\\250\\273\\222G\\313X\\034M'\\325(m\\233\\243\\365\\\\\\003*c=j\\317\\321\\021J\\011#>\\263[\\206\\263me\\373][:\\356G\\3316\\030m\\262pd\\316\\212\\266>\\331\\264\\330\\315d$N\\362\\266>\\336\\264\\204\\211\\327\\362\\357|Z\\011\\307\\021\\360g!\\364\\010V\\324\\211\\300t\\321\\345\\262\\023\\022\\264P\\007\\013\\234\\231\\003\\223 \\343U\\240\\256=.t\\211\\256'\\317yyLo\\210\\304\\242}\\243\\2168\\3760\\3668\\266\\252\\026\\034K'\\270\\273cu<\\2578\\234\\343\\360n\\264j\\221\\363\\345\\264r\\306\\2705\\262\\012\\377\\0345\\276\\235\\277\\364\\004|\\266\\346H\\246?\\3658\\250+\\272},>\\017\\032\\001\\275\\343\\363i\\205\\360\\030<\\357\\2647>\\374~\\341\\205\\334~\\272\\341\\212K\\244\\002y\\374\\352x\\270G.6\\362\\333Ss\\006\\342\\367\\3773\\262-\\337x\\312Mx\\316\\317\\267\\247'\\257\\210\\302\\347Mb\\035\\276]*\\004\\305\\036\\034$\\177\\263\\227|n\\3049hM\\0068\\355\\346\\334\\237\\357\\015\\240\\007'\\025t\\341\\317\\237\\263\\227W\\263\\226\\223 O\\334\\323w\\322b\\321$*W\\012\\263\\034+\\363\\015\\252#\\026\\312\\034t\\231 N~\\030\\301o\\226L\\014}\\255\\365R\\301L3\\014g\\015\\004\\345\\262\\256\\233\\251\\346\\247%\\244\\025Ou\\250Ve\\2632\\325\\303g&b\\364\\027vS\\313\\237\\2766wo\\233E\\222]\\030\\006\\036\\001\\371\\002\\373\\375\\303\\025\\272\\315\\251\\212\\237L\\200nxF\\346\\315\\346\\374\\310\\333\\221\\025\\315\\351K\\177*\\236\\341\\014bR\\266:3\\373\\217\\341\\331\\273\\303\\263\\273\\245\\006\\314\\221V\\227\\316vm\\271\\025\\020[\\276\\027\\316s\\243\\376\\313\\366\\266\\273\\305\\367I%\\377\\376\\345\\320\\017\\264\\305%F=\\375y9|tJ\\362\\265E\\260\\374\\0144\\247\\211{\\213\\354t(\\320+\\007\\\\\\204\\360\\341i\\345w\\007.\\377\\223\\304\\315O\\304\\3053E\\323\\320?D\\\\*\\275l\\230\\271\\330j\\301\\024\\200\\345\\252\\204\\002\\276dxdy\\253'\\362cVM\\010.\\012\\030z>\\353\\017Hk\\022Z\\2325\\020\\310\\2763t\\366\\335V\\232[\\303c\\274)4\\254\\356b\\2751p\\206\\267\\323z\\320\\337\\017\\304F\\356n\\016\\362\\373\\253\\004\\3171\\254?\\260\\317\\341I\\365\\376\\204\\035\\352\\346\\314\\014\\230\\350;\\021\\367\\352\\014\\370\\227\\367\\347\\0055B\\374\\230\\372\\177\\313\\360\\237'\\303\\277H7\\250j\\317\\244\\373\\350\\274\\356\\263\\305E\\256\\317W\\277z\\355\\311\\303\\276\\335[\\321\\323\\321\\270 \\354)\\016\\263$+B\\273xw\\010\\341\\247\\264\\311\\304&\\261\\021\\376\\254\\342\\317\\003\\2549\\260\\373\\365\\005X\\345\\015\\264\\353gex\\225d=eG\\3377\\357\\212\\021\\237nZr\\312\\320\\306\\366\\313\\305E\\370\\334A\\261\\233\\003\\012\\357\\212\\337\\236\\0073\\270\\342\\366\\246\\017\\315\\0111\\327\\207W5%\\036\\034\\361\\366\\364\\011\\202\\200G\\024\\373n\\223\\346{\\200\\225\\267fC\\330hs\\324\\314\\247\\006I\\327\\357\\235\\032{:\\263\\370\\252)\\247\\342\\015YN\\0346\\007p\\001&\\237\\337\\356\\210v\\\\\\202;\\315\\001\\302\\357\\310\\365\\356\\275oWG6\\236qu\\202\\377\\256\\330\\237'\\334\\345I\\270\\211hk\\313\\243?$\\334\\364\\305\\021\\302\\302yA\\013.\\215\\213\\342\\276\\335\\336\\266\\247\\010W\\207\\343\\021\\211\\367%t\\251)8\\336\\236\\216C\\214\\265\\227x\\245ic\\302\\024\\026\\203\\021\\306\\024s{V\\247\\321\\242[\\214\\312\\375P\\357\\266\\315h/\\016\\207\\373\\343f\\223\\341\\213\\266%[\\253\\226m\\344\\335\\177\\205#U\\030\\233\\227\\346\\370\\245?[/\\334-\\2369\\213\\012<\\255\\365\\035\\347\\0009\\273\\022\\213\\373\\207\\327^\\366\\317\\004\\362\\242/n 4'[_\\011\\336\\303\\002\\217\\244\\365\\341\\371^?q\\372\\377zW\\236\\010N\\034Lq\\363\\034\\351\\3761/\\244>s\\360 \\364\\213\\034n7+V\\0315\\030\\264d$+\\330d1\\032f-\\221fL\\317s\\203\\254'\\305\\372a\\323\\335\\004\\355\\211\\330>\\210\\344\\326\\037\\367\\252\\244\\310\\333\\255\\226\\267V\\272\\376j\\302/\\226\\032\\241v\\360b\\352\\243N\\365\\2571g\\220sO\\247\\347\\375\\245\\376\\310C\\015{\\317@\\377q}F\\341\\351\\000\\267w\\205B\\377sn\\207\\340\\332\\266\\376<eF\\004\\315\\212%\\234\\330/PG\\372c\\236\\312\\342\\302\\012Vu\\336\\030H&\\251\\371\\334\\261\\250\\336r\\312cs\\216\\350\\372\\233\\021\\375/\\362R Y\\3152\\313\\354&t\\376\\011]\\357(\\021\\372O\\306\\343S\\371^%{tuX\\341\\325\\331k\\357\\317/\\374s\\035\\312\\277m\\316\\237jsN.\\311\\257\\217{~8\\272\\331\\034\\001\\372\\210\\213\\376\\343\\351]^\\366\\256\\020tm>b\\266\\0133Ao\\251\\363\\031m\\334\\245\\207\\357\\303j\\256\\034\\240_U O\\306\\363\\217\\03669Y\\250g\\316X\\3506\\237\\273\\321\\337\\306\\037\\273\\207\\023\\333\\325C\\370\\315\\375\\367\\240\\015\\014\\033b\\303\\233\\336A\\337\\357\\333M\\304~},\\367\\237!S\\304\\372\\244\\245\\360&\\346\\015\\305\\356P\\373C2\\205\\217\\3449\\2430pRQ\\224\\356\\214\\256\\325\\265\\3404\\263a;\\036\\214\\310\\343\\330lT\\353\\002\\321\\002l\\016'\\005\\265+jP\\270\\030\\334\\370\\036\\027\\203\\220\\226\\027J\\017\\215x\\267\\222\\2235\\021\\354\\326\\276N\\353\\270\\347\\353\\032\\243P\\365\\222\\365Mz\\206\\367bB\\361\\244\\0207\\327r\\022\\244\\0138\\326K\\365\\203\\022B\\300\\017\\254\\310\\310\\213=\\026Z\\346\\277$vo2\\240/VR\\305/\\276\\231\\304\\277_\\372\\240\\313\\363\\324\\207Gr\\377H\\362nd\\355\\373\\023\\314o~\\006q\\333\\307\\034\\002\\036\\236\\030\\3505\\020\\274\\013$\\276\\375\\311\\034\\364\\267V\\376\\023\\264\\362\\3754\\255\\037\\323\\360gN\\330u\\000\\374r\\011\\024>\\202\\367\\037\\357 \\236\\260pQi\\037\\266\\242\\367Xa_\\261\\327\\373\\363\\241\\177\\340+\\234\\324{w\\360\\032\\231\\337\\034\\352\\374\\365\\352|\\346;\\005\\011\\203\\343\\017\\214\\307)9\\202\\366\\336\\0064\\232\\200\\370\\241\\372\\376[\\030\\376[\\013\\303\\035\\301\\177\\346\\323<z\\353\\336\\025yW\\006^FP\\245\\336\\357Lq3\\265\\317\\014m#\\203\\325yw#\\247O\\037\\251\\3517\\3407\\243\\311=(\\235\\037\\276\\363\\037\\217\\3372\\312"\\201\\347v\\377\\374\\265\\347\\372<92>\\274\\000\\311\\010n+\\357\\236\\217\\236~{\\3654\\031\\355\\255\\326\\037\\242\\253|\\224&\\374h\\344\\340\\372\\240\\360f@\\332\\017\\367\\257GcC\\005p\\036\\220F\\3562\\023WS0\\337t\\323\\017\\317\\255\\007@^\\363\\011\\357u\\341=\\305\\356zu\\2174\\000\\340\\324\\272w\\371\\272\\017^\\000\\327\\226\\355\\030eX\\\\\\275\\212\\274G\\037\\210s\\037\\264\\367]\\363\\276\\336dS\\036\\324\\376q\\240\\366v\\352\\375\\343\\374\\346\\037v\\355/\\365\\376T\\236>r\\264\\357\\037\\376\\036G\\033\\246{s \\200\\246w\\227t~{t\\235\\246z\\273y\\177.\\370\\327\\273\\303\\303\\337\\212?9\\300\\374<\\277]^\\2376\\376\\306Y\\247\\234r\\357\\224h\\375\\224\\373Q\\032\\332\\352\\251\\272w\\207\\310\\237r\\365\\275\\267\\261\\226\\016|\\355\\026N\\2771\\213w\\352\\007\\262\\321\\345%\\300\\303Ow\\342\\364\\251Q\\346\\370\\355\\364\\217\\277z\\020O>[\\272u{=q\\377\\220\\245#\\365\\213\\245\\263\\374\\035\\015\\323g\\262\\313Q#\\254\\335\\315[&\\343\\366HJ>\\342j\\260\\012{[\\337\\332g\\344\\354\\350\\340\\203\\264\\304k\\014]v\\322\\370_a\\301N\\304\\377\\203\\251\\261\\237\\017\\333\\326wl\\363\\024\\032\\033;\\374\\366t5\\273\\001\\316\\3118\\361\\3079\\233z=\\212{\\367\\376\\211O?\\036\\366}\\374\\302\\027'1\\313\\374[R\\026P\\207\\2749\\200\\367%?\\003\\2466m/\\011\\341\\032\\202\\263\\300\\216\\232\\317G\\240\\277\\000\\207n\\023\\370\\305Ks\\371\\362{\\337\\377t\\242\\001\\327\\364\\353\\243\\221\\251\\223\\004\\237\\245l\\3648\\245\\374\\316\\005E\\337\\271\\240\\267w\\3163\\\\N7\\257\\321r\\355\\217~}O\\246;\\241+2#\\006j\\027\\346\\341~F\\207M\\011j\\214\\317\\275%\\232\\213\\007\\335\\275\\214\\371\\375\\366:\\012xB\\300}7\\177\\322\\247\\367\\231\\2727e\\004\\263\\357W}|g\\032~\\324\\305S\\250\\361\\263^=\\371\\221\\373\\355\\272\\206GJ\\365\\245\\373\\266r\\342<\\032\\361s\\300\\377\\321\\200\\276\\200{\\015|R#\\266?\\032\\324\\354\\364\\257\\227h4w\\240\\275<c\\031|=q\\313\\367kP\\2155lv \\013\\277\\275\\303m\\347\\363c\\021}\\360j\\023\\217\\337\\207;g\\221\\3505\\237+3\\216\\276\\017\\231\\336\\217\\236\\236F2\\317\\324:{ 7\\204|?\\352\\371a\\303\\340\\327f>\\325\\3358\\355\\333\\020\\352\\315\\014\\202S\\343\\376\\014\\323\\302\\235\\206=\\316\\223\\254RO\\211\\203?fZ\\302\\263i\\351w\\016"\\315C\\323R\\213\\244\\324^9Y\\373\\300\\345\\006\\356L\\371\\232D\\265\\371l\\251\\366\\035\\314\\305\\011O\\233\\333\\026q\\0348\\354LMbn\\326\\376W\\230\\227\\023\\302\\377\\311\\030\\351\\207\\266\\347\\247D~4>\\377O9\\335\\277R\\343G#\\205\\367Z\\354Uga\\327\\372\\351u\\332\\254\\347[\\226\\035\\377~\\326>\\265\\001\\270\\2607n\\360/\\277\\366\\336cE6\\0102<+\\034'I\\212\\327\\345uW3\\033\\256=\\275+\\271\\036\\374=\\347\\346\\277p\\336\\\\\\375@W\\237\\010\\370O\\312\\305\\203\\021\\365\\033\\330oSU~`\\274\\261G\\306\\273\\321\\3627\\201\\322\\015\\367\\237\\231\\377\\\\\\321\\371o\\223\\251\\316\\257g\\242\\2343\\312\\240\\317O\\017\\2127>Z\\376n>\\301\\035\\314\\330I\\356\\005\\271\\367\\203\\006\\334\\316 \\270\\217\\276n\\342]\\3641\\240S\\323\\036C\\312.\\201\\362\\035 \\030\\033\\206\\211\\233|\\340\\005\\274\\234\\334\\200\\033/\\362z^\\\\\\363\\370\\373\\031\\306\\373\\300\\367\\243\\362\\277[g\\337\\256\\344}\\034\\376\\202\\216d\\240\\225\\211\\371\\355\\351m\\372\\327u\\342\\365*=\\365\\272\\302\\367j\\303\\324WV\\273\\276\\371\\347\\251\\037\\217<\\355\\375y\\310\\361\\000i\\014\\361\\353Q\\307D3\\345S\\305\\011\\366\\260\\314[\\247gz%/\\233Q\\233F\\315p2\\241\\322\\253\\3424\\250\\024\\361\\023\\005\\221\\361\\366\\236\\344\\332d\\343\\004D\\252\\246\\020\\013|\\273Z\\243\\204\\273\\236m\\273q+h\\343\\325d\\344bLU\\207C\\026.\\017O\\263V\\342F.7\\227K\\325\\225\\361\\216\\354\\343\\223\\266\\233\\014\\233I\\377\\344\\002Q\\026\\036\\262>ok:Y*\\236\\305j\\270\\270\\305\\253\\251\\212TS\\022\\374.\\344z:O*i\\236 \\242\\232W"\\225T"\\271\\236\\242E\\323\\277\\320\\242\\027k\\213\\355\\354u6\\214l\\265\\023@88\\305\\201rA!R.\\370\\0155q\\036\\364EJ\\353K\\024\\235\\211\\024\\016\\276\\023\\330\\276\\177\\014\\377\\330\\350\\332_\\257^!G\\331\\300\\177\\007r\\365\\027\\317b\\372~\\341^(\\277Ow\\002\\374P\\025f\\257\\211\\217\\327<>\\372AN\\353\\241&~\\254\\264\\377f\\371\\277Y\\376Oa\\371\\237N\\242\\370\\376t\\305\\364_\\034?\\003\\354hz~h\\335\\272\\210\\215}9\\2273\\236\\337\\276~1L\\230\\004\\374 \\313{\\227+\\274M\\353\\336f\\201\\177m\\350\\353.V\\0345i\\321\\327\\3664\\203\\004\\327\\015<\\245\\216>\\\\\\024\\177-\\363WI\\337?q*\\352\\235\\004\\376\\376p\\221\\270d"\\213*\\017x\\034\\316+\\330R\\335\\361 Z9\\353\\304%e_\\266\\313\\270?\\324\\321\\345,@TyL\\031\\355\\264^\\375KB\\304+N\\375gf\\350\\375\\310\\007\\376\\205\\274\\373\\247\\253v\\\\{^WN\\310\\3034\\016\\\\!v\\345\\222\\334\\247\\256\\315\\346\\363h\\276\\347\\010\\376\\374\\177a\\351\\326\\266U\\031\\254L\\015\\361\\331\\376\\340$z\\370\\257f\\213\\237\\257\\340\\272\\246\\336S\\263f6\\267\\213\\317\\360f~\\012~n\\362qw1}\\347\\242\\001~\\004\\342\\365\\346\\015\\254\\267!\\276{\\242\\337\\302\\014m\\327\\216_#\\352~\\363\\371\\205ZO\\257}\\216\\014?\\236\\234 \\274[\\211p\\005\\240\\260\\276\\275K\\002\\1770g\\361\\375k\\237\\341bE8 \\364R\\370\\351\\2677\\345X\\237\\216)x\\305\\030\\314\\254>\\241o\\001\\332\\243^4\\303\\253\\325K\\323\\207\\227S\\0263\\177;\\337\\340}\\335\\217J\\337\\214E\\2756\\3734?\\356S\\231\\003\\265\\233\\200\\007\\317o_\\031\\320\\362o\\037\\212\\336k\\335M^\\370L\\362\\317\\357\\226Y\\274\\001\\273\\032\\325DOy\\215\\313rb\\230w?}\\353!\\347A\\303\\327e\\203\\267Ab\\203b\\030\\200\\222\\347\\307w\\003\\216\\306\\235A9%\\243o\\314\\333\\325\\342\\331\\206\\330\\037\\345e^\\215\\350E\\265\\030\\306\\000\\201\\267O\\266\\354\\347&\\314\\370\\234\\027\\345\\346\\362\\372`\\200\\242\\335.\\270\\031\\333\\325\\363\\365\\362\\223\\346\\316\\245\\324\\306\\200+\\274O\\245.\\355\\272/\\375\\321L\\300\\3679r\\320\\316\\3027\\215\\360<:\\034\\371\\226\\025\\332\\337\\275\\354\\333\\325\\300\\340\\005\\204a<P\\247\\315\\335\\023\\300W\\271n\\330\\025y:\\375\\371\\376\\344u\\236=\\364\\331\\353>{\\275g\\017{\\366\\372\\337\\036\\017(^\\271\\010\\267\\271\\353\\017\\363s\\327i\\215GY\\215\\317\\235\\001\\314\\202\\235t\\305%\\225\\376\\266p\\035\\266\\375\\304X\\315\\344\\007\\257s\\305/\\235\\341\\3607p\\347\\351\\263m\\371\\305E\\233\\275=\\306\\272\\340)z]\\036C\\340\\235\\217\\312\\367\\007\\340\\351\\025\\006n\\333t\\327\\361M\\022Z\\240\\3745\\374.\\012!|\\004\\177\\320\\377\\355\\001\\346\\276{\\275k\\020\\235>\\000\\321\\373\\010\\304\\360\\003\\020\\3305\\010\\270(\\314\\303\\036\\200x\\367R\\377\\0320|\\247\\377Q\\265\\035\\024{X\\357m\\361\\253\\014SzIp\\301\\234\\020d3\\014\\376\\371z\\257\\011\\322\\333a\\233\\335\\267\\353\\025\\337s?\\262\\363\\347\\1774\\177\\236$\\273zR\\222\\310\\210\\377\\361|\\275\\010\\274\\311\\320\\371\\300h\\372\\346\\367'\\240*\\237\\315\\304\\262\\237\\213\\3429\\330X\\317\\271\\021\\245\\347\\361\\3243\\310(\\211\\223&n|\\376\\007\\231\\224\\231og\\020\\360?\\276\\303\\267\\036\\255!o\\034\\221\\357\\000\\356\\265\\232\\276\\336_\\3012r\\017\\370\\264\\237P\\247\\357\\030\\233\\037\\017\\303_\\374\\232w\\351o\\200\\206&\\341\\370\\0167w!m\\276+\\215\\3545\\275\\010wn\\003\\230E\\236:\\237o\\323\\347wA\\357\\037\\361\\232\\232\\351\\300\\022\\211\\257\\233\\254\\360LP\\271?\\346\\\\\\027\\227\\245\\021\\322vCC\\347\\232\\253\\006G\\245lWXR\\022\\032A\\333cJDe\\326\\307\\207\\301tCh\\223\\2221\\371\\215\\272\\222\\206\\363\\301P\\335\\305\\251\\020\\026\\247\\365\\302\\357\\346\\366>\\354\\344?\\227h.\\303\\320.~>\\257\\367{\\362\\210V\\357\\211\\322\\275\\036h}D\\224\\306h\\275\\255Y|U\\2060\\363Y|{\\257g\\276>*\\026^\\257\\355\\2752\\340\\257\\245\\232\\321\\020\\353\\303\\326\\236'\\203\\335\\277\\327L7*\\214Mh\\277W+w\\216\\336\\225\\246>K\\300\\233\\337\\010y\\263\\021\\373\\267\\304#\\274~\\237\\243=)\\202W\\007/\\266sh\\023\\337\\266(|B\\316\\332\\343\\015\\314\\371N\\363\\342\\331w|u\\303n\\027y\\216\\260\\337\\276;W.\\320M\\202\\376;\\264\\372@\\244\\214oW\\241\\314+ \\210\\205S\\314\\372\\355\\235\\005\\006\\370\\006\\336\\026\\010k\\237?7\\377\\001'\\2552\\262\\030\\274\\365\\000-\\217M\\362Y\\023\\\\\\355\\362\\362\\256\\321\\020\\374\\0230\\311\\237O\\177\\337\\345\\000\\276>\\366\\331o\\251uo\\255\\032\\240\\360\\277\\302/B\\373\\004\\373\\355\\262y\\372\\371\\366\\351\\353\\345\\267\\253\\371i\\247,\\365\\011Z\\031\\236\\012\\336\\014\\231\\3744\\005w\\223\\376\\1777;\\343n\\242\\336\\271\\236\\253\\252`m\\327\\014\\002\\375\\356\\357o\\315O\\\\\\367\\246\\375\\315\\365\\025+\\217z\\277\\235\\246\\2655&\\253\\261X\\317\\015\\273_\\335\\370v\\212\\\\O)\\236\\353e\\274\\017\\346h\\275\\265\\244\\341\\313\\323\\312\\247\\263\\277\\365\\375\\266\\236\\247K\\010qm\\267^\\213\\300\\356^\\267\\004^\\177\\273K\\3607_\\177\\320\\214\\327F<!\\017\\232\\321\\354{\\370\\250\\025\\015F\\012\\257\\2146\\357\\225\\022\\366:-\\002\\372`?\\236\\006\\362\\012\\344\\264\\215\\321\\275<\\\\\\207\\035\\335\\333\\023\\335>\\024\\223\\033\\322}\\275\\343\\304\\367>\\347w\\030\\262=\\235\\233\\001\\231\\356q3\\256\\213\\231Fz\\027\\013\\377pFf3i\\346\\203~\\334rZ\\023\\306\\031n\\354;\\207\\233\\365\\340WU=F\\302\\373G\\327\\220\\316\\323*/W\\320\\211z\\267\\011\\326\\357\\206~\\242\\377\\217\\231\\377*Bl<\\017h\\356N\\343~\\247\\267\\177\\300\\260\\327\\2576\\257\\234_G\\276\\203\\306\\237\\210pj\\363\\003bY\\315\\347\\373\\347\\023y\\325"+\\315\\242\\314\\354ws@\\257\\365\\360\\265\\202\\301\\220\\267}VO\\0213\\366n\\357\\253\\263B{\\372\\014#]\\340l\\346\\015\\317\\334s\\243c\\332\\203\\315\\203\\335\\265\\034\\307\\300\\020\\344\\306\\371\\373\\300\\202\\177A/v\\361\\353\\265\\305jn<\\216\\363\\236>\\301 QJ\\300#\\373\\301\\374\\364{ax\\277\\374\\342\\325\\332}\\002\\214a\\204gH\\267"~\\312\\364>\\001O\\011\\316v\\013\\362\\177\\306\\216]9%\\260Wo\\031\\300sWT\\020M\\337\\346i\\266e\\224\\202\\362p\\343\\204wO\\316)\\004\\360\\312\\363\\325\\367\\353\\230n\\330\\373\\355\\235`^e2N\\356q\\357\\214\\337K\\010o\\301\\237\\353\\240\\022.$\\374\\234\\3033K\\200#\\370~\\321\\342\\347\\023Z\\257]\\204{\\316\\371\\267s\\251\\247\\177\\273\\233\\257\\177\\313y\\247\\031\\374\\237\\233\\324\\321\\363\\351\\017x\\347Va\\234\\014@\\363\\354\\316\\377j\\342\\364\\367\\372\\271\\017hw\\011\\\\\\337?\\203\\373;\\177jF\\036\\306\\266\\001i\\364\\355f\\236\\301\\303\\251)\\267\\217^Y\\344\\336qCo|\\255Ns\\006\\347\\373I\\013\\337\\257RAO\\306g\\200:;\\213\\215\\360\\371\\346\\366\\377\\345e\\266\\363\\364\\377\\374\\373?\\334$\\365\\000\\337\\265\\333\\377\\370\\277\\257\\004\\360\\017\\2050\\315\\265p\\012aHI\\314[\\177lM\\016\\363:Syt\\354\\201\\020\\206\\2429\\271\\303t\\373\\301\\240\\304\\350\\201.\\254lM\\236\\341$\\337\\255\\204\\201&%\\301\\242^\\004\\243`\\034\\313\\343\\301f=\\3626\\324\\201\\362\\244\\225\\273M\\225\\311\\216\\011\\223\\236\\210\\262\\256s\\340\\307\\336v7\\\\\\364\\014\\327\\311\\334\\231\\274\\352\\362\\005/\\263\\233\\304\\211\\310\\261\\213\\267c\\\\\\010\\362\\026\\217o\\231\\273\\204\\362y\\216\\300i\\360\\351\\351\\321\\254\\202\\177>\\026\\272\\020\\251Y\\324\\360\\022\\026\\331O\\302\\242\\017\\332\\004G%\\336\\015\\345\\236W\\236<\\240<lp\\336\\020\\376\\371sSms\\343\\277\\011\\023p\\227%\\376\\375b{\\314\\005\\027\\301e\\317GF\\221\\037\\345\\014?!\\217\\251\\264&Ya#t]\\274p4.\\334\\032d"\\220\\244\\316\\345CQ\\\\\\240\\373\\326\\201t\\207\\271\\277\\014\\275\\341qZl\\275-\\215\\323LdsIJ\\311\\305<\\233\\363\\022\\255s\\265\\267<\\344\\276\\344h\\023\\236\\341\\267\\324\\221\\2157F\\333 \\212^\\253\\302K\\342H\\265\\012\\267o\\014\\325E\\260rz,=\\037\\365\\353\\210\\252\\245\\343\\254;\\342\\366t{6\\243\\212\\025wX\\244k?\\336wz8\\306 \\241\\301\\017\\2235\\343\\336\\307\\317\\377\\012&\\202\\352\\363_\\3007\\221\\341\\207E\\362\\345\\225mN\\327\\177\\016\\337\\020\\315\\372h\\242=\\226\\204\\351\\037\\342\\033\\212h\\326G\\267\\317\\037\\237\\3331\\243\\375\\006\\355\\227Yz0\\035\\012|\\035`\\366j\\213Z\\333E\\253\\275\\357\\301\\263\\025\\372\\266\\343'}\\326\\334\\011\\36667\\372\\273\\241C\\025\\013q\\264\\343\\344F\\0335k\\251q\\232\\212P\\266\\311\\315L\\233i\\002c\\317&L\\272\\246\\002\\274b9J\\231\\364\\272R\\312O\\213\\2761\\362Dk\\341\\207\\263\\241\\033\\204\\273|,\\362Q\\321\\333\\331\\007\\233C\\272\\211\\244J\\001\\231\\341\\234\\326\\036\\254\\347\\313M\\225"\\307c/\\233\\257\\364q\\315\\264Gk\\274\\203\\215\\347l\\257\\325\\223\\030EJ\\034\\215\\020\\305)AHz\\374_\\304O\\220\\260\\377\\002~\\212\\355*\\377\\357d\\177\\306\\227\\024Z_\\012hZpI\\\\V\\346h\\325\\251|_\\253\\335\\000Q\\005\\177n\\367\\375Q"\\330\\362\\212\\362\\004U\\217\\3268\\257\\010\\360\\024\\260m\\273Mqi\\253?\\305g\\374\\270o\\256xE\\325w\\252&\\223\\341\\302'\\266\\232@+\\303\\343\\012\\337h\\236\\275o\\365\\345\\201'\\342\\010\\333\\211r\\251\\340\\022\\354X{\\331\\252[\\037C\\211\\355e\\306~-V\\204\\250\\351\\271\\220\\023\\371j+s8A\\316\\307a\\356\\314W\\345vX\\221Rw\\216\\312\\304\\2660+\\371\\301,\\216\\177\\005{@\\272\\375\\013\\330\\303i\\232\\370\\252m\\300\\345\\237\\305'\\015\\342\\342ie\\376\\261m\\021\\351\\372u[\\304\\003\\340\\223\\012\\356\\355 \\216\\207\\335\\244\\215L\\346\\375\\200\\031\\357\\344\\365.\\260\\367lg\\313q\\363\\274\\033\\030\\262\\033\\267\\360\\001\\216\\216\\312m\\\\a\\222\\220\\345\\306\\214\\314\\346\\266K\\020\\231"\\036\\327\\366*\\200\\007RZ\\201\\256T\\371l)j\\021m\\265\\310@u\\027\\366"E\\247\\301\\177\\215\\032p|\\230J\\372\\313\\351\\354g\\346\\211\\316w\\356\\253_\\335\\027:1\\003\\270\\374\\357\\2424^\\027\\222\\217\\020\\032i\\224\\006\\261\\304\\367cd\\276\\362]\\256\\253\\233\\246\\334\\036\\216G\\035\\272\\336\\011R\\206/\\207\\333A\\300\\260\\350@\\335\\213\\207\\243,\\216\\362a\\345\\225DLK\\226\\254\\206!#XKf\\311\\220H'\\225\\345\\312\\303UQ4\\360b\\265\\346DY5\\3156b\\325\\352\\352\\300\\031\\263]G?\\036\\231>?\\315\\005b>\\236\\222#\\257v\\267\\211<\\3318h\\241\\270v\\260\\024\\002\\003\\303U\\217P\\355to\\224\\232\\372_\\342\\334\\302\\022\\177\\035\\003\\275\\0068'&\\371?\\376\\375\\037\\237\\023\\327}\\304G\\357JMY\\366\\027JE\\276\\365\\013\\245D\\216\\3725X\\376\\257\\001\\343~\\005Z\\332\\375\\025`\\263_)U\\031\\373_(\\265\\304\\027\\277\\002+2~\\005\\226\\210\\277\\212\\261QZ\\376\\177C\\007\\322Z\\015w\\007\\211\\031\\330k\\361X\\345u\\226g#v8\\033gQ\\237\\317\\212Ai\\004\\374"\\212\\373S\\242c\\225F1\\224d\\037[\\037=\\256w\\000\\352\\033\\031\\270rf<v \\371\\213\\003)\\231jMi\\204\\314p\\033e\\200\\016\\334\\260\\336\\013a\\327\\032\\347\\334\\230di5\\2238N\\031\\010t\\307\\223;bB\\251\\244/z<\\345\\327*\\265\\\\\\320^\\251ol\\277\\235;m~\\267\\261bt\\330\\332\\326k\\273W\\016HC\\242Z)F"\\030\\337\\337\\320\\235\\377\\022\\201o\\350\\371/\\226\\370\\350\\227$^\\374\\205R\\306\\376W\\204\\024_\\374\\232\\214\\332\\277\\242\\212\\304\\031\\375K\\272(\\3755`\\354\\253d\\355}\\313\\376\\223$\\3534\\241\\217L\\226:\\341\\375!\\311\\302\\371\\223$\\314F\\233@\\025\\032\\316\\\\\\321\\247-\\251V>*\\211r\\302\\210\\262\\313\\3547\\251;\\326\\266\\330d\\317\\364\\205A\\316\\310+\\201\\311\\247v\\205\\262\\355\\272<\\204\\021;\\213\\373\\350r3\\350k-\\3430\\316\\347\\033*\\316dQ\\312\\306\\320m"\\275\\203?\\350"\\302^\\350\\310\\332rA\\365\\006\\3561!\\247"\\021\\254f\\252\\236qe\\031\\345\\366\\262\\355\\013Z\\333\\026,vT\\257\\010\\243\\203\\374\\327\\370U\\015m\\376\\245R\\222Z\\316/\\360\\317\\214b~R\\352\\337N\\260>\\375B1\\000\\354W\\212\\001h\\377\\373\\327\\240\\375\\357W\\336\\266\\022\\263\\204(\\377\\357\\022\\016`\\257[\\011\\035\\002\\0206R\\270HXL\\273\\325\\031\\320y[\\016\\374$\\367IBSV\\334\\221O\\022=\\361\\242\\312^\\365\\335*\\012H\\233kMw&Jv\\230x\\0373\\250\\275\\015\\345\\265\\206\\024\\023\\24193\\332i\\207\\303E\\007\\235\\373\\203\\322c\\030\\227\\332vF\\033lHW\\253rw\\012\\010\\376\\013B\\277\\013\\352\\377T\\356}z\\340\\370?\\012\\006\\336\\315/\\354\\3667w\\323\\345n\\327\\001\\336s\\324\\325\\2737%>\\247\\231\\037\\027\\347E\\245\\357\\367;)^\\340`\\025\\034\\262x\\206\\027\\006\\270\\177s\\3434a\\363\\317`\\306\\311i\\233@\\242\\316\\247\\325\\356\\0171#\\373\\346\\305(h\\251\\213\\021kaY\\212n\\222\\335^d\\016\\352\\250\\214\\265\\371j\\231a\\202\\334\\226\\320(n\\317\\262\\036\\312\\273\\235\\236\\236\\027a\\337\\030"\\302\\250\\273Z\\371\\213$Y\\310\\330`\\021\\247\\223x\\3313:F\\267\\257\\213\\331\\200\\254\\3344\\302f+\\266\\032\\014\\243ik\\332v;\\305 \\306\\246Y\\035\\364\\217\\342^\\214\\355A\\233\\252\\372\\255c\\201\\011}\\327\\302\\037zA\\326\\305\\013\\032\\233)\\203\\273bM\\303\\323\\015u\\317\\213\\344Y\\273\\215j\\346\\010Yth\\216\\314&e\\341#\\353]|\\230*\\331f\\242f\\313\\331\\230o\\227A<\\334\\004\\307M\\026/\\250\\266X\\245[y\\272i\\021\\250w\\330od{@\\314}v\\250G\\353\\2356\\235\\270!\\216ddf\\362u\\352\\223G\\244\\007\\017\\355\\305G:G\\215\\372\\352\\301\\243\\350\\007\\272\\277\\031\\260\\207\\313Y\\377\\032\\341\\201L\\3633\\301\\271o\\302\\265\\320\\274\\036ny=\\320\\334\\214\\2215\\023\\003\\340\\364\\233\\023\\327\\302\\311\\030\\220\\325\\313\\354\\237\\032`|7Q\\346z.\\361\\375\\370\\350\\325F\\371py\\3676\\177\\271\\214\\357\\276\\237w\\014%\\357\\032\\326\\375\\034\\245\\247O\\246\\361R\\306\\225Q\\230\\336g\\210\\262gx\\343\\355\\362vZv\\263\\254\\347\\335\\013py\\317\\315+O\\306\\243\\245\\3007\\233\\216<Zp\\212\\366\\341f@\\327\\303u\\335fx\\356f4\\357\\351z1F\\323\\307'H\\266s\\227\\356g\\352\\376\\031\\313-N\\203\\015\\347\\215E\\311P\\246\\335\\361\\037\\322\\030\\325Ic$\\322\\246\\335\\332g\\030Z\\254&\\2269k\\207\\305\\244}\\310\\205\\242;\\312f\\231ul\\327\\0055\\037\\356'U\\225\\361ube\\355\\375\\256\\336\\036\\2558\\033\\356\\007\\255\\270\\330\\264\\313r\\325\\366\\207\\203\\366\\241\\230/F\\316\\246{,\\217\\255\\241=\\325ZN6<\\356\\307\\355\\012<\\267\\315y\\333\\003\\242\\273\\035\\254\\210\\020\\274\\023\\215\\300\\365\\360\\330\\336\\026\\343\\2269\\034\\003\\230X7\\234\\264\\247\\373]\\007\\031\\3557\\235\\366~\\220\\325C\\262\\364\\3149RO\\3700)\\272mt6i\\007f\\273\\215\\215\\244n>j\\203"\\002\\273\\231\\014\\332\\221\\344\\200\\213\\356\\010\\223\\324I\\004\\332\\327\\236\\035\\007&\\250\\257\\332L9}\\260o\\0376z\\320\\237\\036\\217)(\\347\\233\\263\\0221#\\324\\035\\306\\355t\\024\\267G\\316\\374\\2707:IYN\\332\\271\\021\\311U\\331m\\347\\246\\3439\\331f;\\264\\333\\273^k\\023\\037&\\274\\334/\\273\\305\\256\\000\\362\\234m\\330\\301l\\2149\\346\\261\\215X\\203\\252je\\355\\243YN\\372\\323\\2157r\\006m/\\337\\267\\363a+k\\331hV\\015x4\\333t\\311\\226\\263E}s~\\350L\\007\\355m\\266\\237v\\362Vk/\\036\\264\\343\\360\\310&fl\\364[Y<\\334SE8\\021\\206\\306\\244\\333\\266\\206+\\240\\303\\367\\213\\201sl\\3573#\\010\\305\\014\\351\\216b\\261\\220\\266\\273t4h'\\243n\\037x\\014Ro\\277\\001uK\\203\\\\\\352\\266\\367\\316\\254\\275\\311\\251v\\307\\232H\\236\\200\\266\\016\\023\\233\\013\\262\\314G\\207Vv\\034\\024)&\\015\\346\\276\\200\\366\\335l\\345w\\213ln\\002:\\357\\313M;\\263\\332\\200\\366\\355\\366N\\0348\\007{,\\036\\213h\\207\\315\\346\\303\\262_ m\\247\\333j\\317\\272\\243 \\247\\252`8\\226\\013q>\\356:q;\\260\\306\\220G\\322z\\203%\\210u\\314c\\211\\352\\347\\371js,c,\\263\\262\\022mQ\\036\\326\\332\\347\\307QlXYVw\\354\\311\\261\\345L\\304A\\373\\330\\256\\006\\235c\\273}\\234\\271\\342\\261=\\264\\227YU\\010\\363\\321>\\036n73\\322\\031\\354\\363\\216\\324MK\\243\\003l\\361*\\351L!\\316\\235e5]a\\035s\\201Y"\\340\\223":\\240\\303t\\350LVJ\\317v\\352\\221\\035\\355\\340\\321\\366\\307\\321|s\\314\\352\\244\\232Lg\\230m`\\003p3\\336\\241\\365aP'\\340+\\346dY\\\\e\\352l4[\\241\\255\\375~p,\\216\\325\\336\\352\\316\\320\\375\\030\\313F\\240-\\355U/\\026\\2630\\227\\000.&\\273Qe`Go\\340\\370\\201\\345\\264\\213r2:n\\322\\244[\\304r\\247l\\007\\3650\\233\\264\\332\\307a\\260k\\365[\\373\\011\\033\\354\\204\\035p\\331\\332\\211\\2309u\\351\\014\\353\\315\\242\\332M\\366\\2527\\330\\357\\206\\263Y7,\\250\\2765\\004\\370\\036Hn=\\260v\\325\\206)\\3323\\366\\020\\014\\267\\373\\321\\336\\351\\036'^\\342\\354\\016\\355\\312\\232\\355\\016\\366\\334D\\366c\\300\\335\\335\\240\\006\\370\\364\\007\\323v=\\034\\254\\220Q\\224ur\\345\\030\\011]\\262k\\305\\362q\\264ZE\\223\\275\\013\\372\\326/\\315Ar\\234\\244\\273\\301tP\\002\\334\\232\\003{\\237\\034\\234y\\033\\264\\261\\025\\025N{d\\243\\330\\321\\344\\213\\201}L*q\\305\\226\\303Xl\\315b\\014z\\012p\\023\\341\\001\\027S\\021\\364\\204e\\342m\\023\\341\\277?\\177\\352\\007gf]\\342\\000'|\\363\\233\\223\\027\\2645\\326{w\\206oZ\\335\\266i\\012\\275B\\250\\375A\\253\\247\\006\\370\\010\\307\\324e\\\\\\036\\370\\205\\312\\256(\\337Z\\232j,\\365\\333\\333\\205\\\\!\\255\\274\\335v\\210\\345q\\347\\307\\243\\334\\024\\271h_0\\355>Z\\346\\375\\314\\251\\246\\006\\275^\\315&\\373\\325AD\\323c<l\\015,\\226X\\027=K\\307\\226\\336\\026GGV\\327o\\251I\\345\\266\\255\\336|[\\256F\\255\\221#W\\361\\2703\\031&;\\217\\313$\\300\\021#d\\264\\230Z3\\211\\240W\\246>\\\\\\017H9\\034\\323F4\\232\\025m\\2713m\\013\\331J2-O\\315\\343\\222\\341\\364\\356q\\231N\\224\\266,\\342q\\340-\\367<\\336\\231\\327\\213]\\215D\\236-\\004\\333\\341\\260\\273\\333.\\352\\321dmse\\240\\004st\\326\\315\\310\\302\\235\\221\\354\\334\\361'\\363R\\026\\2663\\252\\353\\353B\\207\\302\\217\\373~o\\272\\244\\320\\301\\202cG-\\257\\255Nq\\225@j\\257\\012\\302`\\270\\342\\242h\\342\\207\\323\\264\\305yB\\177\\305\\310S*#\\017T\\213\\352\\330\\345,\\0313\\030\\302P\\311\\214\\321\\227\\262\\340\\034\\271\\272-\\265G3\\334/g\\335D\\250\\242\\251\\270\\326F^U\\016\\013\\334\\033\\373\\353\\302\\366\\255i\\267\\267\\334(\\005\\243\\273\\035\\253\\217Q\\213\\270\\325\\037\\373\\274\\035u\\305\\214&\\346\\254\\336/\\014n\\266\\243\\366RG\\251\\202\\272\\346\\003\\305\\\\\\330\\342\\304\\337\\3735]U\\271\\233N"\\305\\021\\312p\\267\\335E\\355-\\321\\313\\220\\341\\376@\\246\\275B\\364|@\\350)Cn\\321I\\317\\344\\274\\201\\340\\221iK\\343;\\233\\3556\\324\\333\\375\\365p\\202e\\375Y4\\225K6\\340\\350\\243\\212\\355\\027\\010!.\\211\\345T\\310H6d9\\233L\\262\\335\\336\\363\\355y\\030a\\251\\262\\010\\334uiL\\323-v\\234\\254"\\177\\027LX\\233a\\275j:'\\024%\\354\\321\\021/\\320\\273\\005\\237S\\026\\331\\225\\207D\\247\\277\\233r\\363\\274'J\\266\\253\\266\\211\\356t\\225\\030\\261\\203u\\363!/m\\326\\022b\\316\\214\\230Rg\\207\\356~\\206\\360\\213c\\273W(\\314"\\031\\225\\255R1\\253\\215\\016BW\\253C1\\207\\241\\2121\\307\\356.\\303\\364\\332\\012\\026\\363vw\\331Q\\362C\\332\\331G\\214\\332\\307\\331Yg\\276\\303\\223\\360\\250\\012\\255\\321\\266/\\310:&J>+\\364{9\\313q\\331@k\\271S\\256\\227.\\215Ib\\354\\234mA\\317\\024\\213\\233Y\\224k\\371\\314\\032\\363\\024\\362`,\\331\\015E\\035QR\\220kk?\\\\O7\\330\\304$\\213\\270\\244\\333[\\231\\300]\\234\\306\\345\\220\\311\\211y+\\3349\\362\\275\\267\\376\\027,\\367l\\234\\305\\323&*?Y\\351y\\347l>\\334-\\367\\245\\007\\247\\253\\366\\241C\\374\\336\\025}T\\034\\273*|\\013\\375\\262\\034\\374\\376\\301iM\\335\\303\\312\\373\\203\\017*\\277\\202\\366\\253\\260:\\243\\017\\333\\3669L\\232\\331nw\\360.\\017~\\272\\006\\375\\301\\211\\246 :\\223qQvp)3\\320r\\342\\367\\366T5\\234M\\016\\303r\\233\\000/.\\037H\\233eg\\277\\355\\265f\\033t\\224\\017\\246\\300\\222\\233]i\\256\\001\\357\\252\\034\\224\\224\\333\\223\\306\\012bg\\273>\\360\\010\\333\\326\\300\\356\\356\\217\\303\\366\\014\\270\\252m\\360\\257\\230\\315\\221\\321v\\215\\316\\262~\\253\\210u\\324v\\200\\031\\\\uFp?}{\\023a{\\360xvV\\331\\207q\\233D0f\\301H\\224\\274 \\030\\321\\357UxuZ\\017\\337\\222e\\036\\257p\\347r\\366o\\323f\\340\\227\\033-<\\336\\206#9P=\\303\\\\\\354\\214M\\212\\256Ja\\273\\265\\315\\261\\247\\026\\331vLY\\234[L\\025\\237<,UZ\\257J\\013\\211\\\\\\344Hk^\\260\\216%/_\\267\\247\\330\\224T\\364\\214\\246+w\\177$\\003w\\247{\\254O\\023\\235Js\\025\\326\\306\\031\\001Ow\\346\\326\\3441\\231\\254{\\006#\\3234\\271\\352\\264y<\\344y"_0\\212\\030\\320D\\260\\232x\\207\\205\\304\\007\\036N\\302SY\\003\\012'\\206\\227SY\\345\\323\\276\\030\\213A\\217\\264\\247=O\\223u:a\\275\\035\\273[\\036\\345\\202\\216\\303\\265B\\256EV%0"\\230\\0132\\351jS\\202\\235\\005[\\202\\263dJ\\330\\021\\023\\317\\340\\271\\036\\325\\017\\021\\367\\020\\212\\212\\333\\347\\026A\\344I\\004\\267\\255\\227\\2048\\\\\\341\\325Xbp\\316Z/)\\034Q\\025O*\\204\\003B\\362\\270\\266\\240qS\\301e>`\\374@\\007T\\242\\011\\002Q(\\245g\\261$\\320\\204\\036\\276e\\210\\234\\240\\252d/$\\010\\221\\370\\011#\\373\\342\\017\\332\\277$`\\373\\261\\261\\255u\\273\\323E\\210q\\\\\\272\\246\\031\\257-+\\235l-\\351\\252\\250\\341\\353\\005Q9\\304z#(|U\\315j\\206\\252\\345-\\016\\342;\\232\\334\\217]\\221&4\\302\\235\\351s<\\335\\252\\265=i\\3312Ki\\271\\\\\\005\\006\\353\\021\\246F\\254\\375\\230\\3450\\226\\340h\\242\\242Y\\257\\256\\026U5a\\334D\\031\\313\\025M\\272\\034N)\\314\\212p5\\207>\\270\\016M\\320\\324<*\\327\\\\\\215\\363\\014\\276\\256\\342\\203\\310\\340\\304b\\223\\372\\342\\232U\\335\\037\\321\\241\\325#-a\\273\\364ma\\312\\347}\\312\\356h\\230\\356\\271\\275\\265\\031\\031,\\022\\254L:\\224\\251\\202^\\006\\372LtE\\202\\015\\023G\\246\\270\\2350J#\\017\\307)2Ti\\212(p\\216\\344\\225\\351^\\031\\3202[c\\223\\334\\225\\361i\\342\\012\\0212\\361d\\224\\243\\024Y\\341\\025F\\340\\306\\270\\327[\\341\\253 \\246+L\\241\\345\\\\!\\\\|J\\373\\256\\302\\020\\200\\221\\224\\304\\301]\\336\\027\\210D\\307\\335|5\\367M\\215r\\327Trp\\245\\225\\326;\\367A{\\324\\007\\014\\364\\241E3\\204\\264\\356\\247-\\317%\\363|J+l\\245\\316\\272\\266\\016P\\304\\321,\\260\\344\\026\\313\\2443qKz[)Q\\250\\376\\212c\\011 W\\311\\210\\341\\314\\304\\325\\343<\\0137\\023YRdG\\244\\355j!!\\264\\202\\033\\006=\\302\\023\\012P\\214\\335\\016\\372!A\\314k\\271\\242\\3025A\\313\\225\\315V\\325\\216\\246\\2701Yq\\033\\320\\017\\234\\361\\023@Qmj\\221\\234A(UFx\\332X:\\004\\362\\272/:\\234\\214\\017\\376Z\\253\\361r\\326x?<V\\373\\341\\356\\021\\037\\253\\376\\346\\354\\225;\\335\\372\\340\\260\\272\\267\\275\\237/g\\221\\375\\275\\337\\376\\177\\223\\375\\366\\337reM>\\374\\303\\255B\\256v\\263I\\341\\022\\013?\\335\\274\\000r\\357\\355\\330\\207\\373\\0244\\353\\005\\236\\323\\323N\\005I\\001\\032\\365\\002W\\005\\203\\246\\344\\300c9=\\200sv,;\\264\\013\\373\\376\\331\\375\\375\\333\\275\\352\\316G\\256\\277\\317\\326}\\377\\307\\327\\377\\027	2038-01-18 19:14:07-08
talkbox:resourceloader:filter:minify-js:95d755dec919121af9fd8c9c3a53b9ef	\\345\\275kw\\033Ir \\372\\235\\277\\202\\254\\221A\\224P\\004H\\365\\214\\327\\006T\\302\\355\\226\\324\\036y\\373\\345\\221\\3063\\263 \\324\\013\\022E\\252$\\020`\\243@Qj\\002\\376\\3557\\236\\231\\221Y\\005\\220\\352\\261\\275\\367\\236\\355sZD\\345;####"#"\\253\\376\\311\\311\\037\\376\\361\\037\\377\\261\\237\\264/n\\346\\347\\253r1o\\337\\226\\363\\351\\3426\\273\\231O\\213\\213r^L\\323\\273\\217\\223\\345\\376\\373\\177\\273)\\226\\237sW\\252*f\\305\\371j\\261\\314\\316\\027\\363U\\361i\\225\\336-\\213\\325\\315r\\276?/n\\245p\\367b\\336-\\347\\345\\252^v\\260\\311~\\226\\006\\271\\267.\\177e??\\322\\204G\\331tq~sU\\314W\\232\\242\\337\\331r\\261XI\\371_n\\312\\363\\017/?]/\\363\\336\\333\\321\\333\\247\\343\\307\\355\\247\\243\\323\\333\\323\\277\\214;\\317\\322\\321\\333g\\343\\307\\217\\326o\\177\\327\\206\\244\\243q'}\\324\\313\\312\\352uyu=+\\240xw\\364\\266\\377\\273\\323\\321i7\\203R\\275l9_\\254n\\337\\225+\\310:}\\015\\237\\253ey\\005\\245\\332\\247\\325\\372\\364\\346\\370\\370\\353\\343\\264\\263\\266\\037\\217z\\227\\331\\262*\\347\\227\\263\\342\\315\\344\\022J>m\\237\\336v\\322\\323\\352\\361io\\370\\254=\\354?=\\355\\235\\236<K\\207\\320\\366MU,\\277\\276\\304\\251\\314'\\037\\313\\313\\011\\200\\242\\353\\322\\262\\263\\345\\342\\026>\\276\\237\\254\\316\\337e\\313b2\\375\\374\\315\\002\\200\\237_LfU\\301\\011\\337\\225\\325*\\037\\215\\263\\027?~\\377\\034A8_}\\267\\230L\\213i\\266Z\\274\\206\\201\\316/\\363\\037\\317\\336\\003\\210\\273\\327\\313\\305j\\261\\372|]t5'{7\\251~\\274\\235\\377\\264\\\\\\\\\\027\\313\\325\\347z\\3010?\\273\\276\\251\\336\\345_/\\227\\223\\317\\246\\014&f\\325\\254</jY\\224\\232\\301\\012\\025\\237~\\274\\250\\345J\\372\\300!D.\\277\\\\\\221\\374\\016Q\\244\\277\\003\\257\\020\\373\\256\\0108\\220u\\005\\000Y!j\\014\\312\\213\\366\\201\\026v\\310\\267zWV\\203\\015diNw\\276\\230\\026o\\240\\237\\364\\016\\363\\272\\322j\\216\\037\\243\\343q\\256\\345\\006\\224;+\\346\\227\\253w\\371\\311`[sy\\236'g\\213\\351\\347\\244\\325:p\\003\\014\\032V,\\035h\\017\\232\\320\\305z\\334\\215k\\215\\333\\272\\247o\\204\\322\\342b\\337\\016\\241\\242\\245M\\322;\\202K\\356vA\\267\\370T\\234\\273\\301\\246\\010#*\\321j\\361\\337\\321\\311xo\\275v#O\\357\\264\\000d\\244w0\\322\\274-yC\\371\\333]\\334\\316\\213\\345\\013\\231\\303z-\\311}\\235U\\212\\303\\315\\375Fh\\030\\001\\024\\240\\216d\\345\\313\\352\\247\\331\\244\\2343\\036\\266\\375P\\334\\374F\\016b\\347\\200\\374\\253\\342%\\254:|a;8\\314\\261G\\246\\356d\\265Zv\\317'\\263Y\\015m\\262\\325\\362\\246\\000:S\\300\\036\\012\\233\\336\\326\\352\\206\\313\\342t\\316n\\312\\331\\364\\333\\345\\344\\222J\\214\\024B\\343\\014\\353\\217\\323\\201k\\017kC\\377\\347\\357\\212\\311\\331\\254\\030\\342\\327\\205T\\353\\236\\317\\026\\363\\342\\007\\300\\2766\\015\\245o3\\323\\356\\371;\\350\\002sa\\215e\\301eZW\\305\\362\\022\\352\\300\\352g\\036\\214<6\\304\\177\\217O\\227\\305J&\\361\\315\\347WSY\\307'c\\2029\\226$\\240\\343\\217n9=\\310s\\227\\257{\\305\\223\\321.\\320\\371\\251Y\\264M\\210\\220\\212\\311\\330\\226\\3445b\\273\\307k\\267\\253\\002\\\\\\246I\\354\\343\\276\\225\\352\\255V\\357-\\020\\315G\\275\\356\\252\\250\\3741\\221\\312\\226\\2527\\327\\334\\267+\\327\\000\\232\\352\\233\\317\\200\\225?L\\256\\0123\\277\\207\\002\\334\\216\\325\\241~\\367\\375/XM\\301\\330v\\371\\036\\236i\\015\\240\\212Z\\276[\\207\\371\\265\\262\\256k\\267a\\276\\215\\211c\\332\\264\\210tR\\370"{!\\035\\324\\037\\200\\011\\346do\\206s\\267\\031\\340.[\\022j\\230;\\371P\\320\\001\\340w#\\326\\307\\323^\\023\\372I\\2221\\374\\372\\311I\\367\\367\\335'I\\306h\\326?\\316\\252\\362\\327\\302\\237\\003\\001I\\027\\\\\\204\\206V\\013\\352\\241\\241\\034\\035DL\\014h-\\217\\261_@\\004_t~s\\345\\271\\224\\233\\253<\\237\\337\\314fCj_\\232m\\247},\\365\\364\\230S\\251I\\252\\006\\350\\337\\247m\\000\\037cl\\030O\\304\\327\\253\\311\\371\\007\\337<n\\217*\\233\\003\\252y<\\242\\303\\013I\\212,:mN\\267\\256\\334'\\325\\203\\025\\305&\\273\\223\\353\\353\\331g$+\\031'\\013\\352\\004\\250js\\221\\252\\\\/\\213\\217LN\\351X\\033\\020Q2\\347\\234[/\\350\\033\\207\\207'\\010"]B\\320\\360\\313\\037 C\\247\\035|\\016\\223\\375\\004\\026/\\3558\\324ph\\212M\\356l)\\351&\\035,\\324I\\332I\\307\\247\\246\\211C \\370\\0030-\\200\\220zp\\342J\\236\\001\\200\\263\\311\\362\\262J\\303\\315\\323\\305\\242\\274\\314a1h\\205\\266\\201o\\346b\\236*\\364\\316`\\316\\177\\242M\\022.\\003\\245\\245wp\\236\\020\\3668>S6\\263\\237\\251\\343\\305p8\\362\\223x#\\354\\305M\\206\\211]V\\374\\342\\007Q\\272\\361\\227\\000\\374\\243\\023\\213^e\\332\\267_Y\\247\\354\\234\\340<.\\312e\\265\\332\\266\\037\\212_\\332\\204\\337\\263I\\265\\332\\333Q\\350\\210\\232\\242\\246\\267\\225r\\230\\334\\346\\035\\304\\030H\\260\\005\\220\\022$\\2524K(3\\311\\314.\\363\\271\\335\\367\\213r\\336N\\262$\\305\\336\\256&\\327\\365U\\334\\326\\247#\\035\\327\\334e\\260\\2332\\0177m\\207\\273\\346L\\332\\004\\320#\\365Z\\314\\247[g\\350\\366\\307z-\\373\\020w\\276n\\343>s\\267\\213\\345\\252?\\032w\\361oV]\\023\\304\\360\\223~m\\006\\241Dc\\330W\\227\\241E`\\243\\301X|\\272&\\230\\301!QX\\001\\370\\200.8 \\002\\205Y\\257\\3576Y\\231\\237\\010I\\364yB\\376\\262iQ\\\\\\213X\\260\\270\\306\\266\\224\\334,\\317\\201\\357\\271\\376<\\360\\334\\2424O\\354\\352bVL\\346\\260\\331\\251:g\\014j\\335\\237P\\367\\2032\\177b\\231N.\\006gF\\262 \\000"\\337[?\\226\\270\\024\\036\\333\\334*\\264\\203m\\3104\\362\\274t9\\2647\\216\\216\\312\\301\\346b\\261l\\017\\312\\247B\\330\\313N\\207\\330\\225\\266\\314\\313\\014\\254\\034\\247\\007D\\251a\\207B\\035\\234\\360~9\\337\\227\\202\\3007.\\317eR#\\314\\033\\017\\020\\022\\271dK\\022NH\\001\\202\\331\\351\\035\\222\\304r~S\\320@\\0210\\255\\026f\\000\\243\\274\\205M\\205J\\212=\\216rSj\\312\\353I\\354^\\016\\203\\331\\326\\004d\\325[\\300\\304t\\010\\377\\366\\233\\232\\036\\216\\306}\\200\\245\\314n\\217\\346\\222\\007hFC\\317\\250o\\302\\000C\\254\\3603:\\354\\015\\224\\010\\014\\300kl\\034\\325b\\274\\330\\204h\\334\\276\\233/@\\342\\274\\200M`h\\021v\\232\\336\\251\\240\\236\\377\\374h @t\\211"\\334\\213\\220\\0371\\012\\260\\357\\204\\350\\366\\215\\214kw/\\362]1y\\306\\264@\\226\\362'\\177\\261zS^\\025\\213\\233U\\333\\262B\\331\\311W\\000\\216\\260\\231\\034y\\361AH\\312q\\365.\\346\\260\\361\\216\\007\\267\\300\\225\\027m\\240\\346\\271\\313\\037\\001j\\216\\323]\\247\\203\\227\\320\\021K\\011\\241\\374\\346\\007A\\355\\362\\262X\\376q2\\237\\316\\212\\245\\036E\\256\\2254*\\320N\\250\\265\\004\\331\\300M\\346\\016\\254\\0106^I\\2400\\220Q\\260\\342@\\347\\350\\240Ey@oWt\\364\\237/P\\003\\262*\\222\\370P]\\312\\331\\270\\261u'\\323\\351\\313\\217\\250p\\200\\011\\026s\\234\\302\\326\\254v\\022\\353'\\222\\272\\306\\202V<\\035\\010\\236\\324\\233\\230A\\261$\\013\\326Q\\2528\\314\\366\\003X\\301\\031\\362\\216\\032\\260\\303\\362\\251\\355d1\\2476*\\234\\374\\371\\273\\311\\374\\262\\250\\217\\311\\217&\\254Y\\037J: \\322\\275\\000\\370},fL\\212\\007\\253\\345\\347;\\227$-\\201\\240w\\245"f.xq\\216\\002X\\033X\\245\\000\\276\\372C\\012w\\367\\246\\213\\327\\347\\313\\305l\\326ji\\24387N{\\376\\256\\2003\\223\\221\\303\\323_\\217\\035@\\244\\375\\321'\\012 F[\\314\\301\\305\\0371\\035\\337\\327\\272\\343\\204vc\\304T?\\274\\035\\252(\\215\\030j\\0275\\205{\\027~\\254\\327\\365\\306\\016Lc\\\\w\\234\\254\\327\\220\\34047\\374\\005\\233\\374\\025\\254\\331\\362\\343d\\346\\206\\306\\360Gpb\\011 \\351\\025\\240>2\\227pJ\\205j-\\327_\\226\\230bI\\272\\275\\240m\\316\\037\\367Y\\002\\323\\324\\217\\037/\\2224\\036\\013\\342\\307\\207\\342\\363\\000\\217*\\370K'\\025B@) \\244\\345\\206(\\257\\327\\333\\306\\011\\005S\\202\\352\\313\\253\\353\\325\\347F\\250b\\037\\330\\237;\\022\\315\\252\\311pt\\015\\221"\\000\\217\\264\\\\\\202\\010\\346\\032\\271\\252.Q\\002\\\\.n\\367\\341'rC\\223eU\\374\\353\\353\\037\\1770\\244~\\262\\232\\320\\372\\011C\\200\\337\\007^\\003\\265^\\037p\\011'V!\\246c\\222\\236S\\250G\\345V\\220$\\365\\336\\216N\\307\\031\\034j\\247\\025j]Y\\356\\307\\\\\\330_\\327\\263\\0110\\300\\275\\323\\323\\366\\260?JNOO{g\\027\\363\\345j\\274\\276\\031\\035\\037\\375\\363\\344\\350\\342\\353\\243o\\307w\\277\\337\\244\\275\\313,\\371\\177\\222\\324WIFo\\261\\374\\374t9~\\234\\254q\\262k\\232\\377\\032\\207\\263>\\032\\236N;\\320\\346i\\367t\\3728\\035b\\353\\305\\313\\361\\250sz4\\306\\234t\\210\\355\\215m{P\\344\\355\\272\\277\\316R\\254U=>\\035\\245\\035,\\223\\244~\\271e\\237#\\260Z-\\363\\321%\\030\\016k)\\014\\002\\220.\\213\\333=\\3077%\\322X\\322\\241\\334\\264\\035\\211{\\264^\\355\\344\\325\\034\\220\\276\\234\\356\\323\\312ha\\240\\001\\331|\\261\\270\\266G\\003\\310\\273\\263\\305\\331d\\366\\022\\3127,!\\376h\\265\\234\\242\\333\\003_X\\230w@\\342\\356\\321\\241$X&I\\211Y\\335F\\302\\262\\352|Y^{\\375L\\244pK8\\033\\2168\\376\\321%6:A\\001\\265\\367~\\362q"\\331FB\\253n\\256\\257\\201+\\357r\\316K\\242\\000R\\027\\204\\025\\340R\\236\\2432\\255\\035\\365\\367\\006\\032$\\365\\033\\317PU\\201\\322')\\220 c\\260\\301\\031\\001S_\\301\\366\\373\\246\\200-U\\264\\271LF\\031$\\205Q\\373\\351\\200\\022\\226\\305\\325\\342c\\301=rAY\\212i\\201\\020\\012\\325\\001\\231\\223\\215q\\231I\\027\\247\\005[\\255\\340\\263\\273Z\\374\\031\\346\\262|>\\001\\\\A\\012;\\257%\\326$d\\246\\232\\221\\004|\\247\\024\\001\\031\\032\\225$\\270\\244\\212\\021e\\005\\344$w\\334\\271!Fu\\326\\236k\\322\\336\\345\\346\\341\\007\\325\\217\\270q.\\206\\271NRcA\\222s\\230\\351\\344\\021B\\227|\\242\\337\\235\\301B}\\300\\303\\214\\226&\\224\\010v\\264\\205\\034\\331\\326\\246\\270\\255\\207\\217R\\011\\256\\037$\\001\\317\\246\\354\\0341\\202\\0330\\362\\246\\020 \\303\\326\\200I\\354\\361,@\\250\\010\\372\\241\\202 \\270\\322_<\\372\\230L\\007\\365;\\035\\220x\\356<c\\316\\311\\250\\372\\002J\\352\\027\\337\\336\\271\\265Y\\001\\231\\030\\032F\\367WH\\262H \\027\\275\\234\\257=\\301O\\340\\273\\253\\233\\331\\252\\362Z*IX\\257Gc^q(\\245\\302\\227~\\253^\\230\\222\\341D\\347s\\201\\262r{0\\324q\\211\\312\\200\\014\\324\\266u\\3600\\321a\\201t\\311]\\330\\303^\\024c\\004?\\324|q+\\333\\364b\\232\\033j\\226\\312y4\\177\\332\\234\\\\\\326OL.\\253\\334~\\015R\\333\\242l\\32057\\273\\313\\202\\245.\\322R.H\\261\\000\\034\\326\\312\\253&\\310\\015\\362\\350\\004\\027\\011\\247`\\324VHw\\262\\252\\000.D.`\\313\\234\\322t\\023\\277\\007q\\305^\\016aA\\2674y2\\277\\271:+\\200\\301q8:\\313\\2032\\203\\367Og\\203\\3678Dj\\225\\366\\224\\224\\030\\275w\\227!,\\017\\271\\344P\\234l\\250\\010\\277\\241\\252\\035g^\\252\\266\\235RQ%\\013(\\032+M\\035\\011+\\347\\037=6\\002\\0226@\\233jl\\205\\366\\001\\264\\000\\303<\\320\\026\\271\\003\\000\\177V\\362\\341\\315\\372:M\\255aJ\\240\\274\\212\\006\\007$\\307\\016.\\333\\243}\\373\\205c\\344\\275\\3360<j\\036\\227\\224J\\350\\256\\303\\353)\\034571\\316\\271K;hdTA\\264\\020\\022\\011\\303\\302\\3736\\204\\363M9\\355\\237d\\300\\272~\\012\\324\\241\\234B\\232\\371\\037==\\214uM\\200CO,\\337G\\225\\202\\253G\\337@~1\\037\\200\\310\\354\\023FTz<\\340J\\016e\\274\\004G\\031\\215\\252$\\312I\\203\\326)\\251\\336\\026\\262\\375\\007\\322\\020*y\\271@]\\005\\210\\327\\204N\\245\\251j\\300H\\2759`\\205\\225k\\246\\213\\300\\203i\\005\\177\\327k\\237\\347\\310\\033~t:\\216\\321\\346\\261n\\262\\233\\011]\\347{\\270\\337\\000\\013v3\\311o&p\\246\\177\\267\\270ug\\272\\273\\334\\316{\\355\\333\\342\\354C\\271JG\\373\\247\\2751\\332,t\\307\\235\\264\\307\\027\\252P}\\275\\356\\265QH\\230 W\\332}\\374\\261XV\\320p:\\334Q\\374\\252*\\213t\\277)\\357\\240\\207Z\\200\\311\\252<\\233\\025\\302\\205Cz\\253\\005u\\026\\277\\226\\263\\231t2\\334_~\\354k}`\\224M\\013\\2609y\\316wb\\277\\320\\327kR<\\2102\\031^_o\\035!\\3618\\001(\\253\\265\\003\\210\\000\\233t`M\\037T`\\020\\320\\265\\235\\201\\004m\\012[\\262+\\037^\\261\\317\\337\\243\\246BcV\\207\\204%\\2732\\274<\\250!\\211V\\203\\263\\247\\025dm\\242\\036\\273\\325\\344b\\262,\\271\\013\\254\\346\\216\\020\\305l>x\\362\\306\\203G\\017\\002\\256\\243Ju<\\230\\345\\254\\001\\264r\\327{y\\2549\\032\\354\\326\\322\\304J\\016\\2733\\214b\\010\\231\\331\\337\\254\\304\\211\\365F\\367\\251hv\\215\\351A\\372*/r\\024_\\254\\343\\211\\007\\013\\243\\325\\356\\367#\\375J`\\255 \\352G\\325\\263\\241\\266g\\253\\362F\\333i'\\263\\342\\002E\\034U\\372\\240 \\207&\\016NQ\\031\\364\\230\\235\\350\\235\\264\\323W\\272a\\2721\\026@\\372_\\223\\300\\321\\226\\233\\017w\\277\\217Zd\\305\\270\\311\\373\\311\\247\\366\\335\\315r\\326\\327\\254lR}\\236\\237\\213\\252\\025e\\036T\\252\\364U\\014\\333D\\254\\224\\227 \\271mf-\\335O\\001\\252\\244\\224s\\300\\230?\\276\\371\\376;b>i\\007P:\\210\\274P\\010\\245\\257\\364.J\\010\\004(\\301s?\\311\\311\\371yQUr\\360~(>3\\247\\234!\\331\\311\\360\\350\\232T\\302\\2556\\036\\264\\356\\264b-\\213\\336Yx&\\350\\003J\\001\\250Y\\271\\013;\\312\\366 q\\364a\\354:b\\006\\335\\221u*F\\323\\223\\303\\331\\362AX'?\\300\\241\\201L\\007\\277[\\255\\372\\261&\\355\\031V!b\\013.\\346\\236\\025\\300ycCC\\252\\345o\\274\\204O\\210\\212\\246i\\237\\201D\\300\\211\\207,_\\334\\325\\320U=\\346\\252}s\\236\\2725\\230/n\\335\\351\\211\\372\\212\\375\\027\\260\\257R\\324\\007 \\362"N\\266\\315\\276\\015et\\274\\372!\\016\\011\\350V\\376\\367*\\010\\262i\\371qk!\\310\\203\\022p:k\\361\\016\\215{\\000\\351\\335j\\365yVt\\247e\\005\\262\\320g\\340\\205\\027\\363"\\241\\014\\207\\257y\\262\\277\\277\\377tV\\316?\\364\\236=]\\241\\361\\316\\263\\247=\\371;\\331\\177\\267,.\\362\\303\\336\\344p\\237Z\\312\\017\\317\\027\\263\\305\\262\\277\\0040]\\314\\026\\223U\\037w\\367`q=9/W\\237\\373\\335?\\374ap\\370l\\362\\2647y\\366\\264\\234_\\337\\254\\366I\\243qx\\216[\\373l\\361\\351\\260\\367,!\\240\\300:\\3468\\212f\\315\\312c\\230\\316dG\\376\\204\\324.d\\3666A\\301\\013\\377\\025\\314\\307\\017O\\241\\342\\025\\231\\001)\\001\\226\\355/\\250\\363\\251`\\314E\\037;\\361\\212\\015\\247h\\205-\\363U\\266\\302\\253\\225\\376\\301\\366qP\\001\\2204E\\016y\\267\\272\\232\\275.\\226\\345d\\206\\346\\033\\007;*"\\264}=\\202l\\277\\0070\\025\\376c\\202\\325\\276^\\001{yv\\263\\202\\342T I\\323\\014W\\343\\207\\305\\362\\212z\\230\\366\\343r\\230\\235\\220N\\2727I2]\\224\\336\\333cX\\227G\\256mF\\211=\\311N\\263\\363\\252\\372\\226\\226\\362\\340@35)\\243\\205\\373q\\336\\337>\\025ZfZ\\217.\\363\\363Hl\\346\\330\\373\\3525\\3317\\3008\\267b7\\025\\000@\\354\\320]\\271\\302|\\215\\011P\\020k\\0128{=)\\245\\001Zr\\212\\337\\017i\\225\\366\\016\\264\\351\\233\\312Y\\234\\317\\246\\005\\236\\264/?]O\\346\\323E\\037\\331\\032\\206\\306s\\274a\\224#\\304\\253\\341$a\\276\\240l:\\215\\271\\016`\\375\\367\\320\\352\\254\\217\\215n\\356Q\\364\\341\\211\\372\\005\\352\\274Dt\\253I\\0078\\357$?\\031\\220\\325\\201\\277\\\\A\\322\\323\\250\\317\\243\\014\\253\\317\\203\\255\\304m\\215\\312\\3518\\246dF\\333\\310\\354\\035\\203f\\337\\327\\020^\\200\\223\\235^\\021e\\\\7\\230\\250\\311\\000\\272\\271\\252\\350qXMZE\\344\\210pA=\\007\\325j\\311\\316-\\364\\316+\\314GV\\350|V\\236\\177H\\234\\035\\305>}\\327\\350t\\327\\256\\231\\214\\004\\033\\213\\370*i\\214\\376\\240\\241\\005\\225\\211\\014\\033\\375x|\\015({/\\355\\216\\011r@;\\227@\\262\\026\\207\\244\\307\\224\\017\\204\\354\\341>!#0\\216\\207\\362\\303\\321V\\265\\254\\314\\367\\242N\\325t\\325\\231s\\302)\\254&\\232\\001\\272\\0054\\321\\261\\213\\012/\\277\\013\\362m\\026\\236\\265o4\\316a\\012+\\243\\225F\\355\\361\\211c\\177\\030\\250\\230H\\335\\226S`{\\374\\3675p\\376@\\334\\277\\203\\003)ON\\256?\\3019g\\357\\310\\343)\\272y\\351\\016\\315\\243y\\272t\\354bqq\\001,\\353_\\250\\313<\\177\\0225\\035Q\\2364:v\\017\\361\\330=\\304\\241\\313\\375'\\013\\273\\005b\\312k\\356\\315J\\000\\224\\376\\003\\251\\313\\251\\330\\354\\036\\220\\270\\362Dy;\\356\\223:)+\\337\\203o\\031\\231\\277bF\\033\\353\\300\\224@\\026\\0255\\216\\376Lq52\\271\\241\\001\\0323\\260m\\012\\233Y\\314F\\256\\3508\\267\\212L\\344\\251y\\332*\\344\\371\\332\\336\\306\\302\\221\\232\\233\\263\\253r\\365\\315\\315\\031\\360\\037U\\036B\\010\\016\\014\\312M\\032P\\022E\\235m\\265D\\020\\002\\301\\002Y1\\345\\270`1\\220\\013\\231\\350\\222\\264]\\253\\327\\313\\305u\\225\\337%@1\\223~\\202\\247\\372\\267\\360+K\\316\\001\\213+H\\241\\2778\\321\\204\\3145\\026\\363\\331\\347>\\031+\\374\\010\\277\\222\\354j\\362I\\0149\\023\\370\\371\\035\\375\\004\\302Q\\314f\\310r\\000\\206B\\013\\360\\361\\232?\\240\\015\\220\\237\\201\\014B\\023\\213[H\\204\\263\\023x,N\\201\\037\\234\\002\\374\\030\\311\\306\\375\\004~\\275\\302_\\011\\272R\\240\\212n/\\201\\037\\337O\\256\\201\\320\\341M\\373\\331b9-\\226\\375\\204>\\276\\241\\217\\204\\031\\321B\\210m\\302\\323\\024.1\\273A\\275\\316q\\306\\304\\374\\005^W\\336\\325,_\\310\\256\\273\\177\\267\\311\\244\\215\\276\\374\\205\\363\\016k\\364\\357\\222\\342\\352\\014\\304c>\\362T\\330\\220/T9\\025\\362\\265!\\251\\253\\341f(sWs\\321\\325\\220\\214\\204;\\032\\305\\027EF\\1774\\366l\\037\\031\\207\\323?b\\2040\\364\\263#Y\\220w\\306\\224\\312\\214d.\\343\\214f\\251T\\200>H5\\370\\034\\177\\361N\\231\\266Z\\202\\357j<*:@8\\216\\020r\\2010\\024\\334\\003su\\230\\3404\\357t\\020\\344\\326\\264L\\033sBZ0\\256\\034\\012\\273q\\3444.<s#\\353'\\2025\\254\\020]\\263Y\\233m-\\337\\320\\252o\\013\\315\\324\\032\\372\\030\\310Ui\\335R\\232\\012\\212\\375\\024_\\036\\352\\375z#|\\206Q\\235\\276\\007,\\232\\251"\\365|\\321\\214\\030\\377\\037\\306\\211\\020Nn\\260.?U\\216(\\232|`qkl\\032LM\\307\\244x\\330\\264\\367TE\\340\\356\\365v\\361T\\256s\\232\\217\\303\\025\\236\\226\\307\\017\\002\\036w\\342\\210\\276(*\\242\\324v\\330\\006\\3625\\334\\201\\207\\302\\006\\025\\231\\261\\265g\\373.\\334\\362N\\225au\\352\\242\\245pH\\006\\033\\312\\030\\273\\307\\326Y\\330`[\\\\1\\014\\256o\\321x\\004v\\300h,]\\027\\331]\\203bk\\222\\262\\365\\012\\010\\005\\253*\\207$\\262}\\205\\363\\266\\013\\207\\010%\\216N\\306\\271\\376\\030\\242Q\\267~\\364\\223\\304]\\\\\\204\\344\\200\\330\\033$\\022le\\037\\331\\272\\201p\\205\\213\\354\\033\\352$\\007I6\\342\\257\\3431\\273\\262\\3044&\\002\\222\\2655\\261 \\222I\\011\\034\\352\\215\\270\\211PkTS\\373M\\373\\274\\271\\255\\323\\206\\035?\\312p;\\007\\316K=N\\037\\004y\\247k";\\202&\\262@\\012\\253\\007,\\250\\3316\\341\\262z\\004U\\354\\374\\345\\246\\270\\211m\\025\\310\\276\\311\\235H\\007\\366\\262\\022\\350$\\262\\345\\204l\\353ur\\361)I;\\011\\265\\301\\334\\367/\\301\\012\\270\\326\\230\\325\\012\\014\\204~\\241\\233\\003:\\031~q\\227({j\\365*\\306([\\232SS<\\357g\\022\\230v\\374\\302W{b\\035\\243\\375\\001\\251\\235\\026\\333\\246\\013d\\035\\347\\345\\247\\305\\263\\301\\322:\\004\\37205\\262\\213yNi\\335\\352]y\\261bW\\002H\\203\\315\\007\\002\\314rq\\271,\\200_B\\205^TL/\\230d\\317\\022\\273\\010p\\344\\245\\350\\336\\314\\271\\\\\\320\\310`\\243V\\247\\324\\177\\003"\\025\\361\\360x\\275\\033)R\\004\\204p\\271\\325\\336\\033\\376\\034\\330[>\\336\\274\\220:`\\351\\035a\\264i\\330\\2251\\265\\342q\\351^\\224\\241m\\307a\\325ho\\001?\\241\\263\\037\\360 \\204a\\253E\\245\\240\\243\\203x\\025"8\\271vxS4\\240\\006c\\305C\\250gC\\223\\334\\342\\314\\032\\032\\254J`\\363\\004\\325\\340\\247s\\013\\3704t\\277\\200\\316\\026\\305\\264\\032a\\376x\\275\\306?}\\374g\\020\\343\\246\\035\\225t\\216 \\211\\244I:\\356\\311\\316\\336\\\\7<\\014u2\\354V\\346q>+&\\313\\177\\273\\0178~\\030<\\306l4f\\320\\222\\022\\230d\\206\\2747:\\235\\237\\256\\306\\275\\313loI\\372\\307\\274wZuz\\331\\222\\033\\202\\257%\\371R_\\027\\347%\\220\\302\\345,\\357\\241No]-\\317\\327$R\\24276\\202\\242\\327\\206#y\\265\\230\\257IS\\220\\366\\312ly\\0012b\\205j\\333(s\\315\\007\\341\\232\\265fk\\3249M@X\\241:\\244\\242\\340:o\\333\\2235\\245?\\302\\014\\3223\\220\\250\\236\\367\\350\\367ZU\\270\\275\\206\\355\\204\\276\\247\\306\\267\\014\\331y9\\341\\325|\\204\\257\\030\\010A|69\\246*%\\3036R\\307\\014~]o\\021\\011\\306\\003\\220\\021\\3331\\035\\341]\\214\\360dV\\271{"\\376~1\\217#\\3343-\\373d:}\\216\\253\\346\\307\\341\\331\\226m\\327\\032\\273\\206X2R\\302:\\\\\\350\\015&\\373\\004bJW{k\\233\\233\\016\\232F\\231q>\\316KD\\3204e\\314TF\\303I%N\\003\\353\\210\\026\\373c\\210\\274Z\\345\\\\\\236\\355\\243\\230\\247a<LC\\323\\215\\334z\\032\\226Ogj\\257a\\266\\324\\250\\034\\017,g\\356\\001\\253'f\\327\\365+\\014\\245\\373V\\323\\015:\\253\\202\\021\\346\\311~\\322\\011\\013w \\011@\\260"\\350\\344a\\236\\033\\3659\\214\\372|\\226\\373\\231\\352\\340\\317\\237\\236\\317\\006\\347b\\021\\343\\262\\235%\\023v\\347+\\215\\316\\307\\330[\\372\\364\\230.(\\251\\307N^+C&A\\301|\\254\\201\\257V\\244\\303g\\263\\027z\\302\\211\\242\\350\\277\\017\\255L\\207_\\210Y\\367\\241\\326z\\275\\205\\311\\375oE7\\261\\0355\\250\\246\\233"\\032L\\336nF-c'H\\351\\031\\246}\\011^\\371\\036<zi\\223\\215\\350\\305=\\354B!?\\033\\343\\355n\\312\\202\\214a\\335\\225\\030\\265V\\213\\313\\313Y#jed\\016\\360\\357h+L>\\033z\\226\\352\\252fe\\365\\315b1\\3234-m=\\346\\006\\377%\\310i\\206\\374 \\344\\364\\023\\361\\277\\010]w\\235\\013\\206Aj\\246\\212d\\035\\\\\\033!\\367\\220k?\\231\\301j\\036j\\210\\317{\\342/\\325\\200\\015\\225\\372Mq\\213\\014\\354!}\\364\\017h\\222\\357&\\025\\003\\301,<f\\214\\250\\3200\\321\\263!A5\\243\\333\\317\\3118@\\224@\\014\\016\\205i6M\\015= \\365P4;\\247&\\222%?\\377\\354\\262\\177\\3769\\311\\242\\012\\032\\000\\301M9\\374\\364\\004\\202.U\\206I\\322\\277\\257\\207\\024I\\205\\034\\277\\012\\224z<\\224xg\\343.\\363\\276\\324\\373\\311C\\210\\013\\0228\\254'\\264\\345\\0014\\301\\235\\031\\036\\000\\317\\216N<\\362/\\2551\\242\\\\he\\201\\367\\201\\247\\363[(\\247\\247v\\307\\216\\332\\331sA\\225\\\\\\314\\251\\372\\033Q\\265P 21Qf\\246\\352\\012\\365\\275\\333 \\365\\005\\226\\362\\242,\\246C*D9}g\\312b\\355\\274\\242N\\364\\216V,o\\021\\006|\\010\\353-,i\\243\\231\\241\\253\\320\\024T\\335V\\251\\220\\372\\346\\342e\\021\\367\\246[\\221j\\037\\2219\\202\\032\\213\\341\\261\\033(M\\375:B\\271!+\\300\\217Q\\277\\356\\277;'}\\351\\303/1\\024\\360'\\010\\347:'X>F\\370\\313MAMQe\\377sn\\212@b\\231\\026zs#\\243\\222{\\250\\037\\302\\011\\263\\234\\255j\\213\\215-\\303F2\\206\\223\\346\\373w\\007\\205\\324\\033}\\0067k?\\316C/\\211\\360\\212\\237\\232\\246;~\\212\\330\\200\\027>}\\277\\242J\\011\\333>)\\262\\205\\347|\\266\\206\\227^\\214\\341\\013_\\030)}\\317\\267Q\\374\\301\\227\\023|D\\020a\\373bv\\374\\200\\270F\\325\\256\\220\\273\\202\\366G\\013\\223o9\\032hyR\\253G\\377\\310\\207\\2263\\370\\206\\357\\016\\035\\226\\365H\\023hN\\337j\\325V\\207u[\\270:\\032\\313HnYC#\\306\\266\\037\\000N,}\\226\\037{5d\\274\\217\\230\\320\\205\\373H\\266KM\\213\\203\\215\\351\\325\\250\\356o\\216\\034R;\\327L`\\211\\372\\370,\\350\\3758\\241K\\036*k\\243\\004\\205U}\\0304H\\273:Gs|\\346@(\\223w\\011\\374\\313$\\272\\256KC\\332\\363\\355\\274\\217\\200\\027\\213\\011\\240\\337\\364\\003o\\321\\370\\027\\305L\\242_\\244\\027\\246_t\\225+\\005\\213\\362\\362\\235\\024\\340KW\\2718\\012\\205L\\177qd,\\276\\234\\350!6y\\326\\232\\247\\236\\364On\\237\\231\\035\\200\\026\\331d\\276&\\2162{F\\254\\374v\\036\\251v\\230@\\263R\\337\\021\\001r:Z\\254>]\\315\\362\\240GD\\363\\365\\332\\333y\\377\\365\\373\\357^,\\316\\271\\011\\224o\\362\\232=\\335\\200.Q\\270-w\\351A\\227\\223\\334\\345z\\215\\177\\266Ha\\264\\013Y\\217\\220\\033\\205\\002\\2439\\213\\271&\\006\\212.{R'J\\306\\220\\207[eS\\231<2f\\034\\020\\344\\226d\\213\\301\\177C\\\\\\362\\371\\201Id-)\\252\\265!\\343v\\365Z\\302>ai\\004"\\0072-Z\\367JBk\\351\\214p\\023\\303l\\226\\034\\001\\316Q^\\335\\225\\251\\010\\016v,\\241\\253!VD#vrF\\335?\\237\\314\\017W\\373g\\305>_&O\\225\\203\\227+0\\241\\276[OQ8\\311\\256\\022\\355\\323Rt\\262\\221\\240\\345\\330N\\365}\\031j\\366\\337]_n\\256z'\\314\\0134\\261\\025\\363\\346\\346L\\035\\245\\346A\\265V+\\3704\\374C\\230\\316\\214\\204W>5\\201z\\275\\366\\212\\246\\035K\\201\\232\\256\\341\\261\\265\\3034\\000\\221\\233\\263\\215\\011\\207\\340L\\006P1\\346\\261\\302\\337<\\222\\321\\234\\303\\015fZ\\324\\274\\015m\\250\\340h\\350\\310\\302\\355Y\\330\\007\\205$t\\224k\\300\\236\\306\\242a\\352\\330\\255\\217\\340\\311\\343!\\206v{~\\254\\202\\300\\303\\372AOM?I\\373\\3159\\301\\232)/\\340\\000\\327\\307\\3248"\\025M*&\\233FA\\211\\211$\\313Ty\\357\\264\\333\\356>\\306\\030\\221\\027\\250\\372\\234\\337\\\\{\\333\\224\\271\\211\\033u\\345\\335\\204GoOoO\\253\\323\\356\\351\\372\\177\\243v\\323\\307\\274qww\\311\\351)\\310\\302\\357H\\\\s\\307\\006\\231\\\\\\335\\201x\\323p!Q\\201\\004@\\227c\\015\\246\\001\\017 \\352\\336\\002\\333x\\320\\265Z\\224t\\240w\\300@C\\250\\210\\215Q\\220\\362JK\\011^T\\036\\311\\217g\\357_\\3153\\367\\033)\\232\\014\\261\\373N\\203Z\\230\\222\\271$\\016\\344on\\362\\264\\002#\\264\\266\\202\\0364\\332\\004\\177\\351\\271\\256\\2765*%\\274\\210\\257\\372\\370nX\\317\\277\\027\\346\\236I*!\\250\\231)\\307\\314n\\3637\\205\\335\\241\\237|1\\351\\363yP6\\217;\\363\\337\\0146S8\\267\\0155\\304#b\\236\\215'q\\020]\\376\\036X\\014\\321\\313F >A2w#.M\\246\\263.\\341\\220wi\\262$\\0058\\367\\270$\\007\\363#\\224#\\025H\\245\\267\\275\\250\\246Q\\205\\011)\\011\\374\\036\\321\\360(N\\227\\342\\204|\\267\\310v\\271\\207\\021\\237\\264\\311Lf\\332\\327%\\357[\\214\\247\\233\\327\\215\\336\\357x\\215e7a\\271\\323lX\\216>\\352\\257\\250iT>\\337\\335\\273\\271N\\273.3(Fa\\267\\216S\\012\\374\\324\\326PV\\335D\\265P\\246\\307\\321\\270\\2611\\344\\265}\\272\\003\\216)KHm1|\\340\\367\\327RL\\267\\252\\021V\\032g\\312\\276\\004\\213.\\211\\\\\\204\\3434\\371\\035T\\271\\335\\0236\\225\\263\\023\\2572\\014H\\022n\\256\\327\\353\\340\\323\\334."\\344\\315b[\\2547\\016\\320J_\\352\\016G\\215\\311|Ce\\232\\252\\005sQ\\361\\335{\\011\\305)m2\\360\\213\\033J\\205K\\322\\351@\\317\\351\\235\\37103s\\013\\221\\032\\260\\341\\2724\\221\\2408=\\\\\\267\\315FA\\315B\\260i:X0\\366\\242\\221u`-\\011\\355:\\026\\361%L\\003\\332\\226\\261jk\\347Ip\\275\\250\\036z\\020\\354\\375SH\\000\\321#\\232\\357\\010)\\276Q\\006 \\261K\\354~*\\3261\\200\\2611\\017\\264l\\001\\204\\210\\222\\266\\323\\340,\\242\\254\\314\\334\\030\\032\\033\\020i\\020\\010858\\266h\\322\\254y\\027iT\\321Z\\010\\224\\236\\036\\226h\\321F\\243\\343\\204\\276\\235;:\\227\\261\\246j\\\\\\036\\030\\331\\345\\327+\\330\\356\\230\\327M\\370\\376_\\032#5\\034j_\\210\\011F\\306[\\006\\031\\254,/\\230_'BL\\357w\\303\\226\\022\\0154u+\\355T\\360FD\\203Q\\005\\2155k\\224\\360\\351\\361 \\244J\\342\\023\\362\\233\\310\\243!\\212\\305\\355\\376\\237\\212\\313\\227\\237\\256\\333I\\373\\355\\372\\364\\264\\233&\\035'\\254_\\267\\267\\023M\\3072)\\371\\204\\272\\344?\\212m\\014\\321V\\244\\015\\277\\326\\217\\322$\\3358\\014\\013h\\225?W\\337\\320\\312\\007\\341\\331\\224\\320y?.t~\\177\\377\\324\\225w>\\355\\250\\377\\362\\020t\\371\\350\\321\\216>\\316\\3506\\343f\\301Ly\\003AOw\\254\\270\\333\\0135b\\221\\275\\027\\233\\3447\\012x\\200\\320\\373\\243#\\364\\355\\333l\\374|\\036H\\337\\375La\\373\\257\\327\\341t\\367\\0366\\337\\200\\214\\345yx\\036\\261\\327\\367\\203!\\202\\202\\354\\242\\312\\305+}\\353D\\015Af\\260y\\232\\314\\337\\315d\\231(9\\264\\257^\\357.\\314\\006\\222\\275h\\225a&\\307\\353\\265+\\014\\244\\246^@.d\\265\\353U1Y\\002[;\\367\\207\\237\\246\\230\\341x\\3646\\307\\235q\\2205vH\\021\\317\\307\\233\\2377\\254\\332\\037Z\\334\\336\\004\\2528k\\373(\\024F\\302\\3574r\\237~!u\\251\\273\\346$1\\346\\216\\226\\332\\306\\311\\276\\251\\346a(\\367\\334dJV\\250\\001f&\\034\\2519\\254\\2607f\\034\\274\\371\\316\\312\\355\\355.\\333\\205p\\2513\\264S\\307H\\365>\\262\\343W\\274\\3555G\\320\\312\\031\\327\\323\\207\\267i\\034R\\2023R\\345\\317~\\310c\\312\\027\\257\\027\\233kQ\\261\\264_\\317\\2513\\231\\007\\011*\\012e\\030\\236\\221\\023R\\312$/\\303\\210\\252\\\\\\240\\370t>\\273\\251\\312\\217\\205w\\377\\026\\2439\\331\\324\\253\\3055\\306\\365\\232\\\\NX\\0100\\360\\257s\\011\\236\\350\\240\\312S\\015\\343\\330\\3706\\272\\330#\\0054-\\264\\330BZl\\213\\210\\227\\232,\\232\\245\\242*\\006\\225\\304\\364\\303\\215\\377\\267\\353\\021\\225^b\\020\\031\\243\\321\\223\\221p\\000N\\222;\\254\\321fd\\315Gy\\316\\034\\216WO[>\\277Y\\242\\342\\352\\215i\\311l\\234\\232\\315`\\302\\031l\\014\\023\\355!\\221\\237\\224\\361\\365\\266\\257\\015Z>\\231}\\020\\011\\237\\274\\326\\020bmV\\317\\005\\312\\235/2\\326v\\274\\335\\310\\361\\271cn\\317$\\324\\306\\353IT\\000t\\271\\202\\333\\204\\301\\006\\371d\\355R\\350:E\\307\\327\\200\\235\\327\\305\\264\\235\\222),1\\336\\367!\\016\\227\\263\\221\\365\\367m\\343/\\212\\213\\011\\214\\341\\247%%`\\323A\\244[\\213\\005\\331b6\\315\\312\\3529*\\310\\362Xy(E\\320\\341\\225\\3316\\012\\002\\300\\236h\\017\\227\\216<\\365\\377y\\312\\003\\363\\324_S\\014\\365gDsP\\005a\\\\\\206\\007\\277dD0\\030\\372\\273u\\231\\243\\354\\372B\\013\\316H\\034V\\331\\256\\000\\212|O\\222\\374\\202\\323\\015\\334\\314\\007m\\3659B\\371\\233u\\005L\\212l\\007\\024\\352 \\300\\206-\\315B\\362\\326V\\035Z\\311\\241\\035\\035\\001\\242\\201\\005\\341B\\245\\243f)CN'\\246\\3546\\362q\\270\\236\\027\\345'nw\\275\\026_O!\\003MT\\200\\014A\\220M\\366T;b\\226Q\\337\\025\\022\\354F\\206\\331\\3247l\\2639\\013\\276\\234y\\276W\\315\\260\\235O\\016\\024Xu\\013\\002\\316HR\\007p\\345\\246\\375x\\3712]\\216\\211\\006U\\201\\023duh\\206\\347D\\013\\002\\227\\037\\007\\214\\012t\\203\\256\\330\\027\\363\\330V\\235e\\324\\204N\\314\\343|:)|&\\031\\346\\333\\232\\201\\316i\\240\\301\\231\\352\\242|cTsy\\235$\\012\\347`\\351)\\006\\205\\342B1\\301\\275f2'D\\257\\255\\230R?\\364=\\023\\213v\\356\\257\\256\\256\\212i9Y\\025M\\244\\330\\206\\261S\\335\\274\\031\\015F\\350\\304\\213\\260~2\\231\\255\\376g\\361\\231\\024\\341\\317\\351j\\206~\\222\\217\\343\\031\\373\\003\\356\\2635,^\\341\\234\\0273\\274\\204\\300K\\234\\345s\\240M\\350\\022\\014\\215\\376U\\376\\376m\\377|\\265\\234as\\301\\306"\\227\\211}\\364\\007.g<\\212\\237\\336\\001!\\333\\277X.\\256Di\\254\\032,t>\\241\\206g\\223\\317\\305\\362\\257\\374\\347o\\373WP\\027\\233\\205\\255A\\2677\\373|\\263\\371W\\371\\373\\267}\\024\\246\\312\\371d&\\035\\0028\\212\\277\\322\\277\\177\\333G\\350r\\245%\\214\\036\\016\\023<\\207\\365\\267\\224\\257\\316\\227E1\\377\\253\\374\\375\\333>mJ\\354\\260Z\\236\\353\\010\\231\\314\\355\\257\\026\\232\\360\\261\\204\\215z\\373\\256(f/\\212\\031L\\020\\304\\362\\363w\\211\\021\\3243\\240>5\\362\\246+\\350\\270O\\177o\\205\\311\\274Yu:\\354S\\315\\031L\\352\\002\\3463(fm\\002%V=,\\260\\306H\\300\\217A9\\240\\240T\\327&\\177ttT\\216\\271m\\014\\265u\\015\\304\\3336\\312i\\003s\\362K\\200\\366;\\373%\\004\\317\\003\\313G\\364\\034x\\2245g\\2322\\203\\215\\315H9s5j\\272\\017\\326M\\004\\266\\256A$\\277\\351L\\271\\274V\\014#\\350\\231\\316\\206\\362\\241k\\333\\257U0\\363 \\344\\312\\255\\304\\330\\225m\\2402'\\271*-\\316\\267G-A\\247\\347\\3505'\\333\\266lqi\\265\\203\\361\\013Z-|o\\250\\242@?\\350\\241\\275^c\\255V\\213\\334\\247m\\362qz\\344\\313s\\013\\265\\3626\\37185]\\377-\\267\\363\\371[\\255\\3477\\213\\353\\206\\216)\\265\\241\\337\\270\\264I=N\\355\\242\\322\\316i\\265\\332\\002`\\245."\\357\\271o\\024\\327\\323a\\230&+%d\\303\\235\\005\\324b\\336\\334\\234\\224\\265\\003\\020\\372\\342\\226\\223\\251\\2306&\\271y\\220\\3310~\\376`j\\331t\\020\\360\\240\\332\\266X\\353dx\\322\\017S\\236\\014\\277\\212R~?|\\322?&\\313\\342\\220RH\\\\\\276\\227\\377$\\221\\371\\274\\205\\303\\247\\317\\312\\336\\366\\371y\\221\\376\\035\\351\\350\\265\\210\\213\\006\\237\\251\\366\\242\\357\\370\\317\\305\\365&\\233\\001g\\323\\017\\357\\025\\275\\212%d\\356\\241\\020\\237\\205\\376\\240t\\232\\255\\355\\2676\\231\\273\\262\\301\\256\\304\\213\\217_\\337\\210\\325\\330\\246c>\\2231;gS\\030$#\\365~\\275\\265\\226a\\035\\023\\357\\365n\\305\\342\\006F\\250\\213CB\\337\\262XXf\\242E\\264\\363\\276\\256T\\335#\\354nh\\325\\270\\021n\\201\\225Z{M\\032\\302m\\0205\\320\\222\\270\\376\\024\\227\\344\\206\\002\\314\\353"\\007\\341\\232\\267\\335\\3038\\361?\\210\\206\\316\\223\\233\\333V\\3555\\344 \\266\\317t\\350\\023\\370\\232\\354\\352.j<\\317\\203RMEXH\\301\\377\\006\\036\\001\\370d\\334\\025}n\\330\\340\\222\\250\\222;I\\321M\\021\\353L)w\\275\\324\\344\\333\\0304\\024E:\\221\\013&\\247\\320\\033\\3303\\333\\274z\\211\\221\\326\\350\\272A\\037\\226\\361<`\\323\\013\\230\\334>\\326b\\335(>\\017\\002\\377\\310\\375\\206\\303J\\3176@\\346\\300\\331\\343\\345Zt`\\354\\3214C\\014\\221\\321e\\353\\365jru\\235s\\374+\\262\\244u\\376\\356\\254\\231\\032\\270h0<\\302o\\021H&B&\\343ET\\350\\015TmG\\226\\276vV\\366\\011\\307\\020\\020\\375\\330`\\257\\256\\033\\310}\\037\\034\\246!\\257\\303\\202\\357\\004B\\323\\206\\032\\310\\343\\024\\012\\241\\336\\345*\\304@\\252\\354\\232E\\234y\\303 \\353,y\\276\\367[\\307\\031\\365\\206\\003m\\020\\015P\\035\\216\\3749\\007\\361\\220\\325\\242\\2216\\311\\011\\015C\\336!NX\\0203\\315\\250\\367\\237\\325W\\246oP$k\\202IT`\\307\\010lI&\\003\\267%\\214d\\256\\354\\\\\\223\\022A5pu~\\2204n|\\213\\306\\205Tqu\\300\\344]\\315\\352\\362\\232u\\235\\0308\\006e\\215\\\\\\357\\005\\315\\360\\0167\\320\\024\\326\\002\\306\\032\\235\\0129}\\026\\227\\350\\347\\020O\\351\\357\\356&8\\376\\356\\256\\0267U\\201\\313\\264\\354'\\364\\033h\\3412\\311\\350\\347\\254\\230\\300\\011,\\3117\\253d\\343OBDW\\224k".@\\365f\\230=\\316\\233\\316\\241ml\\003\\264\\225\\361k\\002\\244\\255u\\217\\304)\\034\\372\\301B\\323\\255Y\\332x\\3604tb\\017\\323/\\353\\207\\203z\\362%\\377\\256\\010;Q\\207{\\316"\\202\\0125\\002\\302\\336\\016\\271S\\261Y\\321G\\001\\315\\311\\362q\\013\\360X\\227\\251\\320\\177\\315\\321}\\314\\303g\\306-\\242P})c\\220Z\\321\\223~\\3239\\025p\\003\\336\\335\\245\\274\\232`\\340\\037\\325N\\362\\005\\016\\006\\247\\252P\\031#c\\213\\203L\\370\\320\\0062\\236:\\302G&\\016~>\\300\\233_\\243\\277\\365\\177\\332\\224\\320Z\\332L\\010m\\223o\\027\\313\\351\\003\\347\\004<\\275\\212\\013x\\025\\370\\325\\227\\3151\\210\\372\\240\\274\\337N\\226i\\007\\376&\\021H\\030C\\033\\3603\\210\\345$OR\\301\\234\\020\\261\\253\\274\\247\\356\\313\\342\\333\\314\\333\\240Wf\\\\\\353\\333r\\266B\\225+\\000\\025\\035\\330\\002\\306\\307^\\311)\\250\\311+\\241\\360\\356\\023\\306{\\212<\\003\\014\\344\\325\\377\\231\\335\\012\\304\\017Ub\\231\\325\\\\\\257\\304\\273\\345\\012N\\223\\362\\232\\254P]\\235\\300\\274\\371\\331\\321\\211\\232\\206\\241YAa]f\\242\\301\\007\\006\\252\\322\\006\\354p\\321\\236\\036%)F\\036\\011M\\211\\2327%\\332\\3068o\\204-\\343\\032\\030O\\026"V\\030\\275\\015\\001\\354@\\272\\357\\323\\232q\\232H\\005V\\307%v\\013\\330l\\036,\\354,\\007\\320\\362\\334C-\\236\\011_e\\375\\314k\\3753&\\221\\205\\336,\\347\\365\\366F\\220\\005\\255.\\223\\237\\363\\233\\012\\317\\000\\015\\334+\\351\\274\\274\\241\\317[C\\363\\344\\335\\321\\030\\345\\201\\274\\333 \\301\\206\\364p\\005\\017\\344E\\010\\222I\\012\\211\\366(a\\310\\242'w\\243+&\\277\\007G'c\\015~\\035\\032\\314\\352F\\222\\235\\222\\337]0\\326\\367\\357t\\262}\\2778\\034\\260\\260\\377\\245\\364\\347\\336]`\\256A\\033Q\\314c\\230R\\0347$\\343\\311C\\246k\\030\\234%$(\\017%\\222!q\\253?#\\023\\035EJ;\\320\\3150\\250\\373\\325\\223V\\253\\3350\\305\\020\\012i\\352S\\352\\033\\374\\376i\\262P8\\201)~\\304\\363z\\347l\\007\\367\\341\\245\\305xj\\275\\351\\244\\336k:\\252u\\012\\2005f\\334*\\370\\210\\012V\\355\\276\\002\\262\\272\\355\\024'\\333/G\\337\\237K\\330\\361\\240\\252\\334\\360y\\371;$\\010\\001\\017\\321\\314\\036}\\331!\\363\\334\\205\\374{P\\177\\233A0\\332\\306;U\\331n]\\331mFH\\324\\315\\353\\014b\\344\\371!\\374\\027\\343\\342z;\\330\\246\\255_\\277\\205\\227\\347{\\313\\235A\\355\\003f\\2306~\\237\\211]9O\\262\\263\\331\\315\\262\\357i\\337\\303\\371_\\310\\251\\263\\277"b\\325\\014Z\\251-\\265\\371\\222\\253\\360\\206\\225\\013Bm\\334\\337\\202\\021\\321%\\007wH\\321p/\\232\\016\\204\\264\\302\\327.\\320F\\0331\\365w\\273\\010\\274Q\\202\\332\\304$K\\320\\027\\325\\350\\314J\\011?\\347\\302\\235\\210\\253O=jPfb\\031\\211\\301es\\310u~\\004\\317+<\\304s\\014#_\\2619\\012\\032\\254\\301\\3278\\253?\\242\\334\\350\\200/A\\242\\366.\\346\\034\\204\\217\\016\\251\\310\\237S\\257\\025\\325/\\006\\247\\251L\\007\\251Z\\361!\\224XX\\013\\374\\007o\\346\\010!1\\177P\\003D\\267\\263\\346\\333\\344\\265\\264\\1771\\267g\\011\\253\\303\\022\\366\\3209\\220\\2218\\225Y\\021\\302s\\020>+\\265\\303\\223\\273\\221&a@x\\243\\305Z\\252eK\\010\\323Acp(\\236n\\024\\035j\\347\\022\\267Zds[\\323\\310l]x\\005)\\256\\274[t\\365\\341\\377\\342I\\033\\012\\350\\346M \\214"D8Q\\261\\346Q/f\\326\\016\\231\\255\\177/\\252l\\333A\\276\\177\\323\\035\\237w\\231\\337\\333\\254\\300\\256\\341]\\235\\343\\260+\\201J\\202]&iC\\324\\271i\\251C\\241\\020\\335\\341P\\032\\254\\362\\034J=(tP\\310\\212yt\\344\\210\\025\\024\\224 \\014\\333\\2675\\202\\030\\273\\360\\313\\271^\\277\\367d\\243\\273/\\274<\\337kf\\030iS\\272aR@\\304\\306\\373r\\015\\020\\022>\\007O\\306*p\\334x\\023\\024|u[,\\264\\313\\247\\230\\345\\304\\343\\230f\\320\\361F\\226\\333a\\000\\016\\016\\263}\\037\\205\\241\\227+&\\325\\352\\015\\215*o\\270\\317\\360\\271IG\\336\\035J\\361\\346\\355\\037\\312\\301\\203\\012g>\\255s\\262\\025\\334\\352H\\207\\223\\361\\025\\306\\315Dm\\275\\026>\\211nz\\336\\241\\312\\311\\302\\363G\\370\\006\\244\\374\\361f\\025\\342\\233\\327UI\\241\\264\\353\\365Tm\\252\\000-s\\216\\363\\310\\303M\\360\\375\\344:\\277\\357p\\317\\276H\\0236\\010\\217>\\332iY\\002\\373\\352\\213\\217>O\\016\\360\\024\\177]\\330\\330\\034\\264\\035\\220|\\321\\233G\\366\\012\\007\\340O\\027A\\272os[\\231\\037\\243r\\272\\255\\014M\\305\\321O\\323\\226\\241 \\225}s>u\\245\\224\\265)\\255\\037\\221\\333NHvQ\\340\\011\\3318E\\273\\034\\025\\364\\232\\234\\037\\25327g\\374&\\024\\357ncN\\305!A\\251t`f\\305\\017B\\035\\217}t\\273\\356\\336\\266\\253\\277\\2159H\\011\\357\\324a\\203\\235o\\022\\217\\004\\326\\326*K<\\026\\330\\364t\\340\\255\\360eE\\362X\\364#\\004\\263\\241c\\000\\355\\302N\\005C\\231\\267\\017Zw\\0232\\251zq\\203YaU\\356#\\015\\312\\032\\357f>\\015\\356d\\231w\\023o'\\223`\\245\\347\\2139\\000\\212\\311\\255?(\\262;\\347]\\347\\022\\373\\016\\345\\364ZW\\320\\032!\\323\\247\\372\\370\\365G\\237)P\\353\\313\\337\\015\\237\\0174C\\035\\250\\234f;F\\322pHC+\\216\\3755\\227\\245\\226j\\342\\321@b\\006\\205[\\321\\326\\350#"\\345ri \\273\\320_^\\223\\224\\361>+\\263\\231X\\254\\323\\315\\361\\016\\333:g?G\\334\\300\\267%\\032B\\362\\365\\201s`r?\\344\\3729\\260\\000h\\031\\345\\277\\263`5\\261\\231\\243\\246\\011\\024J\\003s\\323lh\\240\\307\\256/\\224\\336\\354\\005\\202Y\\201\\003\\310Cn\\331\\275i\\015\\261k\\016\\276\\221\\227[\\327p\\036\\264\\354<\\276\\310\\331\\345\\312<\\347\\026\\230\\021\\355y\\225\\255\\353!\\023\\003\\015k{\\3063eN\\220\\032\\253\\261\\202_\\012\\011\\246:\\345\\330M \\360\\207\\3611\\226H\\037\\341\\012\\223\\205\\271\\340\\023\\337h\\007@U"\\002\\213k(\\021>\\351\\275\\255\\004\\323$\\304\\001n3\\200Qp\\333\\345!\\3250L$\\237\\244E\\226*\\353\\265\\3748\\3207Fi\\247\\360\\342\\321or\\251\\367\\233\\241\\357~q\\270\\330\\215\\2077\\327\\214\\341\\315KJy#5=\\213\\014qy\\241\\010d\\376\\252KR\\3571\\340\\214\\012\\271\\005\\353\\206\\010\\374\\307\\300\\226\\323\\367\\027\\277\\005\\214\\264B\\256}\\325\\236R\\310\\015\\346\\030\\035\\306v*\\245\\376\\373\\204]I\\207r\\331\\030\\035e\\270\\307\\311P\\324?I\\0376\\217\\213\\303e\\0361\\357\\342\\203\\341\\377\\333>*\\276\\217)\\255$\\022\\304\\333t\\304\\354\\323\\271\\263/\\334\\316\\276\\2629\\373(;\\356\\0033[\\376J/\\314,f\\263}\\026(\\371Y\\227\\375\\351\\331\\214\\177$\\035F0TB\\354\\323\\257\\233k\\376\\213R\\322\\276\\343\\220\\366\\225)\\332\\367\\030\\273\\357Q\\023\\333a\\215\\317>\\317i\\237\\257J\\366E[\\271\\257W=\\370\\003z\\240\\250!\\001\\373\\220\\355=\\234\\2412B\\327\\305\\234\\343p\\323\\341A\\241\\032 \\263\\317\\252;a\\3729\\004\\304\\3060<\\032\\236&\\370\\224N$2\\231y\\344'|H\\347@\\023k:\\246zi\\264\\017\\0219\\336Z\\0279\\211u\\212r\\256\\014\\342\\234c\\340\\373A\\272@\\361\\352,F^\\000M\\242\\354\\226\\012\\352\\243c\\356\\233I\\235\\023\\277"s\\376\\356f\\376\\241X\\346\\2756\\276Z\\317\\377\\214\\336\\266\\323q\\3474]\\363\\217\\024\\177\\236\\2160k4z;:\\035\\217\\037\\237\\216\\327\\243\\303d<z\\013\\377<\\306_k\\312\\200\\037Xz\\214\\206\\354\\220\\262\\377\\254\\363\\037Y\\373ttz\\212\\311\\353\\021|\\216\\323\\366i\\3658\\203\\377\\323!v\\326]\\237.\\327\\247\\363\\364q\\012x>\\305\\320g\\307 |\\275&\\367\\333\\234\\375\\314\\274\\305HWs0\\340\\335\\213\\033<?\\350\\366\\234l\\012\\316&\\025p\\000&\\231\\326rt\\234\\035\\217\\331z\\336L\\274V60\\335:\\326Gg^\\227\\277\\376j\\3431\\304\\314\\266\\276\\204\\015\\004\\200CY\\323W\\360\\034\\266Z\\370>\\027\\366\\374<\\374k\\214ga\\355\\225\\033\\262a\\220Z\\255\\206\\324\\177\\326\\035\\240A\\321ud\\316\\223Y\\023\\202\\250\\3342?\\031\\237\\215\\333\\017\\374\\320\\025\\252\\305\\371\\331\\256\\327\\360\\003z\\\\N\\200u\\273\\231\\213\\001\\236\\014\\343\\257\\337\\177\\227S@&\\035m\\232U\\213o'\\313\\\\{TI@\\020\\213\\371| w\\331U\\276\\027\\244Q\\265\\024o\\033XD\\340f\\256\\320\\277\\217\\006\\305\\347\\320\\325\\350\\204\\003\\372_\\215\\236\\340\\273\\0348,.\\244D\\232\\2554\\234\\252\\344\\031\\200\\014!\\376\\323\\217\\257\\245\\037\\245\\316\\354\\216j\\212\\342\\353D\\255\\326\\313O\\327K>E\\361\\340\\367\\257\\010\\240j\\027\\335h\\177Z.("\\263\\346\\270\\350\\375\\231\\223\\246\\230\\253\\301\\362[\\032\\033\\216\\244\\354\\270\\317H%\\343\\020\\217\\020\\337\\222\\263TYye\\202c>\\202:\\010\\223\\2607-7\\366U:Q\\235M4'\\207\\321\\025\\275\\376\\354\\237\\3138@\\224\\226\\347\\016\\014`c\\\\\\004\\010\\3763PE\\217\\033\\002N>e_\\275\\340+\\004\\367B\\002\\024\\335\\232m\\273::\\031\\247\\376\\315l\\206X\\367\\002\\211|#\\330\\014n\\262\\264\\206;\\014j\\342\\373\\033\\313\\241\\253\\216w\\021mM\\306\\367\\256\\321\\036\\022\\271\\242\\276\\374V\\006IW\\303\\215\\000\\2011\\274\\303j}A\\315\\305u\\233"\\221\\365\\275\\037"\\021\\201M\\277>Z.\\034!\\036\\000\\323\\301\\005\\031\\275\\377\\000\\016\\320~w\\320lA\\301\\355\\215\\222\\206\\365\\244~\\023\\024p\\235\\037\\012\\001\\235\\376 \\336I\\307 I\\012=\\310\\355<\\035\\3063y\\020=\\217A\\335=\\207\\273t\\304\\334(\\352\\012$\\200\\317\\2024\\272\\355\\0161\\030R\\001y\\261\\274^\\320\\337aaS\\231\\215\\262 M\\210\\006\\265\\305\\363\\036l\\352\\215\\265\\035=\\203\\202\\001\\200\\004\\325\\335\\374\\224\\016\\212G\\253\\246\\033\\010 \\204\\242<\\001,GA\\203\\376\\326k#\\351\\240~@\\316+\\276Vq\\365p}G\\254\\017\\337'\\230\\2169\\366\\326\\001\\301\\323\\035$D\\000\\205m\\325\\223\\306\\265\\341\\355\\027dV\\215\\233\\363$\\265\\032\\362\\201\\326\\006f\\374@$\\023\\015\\367\\355s\\0001\\315\\027\\312\\256K\\014\\215i\\322\\242\\250\\322\\330\\357\\244\\234Wm\\207\\210\\276h\\232\\206\\323A\\354\\301dGk~\\303\\360\\266\\215d{O\\334\\225Ga\\207\\025R\\201W\\213\\316\\026]T\\376\\312\\314\\331\\035\\236\\366\\003Y\\373\\233y\\371\\313M\\361\\032\\031\\014\\337X|\\320\\326\\013{\\246BkQ\\3605\\310\\371\\021\\237!Cy\\324\\260'1\\2772\\320\\211\\022c\\343k\\261\\240\\351\\313\\331\\325?\\001\\261L\\253\\331'\\204\\311<\\235\\222y\\265\\335\\007\\022a\\007Q\\021\\326K\\025\\326}\\264\\366\\332$\\211\\270\\027\\225\\261(BbCa\\341\\244\\212\\2030\\244\\323\\345\\004\\375\\303te`\\350g\\324\\204\\242\\027\\261\\037\\032;u\\305\\032\\033\\266\\246\\205R\\2263\\012/\\207\\210:\\320#o\\215\\341\\323I\\341\\342\\313\\340\\355\\220k\\231\\245F\\316\\305G|\\351\\341wV\\3101\\217A=\\247\\372\\306\\364\\205\\210\\265\\300#\\014\\370\\250\\023\\360\\235 \\360\\240=,\\202v\\203\\300\\231\\361o=\\366\\310\\366\\342\\3644\\021\\321\\031\\237Nj\\353\\2570:m\\357\\364\\024%\\303\\204I=\\215\\014A&\\336\\273\\254\\305\\012\\001\\206\\035W\\350\\266(\\3018\\240J^0\\305\\344&\\375\\321,A\\245\\260u\\357Z\\310\\\\\\301\\212\\371"\\2455[\\037%\\326M\\200\\245\\373\\0251\\224pz\\342?\\033\\273\\310x"\\3251%+\\3474\\244l\\276\\220S\\030\\335\\235\\345\\320"\\017K`X\\201\\336~\\267\\000\\362\\357p \\233\\314?\\177\\273\\270\\231Oy\\302l\\240\\200\\331\\255\\026\\037\\356\\255\\026s\\256\\374\\245\\314\\0266K%\\334\\241\\025[v\\010t\\2619\\216\\206\\3750t\\320H#\\014\\322'r\\307%s6m\\012\\264/x\\350\\253\\342*\\013QH\\247%\\007\\355\\027bT\\256\\030\\025\\004\\307Q\\340\\351~\\327\\235\\236\\213DA\\303\\333\\003\\241\\375[3DU\\350Pf\\224\\247(\\307\\355\\272\\005\\344Vq\\035\\355\\242\\260\\261\\255h\\371\\375\\364\\350_\\015{\\305\\207\\033w\\310g\\220\\235\\302\\306\\337\\022\\330\\023\\244\\215\\340\\313e\\020H\\375\\243s\\004\\263\\261\\006u\\307\\354\\020\\001\\234\\007_\\352\\360Y\\374C\\003R\\014)\\373\\366\\340\\200jp\\360m\\232W\\253E)\\272\\227J\\216\\204k\\346\\342gq\\347G\\343\\034\\342uv\\\\\\211a\\304\\207\\026\\015p\\0205\\303\\233Oz\\264\\276f\\010E\\031Q\\252\\375\\344z\\213\\371\\300\\015NN\\355\\322\\237%\\236A0\\035l*\\317)\\004\\000\\336N\\353\\360d\\372\\001\\033D\\270/S\\3276t\\367\\272\\223Q\\306\\352)\\001\\325\\365\\204\\340\\252\\272\\304\\333\\377\\345\\3426y\\375\\031\\270\\213O\\2543\\312\\366o\\346\\313\\342|q9\\307\\330\\240\\370J'j\\225\\320\\307a?\\351@\\235\\001\\373\\013\\340<Uj\\360:\\377;~\\355s\\224\\274z\\221d\\311\\017_\\177\\377\\022\\376\\274\\371\\372_\\022!\\364\\375\\273W/\\372\\275\\337\\241Vbtz{zs||~|tz\\363-\\374wD\\032\\215\\264\\223\\366\\262\\347\\337}\\375\\372u\\037\\303~\\356.\\207\\355C1\\322+\\345\\250!y\\274\\263\\002\\2258\\035\\367\\262\\257\\337\\274\\371\\023\\326;\\255vW\\300\\374a\\277}\\372z\\230\\323oj mw\\037\\017\\323\\323\\257\\326\\230\\204\\255\\301\\364\\372\\275\\267M\\015\\235>6\\203\\335{\\376\\307W\\337\\301\\344\\373m|\\240u=_\\275[\\343\\375\\356\\232^6N\\217\\316\\351\\261^R\\017\\241\\352i\\275\\230N\\327\\243\\323\\351\\274s\\004]\\236\\246\\351\\260\\227\\201\\264\\215\\325\\261f\\361\\313\\372r\\265\\236ImnH\\253\\245\\334\\312\\351\\224\\353\\265\\207\\371\\350-\\214\\343\\021\\214\\341\\247\\327/\\377\\374\\342Gld\\327\\264\\271>Nv\\230\\252\\262\\352T\\225U\\247m\\370\\371\\030\\201\\363\\204F\\265\\311\\034u\\306\\240y\\250\\351\\373~r\\335\\277kz\\2356z\\301\\226K\\263\\352\\270\\177\\2071iC\\327\\260]q\\347\\371iy~\\226\\217e\\021\\350\\262\\223\\370\\006\\274P\\002B\\207<\\026P\\375\\004\\277AZ\\3208F\\230e"\\321\\001\\365\\204\\3235w\\305@\\222\\356\\235\\376\\245\\347\\005\\3504sy?,VqY\\252M\\364\\013\\177\\220\\317\\013\\213<\\241\\345g\\3142\\351@\\325\\263\\234\\324\\364\\301\\273\\020t\\363\\021\\360\\373\\342l\\3039\\004\\035\\264#(\\0277\\325\\353\\222\\0036\\031\\343S\\325r\\245w\\033+sDSa\\003\\332\\2356\\253\\000*\\234\\016E\\007\\026\\313\\003\\272\\274\\220t>0\\242f\\035\\341\\222\\223\\000\\013z\\005\\230\\232\\330e\\311\\263\\277o\\351\\006\\266\\347\\372\\272m_\\214\\235k\\321\\360\\366\\217\\201\\240\\177\\021\\303xG\\355\\025a\\200"+o\\251\\373\\323n\\350r\\241\\276\\213\\353\\322`\\202\\365\\033\\207\\331\\270\\372\\303h\\300\\375\\350\\273yq\\037\\266\\254\\260\\256\\333\\226\\325\\012\\030\\250\\222\\246\\207S\\360G\\247\\303\\355|;\\317\\247\\345\\3629\\376T+\\200\\372\\2627\\2554\\307\\273\\237\\026T5\\337\\266\\356\\246\\217\\037\\264\\360`#\\251\\355\\304\\317?\\341\\341\\352\\030\\375$]\\037\\312\\372\\303l\\377\\343\\377\\257\\323\\015\\251\\307\\027\\314y\\223\\241DD\\307\\272g,\\032\\004#c\\254X\\027k\\276\\371\\374jZ\\213\\270l v\\325 \\012a\\035'\\2669\\263\\251\\253\\341\\350j\\334'\\015\\023s\\007\\315\\203\\332=\\034\\220\\262~\\020\\223P?"\\257\\250\\004\\261hO\\257!\\266V6C\\013\\367n\\254\\0360\\204\\336\\253\\010\\242\\303\\016\\371\\0332\\004p\\215\\342\\311\\310\\314\\254\\257dl7\\226\\2166\\240Q\\343\\0209HT@"T\\220[\\331\\006\\024e\\034w\\311\\235~^\\033\\214y#\\362I\\377\\216y\\266\\270\\345{$\\025\\025v\\360\\345#m\\270.}\\323\\033JD}\\250\\212.5)\\016\\202\\303\\224\\216N9.\\267\\212'L\\013\\321\\236\\007\\244\\016v\\375q,J\\253u\\357\\253l\\275\\321\\351\\352t\\216A\\345\\203G\\230XN\\302\\030\\205\\221\\304`\\005\\017u\\237Q\\321$\\026+\\254\\370\\022G\\006\\250m\\260\\020\\020\\215\\200\\0334/\\267\\310_\\265\\372\\021\\233\\2221\\303\\032\\367\\352L6NH\\207\\016\\334\\250\\354\\015\\244Jy\\257}\\004L#\\362\\236sb\\035;\\353\\243t\\210\\237=\\226\\332UN\\307\\252\\310\\260\\302NO\\236\\314\\223\\365\\332f\\000\\023\\313\\351\\235\\023\\310\\001\\232\\367Bh\\236\\223\\362!\\367x\\336Q\\244y2\\366\\365\\323\\201k\\251\\215u\\360\\005h\\376\\201\\245N\\322\\364\\350XJ|5\\316)\\375\\2531$m\\324\\370M\\250\\362\\300\\002g\\017\\200A2\\303\\027\\2437Qg\\244\\365;\\026\\211\\320\\245\\362\\367:\\302B\\363m\\271QR\\3253\\007NB\\027\\300\\375G\\356\\264Z\\277\\037\\233]\\365{z\\350\\317I\\206\\262uT\\034x\\360\\254\\352\\213\\277X\\261V=\\274\\211T\\370\\246\\254N\\323\\253\\255\\365\\272\\367\\366\\3646X\\312\\257\\220\\231u\\313!:K\\3756zK\\2473\\360ot\\006\\267V\\304\\204\\270z\\361\\014\\220\\037y\\213\\343\\037l\\333\\232\\301\\015\\000^\\332\\244qh\\016\\267i\\315\\345\\032^\\177\\232\\311\\034\\343\\204M6\\355\\237\\250@\\024\\265!^\\220\\037c\\022*\\320qQ7\\231\\265\\012\\253\\341\\031,\\036w\\305\\034\\343\\211Mw\\311Q\\323\\222\\036F\\231\\252Q\\216\\260\\374j@\\363\\256\\234Na[\\242y\\276\\024|`c\\022!A|PwU\\3227\\254\\\\\\035\\365\\365\\214+E\\254h\\344\\023\\332\\344\\201\\352\\333T6\\272i\\030\\007\\362\\312\\006\\312\\316\\317Q\\356\\206\\362\\005\\006\\335\\335\\333R\\276^\\374\\335\\244\\012\\313fe\\026\\220\\345\\203\\203\\030\\233\\251E=\\367\\241\\205b2-\\226\\315\\035\\366\\336\\235N{e\\223s*y4}\\3322/\\366\\316\\316s\\343\\226\\010\\3621:\\013n)\\317\\216\\204Q\\005u8\\334R\\307\\371#F\\325\\320\\177oK\\025r\\355\\213\\212\\253\\347\\370\\226*\\316\\261<\\252\\306FO[*\\211\\363xT\\205\\234\\356\\267\\324`\\207\\374\\030b\\005\\352\\323\\267@\\014\\363\\342\\012lU\\272\\245\\006g\\006U\\356uV\\225:8xt+\\337\\202$\\326\\345\\334\\275\\243\\275\\346\\272\\333\\260\\207\\0343\\277u\\016\\272\\210\\3221\\036\\273\\315Z"\\363\\010c@\\355R3\\262g\\023\\274\\352\\013*P\\212\\323\\214\\017\\370\\371\\226\\355]\\374\\303\\023\\351dQ{t'.\\205\\215\\315\\266\\014\\304\\027}\\252\\373\\015\\017\\365\\354rK\\371=_\\341YP\\001\\330\\231{z\\360\\305aL%N\\360\\227/\\254\\241\\364\\272\\177\\027\\037\\300T]\\365\\344\\002\\333\\032\\013\\221\\325o7\\304s\\017\\2177\\275B\\321\\323\\213\\217\\306\\206E\\363\\372\\1775l\\327;fg\\305$\\217C\\002f\\321\\365,\\306!\\244\\224r>/\\226o\\310\\264\\012d\\004\\374\\321\\246@\\312z\\340\\007L1\\236\\361\\301{\\204\\332\\0353\\017\\362<]\\256e#q\\011\\262\\232D%H\\346\\233\\324\\340t\\321\\243:8b\\211a\\010\\264\\347\\017Ww\\317u\\323D\\254\\260_'s\\257\\351\\326g\\256\\317\\234\\015\\252\\333\\022-\\003\\331r\\373\\034\\266\\367!\\352~\\017\\373\\364\\2236\\337a_TyT\\011\\377\\251\\251\\362d\\302\\220\\023_\\304\\007\\223\\266\\256\\022\\330r\\022\\261\\032~T\\324;n\\352\\206\\316\\347\\260\\230_\\330\\261\\355\\205\\232\\206=t\\330\\347k8\\030G\\256\\014*\\321\\021\\277\\316\\204\\253\\230O\\366\\015\\224\\0278\\340\\321\\240\\003}\\2112Q\\331}/\\376\\261\\331\\017\\007\\220)\\177%\\253M`m\\264\\035\\364\\014P\\252H\\234\\204hQ\\316\\0277\\320\\3501! \\001D\\3320\\347>&\\017\\232\\201\\265\\005V.\\211\\037\\260\\354t\\250\\027\\200\\232\\276I(\\343s\\243\\2239\\227\\027\\027y8\\312#\\004\\221\\205\\232\\207\\025\\225\\316u\\217\\351\\346\\305\\324\\177p\\205[-\\374\\356\\3217\\212\\251\\244\\236{\\265\\005\\247-k\\325\\360\\272y\\250\\235(\\247^7\\021K\\234\\365F\\335mc\\3628\\211\\224\\324\\004\\261\\373\\316F\\355&\\32274t\\204\\342O$\\337K\\343\\341\\370\\365\\245\\371N\\223@OGX(\\373\\305\\233?$\\316r\\305\\353\\2045\\276\\336`\\372<lL\\345C\\235\\364\\256\\234\\300\\012\\213\\241O\\330\\366\\352\\036?\\232'*\\245N\\222d\\206\\016\\301~#N-W\\011P\\371e\\031 \\367\\241\\024\\343 O\\372\\372;O\\206\\372\\0364\\265\\3402\\036k\\216\\177z\\032\\363\\221\\272\\2732 \\201\\016\\011\\362T0\\004\\251/\\315\\346]\\334X\\253\\305#:\\020y\\244o\\3064\\3247H\\303\\201\\274\\255\\015d\\217\\333FDw\\245\\036\\271Rrg\\317\\037\\302\\232\\360#\\273b\\215P\\233\\352:\\006\\202<\\036\\256M\\035g\\266~\\347\\304\\265\\320I\\216\\022\\325\\335\\207\\342\\334\\003\\316\\366'\\341\\331\\3569\\265\\337t\\274k\\200G1\\324\\315C\\301u\\320h\\200!h\\035_b\\333\\030\\352q^\\267Z\\334,\\317\\213N\\257=<\\030\\275=\\035\\341\\025k\\312\\277\\333\\360;M{R"\\0354\\031s\\330\\246{\\355\\267\\326\\\\}\\350\\252v\\266tj\\265)\\355\\323i'\\265o=\\322\\213Z7\\236\\021\\307\\007\\037\\333\\220pt\\214\\356\\267\\3442K\\312e\\265X\\3637\\343\\004Ag\\267vG\\2379\\2251v\\362\\344\\372\\305F\\207\\\\\\376X\\302\\220J\\255\\035\\006\\206\\262B\\261q\\227s\\375\\205\\334\\301\\206\\202\\352\\355\\350t[0\\344.\\335$\\343\\201X\\301\\2200\\336\\207\\322W\\343\\250p\\377\\244U\\305b\\015\\355k\\326\\226<\\221FS\\313x\\344\\001\\030V\\001\\017j\\224\\361Vz\\310\\355\\323\\331\\216+\\334#\\266\\320\\226\\363\\214\\241S\\212S\\266\\250\\304k\\026\\220\\232\\271\\243\\216\\321\\243cT\\006\\262\\202S\\003\\300\\201\\215\\203R\\203\\375\\342\\012\\017v}\\212\\344\\247EUr\\214IW\\335\\000<;c]\\361d[5\\340T\\316\\2667\\211F"y~\\026\\2311\\006z\\245\\255-\\017\\217N\\372'\\356!\\272|k\\271\\366Y\\332\\372=\\026\\306XSg\\303c\\250Tj\\314\\375\\343]=\\013\\344\\224\\347Ox\\277\\362\\013\\277@l\\266\\001\\360>@\\231f\\0108\\346\\373\\201\\00015j@0yGA\\333\\277m\\322n\\222\\347 \\227\\257\\212?\\241\\363\\326}\\023\\014^\\262\\241)\\006)\\017\\234dP\\307LsBc\\310\\243\\002v|\\3554;\\343Bg\\273\\012\\015\\270%<\\242^\\257&\\313\\025L\\341\\330&\\276\\234O9\\351,*w\\026&b9Jr\\213\\300Y{\\202\\217\\337\\240\\011\\324d\\371\\371\\247E9_Um\\316|\\375\\346\\353?\\275\\371\\371\\315\\217?\\277\\374\\341\\205\\2146\\375\\262\\025rn\\206*\\276\\342\\001j\\210\\036\\260R$)Y\\262Q\\250\\207%\\221\\015gyQ\\231+\\366{\\036f\\372=Q\\233\\216\\347\\353\\345\\345\\354Z\\220<\\261\\330\\370')o\\007i\\250{x\\337W\\367:\\303\\030Sy\\204\\203\\262\\315\\332\\311\\264\\374\\230\\244Y9\\315\\223\\352|Y^\\257\\360h\\204\\203\\370\\005\\0324#\\247\\371\\246\\274\\022\\363\\010\\021\\367\\377\\370\\346\\373\\357\\362\\344\\351\\204\\371\\225\\303\\244SN;\\311a\\357Y\\302K\\267X\\254\\266\\206\\347\\037`.\\264R\\025\\313\\3257\\024t\\254\\215\\355f\\224\\354\\245\\2534\\240\\254\\321Mo9M\\205-\\301\\373\\346\\356\\253\\027\\306\\216\\355\\377\\344u3@gj.f\\235oX\\375\\211\\363\\270\\307\\246G\\320Q\\224\\362\\230a\\332\\245km\\377\\2406]p\\017\\214\\002(\\000HM@A\\201U\\306U\\223$\\232\\206\\326X\\210G\\027h\\335C\\321pN\\317\\264;\\2017\\230\\002n:Znv\\250\\244\\365&$\\330K\\011;rBV\\216L\\236\\002\\336\\305\\270\\014\\350\\272\\033\\225\\007\\360/\\262\\027\\305|\\312\\215G\\245\\237/\\256\\2704\\010z\\204gP|\\253]\\265\\361\\315\\361(\\007r\\355\\026\\234S\\272\\261\\303$\\240~{\\036\\335\\244=\\326K\\324\\253k4\\017\\266\\204\\307\\337\\3607Y\\012\\204\\352\\006\\250\\336l\\026\\300c\\203\\354\\006\\307\\211\\015\\002#\\334\\344h^\\227\\037\\376\\356\\360\\331\\323\\336\\344Y\\242\\000\\363{\\225\\035\\256\\001\\237\\302\\344\\000ib\\254\\332QT\\355\\371\\260\\312\\357\\022\\201\\272\\227\\223\\351\\275\\3728z\\352=\\266\\201\\331\\223T\\246f\\320\\312\\022\\230_\\320\\245W\\243\\270|\\215&\\2661\\322-fS\\361N\\345?\\331\\303\\260\\320B\\362z\\237\\264\\013\\371\\341\\233\\227\\257\\337 4\\257=4\\343\\0010\\204\\342\\324v\\322\\305\\272\\016)\\255\\342g\\260\\211\\275g\\251\\266\\243\\205\\354^\\303\\216\\263;\\235b\\305\\023q\\213\\347a\\350\\212\\312^\\322N\\265\\355\\334}\\244nm\\374\\224\\220f{\\354\\371\\0238KK#\\016\\316\\333\\207?\\360\\317\\256\\342\\013:(\\257\\272Zj\\213\\246\\357\\355h\\272\\276\\265\\023\\242@\\355\\230\\374\\362E\\205o]V\\274c\\331/pa!\\361Y\\234\\243\\351\\264\\344\\0075\\222\\363\\334\\253\\245\\266\\347\\265\\223b\\313\\332c\\035\\324\\011\\362vr:\\256\\034*4R\\270mM\\236\\370&\\215\\373\\216\\363}8\\316\\022\\322\\265%\\351\\300\\023CJ\\371;\\216`;\\234mG\\361.k$?\\027k\\2174\\010\\227\\332qy\\326\\352\\015\\340\\262D\\003\\201\\007X\\267\\375\\347X]:Nq\\004=\\263\\263:\\253@YK$\\3761j\\224\\304\\267\\331\\252\\024\\366Jk\\265\\224r]hA`\\242\\235\\233v\\003\\033z\\342\\341\\0316\\355\\364\\315\\246!\\274\\234*\\357\\013\\326\\014\\260\\263AG\\264o7\\315=\\236g`k\\254\\206\\012\\033\\273$\\377W.\\207X\\207}\\341\\212\\350>\\272\\011c\\015H\\007\\341\\242\\220\\274\\243N!*Z\\204\\2062\\010o\\271\\2603\\254N}M7\\021\\260\\232\\327\\224\\357N\\370\\352\\320P\\322-\\212\\207P\\350U[\\211\\366N\\015\\304\\311?\\006\\317\\306\\230\\232\\373\\023\\000\\310Y\\253E\\365y\\010C\\377\\023\\352\\366\\305\\026y\\300V\\344\\030Y\\241!\\012{$\\260\\344\\224\\305\\226\\321\\221@\\216i\\375\\343\\264.\\342\\310ML\\230<\\214\\365C\\272\\253p\\031\\3614q\\272bv\\206rA\\003\\266\\307\\303pl\\342k6E\\305\\340B\\350\\312-\\312_b\\246\\343s\\334DFP?n\\271\\3703\\276f\\242\\031\\246\\033\\3518\\250CzG\\335t|\\210\\270=\\0270\\241\\026a\\247\\326\\032\\233"\\272\\012[\\002*\\014]<\\005`\\206]\\000\\264\\330zv\\321p\\037,\\314\\203\\203\\024\\026\\242\\300\\243\\004$o\\311\\025n\\002\\232\\221/\\343\\002\\257\\242O,\\227t\\261\\011\\233\\\\\\235l\\346(\\351'\\376\\241Ts-\\257\\205\\330'Y\\333\\360\\036\\312\\232O\\234\\231\\210\\371\\003\\0273\\020\\220\\025\\020\\217#\\201h\\252\\333h\\372C0o \\261q\\002\\206\\225\\217A\\022Nn\\346\\253r\\226\\367\\376\\214\\177\\036\\365\\262%_?Vx\\327\\234\\367P\\353.\\011kL\\241R\\364\\013\\371b(Mq\\305\\335\\002\\366\\262^F\\212\\350f\\235\\270<'3\\237/n\\303\\275F1\\340~\\271\\231\\314\\312\\213\\022@\\377\\241(\\256m8\\036\\023$\\321\\025\\362\\366rR\\350\\022\\260\\3147\\266\\305`\\344\\340\\3005`\\336\\021.\\331\\002\\013\\250%\\366\\354\\342\\343!y\\364\\305u\\313\\374\\246~\\225\\032\\373\\3417u&\\304\\334\\025\\312-I\\367\\336\\253.\\006\\331\\256\\276\\267_\\325\\312k+e\\365\\272\\274\\272\\236\\311s\\257\\333\\341*\\233\\302\\257\\216\\016b/;\\240\\205\\022U\\275\\037\\365}\\025\\215z\\352\\213`\\250\\3300g\\271\\202r\\375\\270\\361\\352\\332\\002\\265!^\\362E\\020-\\331\\307\\015S\\345\\036\\277\\017\\006B\\362\\353\\325\\004\\030\\220\\004\\375\\322(\\342\\266\\017\\204(\\274\\361qD}\\032C\\037KYoro)\\211\\011=,\\321\\220\\311\\266\\024\\027\\006\\217\\\\m~\\236K\\325\\371S\\323\\316\\\\\\303\\351\\321\\310Q\\023\\360Tr\\226N\\017\\260\\032-9\\240\\300j4\\027\\267\\000\\341\\334\\347\\034F\\300\\373\\226\\007\\312\\302\\320\\200Q\\037!\\245\\243\\205~k\\364E\\315\\322\\003\\216@ k\\336\\024p\\213\\341\\304M4\\031\\356DdL\\002\\366syvm\\013\\354?(\\234\\026\\232\\0367-\\250\\035\\222_O\\246<\\334\\260\\203>\\207\\237\\313\\310\\346(\\010\\027-\\226X\\177_\\353\\304c \\026a[a\\373e\\265\\275\\355\\003\\027R\\312=W.\\220\\015\\260\\306\\363hh\\234\\311\\241\\007\\353\\215V\\201o\\213#\\251\\032NF\\012\\245\\201\\033\\013\\006\\201\\221(\\315\\331\\036\\363\\017\\364oQ\\345w\\0337\\215\\001\\273\\262\\243\\373\\276\\206\\236\\214\\235\\370y\\331\\343|\\277\\3605fA\\265\\346\\007\\322\\237\\215\\253TK\\012N\\326\\310\\362\\332\\301TB\\310\\327\\370%\\211\\341\\253\\300\\361\\214\\305F\\202\\351\\320\\324\\340\\237\\220\\323\\243$4<P\\240\\342T\\265.\\252\\037d\\224\\3126\\327\\006\\355#%\\276'\\255\\306\\220?\\310`\\001\\373D\\323\\022\\015\\033\\214\\237\\260Vbsb\\356$\\035\\340|@Xb@\\241\\002l\\014\\014t\\276*\\366\\353]o6\\270\\2628'\\373\\322Z\\260\\377\\205\\335|\\010h\\253\\032l\\253m\\300%\\331\\333n\\034|E\\310D\\035$1\\345\\213\\300N\\221\\210\\252!\\374\\277\\033t\\026\\303Uqp\\003\\213\\334\\004\\010\\311\\027E\\001\\031\\331B\\313\\261\\221-\\005;\\231\\241\\247\\253Q\\235\\007gux\\272\\351\\201\\245\\033\\212D\\010\\373&\\026\\307L\\344\\201\\264S\\276\\310\\201\\337m\\363\\020m\\303\\331\\247\\350CR\\3301\\233\\002i\\004\\370,xQ\\266YR@!\\222'\\340Yv?\\211\\207\\356\\032\\367(\\224\\017P\\245g%\\360W\\212EW\\005\\320q\\016\\202\\015\\364\\234\\203w\\205'\\207'\\244e\\365\\242\\254\\240\\3759\\331\\355k\\270\\220\\365:J\\207\\3261}\\010\\177\\373\\0013\\2159\\024\\365|2\\237\\276.f\\306u<$\\335\\032\\201\\231\\314*9\\330a\\032\\2065\\216zD&\\312Q\\3509\\275s|\\300v\\231\\016\\205\\326\\353(!\\340\\274N\\3020\\242w\\315\\236\\010\\366E\\305\\310\\216Q\\206\\037>\\245\\030\\270r\\237\\250\\2270\\343\\260\\030DV\\315v\\342\\212U \\302\\313\\323=\\306\\2735\\365\\265\\211\\353\\257\\2312\\223\\340\\360\\240\\246\\244(\\236\\327[=\\024\\264\\201\\371\\212\\275\\341\\262'p&{+J\\036\\016,\\324\\303k\\307\\256\\253\\332?H.\\017\\005G\\323\\000\\276\\240\\372\\266\\021\\374&x\\332\\261x\\200:\\241\\354A\\315\\355\\355\\030\\234o\\263\\342\\224{\\220FJ\\265#\\0345\\0279\\372(X\\246\\004\\355\\013\\032\\264\\227\\277\\033\\246=\\367\\242\\261\\252Pd\\202\\345\\305\\222\\274cY[#M\\204\\372\\032M\\375\\013\\213\\310\\252\\223\\251\\023\\265\\242~\\301\\356\\305\\024\\015}\\273=h.\\201\\326\\004*VN\\313\\274\\250\\307Og\\316u\\025\\360\\214a\\321\\234\\217\\\\\\262\\3524\\354\\022e\\361\\363\\304\\216S\\214\\202\\217\\306'R\\276\\205\\223\\\\\\252&\\304J1\\317\\334s\\177BT\\227\\022\\252\\220\\337|\\264\\005\\327\\353P\\013\\020\\261_i\\253eu\\012\\301t\\226\\022'\\021\\237\\272X\\262oi\\363\\231\\200\\206a\\004\\346\\300\\266N\\037\\273\\220\\247\\0053\\274\\301\\265O\\345x\\271/d\\345)\\224\\025.i\\345|\\027\\351/\\251s\\222>\\374n'\\035\\374\\350$i\\022\\037\\301t\\313!\\234\\225i)%\\277\\270\\310k\\013St#:}2\\210\\357\\302a{\\375i\\304\\371\\330`\\263\\255\\026\\243O\\036<\\351\\027\\225\\202E8\\260|\\317\\0360>\\334/\\333\\352\\333\\342\\254l\\226\\24107\\211u\\034G$\\032]\\353\\242\\202\\357O\\204\\0160\\250(\\026\\237H\\234\\243nG2 \\346?\\353\\365\\011\\351{\\3467W".\\017\\220\\357\\262\\2354\\016\\255\\325\\352t\\260\\216\\217\\215\\025\\305\\003'\\356M\\211\\224yv-\\363\\307\\347Ro\\312\\007\\363\\301<\\237\\327\\315\\361c\\003\\005\\027\\203}\\311\\000\\261\\317\\035,\\335C'\\260\\227\\240\\211\\202\\001\\235\\367\\004#N\\247\\235<A\\217\\346igM\\021\\231\\222\\336e\\266\\234\\025\\223)t\\367\\227w\\345\\212C\\366\\347\\275\\267\\247U\\247\\227-?a\\224\\033\\014\\021\\323k?m\\217No\\373\\343N:z\\373l\\214\\261\\203z\\317\\260.\\354\\235\\213\\347 \\316a\\024fR\\301\\261\\373\\326r}\\276\\230\\255\\213\\2533@\\200w\\313uyu)o\\213\\302\\240>\\254\\257\\212\\325\\004c\\230N\\256\\322G\\2752[\\256\\330\\260 \\357\\271N\\240\\357\\325\\331b\\012#\\177J\\177\\261\\024\\216\\005\\276\\327\\255\\337\\015Oo;\\003(2_\\360\\245C\\357)\\333\\377\\254\\237\\262\\001\\347\\372)\\367\\374\\224\\237\\375\\\\?\\255V\\237g\\005\\266\\241^\\233=\\371\\301\\301\\221Fo\\363\\361:\\207\\337\\352\\325\\331M\\241\\360\\005\\211\\2518\\373\\300\\032\\367b\\011\\204\\030\\244\\375K\\037&\\331\\000A\\236\\302\\203\\\\\\342\\366\\250p'y\\366\\264\\227t \\021~\\241?\\334\\355rrM\\257\\320\\360\\370\\372\\243\\223,y*\\001\\321\\365\\365\\303\\374P\\177\\035>\\003r\\361\\264\\307\\371\\317\\222q6+.\\201Vp\\255\\213\\262\\230M\\201\\357\\3442\\376k\\014\\3545,+\\027Z\\241{+\\227\\220\\237\\220\\275\\354\\217\\236\\270<\\206\\262\\024\\241\\237\\266(4\\363U\\\\\\364\\351j)\\305\\227\\317\\032\\352\\300\\362c\\373{q--\\011\\371\\227\\313\\305\\3155\\267\\341\\276L\\013\\210H<|8s\\270\\030\\375\\030g?O\\345\\035\\370\\321q\\206\\212\\257d\\274\\031\\010H\\361\\241Wj)7\\011\\000b\\227\\317X\\345\\276.\\360\\246A\\277t\\024>aB\\225}q\\004\\251o\\352\\235\\317\\240\\220o\\361\\243\\273\\210\\260\\257\\213e9\\231\\225\\277\\0027\\256\\205u\\3709NnZ~|J\\267\\3538?\\3721v\\234\\267Q\\007\\206\\356\\262u\\015\\311\\267A\\326\\256\\207\\271J\\225\\250f\\027N;F\\202\\030\\246\\220\\016\\237\\3320\\357\\373\\225\\231\\317JS~\\223\\305k\\2001\\371\\300\\276\\332&\\011&\\370\\\\0\\030\\364P\\006\\301\\221\\255\\234\\332*hB5\\376\\021_U)\\237\\223\\212U\\003^.\\220!\\027O4>\\361x\\374"X"\\300\\003\\026\\030\\027d\\013\\334(\\353\\036\\270\\005\\357\\367I\\343T\\321\\002\\313\\000\\310>X\\206\\305\\025\\336X%k\\234o\\332-~i\\037\\323\\333\\034\\370v\\037\\335\\372\\371\\226\\014\\353\\312\\330\\024\\232#\\272\\247\\3126\\224\\027h-\\314\\2052\\275\\003\\343o\\210\\003{\\250(!:\\207\\013\\275H\\015\\274\\310\\215\\356~\\017\\337N\\226\\225\\225E0\\000\\225\\025y\\205F(\\377ukB\\315o[\\225\\355Mm\\331\\025\\216\\235\\317i\\017\\350\\027[a\\351\\227\\323$\\272\\004\\213\\034>\\350;4 \\300\\221\\364\\215bi\\014\\216]\\343\\334\\212\\205\\362\\232\\336\\315<l1R\\002\\253\\346&n\\326\\320/'\\234\\360{EH1\\201]\\015;\\226{\\322\\277\\224 \\305\\262\\226%\\2208\\240}\\230&i6h\\306\\333\\2063]\\\\}?\\231\\227\\327\\236C&=t|?${ \\266\\023$\\325\\2101\\227\\024!n#\\322\\346\\177m\\307\\301\\336s\\012\\255P\\032\\244\\221\\360\\023\\305\\375\\020\\3265\\272g\\367\\366=\\003\\345g,\\242\\221\\232\\325%\\331\\266yxip\\211\\027?\\036\\351\\225m\\262\\326\\376\\335l\\244+\\225ht\\273{\\354\\002\\203\\361t\\371\\011\\225\\005\\213\\236\\3516=\\031\\226L\\030\\016I\\360\\234)\\340\\307E \\357\\374\\237\\004N\\300{?\\020P\\321Dy\\307\\320\\234\\202\\211:\\320y\\3105\\201\\270\\001\\222\\025G\\274b\\223\\343\\006=)^"\\276\\24072\\267\\004\\221\\222;\\2738\\202\\224y\\011d\\213\\260\\035\\032\\327p%\\355\\255\\311\\351Uu\\012\\347 O\\314_\\350\\033\\333\\333\\015\\224\\235\\354\\353+H\\227\\336\\352\\310.|\\254\\275\\261V\\330\\272\\363\\243\\363\\206\\270\\015\\213\\\\_\\006\\243\\377\\2149n\\032\\217Z\\231M<\\205\\210z\\204\\223!\\246\\300\\010\\355\\364\\202[t#\\034\\035\\372\\015L\\351|\\361\\034\\333\\321g\\212";\\015\\246\\356\\334(\\236){\\334\\354\\342f\\305\\206\\243Y\\300\\256H\\246M">\\230\\0171\\265Km\\362\\300\\021hm\\263{\\227'O\\321\\226\\214x=d\\204\\322\\001\\011\\200\\201\\035k\\314\\376\\321\\262\\264Gt\\372\\273\\227\\350\\254$\\234\\005\\221\\321\\3636H~\\311\\341\\263\\323j\\3349\\355\\245(\\320\\036\\346\\311\\243\\223\\344\\331\\241/U\\027\\217\\261\\221q\\010\\011~2\\255\\366\\264n4\\005}0J\\236\\006t\\301\\252\\261\\324\\363\\305\\365gy\\310\\026i\\010i\\272\\0322\\370B\\036Q\\213^\\345p_\\351 \\272\\031\\007\\020x\\\\!\\267_B\\007\\365\\007nf\\317\\003\\242k\\021\\177\\250\\211\\016\\364\\333\\341+\\372\\374\\310RD;6a U~g\\231\\231\\307\\330j\\265#\\204\\255\\201\\177\\275>\\250\\257\\211m\\003_\\217\\021ak\\324V\\345\\002[\\203q\\201\\365z\\304rcZ\\213\\030G\\354:\\216\\224=\\245\\335$U\\023\\342\\265\\002)\\371\\266>\\300\\266B\\017\\264\\232\\237C\\215\\226h\\261\\035\\344D\\213xS\\356\\217\\354\\177\\265\\3616\\351M\\202\\026O\\334\\030SJ\\347{\\206\\337\\026\\350\\335}\\201\\324\\230a\\300n\\342l\\021>m\\221"\\243\\276\\353,\\030\\003\\327\\212\\230\\013\\242x\\376\\324\\3359\\211\\220.\\032V\\264\\011\\343w2\\023\\215r\\207\\302\\341\\313\\205\\350fpX^\\271y\\346\\261P\\255\\021\\003\\254I\\025"\\245\\364\\305\\003\\354N\\013|B.\\326D7\\3115\\310\\330\\3441\\213\\243\\021H"\\346h\\020\\361\\371\\364v\\034\\221\\2559\\251\\035$\\233>\\272\\314\\323\\271\\205\\241\\225\\223\\002\\334b\\035\\001\\323\\006:\\351\\031(\\251\\274mQ8\\236A;\\355\\363g\\226\\030\\330&\\231\\353#c\\320\\334g\\021#\\223\\013M`P9.l\\245\\261\\326]^\\242\\205\\317\\331\\254\\310p\\355\\316`\\250\\201\\303TF\\007\\267\\204\\262\\240g\\257\\217\\307\\031+%\\351\\315\\264\\213\\345\\344\\022\\367\\263\\300\\274I[D\\252G:\\233[\\255\\206W\\335\\277r\\227&uJ\\252j\\315\\200\\010\\0063\\335\\333)EZ6:\\236\\246\\002\\205\\361\\363?s\\263\\014\\004Ny}O\\320\\020\\206f#y\\267A\\331S\\273\\206\\\\\\327\\300\\010\\246K\\250\\016\\356/\\214\\271\\023-\\206\\317\\324\\253\\353\\332\\0256\\335\\222\\273T/\\376\\372%3\\247\\201\\177\\363\\357NQA\\214U7n;p\\376\\331\\0154\\364\\255\\224\\221\\331\\221\\235\\026#\\023F^\\227L\\027\\205W\\023(\\264\\206\\374n\\034\\020>\\362D\\241t\\\\\\023\\256\\270\\325\\350p\\260\\201\\240`\\220\\257\\341{\\340\\244@\\270\\347\\364\\257\\263\\376r\\332\\003\\336\\022\\311j\\231\\304\\341\\203\\033\\217I]=A\\004\\302\\0004\\202\\326S\\221\\267\\030\\033\\240\\340g\\371\\354\\030\\337\\245e\\020\\020\\037\\201U\\304\\346\\303\\335\\014zx\\204\\254X_3R\\216:%\\340u\\313e\\215\\037$/+\\000q^\\323\\357\\2309wf\\0304`\\022(\\311Jh\\347\\245/M1I\\207\\273D\\210\\025+_\\000\\211\\345\\0268VwD\\376\\355{\\021{-\\365S\\216\\314\\303\\246\\210n\\260\\021{\\211!V\\210\\357\\274\\363N\\233\\365\\227\\301\\255FD\\234\\000\\250&=\\270%?|\\254>\\357\\225%\\276\\210\\310\\347\\004obs\\025|\\001\\036AV\\313&\\334\\227z\\251\\276\\251-\\337\\320\\037\\377\\340wN+\\317Z\\247wbV&M\\312S\\247\\003\\375\\224v\\3566\\265\\0002Z_\\323\\345\\351r\\237\\245\\017\\3344\\277\\220N\\257\\374\\332\\202#i`\\334\\234J\\223\\34407\\251\\361\\350o \\002s\\212\\205\\242T\\200M\\254\\365Pq\\330\\317\\277\\364L\\232.\\316s\\262\\004\\252\\330\\243\\031i\\341P\\177\\304\\212vM\\357;\\215\\373\\200\\025\\037\\341S\\204.\\304\\311\\245\\276?\\350N!I\\223\\342O\\377p\\362\\244\\325\\302!\\344\\316\\237\\246\\306\\363K\\225\\006\\256\\337\\237\\206\\310\\356\\007\\347\\233VJ\\221f\\310\\304s\\011\\334\\346g\\357L\\010\\004H\\325H\\352\\221Q\\243-\\311W\\273&\\201\\337\\231p4\\322f\\31137\\007\\216z\\370b0I\\021n\\025\\250n\\001CM\\007\\257'\\024\\367\\\\\\201'\\356:\\024\\234\\224\\267\\322\\250\\315!\\337\\263\\243rT\\016Cd\\360\\206\\363\\307L\\035K\\372\\356\\327\\306\\3375i\\027\\270)\\002\\313/\\2468o\\026\\375\\204\\177%\\252Z\\305$\\371\\231dV\\243\\326w\\252>N\\375\\232T|\\252\\025\\023\\216\\015/f\\002\\356-\\266RA\\302P\\316'\\263\\035\\266*u+\\025`\\265\\270O\\3454\\274\\211\\237\\345v\\003\\214\\256\\211\\0056\\006\\337\\027\\037\\372\\220\\313#\\010\\216]N\\032\\351\\234\\306\\376\\262&\\220e\\032\\236\\311\\010\\032\\253\\373\\007V9\\032\\341\\017\\275\\266A\\2167f\\354\\310\\200\\321{\\027\\370\\376E\\017)@\\222\\321\\225@\\203\\305@D\\255]\\316\\027s\\020+\\333j6r\\217\\305\\213\\214\\325\\230\\2167\\231\\270\\320&\\010\\215O\\234-n}K\\354\\366\\371\\216|s\\203\\323/\\217\\236>\\210\\032\\212\\011\\240$\\223\\250\\350\\177o\\273\\217\\364\\021w\\302@\\007V\\253H3kP+F\\246\\270.<\\024&t\\350AS5\\333M\\357\\366\\202\\307\\330\\232\\215x\\221\\254\\222\\312\\313\\005\\313M\\345\\262.\\204\\213\\273;\\025mi\\244\\241\\251\\231\\006\\373\\373\\276\\235j\\020\\366\\267\\270\\314#U\\013u\\262C\\323B\\027_z\\203>\\202\\252\\300\\342\\304W\\344 \\307]\\3135;\\012T\\250Ml\\\\\\352f'w\\252v2\\246\\227\\020:\\364\\361D\\315\\227\\250\\335\\243#\\340\\023\\320q\\336\\372\\2403\\360\\243\\323\\210\\330(\\321\\212N\\252o\\320\\204\\200\\355S\\014\\31036-@H\\000\\020\\231\\271\\203\\225\\221\\362\\3038\\364D\\024H\\302\\223\\222\\276\\014\\033[Q\\313\\215\\250\\035S\\330`\\337\\373\\234\\207\\344\\302\\026\\277\\307\\210\\265GG\\357\\255\\232\\303\\337\\355a\\331\\321\\373q\\246<"\\364\\241iu\\302\\006\\254\\276\\346m\\321\\300k~\\252G\\344}j<\\020[\\267h\\361\\004\\203y1\\315E\\315\\026lnh\\306# \\322\\330,\\204u*~\\336!$\\353\\236\\316\\306\\205\\301l\\030k\\236\\310\\246\\342H\\376\\364\\376\\301H`\\341{\\203K\\361\\340\\026\\022 \\324\\315\\011M{n]\\270`\\246\\021\\215\\2205:\\3404\\211\\272m>\\3521\\267\\021>\\275\\367\\223\\217\\023\\255\\236\\336\\251d#\\021U\\250\\262y&\\272\\226\\022\\254*\\347\\2225%Ga\\321Pw\\313\\346Wu\\325q\\313\\004\\311\\003\\346\\376$\\003B*GI\\315^UZj\\226\\177\\3344R#\\370\\006B\\320\\322?\\336\\033(\\300\\235V5:i\\344^\\0022\\262r\\312<\\221.'}d\\325uq^N\\234;\\0003\\370\\222\\230\\261X\\361\\362\\3235\\360\\357\\213<B\\361 \\363\\313\\016\\205)\\033XzG\\026l\\2028\\325r\\012;\\001\\245"\\032\\335\\250\\234R\\352\\324K1\\365WH\\203LD6\\036|\\243\\344"*0\\276\\003E\\244wX\\216\\351,\\030\\272\\314l\\352e)\\335\\347\\301\\244\\235\\334\\3258\\2330F\\030\\367\\340"\\336\\0047b>\\016N\\330\\006t\\252\\202\\235\\203\\006\\313N|\\032\\177:\\237\\335L\\213\\274\\367\\353\\321\\220\\334a\\326\\027@2\\216\\206\\267Ey\\371n\\265^\\000m(W\\237\\327\\277.\\026Wh\\210X\\034\\015\\337Q\\016Z\\006Nf\\327\\357&y\\217\\376\\340[\\201)\\206\\375\\354eK\\251\\224\\367\\364\\007\\347a\\326\\305l1Y\\345=\\372\\203ML'\\325\\273\\257\\271\\231\\243\\366hr\\364\\3538\\355\\241H\\015\\350Q,\\363\\275^{\\364\\365\\321\\377\\032cx\\317%\\234\\371\\327\\237\\362\\336\\333\\243\\341\\351\\264\\203\\216\\313\\237\\322!\\231B\\2429)'\\367\\262\\363\\252z\\375nq\\233\\337]K\\030\\001\\340\\241\\317\\252\\305\\014\\340\\222d\\037\\313\\252<+g0\\242\\276>w\\201\\217]\\3009\\015\\011g\\263\\305\\371\\007\\340\\250\\241\\205\\277\\224S8AG\\311w\\305\\305\\012N\\342?\\341|\\321>\\257\\252\\376Hs\\207\\2547\\213k\\310\\371f\\261Z-\\256 \\013v\\342\\363\\305\\3255\\3642}\\215v\\223&$\\032\\237\\312\\377^\\026\\267$\\332\\325R\\273q\\335\\214,/\\277%@\\305\\022^UQ\\3720\\321_I?\\361\\305\\023`1\\200\\004\\314\\220\\266\\205\\006\\230\\260\\3766z,\\177\\002)\\3743\\202Y\\337\\3751.\\265\\3476\\022\\001\\361\\251r9 \\015L\\3161X\\001\\313\\357>\\273\\301\\034$\\263\\225w\\336\\245)A\\271Y>\\177\\375\\332\\327\\255\\353\\370\\015\\377\\207\\\\\\234 p`x\\3161\\210\\363\\344\\372S\\342\\2445\\002SmL\\201/\\261r\\333T\\264\\277s\\036\\342!\\026\\337v7\\004\\377\\373'7C7g\\232\\222\\013\\207\\177\\213\\330\\226\\254\\327\\372\\315\\373\\013O18`*^YQ\\031?=\\326[\\015\\323\\026)\\212\\011\\351\\250k\\372\\311\\303@7\\254\\\\\\357E|\\215\\006NC6j\\253\\245\\203\\220\\004\\2165\\302\\017Sc\\273]\\244\\0039[~\\353\\346\\246Q\\276\\232\\313\\030\\263\\223\\343\\264\\223\\340\\253\\027\\311\\017\\223\\037\\222a\\002\\030J\\004\\242\\255\\345%D\\364\\343\\223\\343c2\\300\\207\\266\\366$\\3721\\367\\301\\037\\316\\306\\302b\\204\\272\\332\\322{\\003\\003[<gj\\304h \\301\\222\\207\\022#\\317\\261\\342T$\\223\\201\\244}\\371\\341d4\\333^\\253e\\277\\\\\\274\\351\\304\\315\\002=\\322\\207m\\263DJ\\366$\\206\\206\\251\\215\\214|\\332\\203\\371"d\\372"\\2540)\\014\\320\\226\\200\\357\\267\\363`C\\011\\370\\217\\237\\202#\\230f\\257\\353\\353\\343\\262H"\\362\\313%\\247\\235\\233\\276\\036\\205\\244\\254\\011\\277\\341T</8\\374\\026\\033\\322\\337\\203\\242\\304\\027@?\\031F\\334\\252r!\\276\\031\\310\\013\\347\\357\\362\\260\\362P\\351j\\337\\221Q\\257U\\005\\022\\370\\227?\\322\\275\\333,\\256\\306\\012\\333\\213\\013\\230\\036W7\\011\\322\\014\\236\\2168d\\254uFA\\254\\022\\257C\\265z\\031\\032W\\026\\331z\\310l\\241\\353\\243\\334\\254f\\023\\362]O\\246\\3104'\\035\\326[\\222\\205\\305z}\\314l\\260\\216\\340j\\262\\274,\\347|\\375\\330\\271\\257E)\\\\kP\\036\\273\\272\\177H2_j\\240\\223\\020\\204\\022\\333\\320\\306\\030\\006\\031(\\036P@1\\001{p\\007\\331\\255n'\\034\\254\\201\\0275\\243B^\\217\\361\\375d\\365\\0168\\321O\\355\\343\\214~.1P+n\\375\\272aqL\\312\\263=\\302/\\362\\370\\242\\254\\255(\\350\\224SYL\\330\\304o\\377\\213h\\230\\030^A\\237\\310\\257\\323\\031+\\276I\\272c\\375\\2139\\266\\220#D\\011\\3368\\230\\205\\340\\250\\345\\335G'\\301\\246\\366\\2544v\\016\\224\\357$\\341\\267\\027\\037\\270\\331IG\\212\\263\\027\\322#\\177\\36498l7\\330\\304\\312\\031\\306\\374\\003\\007\\210\\330\\322aB\\351I#i!\\236+K\\216\\036\\235$i\\364& \\361\\377\\236g\\311\\033\\256QL6G\\275\\363\\337\\356\\004d+\\027\\216\\033\\025pK;\\330!\\301\\015\\364\\274a\\003\\342`\\252\\010\\225 \\011\\353\\377\\004\\013\\013"\\360g\\212D\\332\\366\\\\D\\0351t\\261\\270!X1c\\355\\321\\20044r\\307a=\\2040c\\263\\265\\206x\\005\\325G\\321f\\270\\232\\034$\\201y^^E\\274e\\202\\001C\\212\\377\\346\\021a`}9:\\361g\\266\\254\\220q\\025-\\324\\315|U^\\025\\257]\\356\\2409\\271>H.\\355\\233\\315\\375\\304\\361\\245\\031\\020\\022^\\227\\277\\026\\210\\346\\305U\\322\\307\\341\\000\\301\\341\\011\\357q\\255\\353\\362S1\\303\\241t\\210\\0213M\\355\\032\\010\\217>\\212Z\\220!U\\212\\310\\005{\\251T\\221q\\001Z\\223\\230;*\\2044\\005\\215\\344\\302\\351\\035\\344\\313\\371\\350\\211\\212\\354\\2508!\\227J\\272\\341\\302\\333VV_l\\355\\247\\336\\230v\\3147\\212^\\275\\204N\\206N\\251a\\203Hy\\261\\323$vYpi\\012fF'f\\036\\223\\372\\214\\017\\353\\274vnf\\325\\207\\362\\332\\307\\244n~\\220l\\265t\\204\\215\\233\\247\\027e\\244I\\372}\\200\\315\\014\\361\\310\\351S\\211g.\\377\\231\\313\\345\\367=\\232\\316/\\021\\277\\350!\\231d\\276\\230\\027\\211e\\307\\315\\264Iv\\263\\021Oy\\336\\342\\256\\277\\035P\\252\\207b\\262\\363\\276:\\3171\\214K\\012\\233\\204\\324$\\316\\017\\256\\335]\\237V\\351\\343\\341i\\217\\277\\237\\365.Kr\\325+\\316):\\027\\272V\\345\\275\\350\\3155\\224>\\311G/Gw\\254\\305r\\015\\302~A\\377 R\\257\\213\\253I9[\\3638\\326W\\260c\\336\\255YpY\\353+w\\353%\\0061_W\\305dy\\376\\016\\232\\235Q\\323k\\252}\\263\\234\\255o\\213\\342\\003t\\362\\276Z\\202\\204\\236\\237\\016\\333\\255\\365#\\024\\243\\177a\\027\\305\\323!:\\375Uy\\257}:\\\\\\267\\322\\237\\363\\356cW\\004\\252\\243w\\341\\351m\\247\\237\\302\\254NA\\224~{\\332\\033\\376\\216=\\005\\237\\034\\347\\275\\177xr\\014r\\365\\317p \\270\\210S \\372\\341gCp%L\\366\\033\\020\\032\\317\\366\\310\\033\\321\\356?/\\250A\\376A^\\217\\230A}\\031\\253\\025(ft\\352\\007\\221\\361\\207\\271\\344\\241\\235}q\\221C\\005\\317\\212\\357\\363\\033\\252\\220\\216\\301\\241\\324`F\\034\\250\\241 9\\023c6\\366\\243\\355\\016\\020.>\\3678\\203\\374\\224;\\2407`\\222\\177y\\371&\\221\\333\\254\\311U\\265\\305\\334M2\\275\\005F\\316)\\003\\376\\2237\\232sJ\\236w\\374"#\\033L\\222\\016\\350K\\332\\026[\\367\\356\\344\\375\\344\\323k\\020\\327\\321c\\277\\273\\302w\\033q\\000\\300n\\015x\\270?\\375\\370\\372\\015\\236Z\\316\\\\\\210\\000f*\\267\\357`\\266}\\\\0\\254\\320w:)\\024O\\373\\011\\336M$\\364\\335\\327\\345\\\\`\\330\\260\\225\\221\\177\\227x\\211\\276\\232\\254nD5F?\\351\\326\\343\\206\\324\\000 \\030\\370\\264\\371bu\\265\\230b\\314.\\274?\\362\\346H\\2722\\032x\\204\\243\\351\\366\\236%\\316\\332\\015\\272\\201\\323\\264\\272\\006\\362I\\212j\\177\\264\\362\\216D;\\3314\\014\\256\\205J\\326\\260\\222^\\007+J\\262m%2\\377\\3168k\\024\\327\\221\\311\\241\\3033+E\\243\\033F\\020\\243\\305!\\261\\3013&X:B`W\\332\\271%\\230\\026(m\\233\\203Md\\211\\036\\230\\207\\211\\236W\\335\\366\\275.8\\310\\346KLt)\\253\\207\\352\\262\\315\\315\\351\\315k\\336p\\372\\224k\\253\\245^Id8\\260^\\357E\\344O\\374t\\255%\\013\\010\\031L\\000M\\036\\251DQ\\261\\022\\007\\001\\362'\\325G\\247+\\026k:Hh;\\250c.\\277RE\\357\\227\\273\\335\\307\\363EQ\\303C\\341\\032\\277\\275H\\207\\037.\\242\\034q\\274,/z\\355\\015ZA\\342\\015k\\177g\\256\\334\\002o\\314M,\\342PB\\273\\021\\337\\263\\330\\347_\\213k\\372\\361\\\\\\366\\014}\\274\\304\\327\\0059\\237\\367\\007\\377\\306+\\177\\322\\364\\257\\210re\\0060\\013{_\\2770\\227\\365\\027\\341\\252\\235!\\356/\\262\\213\\3460\\010\\227\\366\\355R\\334\\357\\244\\260\\3676\\211t=\\323H\\315\\310\\240&\\275#\\202\\302\\027&Zk\\340\\350\\033\\226\\031\\220R\\235i[\\210\\376Lh\\210\\300\\020\\001\\315\\224\\346\\020e\\241\\201\\010\\261\\350\\273\\0019"\\204\\325\\310\\353\\013f\\300\\266b\\341<\\374n\\016;\\3055\\302|~(Z\\233u\\367\\037\\334\\340\\277\\276\\376\\361\\207\\035`\\331\\326f\\010\\273\\344}\\265\\230s\\210\\230E\\365\\337\\003\\345\\273\\315.\\030\\023\\325\\377m@\\226\\003\\345\\306\\260\\323{\\225\\0340\\206\\343$\\234j8\\2032W\\326\\267E\\337}:gf\\213\\363\\011\\266I\\221\\373\\263\\313\\331\\342l2\\243P\\274\\231A\\016\\361\\371\\344\\023\\010o\\275J\\256\\324\\373tt{{{\\204OB\\034Ac\\305\\374\\034\\310\\014\\031\\317Pl\\\\\\272\\231\\242\\266&\\325\\347\\3719\\377\\374\\364n\\331\\227\\020\\250\\177\\375\\376\\273?\\256V\\327\\177*\\200;\\252\\360-HIwc\\242x\\245\\300\\250\\035\\320S\\2313\\350|\\275>\\220B_\\237cT\\332\\277J\\240\\250a\\235n\\342+)\\215\\035\\265\\203\\030\\305A\\224|S'h\\277\\235|_\\236/\\027\\325\\342bE\\215\\275y\\363\\023b\\227\\211\\220\\237\\241\\206\\375z\\005P\\375t5\\213\\200t5\\313\\310\\205\\034\\177%\\354\\265\\302\\227\\230|\\2303\\376\\367\\343{\\315l\\3376b\\356;3D\\356\\260\\013L\\221>lA\\362\\250\\347v\\341d.\\347\\211\\017+\\220<\\356=N6\\374d\\360\\367r\\376\\367\\3576Y\\261\\232\\\\\\342_\\304\\024\\017$\\264\\251y\\355p\\216X\\227<\\304<Z[\\250\\327\\204\\201A\\355\\001\\263\\365\\213\\371\\265\\036\\343\\301\\206|.\\006,\\266\\016\\333\\\\:\\246\\312\\031\\311\\260)b^\\351=\\261\\275\\034A\\276\\207\\014\\017[-\\214(\\346\\360\\321\\207\\345\\241\\334\\200\\351\\345\\244\\220\\271\\343\\264,b\\3456\\256y\\2714 \\202s\\2358\\226\\032\\223p\\353\\210{\\032\\210\\003\\022\\206\\247\\213,4v\\005\\177;y\\233\\005\\003\\2337LZI\\037\\244\\364\\264\\003\\011{\\324\\354z\\235(x 9\\311\\207V\\353q\\300\\343\\300\\2003\\246\\027\\241]2#I\\030\\362\\237\\016\\365\\300\\035lm\\337\\314\\216\\211\\351\\2269'\\260m\\025\\320\\265\\001\\254\\327\\265\\231\\003\\305\\302.s\\351\\372\\271\\364\\273^\\267\\005\\204\\035\\020\\371:\\035\\263\\200\\361,:\\326\\275\\015\\333\\317\\222\\034kA\\345\\016\\372\\265\\2458x\\024\\032\\350\\337\\335%\\355,e\\323H|\\346\\021\\025\\033\\347\\301\\327z\\355\\303S\\\\]\\313\\2355>\\325"d\\034\\360N\\271q\\370\\0316\\344\\257s\\220\\336\\310\\015oP\\304\\322\\023\\230=\\306\\341H\\357\\360\\337\\300Z\\241r\\306\\331\\015+"s@\\234\\327@\\370\\244\\210\\273\\323o\\011bN\\025\\265\\004\\245\\361\\276\\360hK\\362U\\305\\262\\267{\\363+\\204(\\010\\262\\031\\200\\361g\\200\\351\\252\\002\\200>!\\200"\\344\\241l\\247-\\257|\\011V\\357\\304\\364\\204\\333\\350S\\370q\\263s\\303!=d\\317pMi\\204O3\\357\\000:!\\222\\216\\266\\010\\201y\\000l\\377\\313K`\\275=\\263\\230\\210\\200\\011$\\000`\\200\\222\\271\\334\\021Qo\\344\\247\\274\\242W\\207\\321\\272\\245M\\177G'c\\272\\377\\243_@Ujg\\330z\\315\\271O\\202\\334w\\300\\236 \\256\\357m[H\\013\\002T\\177b\\317b\\244\\005\\230\\341\\257\\255\\233MK\\260\\214X\\326o}\\363\\213\\2509\\353V\\266\\275\\256\\34284\\376\\321\\255\\226\\347\\274\\256\\274K9\\365\\371;T\\270\\257\\324\\030\\007\\304\\022\\372\\316\\243|\\261=C\\214\\327\\220\\376s\\305K\\251\\271\\230\\223\\212\\303}\\301`\\246\\237\\361\\260(\\240M|\\361.\\272\\021\\232\\222?\\221\\250#\\250\\360k,,n\\022>\\001\\341\\210-\\003\\213\\322\\230\\247{\\027-\\212hTdp\\335\\270\\267\\037:R6\\177\\341\\315\\014\\273\\222\\313Y\\347\\274\\035\\373\\03368\\345\\006\\366a\\302\\033P\\2065\\367\\252_Y\\363\\246%\\216\\347\\205\\0071\\246\\002\\013\\006\\253\\002\\377\\3629y\\000\\277\\374\\375\\033\\255\\350\\015\\364Hj\\370;\\310\\353.@\\334\\247S-\\243E\\207\\177\\211\\237\\313|\\271\\014\\235\\353XC\\246\\267S;*B\\021\\244\\201n\\243\\257\\327\\367\\235\\366\\314{\\362h\\000\\207\\204\\221\\373#\\000\\001\\367\\255\\274y\\177\\204e\\200\\235\\012\\252\\310\\204\\312\\013er,\\263o\\231\\237\\021\\015q\\274\\255\\217W\\027GZ\\362\\350u9?\\207\\216v4b\\375\\310\\220\\243r\\215\\357mm\\375\\007X\\243#zn\\327\\265lk\\262\\335\\335\\201\\022\\200\\346f\\376z$\\0110H\\366\\026LB\\326\\027\\011[s\\325\\257\\211}E\\350)\\031\\302CD\\230\\332\\221O\\035\\017\\033S;I\\266\\217\\034e\\337\\345:\\373\\3264:\\327*q\\250D\\001\\033\\373\\360_\\254h\\2148A\\024\\030\\262*\\325s\\2125Z\\236\\264\\037\\035\\005\\304}7i_\\\\+\\000&g\\213\\345\\312k0\\354\\261\\310M\\243X`\\353\\222\\003\\300\\210\\3062\\226\\323\\241a\\273\\023\\322\\357\\240We\\205\\3175.n8\\262\\025n\\274\\365\\032\\353\\004t\\350\\030c\\353J9$K4V\\341$\\315\\206FcoG\\2176v\\247\\023\\331\\202\\322\\264\\257\\267\\014\\311\\231\\312.\\256-3i\\232i\\265\\240*\\220\\325\\332\\370~\\037\\215o\\305?\\023r\\204\\212F\\361\\200\\336E\\025\\331\\330\\344\\320\\375\\352\\353!\\376\\016\\260Y\\36444\\301aR\\240\\376\\0061\\317orw=\\203\\245\\177X\\270\\375\\331\\246\\005\\024\\236\\301j>\\373N7J\\024\\022\\232\\374\\276\\272\\0344*OY`\\264\\222\\002vB\\276\\355\\334\\372\\236\\356\\212\\254\\362\\270\\277\\\\\\242\\261\\007\\265\\225\\320\\315\\364\\222\\207=\\340\\256r\\370#Nz_\\240\\2555'\\251?\\2456\\201u\\000\\0332\\222\\212\\253]\\361^b\\251\\213\\373\\305\\001z,BS\\314\\306\\225\\275\\263{\\206\\267\\011Sr\\314\\020\\005\\323\\206\\037\\302\\226;\\275\\257\\261p\\356\\252\\015\\334\\257\\350\\360&\\034\\325\\362L\\0000i\\260\\251cM[w\\002j\\323"\\222B\\243Aj"C\\3067\\033*~\\034\\025\\276\\332\\265>\\311\\020\\315l\\245\\246\\336\\334\\354\\321\\331\\332\\265,\\207\\027SQ\\024|\\205A#\\015\\017\\207 \\247\\317?\\333\\257\\027/\\277{\\371\\346e"\\002X\\237/\\307\\375\\034\\266\\256\\025i\\312\\212\\200\\363\\330\\260\\314'\\340o\\030\\267\\365\\261sX\\301TS>\\221\\225\\226\\237\\315$\\227E^\\306\\023^\\215\\035\\224Q\\260\\324\\020G\\337\\277\\0377\\017@\\277I \\221\\337;\\250>\\337a\\354\\352]\\025\\271\\266\\373\\277\\373\\200\\360\\343\\327l\\342a\\320/-\\275k;\\005\\304pO\\375\\257j\\341\\327\\251\\361\\264[\\257\\356t\\2040Zz\\333\\303\\255\\270\\361\\343\\017\\266\\251@\\216\\250\\005\\202\\215~0\\314\\002UHP'\\002\\231\\031\\363C\\207\\2348\\315\\270\\2026+\\306\\034\\314\\212\\340\\330?\\316\\014%\\366\\203\\247\\375\\3545j\\007\\264OhX\\255VM&\\312\\215^\\257\\355K>\\313\\237\\034\\037\\323\\361#\\011O\\277:>N\\371\\244t\\244\\360\\253\\343\\337G)'O\\236|\\025%\\035[B\\021\\236\\365Yt4\\004S\\240\\213N\\266\\3250\\334\\035\\221\\263Kd\\235\\370.Jy\\247\\357\\240\\214\\343\\016\\223\\224th\\333\\312\\276\\204<\\276\\006\\265-;\\254\\014\\230Id\\374r\\233\\302\\246a\\024\\226\\325\\262\\210T\\016\\177Y\\354\\332\\005\\251c\\231~\\350:\\200\\363ff]\\014gV\\333&!\\014\\366\\021\\226f\\323\\316\\354\\323\\325,Wj\\207j\\316\\365\\372`EL\\344\\371\\312_\\000c\\006\\232a\\022\\201\\311\\341k\\310\\314\\005\\267\\016\\254j\\337~\\323\\033[H\\256\\257\\360\\305U\\264\\312\\337\\366H\\033vj\\017U\\017\\036\\242\\245a\\036\\357\\015<+\\260\\315o\\331\\340\\223\\317s\\233D\\352\\177q\\027\\3303&\\315T0z\\333oe\\025b\\2153\\347\\373\\010\\272\\366\\216t\\214U\\2017\\036m\\361\\221\\2667\\320F\\017\\320\\334\\246q\\201\\241\\226\\365J\\204v\\375K\\274\\242S\\317kA\\013\\326\\215d\\244\\331\\264\\257\\364Y\\335\\246hwGd\\320d2B\\033p\\233q\\317\\305w\\030S\\203\\357\\004Q58\\221\\0073\\3028\\004\\023k\\356\\351\\236\\204 \\031\\223~\\031+\\360\\300\\221\\364z\\011C\\373\\204\\026=\\223\\364\\216\\\\\\313\\177\\242\\353\\3616gd\\223\\021\\377\\030\\033pT\\022\\250\\274e\\024\\212\\313'\\307Y\\322IL\\004\\201\\206\\306\\026g\\357\\303;#\\236\\025&\\207\\263\\201\\024{o\\370\\221\\261\\305\\303f\\275\\356\\235\\216N\\307\\217z\\254\\315\\342\\346S\\236\\270\\364\\365QgZ\\037G'\\031%\\035gjo\\354\\024\\234)\\266\\273\\203M\\207%\\251|\\223qB-\\332\\300\\177\\007f@ |\\237\\275g\\257\\035\\247)\\207\\224\\300\\006b\\353\\004?\\340\\004\\267\\014\\363\\203\\353Z\\347c\\346\\210\\200\\263\\307.f}(>\\253\\371\\276\\215\\013t_\\270\\234\\001\\212\\245l:\\0024\\221.\\244\\376\\374\\247W\\310&\\000\\2377_a\\263\\250\\342N:\\015y{.\\266\\2168\\333\\340e\\263\\030<\\341;K\\313\\213O\\010\\222*\\357\\255\\026\\227\\227\\263b]\\275[\\334\\242\\271P\\201\\2162\\237\\330\\255\\245=\\352\\034\\215\\363t\\330\\036\\235N;G\\335q'mw\\037\\247\\217z\\031\\362\\217\\313W\\323\\354\\342\\023z\\376\\300\\016\\033\\251Y\\266\\232\\025\\263\\217\\012\\377\\026O\\025g\\303\\314y\\362\\341\\334XFbu\\255\\265\\304\\001\\206?\\376$\\215K%\\311\\223/\\365\\221\\0319\\343\\312\\361\\270\\301\\212\\010gh8\\223\\353\\242\\230\\206\\366C\\224\\004\\374\\007\\376\\311\\315\\253\\307\\362\\246\\313\\274\\274\\002\\316\\264}Y\\314\\277\\375\\324N\\260\\265$\\373*\\315\\242\\206\\032\\235\\302\\033\\003\\250\\250\\305`\\034>\\203\\334\\011!\\303\\231\\247\\271 bl\\305\\250\\253\\010E\\310\\023\\301o\\336sq\\213\\241\\026\\352\\326m\\022[J\\017\\032\\033\\344\\214\\036\\301\\225\\032\\372l\\255|\\2164\\177\\214.\\236\\334uc\\266\\263\\034\\227\\300\\305\\316\\330&\\351h\\231Nb\\255n\\336,\\332\\022\\254v`\\033\\246i\\370\\341\\363\\263\\322\\234\\355g\\242)\\342:\\305.\\242>\\372U\\343\\000s\\235\\340\\346>\\220+(h';w\\335\\343\\354C\\260\\222\\357\\237~\\030\\274\\307\\225\\244&\\336\\307\\353S\\353\\344}\\264\\256\\264zap4\\340e`\\013~\\011\\226\\356\\355FSl\\356\\277\\013M\\221\\376.\\320W\\032\\3769\\360Ku/\\260wb\\357\\337\\265\\004j\\325\\031\\301\\370g\\246y}O#8!\\223to\\0033\\317.\\346O\\030\\006g\\213\\305L\\036\\265\\332\\277\\230\\263\\277\\307\\002\\235V\\355\\0164\\024\\375b\\236:\\325M\\220\\374DC\\366\\3110\\304\\367\\226\\214\\022m\\254]=\\323\\2603<\\304\\326k\\354\\2601\\334\\237p:\\244\\324\\302B\\303\\213\\271\\276U\\3066N%\\354\\250\\276\\270\\035\\252\\361\\016g\\215\\250\\326\\220\\351Y\\237\\361e\\334\\216\\003\\373EX\\305\\003'\\274\\022\\020\\305A\\376.\\200\\273~\\263\\210\\021y\\265\\250\\033\\277H\\224L\\342S\\375\\030\\231\\010(=\\317\\216\\323.\\016\\260-q\\252\\335x\\356\\244D\\177\\265\\330\\324Q<\\223b~\\030\\350V"\\345\\212\\011\\276\\377\\020[p_\\257\\314\\323bT\\260\\335\\\\<X\\364\\227\\030\\367P\\314+\\260\\213\\246\\370j\\334\\264W\\033\\004\\020\\033I.p\\2217\\356\\036s\\230`\\305\\244\\277\\227P2,K\\264\\340P)2]\\200\\223\\235[J\\263\\353L\\254\\265\\235\\321\\234\\177\\224d;nd\\336\\216\\023w\\3355r\\2414\\243;\\2654\\317\\257\\037\\340\\020v\\015\\373\\237/]\\260\\262X\\241\\323\\317\\353\\261>!\\250\\237\\327T\\222XkI"7/D\\304VK\\014\\230\\327&\\2070\\025#,P\\226\\203\\364\\002\\357\\351\\002=\\014G\\255#\\177\\307k\\3439\\006\\215y\\037\\257\\224\\003\\3120\\335H\\361\\201\\217\\230~+Y24i\\200\\305\\340\\240AG\\227\\333\\334\\327wiMr\\202\\314\\000P\\003QA=\\324_\\022Z\\345\\265\\224\\365\\372n\\223\\342\\204\\245\\332\\350\\004\\000%0\\320$\\014a\\213\\035\\331\\321\\034\\310%y\\303\\240r\\365;\\036l\\010V7\\313\\257a{\\324\\021\\210\\226;0=\\244]Ss\\311\\225\\24069\\032\\032)%\\375\\204\\346\\261\\027\\210\\203\\342@K\\356@\\314j\\272h\\207\\030\\355dD\\206\\226\\271R\\222!\\017-$C\\310\\005\\217y?\\031\\336B.\\262\\211GuAbS\\324\\027-Wy\\201\\323\\342\\220:\\350\\202\\306\\246\\324\\032\\177\\013\\346g]\\332\\364\\016;\\315n\\346\\345\\212\\257\\300G_\\215\\341TF\\217\\021\\250\\212\\311x\\216\\301\\247\\030\\363Z\\237\\21264\\267^\\237\\244\\035,6\\340\\356\\333\\232\\3303\\003I\\037S\\346\\240\\326\\002%su\\\\\\306=\\275r\\007\\360\\300H\\333\\3562\\036\\341t\\224'\\303\\243\\223\\376I\\372\\030\\362\\322\\016\\267\\270\\301^*`\\237\\333\\364\\235A\\026\\315E\\301\\025e\\243\\201*\\231%X+cz\\361\\226\\314\\204W\\013c\\226\\207\\341\\030\\226\\377\\206d'\\273\\\\\\254\\026/\\241S\\266\\243@\\316\\337\\031L\\361\\027\\271F\\271\\362\\202{D\\262\\332#\\224Q\\033\\017,\\317yp#>\\014J\\211aPJ\\014\\366\\202\\002&e"\\233*\\341nhSc\\216\\033\\226+\\242A\\233\\245Ay\\222\\270\\304\\007\\211\\325\\355\\345\\300\\327"\\363\\343\\202\\207\\031\\037_\\221\\351\\355]5\\003||\\261\\270\\235\\367\\003\\356\\377$\\315(\\347\\317\\327\\375\\200\\335\\322\\3647\\314ND\\207&\\344\\342\\351\\370j\\336w\\247\\027\\267\\307\\247\\346\\2177+\\223A\\015\\326^\\204#\\357\\310]\\201\\266"\\266\\261\\211Ad\\017\\313\\332\\231\\331`\\334Ke\\342\\243\\\\\\316C|\\233N\\217"\\312\\360Fi\\302\\240\\252\\260=\\344f\\356\\274\\215?\\220\\365\\203\\213y\\253U\\010\\305\\2533KT\\005H4w9\\275Y\\222\\316\\265oG\\320\\267-\\360_\\033&\\3355\\305Y\\251\\226\\335\\020\\015\\327\\026\\235\\013\\312'\\364R\\032\\036\\367U]`\\313x\\327\\377\\241M\\357\\373\\2724.:\\313]\\356\\330\\207\\353\\327\\374\\356\\236^'\\3639\\002\\274\\265=\\273\\006\\366#\\272a\\302,\\302\\330\\003w\\205\\034\\034\\345\\006\\237\\033yR\\351/\\345\\203n1\\233\\006\\007\\345f\\340\\217R\\014\\306\\317\\360\\275\\303\\310\\033\\023\\243\\323\\277\\316\\346\\034\\333\\363\\207\\033|\\205\\356\\302\\033\\212kj\\007S\\037_\\223\\353\\\\\\360\\220\\332\\326\\252\\355\\366\\021y\\364\\236/\\252\\366\\365c\\372\\371\\323\\253\\264\\367$\\355\\034w\\377\\220>\\306\\242\\035\\255\\210\\034<o\\361>F\\352\\375\\264\\3055\\217\\271\\026ByIR\\237\\272\\201s[ y\\223?\\2618\\235\\254,\\306p\\311.\\232o\\244w\\366\\213\\214\\243\\015\\201\\200e\\245+\\000\\322r\\336\\335\\\\O\\003~\\323\\307\\337\\3246\\252U\\021\\015\\213\\222\\374Bt9|\\0133m\\267\\372\\012H\\333`\\021\\024\\037\\2711\\207\\010\\206-9c\\005Y\\327R_U\\244)Z>(H\\015\\371!\\357B\\250\\002\\207K\\350\\326do\\362\\2516R\\023\\273Q\\353\\314)\\266\\214\\037\\257j\\344\\304\\306\\311\\306\\215\\210\\022L%\\261\\375\\253\\373\\245\\2302b&\\324\\344\\265.,\\234\\001-\\26344Pw\\026.[\\255\\345\\263\\243\\223c\\370o\\270\\354ou~ohI\\034\\3363>n\\035$\\366\\332\\027\\313\\305\\025J=t*+S\\006g1^\\346\\212A\\242O\\314\\261\\264 '0\\000\\253\\005\\377&\\356\\004\\377\\021\\000\\361ObR\\024Kr\\337\\210`\\363\\242ri@E\\216\\007\\241\\213\\226\\277\\024\\364\\307\\250{\\277\\204\\270\\224\\342\\332\\345\\300\\201\\312\\233\\305M\\234\\324\\351m/\\336\\312\\201K\\021\\253V\\024\\230\\214\\365\\203r6\\277\\302\\030\\353\\253Ws\\220\\360P\\221\\357\\321uU\\236\\177\\310N\\276\\342K\\351@;\\027\\355\\020\\012:k\\260!\\010\\253\\322\\264\\036\\203p\\203aT\\036\\342t\\330\\311\\210\\231\\242\\006\\354\\217\\266\\204l\\224\\341I\\3778\\223\\232\\313v\\032\\310\\317\\324\\261\\012\\247\\203X}\\363\\237;\\015l{\\3134h` %\\023\\037W\\030>.d\\336\\304\\377tj-k\\244\\004L\\375Y\\036t\\247GX'D[\\231\\223\\303:@\\325F\\234;\\021\\354%\\212\\330\\216\\246"\\302\\207\\005\\006\\215\\307q\\205(w6\\325\\250\\023Tm\\252DcT~\\240\\303\\230ar\\314+\\262\\213\\210+\\012\\031\\013$&C\\345B\\371\\316-\\241Jx\\252\\026\\333\\213\\325[\\274\\206u\\005n\\023\\005\\205BC\\370\\277\\3374\\256\\006\\275nw\\233\\337\\362Cht<}\\304\\246\\200}\\020T\\306\\364\\266\\217\\307\\036\\224\\227\\375a\\367\\225\\347\\344\\257\\267\\257\\331\\026D\\277\\316\\352\\333\\343\\232n\\265\\302fjR}W\\034\\253\\303kp'"\\316\\363\\325Q\\210\\264\\003\\203\\230\\363^#\\2323\\211\\014\\244\\362p\\2626KN\\311\\306<{$\\231\\330\\025Mm*\\337\\352\\354+\\351\\273K\\\\\\023\\310\\302\\370\\007\\204af\\300\\024\\215p\\233\\005\\305G\\221\\342 \\350o\\334\\3663\\007\\346\\3538;\\311\\032g\\2376\\235%\\035a\\034`\\213\\033x\\246\\217u\\034i\\264\\3057\\201P\\031\\207\\266rt?\\273C\\302\\337\\217\\224Y\\215\\222\\245\\015\\311X>\\015$E\\3772\\226\\027\\000S\\225\\006\\235\\360wt\\304\\342\\237/\\027\\207\\214'\\266iq\\335\\346S(\\020\\2021\\234+\\312\\265\\356\\350\\322sm\\240\\347\\032\\233\\213\\261\\024U\\365AN\\204C\\354\\037\\217\\217A\\220\\253V\\375'\\360\\3039)\\375\\376\\370Xh\\263\\023\\356<\\303\\364)\\332"0&\\241"\\252\\000\\205\\024X\\033\\244\\357\\256\\305\\240:\\352\\211?\\031\\002\\320j\\005\\237#fS\\225\\373\\202M\\333\\230\\233\\267\\345\\227=\\022M\\222\\036\\210&\\020\\217\\014\\254/\\177;\\360\\2275\\032|\\277\\300\\335\\370\\016\\270\\230\\004\\001\\374\\315q(D\\206\\2356Gdp\\376\\224K\\340b\\002|\\312\\214f\\337\\225\\026\\305\\002\\336\\024"o\\263\\321\\027\\324P\\0266Q\\242P\\206'\\223\\022\\020\\002E\\346={\\037G\\337\\226\\013Q\\011\\236)\\232}\\222R8]\\035\\377\\261\\215\\324\\232\\007@[D7\\306t\\3050\\360\\012\\032\\310 Z\\234\\\\\\026\\253o0\\336\\021l\\352\\347\\263\\262\\230\\257\\376\\204R5\\206\\217\\334\\342\\015a\\364\\003\\022{\\303\\203\\313\\205\\012\\011\\236\\031E\\215"K\\231\\234\\271\\363\\215\\020i\\234[F+\\354\\037\\351\\227\\274\\000 BX\\231\\352\\333\\036\\022\\264\\356\\240\\036\\275'\\212\\320#\\267\\217y\\336\\024\\350\\207\\343\\372\\206\\313,#\\300,\\031\\202\\234\\016|k\\363\\211\\333i\\004\\037\\361B\\347\\371^\\275\\247\\214\\202\\003c\\214x\\374\\201\\245^R\\014ZH\\210\\300\\234\\235Sso`\\207H\\251\\256K\\301+\\233\\351g\\373},\\305)JNX\\036\\223\\202\\012\\234\\000\\254'4\\015\\363\\350\\302\\337\\016\\351W\\273\\327\\223\\313\\342o<Y'\\376i(*(\\371\\375bZ\\314(\\342#5_\\235/\\027\\263\\231\\037\\216\\373N\\217\\334\\3102\\212\\177\\203\\275\\340\\017\\323\\315_\\277\\260\\0333\\013\\237\\240\\035Qt\\035q\\220GJ\\273\\222\\216\\373\\370\\317f\\260\\011\\243\\201\\375\\337\\212\\267a~\\011\\324\\224\\3437\\210\\367\\032\\247\\377\\304\\341\\361Md\\035N\\301h\\377\\037\\177\\214\\213\\020\\2327`y\\020\\276j'\\226G\\373\\301\\304\\343\\242\\322\\376\\233\\006\\360|[\\210\\255\\341\\003\\303m\\365k1\\241h\\033\\230\\351:\\2445i\\204_\\0341\\334G\\3575>J{)\\307c\\003I\\001\\247\\341>d\\342\\326\\020J\\361\\203\\321\\275\\372\\266\\374TL\\177\\222\\270\\256\\255Vm\\216]\\215\\371\\312v\\240\\237\\310\\246\\375lYL>\\260U\\372\\17720\\006\\000\\214#\\211"\\245\\273y\\200\\320\\010\\022\\011\\034\\036/-\\232\\244\\270\\377:\\021<\\251\\205N\\015\\2405\\240L\\027E\\365\\303b\\365\\365t\\372\\015\\205\\000\\004\\211\\277\\241\\204\\313\\376v\\261|\\203Q>\\276\\236O\\237\\027\\263Y\\325j\\365\\336\\256\\332\\364\\372\\317t\\375.}\\324+M\\020<\\377\\024\\215\\014\\321\\350a\\302`k\\034~\\020\\206M\\241\\246H\\003\\303\\343\\277\\247\\006\\316\\311W\\331\\324\\366K\\260\\233vo6\\253fu\\010s\\266ZN\\316W\\225\\233\\373\\217"2\\002\\304\\376\\235\\003I\\341\\203\\005v\\\\\\376\\362.O$\\326T\\362\\3378\\373p\\263\\006\\225\\344Vv\\027\\262/\\213\\331\\004\\255\\250\\361^ugA\\224A\\312s\\235\\030\\235\\0201\\346\\231D\\016\\304\\366\\320\\375\\270\\367\\260\\015I=;\\346\\265v>f\\321\\361(\\243\\332R\\001G\\230\\305\\007\\235{\\317\\245\\371x\\013&\\223\\337y\\332\\036KCJn\\375\\361A\\221+& \\012.\\267\\372\\266\\322\\243\\012\\031=\\250\\360\\242\\374\\230Q0\\035\\374\\301\\317\\255\\255\\2464\\332\\357\\325>o{xO\\352\\316\\032\\362\\271\\240\\236\\024\\361!\\347\\370I\\034\\036\\363\\320\\005\\273\\326X\\327H\\233\\372\\214\\215\\360\\207[\\201\\037\\214~\\375?\\\\\\177\\332\\207r\\345t\\377w\\307\\307\\307\\0031\\341\\203|\\0227\\372'\\327\\237\\006,e\\320\\317\\303g\\330\\325\\263\\247=\\363/\\315\\346\\277\\247\\367\\375s\\240WR(?<\\346o|\\262@\\276a0K\\370\\177\\012C\\343\\177\\226\\370\\017\\277\\001\\021I\\277n\\365$\\226hc\\220p\\032;\\243\\314q\\246c\\317d\\354\\307\\031\\0172\\201\\241%\\022YO>\\032\\202\\213o\\320\\323F\\273\\364ol\\340\\372\\015\\010ikO5PQFh\\353\\215\\253\\350\\224\\373\\346\\314\\343r\\212c\\271\\026\\263\\231\\253\\251O6\\017Y\\332w4li\\272\\221\\215\\216\\226\\274\\255=t\\367\\034\\265\\000:\\371\\207\\324\\227\\337z\\320\\344\\355\\325\\324\\323\\230\\234j\\271\\346\\252\\220J\\010\\215\\310\\242|d:\\222'\\307N\\331\\336H\\177\\314 moO\\216\\327\\353\\306\\214\\223\\035\\343h\\352?q\\213\\260\\315\\244#\\213\\012\\370i9\\362\\254\\343\\277\\377x\\3322\\235#\\013s(\\375jN\\301\\317\\231\\236\\274\\232\\177\\343\\370\\330\\274\\035\\022w\\341\\266\\034\\341I\\031\\001\\255\\247\\270\\303-\\316\\363\\270\\226{\\364SL\\223G\\014E\\371\\262\\215Y\\016\\275B3\\317e{J\\353\\037\\211a\\011\\313\\216Y\\345\\241\\360<\\332\\301\\231oc\\222\\266B\\251~\\300?\\224\\010\\327\\017\\372\\3555\\331R\\332\\004e\\336q<eN\\030\\332r\\245Z\\022\\203\\334\\343\\203\\\\\\354\\374\\303\\256Yk\\245\\330\\207\\357\\200\\230`\\244\\215X\\311\\021yo\\226/\\275\\311\\360\\236<\\320\\003\\251\\202P\\222/\\240mS\\226;\\3010\\374{\\323(V\\016h\\030\\027\\236D\\357\\033b\\177vW\\233y\\210I\\275f\\373N\\2256\\335\\365p\\356\\364\\325\\032\\2425+\\375\\0344\\014\\007\\005+'\\360k\\013\\270\\307\\217\\\\9\\374J;<?^\\035W\\216\\370{_\\020?\\251\\344w\\264|\\250#\\272A\\225o\\022\\204\\234\\225\\272\\224cF\\306\\026$"o+x\\361\\236A36\\233\\006\\023zwfEQ+D\\010o\\210\\265le\\364\\220\\231f5\\264I\\201e\\025\\276\\310d\\265\\365!8\\301\\204\\336[\\304\\3565\\036cNn\\260\\215\\350C\\350$B\\014\\357\\354\\201\\272\\351\\333\\202\\256\\375\\301\\302\\301\\375\\336\\210\\347\\215\\273q\\341\\227\\343\\201\\015\\304\\233\\322\\316\\260\\273\\233*Ds\\325 \\354*\\007lm\\365\\036\\222\\261\\245Y',\\330v\\015\\0051\\240\\213\\347\\300@\\267\\260\\251\\215g\\263\\0074\\307\\366\\374\\300\\330\\2245%H\\015\\225L\\210\\030D\\027Q\\011\\330\\022h\\177p\\037.yDr\\252i\\334!\\201|hh\\235\\225q`\\343m\\023)#\\001R\\325\\274Ab=\\372\\243{\\020\\006\\221ol\\035\\261\\330\\314\\026arU\\254\\336-\\246\\344h\\007\\342H\\322!\\263Zo#\\306\\331\\306J\\314\\333p\\332Mz[\\316\\007\\252\\367\\252\\253\\270\\240\\316A\\323\\013*\\015\\272\\266\\364\\016\\232\\3121\\204?E\\206\\362\\326(\\220LyN\\322j\\037\\224\\350\\371\\244&\\353\\230od* \\001\\333\\262\\337\\340\\275\\2155Tw\\223\\374\\210\\316z\\316\\206=\\034\\010\\253\\331\\\\d\\351\\371\\020\\275*\\235\\246\\023\\311'v1\\204\\177F\\34501\\272\\326\\244\\037\\024\\034\\253\\351W]'\\212\\263\\333\\246\\227\\3271\\256\\327A)z\\217M\\262H\\341\\243\\037\\362*c\\360`\\205\\231\\210ZP%\\012\\022\\234\\000\\346\\310\\323\\003\\356}Xz\\316\\242\\357\\224,b\\015\\376\\317\\374\\312\\205\\321DIlx\\336\\256\\334S_nXC\\214\\374\\243\\272|1\\211\\330\\202\\225x\\237\\261\\307\\361\\352\\303\\270\\376\\0363\\023b\\362\\030a\\307y3\\021\\300\\267pcG\\021\\300V\\272\\221\\241\\321\\371'2\\322>\\243\\253\\355aq\\263j\\350\\201\\311\\361\\027\\366\\303\\225\\206\\372~F\\337\\275\\373Q\\357\\226^\\3602f\\231\\300*6\\253\\256\\303\\335\\206\\345l\\024Z\\262\\331i\\266\\350\\243&\\177\\323k\\356\\230\\302\\003\\244F\\202\\367\\334M\\036\\275\\344\\346\\324\\032\\017\\3042\\217\\325\\250M\\232\\240\\3237\\271\\000\\303Qs\\362\\234R\\222\\250^m\\223$|c K&8\\031n\\226\\260H\\277]C\\355\\324_T\\006\\325\\233\\373\\240\\030\\301\\322\\262%\\241\\222Q\\253\\334P\\206+3-\\337]9(\\223\\366y\\305=]\\265(\\3106A\\350\\274\\315v"\\204\\226\\210\\216jh\\313u\\325\\213{\\210\\337\\375\\266\\343q\\011C\\360y\\004z\\011A,|%0(\\367"\\201\\001\\273\\217\\004A\\240\\200\\204/M\\007\\261-0\\364q\\205D\\331\\230\\003\\257\\374\\333^\\360{O\\020\\367\\360\\260\\017_\\260\\345_\\323\\260\\332\\336-\\271\\367\\366\\264\\352\\364\\262\\303C\\274\\315\\306\\366\\310\\177sk\\203\\367\\267\\007\\315=\\322\\366n\\316\\277E\\215\\302\\326\\326P\\000\\206?\\355\\343\\354$\\015\\303lvL\\356I\\206\\037\\032\\265}\\223\\025\\325\\371\\344\\272\\370\\323\\313\\355\\315\\272\\301\\264G\\247\\247w\\233vz\\272\\356\\016\\037w\\216\\336>B\\247hzD.9=\\345\\220\\216\\2318\\014\\371\\326>\\362&\\375P\\220\\325\\017\\271?'\\353\\365G\\016\\240D\\237\\307\\362\\315\\216`\\037\\325E\\210\\303\\262\\210\\313\\364\\241C\\237CO\\021\\226\\362\\024\\355G\\377\\276\\361q=\\327\\266\\302\\366\\332\\207l\\330\\003CB\\263\\236\\217\\336\\306\\227O\\202\\240\\201(\\032\\005\\355\\371e\\034n|\\262\\\\\\276yG.n\\313\\257/A\\266\\2578p\\224$\\313\\350\\016r\\237\\035G\\343\\227\\346C\\223\\220\\260\\272\\263\\011\\221\\344Q9\\306\\226&\\363s\\234\\035\\015\\210\\005\\226G];HS\\334\\014\\017\\037}\\214;wNy\\276\\006\\260Ca\\235\\270Jh\\024\\343\\366\\336U1-'\\177)?\\224\\350@\\343\\351\\365#F\\205\\357^\\376\\313\\327\\317\\377\\366\\363\\277|\\367\\3437_\\177\\367\\232\\215\\343\\230\\307\\253*`A\\310\\323\\202\\336\\032Q\\256\\340{\\340\\221]X\\031\\204\\0109\\200W\\271$\\346b\\0337\\344\\336\\373h\\305<\\300\\247{\\235\\3612^@\\305Ou\\303/<\\364\\342'\\026\\366\\\\n\\200/>\\365\\221\\211\\021\\357R5\\366&?\\367n\\336I\\341\\225t\\345\\202\\265\\224\\342#\\227\\013\\020\\0363\\303\\217\\341\\262m\\262\\037\\351\\300\\277\\337"\\257\\300G\\257!\\004\\343g\\272yh\\237\\2200\\000\\364=\\217\\343-\\346\\313k\\317\\007\\315\\233P\\263\\335\\270\\2020\\346\\315\\2355e\\327\\226\\254j^2\\377T`\\323|\\203\\375M\\274\\001\\356p\\277Lw\\301\\200\\306\\271\\207q56;`\\007(\\235\\017\\210\\276\\377\\027\\000e\\013p\\345\\311\\270x\\212\\305\\247\\262ZU\\015\\263\\264\\363\\003*U5O\\015P\\253\\252\\243V\\245\\246cm;\\2712\\000v}\\357\\007\\033Y\\337\\026\\026\\233ind\\277\\214\\326\\313nP\\336\\271\\300s^g\\030\\020\\202"\\227\\024l\\343Du0\\364\\370d\\225\\037\\322\\311}8P\\3117\\207\\377\\371\\003j\\345xD\\260\\371\\235\\253\\256N\\311&%\\200\\370p4\\356\\333\\015i:F\\204\\342a\\031\\210\\313\\273 {\\336k\\303\\2144\\334\\263>'\\330\\264\\321\\000G\\321\\267\\213ia\\212\\224\\343\\310\\005\\253a`z\\366\\3071S\\025R\\202+m\\005\\226[\\301\\303\\247\\207\\035M\\354\\034>;\\224'W06\\267\\253{)& Tq \\216\\206\\016\\302\\341\\004\\006\\\\\\325\\276\\023\\322;}\\324>\\235v\\360\\234\\267<\\002\\272H]a\\324&\\246\\352\\024\\357\\306\\253\\037)\\007\\225\\214G'*\\216R\\011r\\272u\\275\\015-\\2300{\\334?|t\\330\\241\\312\\306P\\014\\207\\263m=\\253\\300\\221\\250\\011\\333,\\261\\361<Vs{\\030~}{{\\230\\373E\\355\\305;\\274\\246\\373\\251\\255\\353\\300l\\253?W\\3052\\262\\263'\\217T<\\017\\003\\241\\031$\\314\\311\\252x5\\025\\005R9\\315\\017\\017\\305-\\242\\200\\337\\307'O\\276\\372\\375\\037\\376\\361\\177\\374\\323?\\177\\375\\315\\363\\027/\\277\\375\\227?\\276\\372\\327\\377\\371\\335\\367?\\374\\370\\323\\277\\375\\351\\365\\233?\\377\\373_\\376\\372\\346\\177M\\316\\316aS]\\276+?\\314\\256\\346\\213\\353_\\200\\321\\274\\371x\\373\\351\\363\\257\\207\\301\\353\\321K\\330\\031_=\\221\\363\\213o\\217/f\\013(\\300\\217\\026\\342\\303\\310W\\355\\3641\\366\\353x\\314r\\332\\311)\\2019P\\204\\3262[vN\\374YVN\\305\\223\\222\\234\\260\\353\\320r\\374\\004\\032\\037^\\224\\227\\204\\321\\207\\267\\227\\010 Tb!{,w@\\260\\004P\\365\\325\\324\\354q\\225\\0225\\007\\031\\244\\305\\207\\262h\\037\\372v1B\\256\\257|H\\272\\034w\\012hEKy\\326k\\223.\\301\\273]\\202]\\221\\301\\003\\272\\313\\334\\317\\354\\356\\260\\370t]\\302\\341~H"w\\006H\\274zw\\330?\\354\\035zI\\325\\017I\\247]N\\363h\\272s\\016\\2032Y\\021L\\371\\022\\207\\025\\027zN\\223c\\272\\240\\313\\3261\\226!,\\312\\030\\010\\245\\233}\\031M{\\263\\253M|\\357\\334\\314\\364\\253\\177\\374C8Q\\203\\027\\202\\031\\263E@\\033e\\336\\214\\016nS\\204\\234\\245\\232pC\\237T\\202\\267\\223\\034>\\274U\\355~\\262\\351\\276\\253\\3708\\363\\260\\360\\2511\\027`\\250\\253=\\234L\\000\\014s`T\\357\\312\\213\\225{,\\324T\\035\\371c\\203\\006\\251g\\254\\003\\246\\316!>r\\025)\\256\\252\\313\\355\\363\\250\\355,iM\\354zk\\351&|GH\\364du0\\342\\\\\\310\\355\\353c\\243\\227@\\340\\226\\030\\230\\211(\\322\\031\\222v\\234\\033~pH\\010\\371x\\2778\\253\\364wuSa\\024\\035 ^N:\\240\\000\\232&:\\366\\243\\253\\311\\362\\003\\364\\371h\\257}\\210a\\266QE<!g\\341\\374OE\\265\\270Y\\236\\027\\337\\321\\250^|\\206\\304\\362\\234,g\\252\\361\\241!\\234"'\\265'\\331\\031KVNR;{\\220\\200v\\026\\213f\\217|\\3444\\226\\260\\360\\010w\\275 \\037\\177\\326(ya\\337,n\\235\\335+e\\371\\341\\363\\261\\364\\357\\260\\234\\360\\365\\003\\271\\357\\222\\025?\\010\\205\\370\\352\\201+w=\\231\\342\\024\\263smx4yzr<<<>\\354L\\372\\220\\241\\037g}(\\243\\037\\347\\375\\3631\\307]#\\345\\0039{\\320fy\\301\\376\\020\\323\\256\\304m\\365]\\342\\313\\323\\307\\272wG\\330\\353\\024\\011\\365\\237\\337<\\377\\026(\\304\\337\\212\\011\\372qi\\322\\367\\370l_;\\355\\234\\270\\024n8\\315\\016\\337\\034f\\266\\362\\037a-+[\\263\\234\\337\\254\\012\\233\\362\\272\\000:0\\255\\250\\362\\377:\\264\\303v0X\\026\\347\\320\\012\\354\\236\\305\\364fV\\340\\223d\\213\\331\\307\\002C\\012\\350O\\273\\265\\025iG\\\\\\274&\\035\\255\\336-\\027\\267\\264+9\\012\\354\\341\\237\\347\\037\\346\\213\\333\\371\\376\\264 \\264\\235\\237\\177\\356\\357\\003\\033C\\265S\\253\\205\\210[\\356\\272\\032eA\\274\\255\\216\\230$\\254]ew\\346\\266-\\321\\336Y\\362\\300\\212\\026\\273{\\034\\355\\314\\036\\233`Fs\\330\\036\\363\\247;\\213\\353\\326\\231\\373\\2553\\347\\255S\\253\\266g\\353\\215\\346c\\267zx-utr_\\365\\270\\266Y\\362\\003\\256_[\\316\\347\\345\\362\\374fFD\\347\\242XB\\325\\002Vv\\0050*\\246~];\\207\\373G\\317\\340\\353\\276\\016\\351\\330f\\354\\273wlMxI\\004\\200\\177\\217\\364\\207\\0233\\270\\241\\201/\\256\\336A\\036 \\202\\362\\246Er\\0332[\\203\\222\\037\\2705\\270T \\220\\222\\356\\206\\222\\211~+\\022\\\\\\001\\022\\\\=\\345\\014]\\355+\\215\\272\\025\\241\\262\\035\\301\\350jl\\336\\177%L\\332\\2128\\322\\255\\300\\323K_\\021\\\\=\\015\\225\\2025\\255\\211\\237\\226U\\231\\034\\310\\220Ph\\321\\265s\\324{\\244^\\331\\002%\\234\\37362\\203\\261B\\274\\336\\206\\322\\220\\257\\211\\320\\356\\325\\034d\\353r*\\203\\331\\327\\0237 %\\206\\374s\\\\)r\\177\\2532\\231X\\240\\031\\241\\234`N\\222\\304\\201\\261*\\231\\300\\014\\346\\245\\201D-4\\252\\230\\354E\\213\\334\\000\\233\\255\\013"x\\352I\\204h/h\\034\\272\\244{\\244\\273h\\302\\237*@\\240\\255\\244\\015\\372\\0357\\251\\262\\270\\033T\\370\\204Y8\\363\\021\\376\\023\\215\\023\\333\\321\\000\\355\\030\\345\\247\\241\\027q\\270\\314s\\327\\366\\275\\3159$\\304"f\\003b\\240\\0378\\321\\004\\236\\177\\3279\\364=/\\311\\273I\\265?_\\254\\366\\317\\212B\\027\\007\\310\\330t\\377s\\021"\\223n\\202\\032]\\322\\311\\035\\372\\312\\017\\357\\356\\027~\\332b\\037]\\376A\\320-@\\\\Y~,\\226\\277\\241wd+\\031q\\357\\353Z\\375h\\247\\373R\\3477\\315\\0258\\314{\\372\\232\\314\\250\\024O\\225\\037\\251y\\350I\\317V\\275V\\223\\330\\\\\\304\\261\\236\\302\\341\\312\\313\\033\\206%G\\253\\016}\\232\\264}H\\225\\0163~\\301\\360\\220^\\221;\\257\\252\\303M\\2063\\210*='W\\356\\346~\\3234\\255\\221\\305\\355\\223\\020\\352\\217\\356\\021\\315\\205\\366k\\267\\023nk\\357\\321\\250,\\341\\210F\\362wN=\\243\\362}\\372\\367\\213\\3010\\242\\262c\\202\\306\\256\\345t\\022\\244=\\012\\353\\302\\031\\262\\311\\365\\2364W^)\\250\\217\\204\\337\\316\\346\\013\\312\\314\\265\\212\\207H#\\366\\012\\356\\272c\\363=\\320\\316\\367OQ\\242r\\321$\\205p\\2524"\\247\\207T\\314\\260(\\306\\230\\264\\007g\\332\\234j\\011\\224\\026`\\341,d_\\203<\\024\\025i8\\302\\236\\274G\\036\\344\\375\\321\\221\\234\\010\\313\\360\\024\\261\\333t\\351v\\350!\\357\\267\\303\\246y\\214d"\\310B\\371\\212\\341l\\266\\346\\244wJ\\202\\227d\\035\\350\\203\\321\\373\\365\\234-.\\333\\207/?\\341\\2339H\\263\\211F\\314\\367\\317>\\033v\\020\\011A\\241K\\233\\016\\302\\272\\305\\366\\265\\243\\200\\347\\017Y\\273\\032O\\327\\270>\\007\\216)\\216\\026\\211\\372\\331\\262H\\034\\201}\\373"m,\\277H\\004\\276m;\\315\\010\\372\\231\\274~\\340/\\323b\\351\\3061"\\241`\\021\\312\\021\\030\\325\\302\\362o\\307\\343\\0009\\266\\010\\031Q\\225\\035\\322FP\\262\\241\\3248\\177X\\243\\314X\\222\\360\\256\\272\\021i\\341\\331\\211B\\326\\257\\3428\\277;\\264\\265\\017\\373\\016u\\375\\221\\236\\331\\0037s\\347_\\246\\250?\\316B\\224\\026\\254\\3573\\370\\005\\223\\372\\364g3\\330\\004@\\276\\257\\267\\250\\351\\207r\\340\\001Z\\306\\342\\014\\351wTJ\\243\\217\\021\\375\\273\\203O\\267\\273\\006\\2657\\335\\333\\305\\362C\\370X\\312b\\271bc\\237\\205hv!\\001\\330\\357\\273\\015)\\302&\\312\\236\\312\\365\\376\\202\\243\\213u\\341\\364\\376\\361v\\376\\323rq],W\\237\\333|\\2072\\341\\300>\\254x\\337L\\272\\025?\\235#\\325a\\346\\360\\357SU\\013\\341\\007N\\231\\373\\033MF\\360\\015\\354\\346B\\177y\\365,\\0250C\\246`\\353\\314ET\\242:\\343\\035\\374\\375D\\242\\217N\\226K+;\\3710\\371Q9\\214\\343\\205Y\\270\\231\\016\\321pDb\\267\\037v\\017\\007\\320\\006O\\347\\272\\343ji8}\\321\\211d\\207\\251\\327"cyN^\\037j(C\\204\\266\\325\\263\\352\\200~\\001X\\374\\362\\324.\\336\\340\\027w\\321\\270'K\\033\\354\\323\\365\\332\\355"\\315\\366\\224<`+\\003\\024\\322\\262\\031)\\012\\025w\\350cD\\377:\\334\\321\\222H/\\232\\006p\\267\\265\\177\\267\\257\\210\\2609%$\\316\\305)\\036[-\\333\\233\\214@\\361\\203\\025\\231U\\001[\\272\\372P\\316\\017\\373\\315\\027\\024\\224\\007\\233t6\\201\\276\\266\\224\\341K\\214\\357\\240\\304\\015\\234\\032XzZ\\234\\335l-\\316\\231\\351f`\\236\\015tZ\\323\\313\\345\\342\\346:0?8\\203e;{jg28S\\021\\234J{R' \\006 Q\\006A\\243M?\\021\\015\\271i\\3301\\374cD\\177\\306\\244\\243\\016RF\\301\\227[+m\\334kP\\343\\226\\371\\375z\\326e\\302\\240]1\\370}\\371\\264\\251\\321\\301\\245\\340\\237\\233A4\\020\\230\\211\\264\\367L\\376B'\\322\\301\\375u\\0005\\004\\304\\337\\340B?rVb\\207R\\000\\350w\\203\\376U{\\332dg\\024/\\330\\264\\361\\035\\333(=\\222\\027\\213%\\325E\\344\\220\\222n1g\\345U\\271\\312\\257n#l\\011u\\333\\337O>\\021)\\344\\266\\0173\\330+\\\\9\\017:\\355\\37437\\237\\243\\205\\373/x\\222\\325mT\\032a\\254Q\\322\\367\\360y\\233\\027\\350\\361\\203\\227\\274!\\320\\3121=\\207\\363J\\336;\\001J$w\\314L\\250j\\205\\235\\225\\232m3\\025\\265\\377\\305\\256*\\266BGfz\\366yE^rp\\000x\\242I\\223\\\\\\216\\207\\334\\236L\\246\\363U\\277>p\\311\\241\\207~\\020\\340\\317\\216Q,\\243\\332\\007\\000\\243Vk\\326\\361=<\\243"@X:\\235\\201\\024B8\\326\\201M\\301\\025\\332\\265\\361\\360\\313{\\370K\\311\\262\\\\\\362\\004iL\\303y\\350\\351`\\326\\311\\375\\000\\374\\366\\241\\245|\\2125u\\251\\226lR\\304\\024a\\244?\\334\\0164\\010,J\\211\\303~\\303\\261\\244#\\335d\\212\\237\\260\\021\\334\\235M\\215\\007\\224'n\\321q\\366\\320s\\260npv\\010\\361\\000\\307\\271?\\310M\\252 \\302\\362<\\337F/\\021\\363_\\223|t\\230v\\340\\014\\354\\230\\035\\345[\\3011u\\362\\255\\202#\\327\\017$G\\377N\\317a\\006\\375\\367\\341\\377\\015[^\\312yI\\376\\245\\033\\2428\\023\\364\\256k~\\270\\356Q\\373\\020Me\\017\\365%\\210\\266\\203\\025\\232G\\036\\247\\254Ur\\326\\276\\267\\313\\022\\345\\016Sf#wjzF\\032\\223n\\346\\372\\205\\306\\004\\374ZF8}\\217\\242\\366^\\315,>p\\034T\\037]\\215\\003\\266\\275\\306\\235\\351 \\255\\356\\266Y\\267*M5\\210\\312QS\\265\\033H\\316\\317l\\017\\033\\363\\014n\\320\\313\\201\\035mM\\221#\\032\\313\\253\\233\\012\\225U\\373\\223}1c!\\025\\322\\004\\304\\267\\240\\255\\235\\352\\234\\272\\345Ws_\\2520*Q?\\005+^\\254"\\215QM\\307\\007<\\005r)\\207\\375P\\026\\240\\005>\\324\\350\\275|x\\373\\311\\016)AL\\006B1c4\\316\\374\\231\\245\\306k\\374\\035Nb\\350\\214w\\364\\024\\353\\037o\\214Vx\\2530w\\317\\265QtK\\024aG\\334\\252 \\210\\263\\376\\375\\315\\027d\\366c\\240\\233J\\227aU\\333U\\362b3{\\260\\343\\023x\\263\\362\\327Il\\214w\\237B\\366\\276\\375\\021\\240\\024\\367x\\020\\316\\251\\206G\\\\\\312\\340\\254\\026\\256a\\255{\\222\\332^\\001|\\236EF\\212\\255\\326^\\234\\031\\2336\\272\\014\\267Y\\353\\243"\\025_\\274\\221\\366\\027\\0249\\014\\352\\324\\007G\\212=;6\\013\\343x\\210[\\212l\\037\\217-\\351\\2075\\3376\\232`}\\037\\276\\315\\335\\300\\266(\\354\\376\\313\\210\\202\\025\\\\\\240\\345\\006U\\022\\277\\014\\317\\177\\006\\021\\002\\230\\315\\352\\266U\\223"w\\253\\336v\\213\\032\\270raT\\032\\300\\032\\020\\373\\355\\332S[\\205\\232\\272_\\261\\327\\264\\333\\323{\\262\\275\\212/\\270\\020P~\\304\\247n\\324h(0\\306|\\200\\256+ T\\007\\026\\260[\\362\\267\\037S\\266d\\343\\036\\233\\220\\360>\\371\\\\\\303\\353`\\316\\233\\275\\007\\320\\356\\235\\244\\272\\361\\2266T\\023\\355Z\\261p\\201\\266*\\221\\233\\224\\307Ni\\354\\237\\012\\322\\326Y\\311\\025\\265\\356\\344t\\337l\\223\\272\\323\\2519\\303\\325\\337\\272\\274\\016\\037p\\343\\305GF\\305\\236K5\\236\\253q\\365M\\326\\177\\375\\3027\\336\\344\\332\\213m\\275Uu\\262\\330\\377H\\241\\004\\2765\\332\\357\\365\\200H\\324\\362\\377I\\363+,`_\\323\\364\\327.\\304\\373\\242)\\226\\347}!\\341\\351\\254\\234\\177\\2005\\236\\241\\027\\027\\232`\\275+\\212UB\\256\\223y\\242u\\361\\3554\\254\\265\\202\\316\\016\\337\\201\\034t\\350.\\264\\243\\347<\\242\\2277k\\254\\273#pZ\\300\\322c\\022-\\230R\\376=\\222\\201\\014\\215\\245\\003/\\017\\3248\\177w 7\\261\\374.s\\207\\273\\221\\273p\\227\\037c\\237\\244\\273qO\\341\\264s'j!\\017\\325\\273F\\250\\3266\\231\\226\\337b\\017\\327@C\\253h\\301d\\003].\\254Z\\321\\333\\367qC[\\265\\2766\\270q\\215c\\303\\324\\207\\212<^\\227\\332\\300\\245QK\\355\\253@\\3040\\022\\306\\0263\\220\\0070{[\\316q\\372W'\\247:\\251hzf\\237\\332~[-\\307\\3147\\334\\237\\372\\365i\\320M\\325\\006\\243l~\\344\\2733x\\324v.\\257r{\\027\\230d#\\265vo\\353\\244j9KJ\\200\\310\\000\\324\\2338\\220\\223\\341s\\361\\025j\\343\\323\\346\\267%\\336\\261\\301\\257\\363IU$\\207I_\\374\\031Z\\277;\\376\\352\\237\\007\\207\\003L>L\\016]\\362/7\\213\\225&?\\365\\3113\\227\\370\\314'^\\272\\304\\226O\\234\\\\]\\017\\0165\\3766\\017\\310\\270\\336x\\217G\\357\\3670:L\\236>k\\215{\\227Y8~\\207\\227\\177\\232\\334\\006!\\007\\334\\013A\\374\\024\\252\\270\\375pY\\272s~p\\351"\\226R\\366\\350q\\034$\\220U&\\357:W\\372\\0100\\372\\200\\2209\\267b;\\026C\\273xzg\\027\\253\\000\\274;\\371!\\034\\027\\232\\3239\\314\\023q\\034\\341\\271\\265\\251\\334H\\363\\307i\\007\\200oy;\\35542\\000\\367\\311j\\005\\017\\035\\0011W"\\000\\242\\027\\246@BSS\\3264\\251\\223\\333\\341\\2709z\\342\\244I\\226C\\325e\\240\\372Z\\240+\\240\\274\\267"\\255\\011\\007\\376yz\\332\\033M\\216~\\375\\372\\350\\327\\261D\\377\\011[K\\233\\270\\371\\333\\340\\360\\350\\357\\277\\232\\315\\212\\313\\311\\014_\\343\\332_M.a\\027\\002\\250p\\021\\236\\277\\370\\372\\315\\327\\250J\\3322\\312\\207\\264-\\306a\\010\\303}\\003Di\\365\\360i\\217\\221\\200\\234\\200<\\360\\315\\016\\305\\261\\235\\223!6\\244\\261iA\\340\\347\\200\\001\\320\\377|\\035qL\\222\\212\\026\\277\\005=m'\\011\\203\\372M\\035\\376i\\037\\362k\\321b\\373\\177\\350\\\\B\\037\\275W\\017l\\365\\021\\275\\365g\\360\\240~\\0000I\\276K\\270\\271\\244\\237\\020\\335\\301Gs\\261\\344-\\224ti@\\206\\222\\301\\377\\013	2038-01-18 19:14:07-08
talkbox:messages:individual:Watch	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:26-08
talkbox:messages:individual:Unwatch	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:26-08
talkbox:messages:individual:Watching	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:26-08
talkbox:messages:individual:Unwatching	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:26-08
talkbox:messages:individual:Tooltip-ca-watch	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:26-08
talkbox:messages:individual:Tooltip-ca-unwatch	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:26-08
talkbox:messages:individual:Showtoc	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:26-08
talkbox:messages:individual:Hidetoc	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 17:09:26-08
talkbox:resourceloader:filter:minify-js:24a7c889561bc4d914f64f8e8bc3b5a3	\\325}kc\\333\\266\\262\\340w\\377\\012YqE2\\242$\\313I\\332\\3062\\343us\\322\\323l\\3234\\267v\\317\\271w%\\305KQ\\264L\\233\\022uH*\\262\\327\\322\\375\\355;3x\\363!\\333\\335{?lS\\333$0\\030\\014\\006\\300`f0\\000\\263\\343Wo\\216\\336\\274>n\\316\\303i\\344\\3773\\272\\215\\272q\\342O\\303\\264\\033\\315\\227q8\\017\\027\\271\\335\\274\\371\\327*L\\357\\273\\301u\\030\\334N\\222\\273\\363\\353\\350*\\177\\037G\\301m\\323\\275Z-\\202<J\\026\\366\\201;_;\\017\\266zw\\036n\\376\\215\\212]-*Jz\\0220\\017\\357r\\347\\341\\233\\2376\\226i\\370\\355=\\207\\364\\026\\2538\\036`\\352\\001\\276\\345\\327Q6\\300\\247n\\200\\245U5\\241\\363\\020]\\331z\\311}\\217\\312\\266Za7\\303\\352~\\015\\357\\235\\007*\\232A\\321\\320\\376\\315\\317\\257\\273\\363\\010(\\304\\264h1\\015\\357\\214\\362\\216\\253e\\204\\335\\334Oga\\3568.+\\347\\337=\\263\\\\\\273\\357t\\375<O\\355\\007bB8=\\026y]\\236pj\\361\\007\\353\\330\\262\\266\\316`k\\360A@\\017 '\\015\\363U\\272 \\216\\014\\266\\220`3\\016;\\203\\301\\326}\\300\\377\\235\\301S\\2721\\216\\340uw\\327\\035p(o\\021\\256U\\206\\350\\246\\344*\\212\\303\\001\\366I\\227\\277x\\032\\014\\364G~\\277\\014\\223+\\001\\351y\\236\\265\\002\\266\\\\E\\013h$C\\262\\272\\305\\264\\333E\\262^X\\324\\315w\\236u\\307\\236\\326Q<\\3753\\013\\323\\263\\031\\020\\220yC\\353\\367e\\230\\372\\226k}\\366\\277E3?ORx\\376\\015p]Ea<\\205\\347_\\177\\271\\370\\355\\023\\374}\\177\\235&\\363\\020\\036\\276|:\\373\\217\\363\\213\\263\\213\\217\\277\\177n\\274\\262\\306\\204u%0^\\244\\376"\\213}$\\026\\220\\017{\\366\\317Q\\032^%w\\233\\337\\316?~\\330\\020.w\\004C\\3456\\034e\\177\\207NH6\\277&\\013\\344\\\\\\222:=\\327\\262\\306\\356\\220\\327\\3248\\367\\257\\3744R5c\\226 F\\026\\242T\\235\\\\^\\037\\245\\353M\\372\\034\\346Y\\340/\\031\\032\\263\\011\\320\\244sh\\210\\313\\232\\362-L3\\240\\376\\013\\240\\211\\356B\\344P\\340\\303\\200N\\000,\\020,\\270\\342\\225\\270\\326B\\240u\\367\\344\\363\\367\\220\\236p\\256rl\\360t+Iv\\255\\370~\\201\\205\\347Y\\204\\3302\\321\\320e&\\370\\311\\213\\235\\257\\256\\200\\010\\317\\262G\\243\\336f4\\032\\234\\216F\\331\\306\\261\\207~\\347\\377\\034v\\336\\216F\\335\\321\\250=~y\\352@\\376`3\\015\\277m\\3220\\0068g\\203p\\007\\016\\353\\361\\205?\\177F3v\\320)\\332$\\351\\215\\226\\311\\224\\376\\\\'\\013\\004\\230\\304>L\\2530M\\357\\215\\306 \\001\\346\\270`\\351\\261\\177\\237\\254h\\014\\316p$\\024\\352.T\\272\\016'\\267Qn\\351%\\013c\\315(}{\\235\\317c\\352k\\216'O\\243)\\214OJ\\0228A\\024dyb\\215u\\244\\377`\\234G\\252\\374%Ln^\\257\\313id\\240K\\250\\365*I\\347\\010\\265\\216\\260w\\347~\\200\\374\\212\\026+dX\\266Z$\\031\\376Mb\\340T\\246xd\\026/6\\240X\\014\\010\\0233\\277\\221s\\330\\320\\316\\222U\\032\\204n\\256\\025v\\036\\000\\235\\215\\250#\\357p\\020\\235\\350y\\3358\\\\\\314\\362\\353A\\324n;\\017\\254\\254\\307\\376t\\323\\020(\\001\\241\\255\\203\\017\\243\\361\\360p\\354\\026\\223\\372c\\020\\235\\\\B\\262\\322 #\\215\\231\\357-\\304l\\353\\3124w\\356\\347\\301\\265\\213\\003\\300[\\335\\272\\214\\303\\352\\211\\217rL\\020,\\301g\\221|7\\000aG\\030PP6\\376\\010g\\037\\356\\226\\266e[mS\\210uo\\022Xp\\254\\215\\345\\264-\\307r\\272\\341]\\030\\330\\222\\006\\307yP4*.*\\032+e\\027\\264V\\225\\222O\\335\\275<\\371\\224\\254\\303\\364\\275\\237\\205\\266SK\\037M\\271G\\311"\\266(\\212\\010\\0230\\332-\\316\\027\\240\\245\\256">\\205\\036\\255\\212s\\276\\242\\262\\362Tz\\264:1E\\214ZG \\242@\\014M\\333\\262\\376\\212\\361\\3205\\330'\\351\\022\\035\\276\\364\\323,\\374\\010\\213)\\243\\356h\\274\\203\\0249\\005+\\333\\256\\352\\026p\\245\\252\\345\\210\\253`J\\325\\004\\335AKa\\3110)j\\033\\262\\274\\242oD\\353Y\\355\\257\\306T\\017\\216\\201.\\245\\330=&o{N\\253\\305A\\337\\275><T\\345\\254\\243\\356\\241%\\013\\241:\\300\\344\\233\\002\\367\\336v\\177T\\360\\25278~\\236\\001\\3757\\304U\\245;~\\351\\364"\\007\\370\\260\\331\\364\\017Qabz\\306\\203\\205\\370\\255c\\374\\015\\242\\216z\\316:f\\177\\305;\\037\\032"\\231c\\006I\\313\\031j\\035\\213'\\2654\\036K(\\376\\360\\023t\\221ul\\3637\\3208\\357N\\221\\341\\347 \\302\\0273\\221\\354t\\263\\325$\\003\\315\\357\\320\\355;\\307\\240\\037\\212\\322\\237WsX\\202\\240<\\215\\246\\237AQ\\313E\\031\\267\\177\\350l6\\207\\335Cg+\\205\\231\\320\\267\\266L\\343\\312aE\\360\\366\\244\\2765\\367\\227\\206Z\\346q\\255\\233\\351oB?\\003I\\2000\\323(\\345\\371\\2665I\\246\\3670\\030\\243\\314\\266\\272i\\036[\\316\\251\\205\\177\\216\\2558O\\255\\201R\\342\\240\\202!\\224\\033\\357c\\267Mn\\302 \\2676\\233B\\336\\220W\\323E\\316\\217\\213\\372\\036oG\\236\\256\\240\\021b\\271\\365\\252\\313\\016\\3042\\021$\\213iD\\353J\\264\\240\\002\\254\\225\\311\\322\\303\\227\\241\\314\\306\\265\\200)$~\\\\\\312\\352\\217\\261!\\230\\343yW~\\234\\205\\222\\030z\\033lC\\370\\335Pm%H+\\243n\\264H\\223\\335\\267CH\\264-A\\244\\030\\022\\355d\\331\\266\\2320u\\374\\030\\377\\342t51W\\243^\\260\\256\\337\\205\\232\\217\\016\\254\\000\\262+\\020o\\015~\\202\\025\\340\\014\\016\\354i\\022\\254P\\313w`\\311\\364\\247\\3675:\\273wP\\036\\027\\007\\266E\\232\\010\\230)\\323\\351\\373\\330\\317`@0\\240\\016\\3100\\255o\\036\\005h[Z\\2026Sv\\026d\\323p'\\210\\230\\220\\016\\332@\\177\\331\\352I\\222\\333(,Y=b\\266P\\256\\262bn\\303{\\027\\270\\277\\012\\335d\\311\\365\\027\\35010\\304\\210\\311Bcy\\327o\\265l\\002\\363\\230\\321)'\\006%\\302\\214i\\262\\031\\323\\204^\\344\\210\\304\\374\\004\\2537\\\\Lmh\\200\\250\\201\\017U\\211\\314y\\330\\343Y\\000\\274\\004E8\\363:}\\222\\242\\274\\222b\\256>\\276h\\266\\373\\367\\231W\\000r\\363b\\012-\\025\\177\\303\\305\\305\\031\\344\\335,\\314\\3519\\357\\316\\370\\223\\323F<R\\267\\222#M\\360l\\030.\\202d\\032\\376\\371\\307\\307\\367\\311|\\011*$0\\035\\330\\007\\342\\316\\263D\\333\\272\\251\\277>\\025\\322\\021\\233\\350\\034W\\2242\\000\\034\\267@\\347\\2515h\\010\\222qv\\030\\231\\260v\\376y\\361\\236#p\\300\\216\\226\\245\\227`\\266cQ\\374\\253\\225\\303W\\035l\\232\\314\\375h\\201\\200\\354I\\003e\\011:p\\026\\006\\2534D`\\366\\204\\206\\373\\230\\257\\251 \\012\\006[\\321\\327\\324\\224\\315\\346\\201)\\242@\\347*\\316\\335i\\210-\\367t\\326\\310q\\227\\311\\331\\236\\015\\266\\307\\014R\\347\\021w\\001\\330\\014\\225\\271\\312\\237\\036\\177\\335\\014\\032\\260\\234\\327tH\\333\\362\\354\\341\\327\\001\\254\\235B\\007)t\\245\\343\\234\\262\\0329zT\\251\\217\\311\\017\\263}\\336\\\\#\\235\\375:\\211!\\367\\251\\036"\\255\\210\\356K\\020\\242\\016\\027\\276\\320\\007U\\240\\340g \\027\\204*\\332jY\\332\\233\\005+\\207j"\\310\\305<\\374\\300)e+\\251?\\373\\214rMT\\303\\026'\\235\\022\\002\\203\\211p\\226\\303\\310\\232\\254`6\\030\\370\\331\\242z\\020-\\226\\240\\271\\362u\\025\\213\\320T\\246\\262b>[\\270fj\\011\\032\\026\\230\\346\\014\\203&\\002\\215J\\260\\214\\255\\027\\030ly\\201I\\274J\\2538\\242ju\\036\\264\\004\\015\\307`w\\225\\270\\254t'\\021\\310'\\353\\012\\030\\2305\\246i\\262l\\300 \\232&kPH\\374,\\007\\203\\265\\340\\203\\343\\030\\257\\375\\254\\012#\\201\\204]\\224\\\\@\\027\\242\\263\\320C\\227\\244\\321,Z\\370\\361\\207o\\330GS?\\367I\\241\\275B\\266\\344\\351\\275N\\375.`.\\254|\\333Bob\\017j\\006\\223\\027Z\\021\\220\\372\\030\\336\\005!M6\\347\\257\\341CL\\260\\012\\245!\\302\\375-\\274\\362an\\330\\016S\\036t\\214\\226%{&\\015\\347\\311\\267\\260\\216\\265L\\221\\303%\\255\\325:\\260\\345\\013)\\214\\363(/t\\351c\\214\\345\\371\\244KX\\316cU\\343\\377\\317_D)oMy\\376b\\266\\362g\\345\\225\\324.\\274\\317\\327\\022\\026\\024sX\\313\\203/\\237\\376\\374\\343\\354\\223u\\254\\271~\\347\\270\\266\\263\\361#^\\272y\\224\\307a\\253%\\337AK\\206Y\\232\\203>\\321jiHAh-@\\311\\310\\277\\300$\\000=\\311@\\241\\212\\360\\225\\332\\363\\016\\305,\\307^b\\012\\346\\012\\014\\347\\012\\204L\\001+\\320\\343\\242\\266%=\\260\\265d\\330\\322@$\\364\\216+\\261\\354)\\232\\230\\235VA,\\250\\262J\\344Uf\\213U\\030\\033\\341ZF\\325\\032_\\251n\\227lO\\246i\\322\\343f\\303\\254\\321J\\216\\360u\\245@\\276\\347\\365\\235S*\\005u\\037\\263\\007\\320\\251\\267\\344\\230z_S;\\201\\271\\014\\301\\303\\372\\032\\265L\\275\\342\\023\\236\\303\\322\\226\\253\\354\\232e\\017u\\240\\216\\356\\315\\241\\014\\255\\275\\302~\\22252\\255\\307\\215\\026y8C\\311\\201M\\326\\273h\\012\\363\\2349\\020\\310d\\366'\\2612\\004XY6$r\\003\\304{\\004\\005\\012y\\275J\\311;\\206\\322A-\\216\\036*\\253\\232/\\321\\311(\\235bh\\345\\344\\005\\012\\001fh\\246\\015\\243\\361\\330\\213\\006\\333\\002\\241\\000\\310\\015+\\252\\201\\251A \\216\\332\\274FnO!\\357\\302)\\343\\036\\012+\\323#\\247\\2275<r8VM*tP$\\311y(`o{\\217\\224\\340\\302\\263T\\254\\0007\\220\\306\\016g\\364\\2516@\\215\\242\\316q!\\001\\307KE\\247Y\\244\\320h\\022\\320\\225b\\357\\371\\262p\\225GqI\\016\\356\\225\\004\\241\\304\\205\\360 \\013\\243\\005\\230\\247~\\034e\\270\\345CV\\235Ki\\332\\210Vk\\271\\006\\254\\214\\330R\\016\\331\\202\\007\\317\\260\\372h\\323L\\231n\\322%Cr\\033\\351\\004\\215:\\211\\363hy\\026\\004a\\226\\375\\032\\3363\\337\\021X\\307\\270\\251\\326\\011\\263\\240c)\\373\\271\\200\\213\\373\\357\\037Ef\\027M<(\\213~\\352S+\\310\\323\\270\\303T\\344\\016\\250\\327~\\014\\006\\241S\\256O\\224C\\347\\004\\272\\271[\\255\\002%|'@\\245\\033^\\240wo\\216\\276\\177\\274\\305D\\013Q\\240\\010\\330\\257"}\\027\\005\\016\\230\\212\\3259\\233M\\015\\027T\\006/\\240\\266\\017\\234'R]\\337EbgE\\321\\253Y\\354\\220\\177\\364\\204\\241\\200<a\\303\\0015\\037\\333"EdH:\\236\\330\\361\\035\\037/\\222\\334\\356.\\022\\202\\313\\302\\030\\254a\\264?\\312;\\302lP\\356\\333O\\324\\340Ye\\344x\\2215k%\\307P\\207\\366j\\2635\\027 _\\240\\337\\013\\226\\256\\034\\267Z\\034.\\350TS\\017\\002\\226\\345\\225@\\025'\\017\\354=\\353\\205\\237\\346Q\\000\\362\\344\\021\\024\\022\\214K\\274J\\240@\\325\\241vy\\231{\\307\\364\\375\\270\\026X\\213\\2534f\\026\\236&/\\262\\034\\226\\031\\370\\345\\341S\\033\\325\\300<\\021\\326\\260@Xa\\026b1\\271\\307\\322\\333\\357\\315\\\\\\353\\273\\243\\276\\245\\245Y,\\355\\007=md\\263\\304\\037\\215D\\207%\\2765\\022_\\262\\3043=\\361?)\\355\\207\\017\\330\\\\\\327BA\\372g]\\213t\\363Ooy\\201\\360\\357\\216\\016\\021\\347\\245^\\313w\\257\\3160\\355\\330H;\\372\\031\\323z\\254f\\264}\\316\\317\\015uTD"d^\\335\\250\\313\\362{\\352\\315\\214\\2312\\314\\336\\010\\262\\314\\202\\2244\\214=\\006\\220]\\207aNN\\324\\254K\\011\\347\\230\\000=\\244\\275u\\241\\324\\005\\224\\366\\020\\005\\037\\035Y\\327_.\\303\\305\\364=hMS\\273@\\003\\002\\177\\306\\306c\\2016s4H\\0200X8\\215\\331O\\367\\027\\314\\260\\265\\233\\327\\241?m:\\240\\273\\031x39$\\200\\036$e\\263\\311DW\\374=\\314\\343hq[\\323\\021\\353\\331y\\230\\202\\234h\\257ggl`\\177\\301\\250\\010\\301`\\353\\240o\\271\\324YF\\257\\022\\012b9P\\371\\005\\325\\331\\177\\240\\275\\244\\325A:\\256\\013\\335\\353<\\300/\\017~N\\341\\347X\\266.N\\002\\332\\342\\350^\\203\\344\\341\\276\\024\\303\\3711\\374\\372b\\374r\\330:\\035[\\355\\203nH\\033\\305\\177|`h\\271\\337\\243\\365\\202\\034\\037Tx\\356\\245!\\337\\345\\200*i\\217\\014L\\013\\351\\324\\223\\315-\\373_\\366\\354\\271\\261\\321\\310\\274#\\256U-!\\305\\302U\\316\\007\\272\\303\\273\\245u\\334\\033\\015m\\022\\324\\316\\251\\215\\240\\360\\207\\011Tx\\300%\\026\\376t\\235\\321\\370\\240\\347Z\\253\\345\\024\\007A\\001Q\\246\\253\\301@\\354\\247(\\343c\\370\\000_3l\\234H\\007%*\\313\\375E\\200\\276Cn\\376=0(O\\200(!\\247\\220q\\220\\003\\225\\244\\233\\2765d\\331L\\256\\305\\253\\371\\242\\003\\234k\\370n\\343\\305|\\335\\301\\001)\\236\\227\\376"\\214\\351e\\331\\211\\223Y\\322\\360qH?\\206T\\210\\375G\\001c\\177\\022\\306\\010(\\234;\\254\\035\\0057R\\304\\230\\005\\245=f\\211\\363h\\035\\213\\254>\\213\\255I\\373\\220M\\266g\\345j\\310\\372\\222\\215'H\\207\\005\\011\\261\\301\\217\\234\\027\\273K\\272\\326\\320j\\357^j\\333\\315\\2037\\343&\\372\\352\\313$\\272X'3\\355]K,+L\\315%\\031\\367%I\\001,\\377d\\316\\352%KuqB\\271(P\\334h\\352\\362\\312]\\237jG\\037\\370\\002r\\220m\\225\\356\\357\\223W\\232i\\203\\363\\200\\206\\035\\212\\017\\\\\\325N\\374w'=\\377\\235%\\250\\305\\232,\\252\\017\\026'@\\313\\304-y\\312X\\2650\\322\\260l\\241q<o\\260\\315\\326\\021:s\\262\\333h\\001\\366\\006n\\300\\341`\\236\\372)(\\321\\364\\012\\243-\\231-\\302\\011\\211\\226\\003\\273\\371\\342_+P+&~\\332t\\270\\370\\263y\\005W`M\\003\\201\\223\\264\\321{\\247F\\010#\\035%\\251}\\350\\354\\015\\010'\\350-\\271\\037\\317"\\237a\\314B?\\015\\256QE\\003\\234\\023\\320\\237\\322\\220\\341\\224oV\\243\\365\\242\\177\\364z\\320\\260*\\321\\016\\246\\314}tL\\254\\342\\235@:\\200\\325\\346o\\304\\022\\221%\\215ue\\255\\353\\274^\\305\\236\\204\\274"w\\335\\0127r\\302\\177aU\\210f\\025\\033\\030t\\314\\014~\\032}\\223*\\014\\203\\221\\000\\234g\\326\\311*\\206\\236\\204_R\\211\\251\\304\\001\\225v\\372Nu\\251\\335\\204n+(5\\332*\\213\\032\\276\\255p\\276\\314\\357\\371\\350\\226\\256\\330<\\234{\\214\\341\\353\\324\\207\\205\\341$\\216\\336\\235d j\\200\\030\\376\\007RP9\\364S\\\\\\320\\325\\003\\231\\363St\\247\\001\\016>\\010\\243\\251\\005\\363\\202Q('\\2059Ne\\262\\245\\246\\015\\010'6l\\333\\236\\325\\200\\311-3\\332\\326\\230\\355\\203?m\\310\\353\\265\\266Z\\262\\314n\\311G\\303\\221m\\266\\363\\311\\333j\\211'\\336X\\324"<\\017Y\\316F%\\252\\320r\\246\\313q\\215|\\020=\\316{\\210\\272NA\\032\\303\\006\\262\\305,\\323KV\\024\\243^/V#VT\\306~>[\\266 \\322\\276\\201\\211\\213M\\3750\\367#\\335\\315\\204\\2579*l\\024\\363@\\317\\334\\345]\\232'\\351U\\360\\346\\325\\321\\321\\245\\217"\\307\\333k\\262\\340\\264\\375\\027\\007\\337\\265\\254\\227\\355\\321\\250\\323\\363N\\277^\\376\\357\\207\\315\\366?\\233.\\000\\367\\017_\\275\\276\\214\\247\\327\\227\\250Q7E([\\247\\351bl\\337\\233\\313\\020\\253\\273LIx\\033Z\\310W\\253\\215\\262\\334\\250\\256m\\215F\\335q\\033r\\376\\207\\314\\325\\361\\303\\220\\300L\\373\\364\\030\\340\\252\\263\\235\\227\\000p\\200!ZR\\250\\330\\33080zy\\303y\\234D\\231<T\\273\\266\\003\\323\\003A\\216\\003\\333\\371\\257q\\201\\304\\341\\314\\017\\356\\273\\376\\215\\177W\\362\\204\\2009<M\\326\\335\\0143/\\247\\341d5\\273\\234\\343\\310c\\306\\214\\221\\233\\206`\\330f\\371%S\\252\\377\\376\\341\\302\\032\\224K\\027c\\206qi."w\\014\\203\\011;?\\364*\\224\\344\\237\\356?\\202\\014\\322\\012\\363\\225\\036\\026\\272\\260V\\367_\\002P\\330\\015P\\372\\240z\\355\\031\\345!'\\232\\026\\222\\260\\372IU\\365\\232\\216\\316\\3430\\320\\267\\013\\004L`\\256\\244YNz\\272\\3630\\201\\256\\312\\3024\\377\\211M\\225\\3205\\262\\371\\004\\233\\030\\272}\\210\\035\\316t\\334\\272f\\220\\270\\036\\314\\237lj8\\330j\\035x^\\260Q\\315\\256\\302\\321u\\311\\266\\275\\365\\235<\\2151\\202\\361\\032\\244\\3554\\002?\\216\\303i\\267\\313E\\371\\331\\000\\367\\177\\316h~\\375\\373o\\237~\\311\\363\\345\\037l\\220\\330jc\\207m\\0221\\2403\\250\\351[\\370\\357\\2773|{\\326o\\331\\335<>\\352b\\331\\213\\213/\\326S\\012Y\\277EA\\232d\\311U^.\\226\\004\\016\\226!\\231\\262E\\351\\272\\177Vh\\324\\373d\\025O\\033\\213$o0&\\242\\313u\\021\\262\\330H\\326Jl\\233\\220sgE\\276M\\223Kd\\201\\342\\031>\\\\R(\\023(^\\231\\313\\003\\312I]\\215\\334;w\\301\\202\\033\\323\\210\\005l\\202\\242r\\211[X\\003H\\361\\244\\235f\\333\\360\\030\\244\\3212\\3471\\005\\2472\\001-\\267\\266\\325\\243x\\365\\356\\362\\032\\006\\367\\261\\310\\002\\223\\351\\324'"<$\\215\\031\\262\\345y\\312&*\\315C\\250\\224E\\276\\377~e[\\247\\226\\343y\\240\\013< )\\360\\003\\330R\\334\\263\\257p@\\3106\\212\\321,\\213\\264\\236R\\004=\\330\\314{\\215,2\\274\\326:"\\314\\034\\216\\253\\321Q^\\204&\\235d!\\357e\\242G%ZO h\\007=\\012\\221|z\\006m\\333;\\257b\\316\\220\\310\\272s\\036\\374\\030\\204\\204m\\235\\375\\317\\263\\177\\247\\361\\227\\255\\226\\2501a\\360\\325\\300t \\341\\310\\277\\353&0\\227+:\\024\\014\\360\\210\\357s\\251\\271\\002U\\360a\\252\\214ph\\000\\367"bZ\\214\\357\\226\\240\\242\\371\\037\\311\\012\\244^\\232\\254Ar5&\\000p\\233\\025&p#O\\032ZI\\027\\304\\310}c\\225E\\213Y\\303\\007\\303\\336\\217\\033\\242\\006\\334\\372\\001+\\374[\\030'K\\024O=\\014~\\303\\375\\011\\260\\205\\266\\3715T\\322\\010\\367H\\327\\251\\034\\236_~?\\307\\361y\\207Q-\\274\\356_B\\\\\\313`\\246\\207\\3715\\205\\206#L\\303j\\323Pi\\340\\224\\357\\365\\273}\\340[U!\\356\\013\\354\\\\\\334S\\034:F_G\\214'\\275\\273\\316z\\275\\356\\240e\\320\\221^*d\\377\\266\\012\\317\\227\\324\\237\\3151\\274;\\000[4\\364\\356\\303\\254\\256B\\314\\357`\\265i\\022c\\020|\\322\\221\\033+T$YP\\270\\027\\030)y\\030\\\\\\373\\213Y\\361$\\306\\035\\213\\007;G\\200}\\357\\265\\012u0DW\\032\\006!\\310\\301i\\303\\266\\332@\\007\\000\\2572`\\207z\\271 M\\306\\241\\2244\\314`|f\\264H8*P\\320\\346\\002\\012}\\313\\234\\004\\014?\\240D\\373\\316)\\306\\332i\\340<\\252\\220\\355y\\260\\2431<4\\0032?~\\376\\362'\\0272\\202\\030\\317;\\302\\350R\\016\\312\\366\\336M\\262x\\370]}\\241\\010$s\\212\\352R\\251 \\363l\\024\\241\\254\\023X5\\033\\264\\364{\\3150M\\223\\264\\371\\356\\003\\3769n\\354\\344\\030c\\250^\\003p\\361\\244\\007\\310\\336Y\\270\\216Pm|\\372N\\374i\\203UL\\303\\336X\\025\\216i^\\373\\015\\031l\\017\\000\\214mH\\000g\\245X[`e\\321{W\\312' \\007\\206y\\303\\223\\303\\275G\\313\\006%H\\241\\304\\006"\\350\\353ZJ\\035\\266\\265\\037\\321l\\304um\\032\\202\\031\\0266\\356\\252U\\203\\365\\3259\\223I\\331\\031\\240\\362\\012\\373T|\\332V\\2128\\310\\337\\313\\364\\262\\034\\370\\024+`\\273g\\242n\\236#\\235\\233Z)\\025\\301\\324\\\\\\243dk\\0367\\377I\\177\\335\\346j!R\\376\\344O.\\203\\201\\226\\0110jdW\\001\\263\\254?\\345\\013\\313\\344\\006Z'\\360;\\002\\345\\331tJ\\336\\353\\306\\322\\237\\205(\\367\\356Q:Rn\\034e\\271YHQ\\362\\007\\331\\271Z\\311\\2534\\231\\027\\313>WG\\307\\347I\\224guz:\\333#\\374\\362\\276\\352\\230\\204\\031\\233.z5\\312.\\351\\314\\211\\327\\243?=\\212M\\266\\005\\036\\247\\325\\332\\357\\321)\\227\\015\\014\\377\\344*L7\\342\\020\\317\\250\\367\\303\\250{X\\204\\327\\320\\262\\2551\\257\\230p\\011\\011"\\221\\035{\\271\\0241\\343\\012\\224m>\\226\\022.\\347~`\\232\\036\\034\\003\\013\\230\\027T\\210\\220s\\355h\\015\\036\\033\\230\\266\\235\\036\\011;\\275\\220d\\235\\242X\\242\\221\\332\\220~F\\307\\331\\007\\275\\250\\325*\\003q\\0061\\305\\251\\304\\007j\\266|\\253*\\317Jd\\254\\202A5\\207\\344\\326\\271\\336\\004\\362f\\227xW\\256@\\354\\350\\356{\\217\\267\\300l\\202\\306}\\371V\\201`\\217\\266<\\031\\376\\255*}uu\\344\\365\\370^\\345\\2507<\\352\\274\\035o\\346\\3420\\335\\250\\367\\252n\\014A\\271K\\020W\\231V\\370h\\307xCp\\316dx|2\\207y\\311\\273~\\177GI\\310-\\225\\242\\315v\\257\\360~\\211\\247\\2750\\310\\254\\224\\361\\366\\215H\\242\\367\\357Y\\323\\364\\244\\037\\312Io\\337\\26046\\346a\\350\\226I\\343{\\376\\373\\244\\255\\027\\251#\\011\\376\\030\\211\\224\\012\\023]\\031\\220h"~\\246\\255\\207b\\331\\252\\202O)\\007\\255\\357\\321\\023L\\304\\267\\243\\356\\360\\015\\016\\202a\\037~\\343i\\220\\261S\\327\\257:\\257J\\015\\030Tp\\317\\244\\024Z\\245\\2210\\250b\\255N\\326\\2332\\035r\\034\\207\\337\\027\\272\\242\\207g\\376\\032t\\232e\\374\\320w\\267C\\020\\207\\370x\\350n\\001\\015m%H4\\373\\374<\\263vZ\\2049\\234\\272\\007}\\347\\304\\373\\276\\213\\216]Q\\003[vy\\275S0#~_\\340\\322\\360K\\222\\334z\\362L\\006\\331\\015\\242=\\224\\3773\\256\\010\\231\\034\\003z"\\206)\\011\\204\\376t\\252\\341\\223\\313\\3105\\274\\0210\\363\\311\\230\\325:\\017:\\266\\341\\236\\376\\306-\\244\\261'1p\\005L\\276\\333\\344\\300\\022|\\234\\343\\202\\316\\355Ym\\363p\\306\\017\\207p\\323\\227\\362\\301\\350$\\177j\\265e\\205e\\324\\276p\\203\\357\\036\\027\\266\\212#\\266Wl\\356)GlS\\031l7n!\\247\\376\\272\\025\\220\\301A{\\3017\\3767?#\\012,\\241\\210\\350d\\003\\025h,;J5\\242\\225{\\312r3\\357\\241\\262\\261PJ\\265\\227\\266I\\201\\317F\\301!\\244\\216\\013\\256\\3172\\000\\033\\036\\217\\354p3\\342q\\213;3"\\237\\2634\\260h\\217\\266\\224\\2233{\\250\\330~P\\012w\\273\\276p7\\320\\332\\265==(rCn\\256\\027\\273\\337d\\265\\004Cvk#\\242\\272\\313\\202,k=\\177\\2548\\365\\304\\025\\273\\2139X\\331\\030\\215k\\031O\\373\\356\\316 .E\\026\\304\\345\\310\\202\\230v\\302q\\243\\234v\\257\\031\\372\\270K\\017\\036\\375~,6\\240\\206\\371\\261d~\\254\\332\\307\\001\\316\\317\\253nm\\250\\033I{\\377\\237\\005K<i4\\252\\3037D\\033\\236"\\331\\327\\017\\273\\265Z\\270?\\211\\361[\\311"\\231\\200\\020c\\226\\253\\266\\022\\301{\\305\\030\\225\\330\\332 q\\332\\210\\003\\036\\350\\336\\203\\357\\177\\246\\003\\233\\3105\\315\\206\\326V\\255\\347"\\374\\241\\036!_\\326\\236\\213\\361m%F\\241\\201=\\003\\333\\317?\\037\\031\\250\\320\\261c\\255g?A\\217\\336\\376\\214Q\\320\\031\\006\\204\\261A\\331j\\011-W\\317\\327\\375Uy\\262\\334\\347\\332\\206\\\\\\330 M\\372\\261<)\\200\\331;\\324'\\034\\262\\327\\311\\372"\\011.\\222\\331\\254t\\265E\\3158\\343\\223\\033\\246\\360/\\354\\350H\\355\\246C\\236\\004"\\266\\200\\266'\\356"ri\\341\\376\\374\\256BH\\012\\227\\020\\270\\306\\252\\2326\\033\\035\\205y\\226%\\001\\361\\234\\236/\\375E\\275\\264\\207L@)\\001\\365\\355\\015\\244\\224\\352e;\\031\\354\\331\\244s\\257\\200\\016\\224\\311\\201\\202\\243\\035\\021\\215t=K\\253\\007c{\\323\\205\\037\\033\\371$\\337\\254\\027\\326\\200\\216\\250D\\301\\355/\\376b\\032c\\\\\\276\\204\\321N\\240|\\003y\\3012\\240\\337T\\310\\333m\\024\\307\\037\\276\\345\\224\\217'\\0374\\374O\\221\\035\\312\\274\\236g3\\020\\020\\3214\\004\\236\\220\\354W\\014{\\012"kh\\325\\226Q4=\\033\\353\\030\\261\\252\\221\\360\\264B\\215\\035\\205d\\375\\016\\217\\031\\307ca_\\022]\\304S\\222\\264 \\232\\234'^\\223\\206\\245,\\360\\016\\215\\304b\\241\\340\\332O\\317r\\005\\324\\376\\221\\016\\030\\030\\035\\267U\\332\\036\\363g\\222\\324W\\035\\035\\273\\213p}!\\266\\377\\302\\230\\371\\350X\\202\\376\\346q0%\\217\\302X\\333<k\\265\\214\\327.nLSP\\032a\\251\\312P\\010%\\201|ty\\3460\\204_\\036\\374l6\\034\\212N\\015\\3117:k\\2449M\\001\\262p\\262\\310\\3317OO\\227!\\200M\\230\\230\\2010\\373\\222&\\240\\236\\370L<\\361u\\021\\363\\002\\014\\363\\212\\177ZM\\350x@E$\\351@\\012D\\316\\373\\242O\\016:\\225\\316A\\356\\355\\022d\\\\\\206\\341\\000\\330\\015V\\263\\344b\\020\\2108\\277]%^\\036\\023\\203\\200\\033\\343"DA|\\016\\230\\326\\320\\235F\\031hl\\367x&\\026\\2575q\\036\\324p\\322EH\\355\\024\\037\\224QY\\264\\233a\\015\\012\\343\\332\\223\\223\\340\\2609\\340l+\\210QK\\234wx\\012\\015\\270\\372\\324\\323@\\255\\251'\\241_G\\002v\\022\\000M\\303\\205U7\\026\\346\\353\\017\\323(\\377i\\225\\347\\374\\012\\034\\231\\376~\\005\\203m^\\235\\313\\242-\\377m\\225\\200\\361[\\245\\037\\232\\221\\232M\\253\\3516g -r\\241\\315I\\325:\\015\\335\\346hd5Qz\\033EF\\243\\305#\\205\\026M\\025\\345\\254\\221\\203\\256{\\036f\\266\\255"\\227\\\\\\373\\217\\222l\\265\\254]\\265\\267\\374\\371rP"\\332j\\356.\\364/ \\240\\242\\324\\311\\356RqU\\231w\\273\\313\\314x\\031~\\252\\014%\\230\\340\\305\\336\\256\\300~\\322\\310\\205\\003\\004\\205\\3643\\216\\203HG_m9\\3031X}\\334C;laxB[-\\315\\025j\\3728\\331y\\216g\\235\\343(\\240\\266\\345\\373fS\\366\\227q\\027e\\247_\\225\\251\\235\\316 \\207\\332#\\204\\230\\354\\002m\\271\\036\\3368g!\\005wU,\\251\\367\\344\\200b1\\006j\\342\\310\\324\\264P\\201\\300\\310.3\\306\\030%1\\356N\\202\\270\\201\\016\\300\\033\\274d\\304/\\3368\\305\\342}\\331\\023E\\373\\342\\215V\\024\\353k\\025\\216\\276\\231\\210*\\220\\327\\256\\011fI\\332-G\\337\\210\\236\\352<\\324\\005\\313\\031`5k\\024E%o\\267u(\\0361*e\\270\\362_,_\\212b.\\034\\332\\343\\335a\\204\\032\\220Y\\301Py{\\002\\002O\\323\\211Hg\\236Y8\\331\\256E<S\\274\\363\\363\\343\\234w\\3047\\357\\216k\\026\\004e\\025\\004\\211\\370f\\345\\2150b\\2325G\\320sC\\232I\\324'I^;\\266\\364\\210\\334}\\204\\254\\210-\\\\\\305\\231\\207Y;4\\034v\\305\\034T\\211x\\000^\\03448t\\0360\\325\\203$:\\332K*\\002\\245\\324Yk\\022\\033,\\355\\2426\\322SY\\310\\21296\\210*\\345V\\027C\\244\\335\\216h*\\027\\262a|\\220\\262{A\\241\\023}\\274\\370\\252PE\\271\\000\\263\\320\\213\\200\\255V1\\205\\020\\177\\326\\356\\213\\232F\\337z\\221S\\256\\3030F\\250\\2238W\\250\\356\\212\\314\\255\\220I\\205\\236a\\264J\\005\\310|U\\316<\\373\\353\\246\\341\\350q\\304vcs\\340\\364\\334\\346\\301Q\\2233\\332\\320G+\\254\\335\\370\\251\\306$\\017\\245\\213\\245q+\\317\\262dO0\\320\\263\\242Q\\310\\302|\\251\\2671\\346y\\257\\256|\\214A\\243,\\244Y\\367j\\221\\215\\307#\\236)\\027L\\365hZ\\014t&b\\315I\\371\\377\\030\\357\\\\\\201\\361\\251a\\317u\\022\\224\\342\\370\\322\\324\\277g<yR\\3543\\0332\\224l\\204X"+\\224\\204\\320\\246\\244\\301=\\036\\262,|\\316\\360\\246t*\\020\\003\\037\\245\\021\\252\\331\\255\\372\\275\\250\\241q\\313\\224P\\\\c\\375n\\037\\002\\251\\270D\\213C\\201\\221*&+\\231\\262\\246$\\307\\250\\215N\\006#\\272C\\3011\\264\\253\\312n\\024\\222X\\036+!j\\301Q\\313\\303\\236\\364\\322Z\\262\\200\\324\\014q\\005'\\023\\231\\260\\304xj\\213y\\223\\202\\014\\226!}\\327\\2179\\307\\003)\\247La\\026\\363\\333!\\331!\\220\\300\\020W\\3548H\\243\\177\\214\\361\\322^\\216A\\011\\252\\017\\030\\2543\\230\\240\\223\\220\\016u4^1@\\205\\204\\014|\\016!\\003\\321\\001F3\\223}\\315\\342\\361a\\\\\\346Z\\347N\\223\\2170\\2134\\277\\005;\\332\\012\\346\\220\\332q\\023\\276F\\037\\035\\013\\374j\\337R.\\314\\213\\325\\362\\375\\216\\273\\222\\235\\207=\\015;Pd\\340\\223W&\\223\\322\\221=\\026x\\314U\\023r\\260q\\024\\272\\243-\\263\\031\\032\\315v\\252\\203T\\004\\262"n\\226\\373\\251\\010\\320f\\217\\364\\007z\\222\\206\\0014:\\312\\256=Jk\\037\\2759DA\\304\\322\\3361\\004\\362L-\\2074Ru\\035\\210P\\300\\360`pJ\\375\\011&\\274\\014\\256RHF0\\241=\\010\\320\\333\\331\\203\\031\\320\\262\\357Y\\202\\257\\326f\\203>\\2626\\300\\311\\005\\003\\003\\273\\034\\245\\3507\\214\\323\\314\\015\\261\\177\\216G\\257\\242\\205\\270\\343\\016\\204\\205\\247\\372J\\220\\256R\\206\\0000\\366\\202\\311 \\2300\\314\\036$\\224\\234\\235\\301\\304\\015*8\\316\\246'k\\364I\\201e0\\210.\\242y\\230\\254\\214{d\\036\\351d\\227\\341\\3023d\\030&7\\330\\226F\\263^J\\223k\\206X+\\210,\\031\\203C\\316+"y_]\\312\\275\\331\\030\\203WH(#\\221\\337s\\000\\3341\\303\\3128\\203)\\252\\221\\001\\361+\\264\\331z\\212\\203\\302\\025CB\\336\\243\\000XNt\\354bP\\252\\354v\\177\\300\\007\\234\\016'\\266\\233\\010\\330\\310\\340\\300\\012\\001\\336\\317V\\036\\234\\036'\\2054/m\\004\\200\\364\\341d{\\2421\\264$\\277\\333\\243\\222\\260\\3641\\276\\232E\\222\\005\\017\\3644\\342,\\253a\\310\\241\\372$\\216j\\313\\227\\022\\025\\357\\245\\002%;<\\371\\020\\317az\\247\\\\\\212\\270\\211\\204\\341V\\233\\237\\246\\177\\020b\\201\\306S\\353\\263\\036-\\212\\210jj+\\204\\220r\\254\\237}\\014\\325g\\270\\275\\035\\245m\\235$\\332U\\224\\324\\002\\336\\227j)-\\340T=w\\015r\\352\\372\\244\\220-f\\3605\\277\\022\\245\\220=\\274\\036\\213\\240US\\264x\\236\\252\\277p\\303\\353C\\211W\\303R\\212\\214\\220(\\327\\247\\226\\252R)6C YvB\\221\\013\\255\\026\\261\\320\\307#\\001\\342\\351\\270\\314U\\261X\\250\\322L\\347\\244\\032\\321\\375\\244x]\\335\\317\\015\\2557\\364P_su\\327\\200\\014K\\266\\242\\232aE\\232d\\222\\3565\\004\\335~4\\312\\234f[C\\216sC]N\\320\\351\\315\\320y\\330i:\\355\\246\\315\\356#\\307\\270r\\036\\224\\373_\\\\ue\\275{F\\305\\264c\\307y\\317\\316\\016\\375\\206\\346R\\230\\235i\\266\\335\\0150\\354\\346D\\353Z\\301\\260\\033d\\230(\\356i\\000\\303\\233\\361@\\303\\304\\266\\003\\004\\272[@w{R\\337\\260\\301-\\037\\357\\373U\\014\\271\\035\\263\\220'Q\\255Z2at\\353u2O\\263\\320\\260\\360\\240\\223\\312|\\336<\\220\\014\\022\\243\\337.\\301j\\032K\\032N\\243\\024F\\334E\\3623\\306\\334#g\\324\\371\\032\\236\\302$\\014\\2776\\271"\\364\\225\\333\\254g\\030\\307\\371\\317p\\362k! \\224G\\202\\322\\227\\013(\\367\\037\\325wE\\367\\307"~T\\301\\234\\274>:T;\\266\\333\\252\\263\\026>,0t\\252\\2612G\\264\\201\\373j)\\014\\227\\026{\\025\\177U\\270M\\256\\272\\002\\305\\213\\335\\325\\3201s\\245\\034\\200\\256\\035\\315\\375YxI\\267k\\352{\\372A2\\237'\\213\\036\\345f=\\253T`\\265\\004\\013\\010\\354\\015x\\350\\316\\242\\2532\\000\\3364\\310A\\360\\261\\032\\0107C8\\020>\\026\\201\\302U\\232,C<$\\016j\\302z\\306\\015\\226O\\374N/P\\372p3D\\201\\3731\\355C\\347\\341e\\232\\254/\\3618y\\232\\231\\021\\303\\000\\304n\\250\\272\\224\\3070.s\\272\\202\\213t\\357\\022\\024\\035\\302\\364\\366\\364L$\\026Kd\\024\\347^\\334u\\213\\246P\\022\\246$y\\352\\010\\314\\253Y\\345\\204r\\357Z\\004Gw\\3623\\314\\226#gw\\216\\3425\\217N\\030*1\\245sq\\255\\327>K\\037\\346 \\026\\321\\021\\240\\275\\232&:\\236\\203\\226\\370Y\\213/\\243\\351\\245\\325&z\\035\\324l\\360a\\260\\205\\246\\317\\301<:\\347\\240\\266\\302\\250\\353\\224\\005(m\\013\\206]|\\306l\\2044\\313\\377H\\326\\264\\224`r\\027\\217\\024\\201N$\\23757\\232\\204\\241\\2233\\002\\210^\\212\\240\\002\\257W\\204\\031\\326\\024\\352\\364\\205k\\256P\\224\\012\\035r'\\330\\276\\310T\\323\\331\\\\\\342D~7\\010\\3438+\\371k1\\3253a\\270\\351\\302\\254\\021H\\250\\267GV\\013\\3217\\015q\\364\\356\\300\\306"\\332q|\\277AN\\247\\346\\213\\2468\\306\\202e\\256\\351\\240Q\\023j\\260@g$c\\263\\011\\275\\223\\206\\230y\\301\\272\\220.45v\\014\\233\\357\\000\\236N\\325\\353\\270@\\016'k\\226\\025\\315g\\215,\\015\\274\\246\\3256DD\\333\\230\\271m\\253\\331\\2009\\3475[S(;h\\366\\324\\031}\\377\\235\\210\\377\\251\\231\\2270X\\265\\014>p\\314!V\\357\\211\\341\\2151\\334\\004\\220>\\320Kk,P\\205c\\014\\260\\221.;x\\353\\356U\\333\\326\\314k'\\267\\266\\247\\004\\253\\034P,5\\365\\362i1\\221m\\240`\\006\\366\\337GR\\324\\2450\\200\\245[\\207gw+RN\\253\\265/f\\000#A\\316\\201j\\235\\224\\013\\015\\207\\317y>\\2425\\334[)\\036\\324\\2006f\\242\\270\\003\\304\\353\\233\\000\\265\\022R\\030x9\\223|\\346\\265|6W\\177\\000\\3639\\331YO\\234\\317\\247\\207\\307}\\246\\221\\3421j\\230:\\231G\\336\\004\\211\\307;\\224\\245\\177J\\246QX\\376\\020\\211\\236iLK\\201\\261\\355\\0310\\244C*\\032\\250\\325\\002\\364\\244\\304\\037GR\\322g-\\214\\362\\271y\\367\\242\\000\\220\\264\\350\\310\\345\\005\\214J\\342\\240\\325\\250\\211\\220wl\\304\\240\\027w^\\362}U\\024\\0332xTF\\240\\000\\374(\\305\\364\\353p\\224\\215\\356\\374\\303q\\033\\277s\\244\\305=\\313\\364\\003\\312 e#\\237\\357\\223Z"t:\\346\\337\\203)s\\265@2hM\\006\\365)L\\243\\200\\035P\\006li\\202N\\333$E\\000m@R@\\374\\327\\321t4\\035\\216z\\335Fg\\214_\\017:\\353\\374\\257\\361\\303\\253-O\\301L\\374w\\300c\\354\\241z\\374@F\\001'\\363\\017\\343\\262\\362kx\\257\\266W\\025n\\206H==\\202r\\357\\257\\340\\374k$\\332_\\355ag\\264::\\352\\037\\215\\033/\\235\\323\\341hux\\350\\277:\\200\\244C?\\240\\227\\327\\364\\373\\315xC\\177\\217\\016\\234\\235\\025\\005\\253\\024&sp_QYA?\\331\\205E\\2359\\340\\3633\\304\\235\\366\\320\\243\\015\\204\\202\\017\\031\\273\\034\\264m\\\\\\201,T\\331\\304\\306W\\270\\246y\\251\\233\\207\\334K\\223GA)K\\3319rb\\334TL\\214\\033\\261p\\246\\346z|\\243\\326\\314\\224\\316\\264=e\\311<9d\\270n\\303{\\026d\\\\\\230F\\251\\\\\\222\\325\\344\\271\\262\\005\\264\\247\\034\\271\\316\\203H\\024\\267\\014'\\361\\224\\204\\270gs\\326\\235vn\\216o\\234\\302\\224\\010\\247\\236\\316y\\201\\372\\371S\\323\\031pv\\017\\371_\\303>e<\\206\\326\\270z\\325\\256\\240\\321Q\\236.\\3363C\\365X\\203\\210]_z\\323\\021\\235\\205k\\260\\250\\0329l3\\221 \\275\\006\\311\\032\\203nHD3~\\220\\365\\307R\\275\\247(\\0168\\262\\312\\212\\203%\\332\\335\\345hm\\276e\\226U\\016Q\\274MM\\336f\\264\\367<\\002VKU\\375JV\\277\\2632>\\033\\012\\032a\\211\\267J\\033\\304A\\255\\365\\002(\\202\\222\\247K\\372\\210!\\000\\014\\217\\306\\356\\241\\013\\017%\\304f\\327\\3135\\204&\\205\\030\\036\\364\\015\\255\\372\\351\\201\\264O\\222<O\\346R\\2434\\027\\301B\\224\\274\\201\\026\\307\\300\\177/E\\373\\177\\201"\\241\\266\\325ZTy\\3522\\275\\215\\233:8*4[\\212w\\032b0?X\\206)\\270\\274\\352\\247\\305\\377\\252\\002\\014R\\203F\\222\\302e\\314\\231\\277\\256\\014\\227U\\256\\352O6\\342\\315!xmb\\236\\244\\005p\\335\\267\\277\\331\\330\\265\\200\\300ntX\\264Z\\353\\331\\337\\312\\367/\\303\\250%w\\006\\377B\\011\\002\\274g&\\004\\236\\205s\\273\\343\\346\\240^\\205\\324>\\332\\363P\\017\\305\\277\\266\\341gA\\024y{\\273\\350\\244\\331\\224\\333\\315Q.v\\373\\361R\\012\\272P\\271\\276X\\337,f\\016\\017\\252\\324\\030\\036\\265t\\016eet\\2537\\225\\244\\230\\012Fx5\\367\\0124\\353\\364V\\201\\377\\267\\323*;\\021\\203\\277\\016a\\346\\364\\341\\347\\010~\\360\\233\\225\\257\\341\\347\\015\\374\\340\\327&\\177\\200\\237\\037\\341\\347-\\374\\340\\277\\321\\250\\313?58\\367\\357\\210\\364O\\3542\\261\\276\\244\\222\\360\\322\\275\\350ud9\\017\\254nv\\213<=\\353+#\\374w0z9j\\217NG\\335\\221=rF\\233\\321\\303h;\\032\\216\\306\\243\\316\\270\\247N\\017\\310\\217\\256\\000UV;\\033l\\035Z\\337\\031>\\256e\\233T:\\017\\005\\252uXf\\267\\232\\000x\\251ha\\300cT\\024'\\237\\1779\\306e\\257\\016\\213\\232\\240Q^,c\\027\\312l\\264B\\016\\336(Q\\364=\\351n\\351\\257v\\263\\335\\034v\\332\\\\\\315<\\245\\323\\2474\\355\\306/m\\274}\\214=:\\247\\366\\207\\032(\\347\\0240lL,\\315\\266"\\260\\335l\\177\\207 \\316A\\323mFM\\323\\242\\3264~\\257\\314\\373FV\\270c@/jh\\315\\332\\306\\273\\370v\\304\\036>\\311\\353\\350\\372}\\031(@\\351\\3743l\\257\\334WNq\\007\\206.y\\274\\361\\361\\023o8\\024\\223\\005~$\\350\\260oi\\341\\002\\326U81\\263\\217\\214\\354\\271\\237\\232\\331\\257\\214l\\177Y\\310~](}of\\2771\\262oV\\005\\322\\276/d\\307f\\366\\017f\\335\\253\\231\\231\\375\\243\\221\\235\\205K3\\373\\255\\221\\235\\004\\271\\221\\335?4\\262\\027\\31173\\333\\344\\3324\\014\\314l\\3115\\261k\\245\\367\\315\\017\\356k\\247M\\220m=\\371\\320=\\322N\\224\\231\\235\\314\\335~\\005/o\\3413o:\\262\\357\\261\\216"\\366\\2669BDuO*\\377\\252X\\236\\221[M\\357\\217L\\000\\334\\247\\236\\211\\363\\210\\335\\305/\\366\\012\\356S\\347\\344\\0154\\015\\340\\254\\243C\\253}\\237r\\2020\\241\\377\\226%T\\265\\233\\356m\\022d\\337\\247O!Toh\\241D\\015k\\304\\327G\\016\\371\\177\\2261K\\225\\261h\\314o\\212\\002\\221\\244\\035\\356v\\023\\355\\213\\016\\344\\246\\343\\347\\025\\272K\\334\\200V\\205=\\262\\232`\\361Z\\236H\\035l\\211\\013W\\340e\\342t\\321\\222\\035Dzd\\335`\\230)X\\250f\\305\\013d@&\\007\\015\\240\\371d\\252~FG7\\221\\007\\264i\\207\\362\\265-\\276\\241\\333\\030\\3439a\\315Rk2y\\331t\\255\\216\\012\\347\\265#P=?\\343\\007C\\234\\323\\316\\307\\005\\306\\011\\344\\367\\307\\344R\\327\\031[\\262\\345\\253\\344\\247\\321\\001\\0061_\\271c\\001dx\\327\\345t\\231\\025\\350\\336\\032\\205\\333w'j\\263\\034t\\211\\223\\011\\374:\\355\\364\\217\\361\\345\\035\\275\\340\\363\\321\\2703\\201_\\006B\\251\\214V\\372\\366\\351\\221\\251\\355\\334v\\257\\366\\242\\346\\354n\\304A\\205\\307\\256\\302_'1\\223OA\\203B\\345\\274\\246\\202\\324r\\012;\\253\\022C\\311\\323\\000f2-r\\202\\350?\\230\\277A\\213+e\\272\\026\\032.\\302\\363\\241"(4\\237\\037\\333sU\\350\\212[\\255*gx;\\336']\\272\\230\\204\\0215\\025\\311\\311\\024\\343n\\364z\\333\\236\\001\\203V\\025j\\011\\225\\364{FA\\373\\346\\273#\\317;<eu\\0353\\334\\372\\346\\337M\\366[\\246\\335\\3119\\017\\263\\014\\014\\033Wm\\001\\363\\313 *c\\253\\213_\\265\\244\\225\\202a\\370[\\364m\\257\\376\\010\\330|\\335\\271\\311:\\034\\224\\037\\206U\\005\\361k+\\342\\371\\221\\0130\\365\\263\\274\\305J\\3701\\006\\371]\\006\\355,c\\031\\224\\303\\2002\\372(\\214\\031l\\252Hu\\237P\\264t\\363gcw\\013\\036']~\\233b\\007\\351\\3523\\027\\317&]\\025-_ZZ\\370\\244\\251BW\\265\\361X\\354r\\035\\272\\362\\200\\036\\335u#Ga-r\\202)\\342\\357XmUV\\217\\310\\345\\371\\236\\036\\305\\302v`\\264\\012\\360#m2\\244\\025\\025L-\\217_^\\315\\256PU\\311\\006s\\264t\\343\\306U\\226,?"\\242\\240\\224\\243\\200'\\016\\314\\317\\303\\312+*\\026H\\362\\371\\222\\340\\365\\3350\\3520\\274\\344\\232\\357k1\\200\\332\\217\\256\\314g\\024\\214NPt\\274\\033\\230\\307_;\\270\\035,\\363\\320\\373\\241\\002\\002\\366\\212\\021\\001\\002\\214v\\354\\305\\013\\372B\\3043\\277\\220\\243\\333\\355R\\177\\212\\023"\\030\\233}\\036M\\342h1\\303\\243\\272,Q\\355[\\231\\243\\224\\343r\\253\\012\\213\\303\\262e\\024f\\234<a\\320\\235)\\254\\033K\\234\\254\\345`\\205\\000\\323\\031\\306B\\324x5\\017\\242\\365\\0329\\372\\260\\251"g\\265\\250\\272\\222\\207\\337U\\240_\\304\\263\\331\\354\\327\\311\\213J!\\241\\026J\\355\\013\\231\\205+\\205h\\220\\325\\006\\346\\343~\\337\\240&\\250\\031,<\\376\\305\\314\\342\\247\\213\\315\\010\\211\\342\\352_q}\\020[\\376\\215[\\206\\242\\261qq\\220?\\235\\226CW\\371\\320\\367\\363\\334\\017\\256\\335k\\036Y\\373\\240\\0156(F\\347\\265\\361\\374TH\\375S\\227c\\233X\\230[\\334\\321\\017\\237\\363r\\004FE5d*\\321\\266\\360\\333\\322\\005\\222\\264\\206\\340\\275H\\004h^\\276D\\241\\230\\332-L\\252\\275<\\336\\307\\255\\2002\\343\\272\\253\\303{9\\217$s4\\304"\\317\\242\\260\\001\\313\\335S\\344\\232S\\245\\026+\\31368o\\024\\254\\341}E\\246m\\242*\\261_\\334\\207\\025Vp_Kd\\334/\\220\\205\\334\\227l\\267-\\034d\\226k\\314:\\266!\\032\\026\\356w\\221\\327=U\\204E}\\374\\300\\3569\\271\\241kN\\214\\353Fly\\007{\\223\\037\\004o\\036\\323S\\323\\025\\207\\274!\\001\\237\\360\\002\\310\\346\\340\\377\\002	2038-01-18 19:14:07-08
talkbox:messages:individual:Accesskey-preview	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Tooltip-preview	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:pcache:idhash:1-0!*!0!!en!*	\\245Vmo"7\\020\\276\\317\\374\\012\\263\\037Z\\351$\\330\\027HH\\314\\262\\325)\\272&\\221BBu\\264\\367\\241\\252"\\263k\\300\\212\\327^\\331\\336\\2204\\272\\377\\336\\031\\263p\\013\\271V\\271\\036B\\254v<\\363\\314\\343y\\345\\216\\306\\011\\015f\\314Xn\\356jW\\325.\\240\\311\\210\\276XzB\\203r\\316\\237\\\\0\\2664\\216\\317G4H\\253,]dS^\\010\\366Y<\\010\\262f\\226,8W\\304\\326y\\316\\255]\\326R>\\023\\241\\254cR\\362\\242\\237\\206\\213\\254\\223\\206`Ue\\027Z\\331Z:\\342\\326\\234\\244\\214\\254\\015_N\\202\\265s\\025\\015\\303\\222;\\326\\337\\000b\\211\\320}mV!\\276\\205W\\\\V\\024\\014\\035W\\316\\006$\\227\\314\\332I\\000\\224\\270QL\\022\\207\\344\\210\\341r\\022(\\275\\324R\\352M\\220\\375\\016\\367\\370\\331\\222\\313Z\\024<\\015YF\\226\\332\\000%\\370-\\231\\023Z\\021\\370\\326V\\250\\225g\\202n\\210\\325K\\267a\\206\\367=\\327N\\272N\\262\\324VL\\355\\035\\026\\302Y\\236\\243u\\220\\375\\271'\\037\\302-\\037\\026\\372)\\011\\327\\3003\\024\\252\\340O\\375j]\\375\\342\\204\\223|2eB\\335\\317\\330\\212\\377\\304\\312j\\314\\274\\371\\004\\241\\374{\\2037\\211\\003\\262U\\017>\\302\\021i\\304\\224\\\\r\\347\\220$\\204\\3228^\\004\\031Z\\342}\\376JC\\344\\226\\221\\003\\212\\345\\246\\267\\346\\254\\220B\\361\\200\\210b\\0224\\366\\367{\\373cD\\322\\340\\244!\\\\\\267\\223\\3262K\\245\\310^\\245f\\263\\331\\364}V0R_33e\\252f\\022s\\263\\024\\253\\332\\370\\310\\336\\333\\255\\207\\267f\\352\\300\\230\\354\\214\\211\\024\\326_\\024\\222\\001\\204\\376\\007\\251_?\\374\\366F\\006_+\\031l\\376\\313\\247\\005\\247\\310\\313\\036Ui\\311\\204,\\231\\362gXc\\341\\236U\\217)\\245k\\225\\363\\357\\246\\002\\007\\234YN\\020\\033\\363u\\024\\217\\0202\\325\\351\\244\\335^\\217tn\\371f6\\003\\205\\022*\\307\\360J\\033\\327\\231\\301\\323hlF({\\245\\013Nr\\240\\341(\\031\\204q\\344?\\235\\231\\266\\256\\307\\237 \\371\\0054F.kP\\262\\342oNI\\024&\\321\\371(>I\\310\\342\\331q\\333\\231\\363\\262\\222\\314q\\302\\314\\252.\\241\\011\\377E\\357\\343S\\305\\225\\025\\217\\234T~\\216\\220%\\334\\334g\\265q\\036\\241\\363N\\257\\267c\\376\\211=rt\\276\\323\\317Y\\356\\233\\321\\255\\311\\003\\177&Mc\\321\\312\\313\\251(`\\320\\254i\\334\\213\\272\\357\\273Q\\267\\313U\\367=A\\366\\016R\\001\\345\\\\V$\\211b\\370$gQ2\\034\\015N\\011z\\362ck\\0103\\354\\206\\251U\\015}x#\\324\\203\\015\\306\\214F\\364\\345\\013\\21648\\273\\200\\333\\255\\264\\021\\274}\\020\\341\\340\\303\\246\\334M\\277s\\032`7\\023\\354f|?E\\324#4o\\324\\304\\253-OZ\\362\\353\\242u\\002\\363\\264\\274.\\001\\261\\255\\215|?6\\205\\262\\3670\\304i<\\204\\243\\357\\032\\227cAc\\340zrN\\177\\250\\227\\033\\230a\\364F\\030\\354\\276\\306\\346t@\\177\\270{<\\024F\\006\\267\\3215\\\\\\315\\340\\371\\267R\\011\\315\\360\\251\\031\\322\\343\\005\\215\\306\\215\\315\\025\\354\\201o\\034a\\272n\\365%\\356)\\363| \\275\\2029z\\355x\\331\\302?\\003\\361T\\027\\265|\\225\\331\\355\\306\\274\\322\\272M\\007"^~fFm\\343\\327\\2266,\\2744\\246/\\002\\2742@\\177\\361.\\234\\316%\\177\\344r\\2379\\0324\\357\\340\\214\\006\\011>\\241\\010\\374\\214onw\\274%\\266\\265\\251\\352r\\301Mc\\026\\007[(\\277\\236\\3322\\340\\2634\\272\\364\\333\\247U\\344\\367\\273"\\307``{\\353\\345\\022\\212\\301\\223:\\035m\\0350\\225\\257\\2659"\\261_5\\343/\\273\\224\\314\\214\\256\\270q\\007\\335\\205\\261\\234\\337]\\\\\\315\\2477\\010\\000N\\360\\221\\000\\352\\273\\366\\237\\220w\\220l <\\323R\\344\\317-\\305A\\364J\\361\\203\\377\\357\\301\\213\\273j\\037\\333\\001\\206\\024\\233i\\033\\012\\\\\\215\\333d,|d\\221\\\\{\\2517b\\240V\\003\\256\\204y\\261\\0255t\\377\\340\\306z5\\037\\310\\270\\177\\332\\037\\356\\002\\004\\003\\004&\\324\\034\\212z7n\\016'\\221\\227&;=\\230\\223\\002\\253\\355\\026\\245\\330\\377\\330\\254\\020s{'\\213)[\\211\\374\\240\\020\\347\\273\\351v\\004=\\212\\317\\006'\\361\\010\\342\\374\\017	2011-11-28 18:47:36-08
talkbox:pcache:idoptions:1	E\\217\\301\\012\\3020\\014\\206\\337%\\017 m\\235s\\246G\\361(\\273\\250\\367n\\0153\\340:Y*(c\\357n;\\031\\346\\024\\376\\357O\\376\\244\\306\\003\\302\\321\\265w\\272pO\\200;\\234\\004+\\204\\376F\\243\\360\\020\\300J\\322@o\\312M\\221{\\255\\022\\373\\373\\263R \\030\\245S\\231J\\231b\\277-\\027\\325\\254\\276\\323\\373\\311\\343\\007,cU\\026Je\\266\\317l\\010\\321q\\220\\372\\341\\317\\256\\343\\026l\\203j\\035\\274\\012\\371\\372\\031S\\276\\200u\\270\\305\\211\\1770e\\205W\\337\\320x'\\3479t\\222\\367\\352L4\\002y\\216Bm\\\\\\316f4v\\371\\344%4>\\\\\\350\\300\\316\\363\\027	2011-11-28 18:47:36-08
talkbox:messages:individual:Viewcount	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:47:36-08
talkbox:resourceloader:filter:minify-js:260fd63b6ef730ba3609fe218f936508	\\265Ymo\\3336\\020\\376\\236_\\221\\011[k\\003\\216\\0359i\\334\\3123\\206.K\\260\\000\\351\\226-n\\013,\\016\\012Z:Kl(Q#)\\333i\\232\\377\\276\\243^l\\305\\242\\3458\\311\\362\\312#\\237;\\036\\217w\\307#-\\235^\\367m\\317\\261\\246D\\354Ry\\314\\303\\230(:f0\\230$\\221\\253(\\217\\032\\315;:iDdJ}\\242\\270h\\2238\\376\\004B\\342H\\233F\\036\\314\\377\\2344^\\177\\270<;y\\335\\374a0\\330\\263_\\275\\212\\211\\220p\\3128Qf.\\0313\\252\\012\\236+\\373\\272\\371\\363Q\\363N\\200JD\\264;!LB\\377>\\247\\224H\\220\\350k\\325\\244"B}\\214\\313Z\\205\\340Q\\362\\231\\336\\3206\\316\\345\\201h\\013\\360\\251T \\032WW\\226\\244\\012\\254\\226e\\037t\\273\\207\\207G\\275#\\333j]]\\267\\262\\356\\353\\026\\216kyIl\\202\\344#\\032\\225H\\020\\006H\\332]\\214\\267y\\254\\025\\222\\006\\\\,\\350\\224\\024\\023\\336\\320H\\266\\247\\340\\2425*\\320% \\344\\021\\037s~S\\003\\2214\\214YuqK\\200\\033P\\267N@\\310\\321ZQ\\235\\000\\316\\270\\037\\301\\230%u\\323D\\034M\\305|J\\352tU$\\362\\210\\360\\214\\220\\257\\377& nk\\206\\332D\\336Fn- Q\\374\\2041\\032KZ\\331\\200\\002\\023P?`\\370\\253\\2060WV\\231\\333\\015\\300\\275\\031\\363\\371e@'\\352\\230\\255\\263Z\\201f\\024"U\\213\\340\\214\\021T\\005\\303gH\\306U\\217x\\010]\\343\\007\\013\\000\\277\\241f\\363\\347\\010\\017\\030\\271\\005\\357W\\214B\\023l\\247\\300\\301<\\326\\233\\200J\\235R`u[\\261b\\252\\032`\\314\\210\\013\\001g\\236!>J0\\306]\\302\\350\\267\\332e\\310\\304\\367A\\032C\\310\\270\\313e^E\\306g:\\007\\325\\311W\\270\\224K`\\220\\246\\215Z \\312\\257\\365\\306\\204\\342\\256\\210\\312b\\012?^\\201\\316\\250\\347C\\255\\021\\021\\024rL!\\353\\226\\275\\024\\262\\302\\025s\\314c\\033V\\2030O\\020\\337\\327\\373^3A\\276\\240\\252F\\233t\\360\\004\\217\\343\\027\\023\\3362\\252\\2752\\245\\000I\\277m;\\245a\\202L\\213\\025\\3412u\\221\\377M:\\027/+{\\247\\324K\\\\\\344\\365\\014\\376\\360\\010\\351+z\\352Hs\\271>_\\252\\307\\347\\226\\272.\\234te\\212q\\242\\324K\\250\\352\\341\\311\\032c\\312\\256f\\240UY\\253\\214\\224\\340\\361\\366\\314\\325-Va\\016\\267:\\227/E\\257\\311\\267Wc]p\\037\\007\\345\\230l\\\\\\347f\\233IF\\015\\031\\373%\\034\\\\\\031\\316\\273-\\365\\203\\311\\004#P>:\\307\\026\\37013\\234\\200F\\241Fn\\216\\025\\345Z_\\337\\310\\216EA\\245\\210|4\\263\\316\\241\\253\\314;\\217\\346\\306s\\235a%\\367\\344\\331'\\274Z\\014<\\232yQ)<YB\\2340I\\326g\\231\\215\\374\\022K\\213gp\\007\\344\\346\\031\\334:\\216\\236\\314\\255\\004\\211\\344d}\\034V\\005\\244W\\235\\031^u\\214'\\376b\\264\\235(\\312\\326I5\\026\\273\\253\\245\\255\\241\\274[\\231\\202\\244u\\024\\356\\277\\304\\213L\\245\\\\*\\001\\031\\370\\304\\275]\\000\\315b\\2206\\227H\\025\\344\\224\\302\\254-\\264\\307\\245\\272\\237lf\\2241\\270\\230\\3521\\203\\002\\032\\0330\\312\\315\\025y\\225C\\002\\021n\\260\\001\\314H\\344'\\3047\\327\\266\\0253\\220\\257d\\245J\\3351\\301t{L\\225\\\\5WI\\312\\214\\250\\252n[K\\032ci^\\271\\355l-\\005K\\005\\274\\260^\\010\\272\\346^d`\\210&\\264z\\366n;\\257G'\\223m\\204\\264\\326;\\260Q\\276\\311-\\267V\\022\\242\\200\\240\\323y.\\376\\363\\253\\276\\267\\265\\274G\\207\\334\\323\\327\\035\\250\\220M\\270\\010\\237\\255\\353\\331\\311)\\235\\277\\300\\232CP\\004\\013\\275\\312\\023\\303\\366\\202f\\371=\\363\\331\\222t:\\331fa\\255\\235\\032;\\257\\235B\\247\\273\\027P\\225+<I\\236-\\307\\234\\017\\267\\027\\023\\020\\001\\346\\367\\207\\012\\026\\317\\236m\\340I\\254\\337\\000\\237\\255\\341r\\323\\326\\013*\\322\\376z\\011\\261\\316\\207\\246\\333\\336\\365\\365u\\263\\277|\\266\\314\\222!ZW5\\356\\254\\231\\177\\216+\\270t\\005\\215\\225\\345X\\035E\\230>\\255\\273\\235\\000X\\334\\321\\253k\\307\\201\\256\\026=\\030'\\276\\345\\244/\\245\\255\\364\\231\\015\\341\\213wE\\251n\\031\\304D\\005U\\031\\351\\213\\034Bf\\376G\\301.\\3205\\360\\246\\307$\\342\\002\\245\\342\\321\\310\\031\\215:\\370\\363]SrIN\\312cT\\270K\\302\\347q\\000bI+`\\021\\250%\\035Ee\\326\\031\\027\\314\\233a\\245\\276\\354\\012\\011e\\212#\\375=\\202\\231\\236\\362\\273\\234F%\\371\\264$,\\014\\227:\\245kx/\\024u\\031\\\\\\030\\227\\232>Lk{u~\\264StfW#\\2704~2W\\020\\3517j\\004\\345\\326.\\206j\\346\\320\\021>\\363?\\021AI\\244\\036\\250\\225\\357\\021*\\233\\346^\\335\\211\\366\\326/\\303(\\026\\304\\024\\253\\253\\314\\372N\\247\\343\\301\\024\\030\\217C\\254\\3030YyX\\375\\221l\\257$\\210\\363\\302\\347\\034\\013\\242\\264\\367\\230G\\250\\252\\252\\016\\344\\217\\354\\330a\\267\\355^{?\\355<\\211\\2647\\276\\2778\\263\\034\\375\\244\\276\\354\\372,\\250z\\330\\177\\211\\316#\\364\\213\\3750-R1G\\015SOv\\256,\\024e\\245\\252\\377Fqkj\\306?\\020\\212k\\365aH\\225\\036\\2614\\275{\\221\\225J3\\377\\024y\\210R\\340\\375AB\\2201\\321e\\231sg\\355u5R\\307\\006\\242\\366l$.\\263j\\014\\311}\\244t,\\341\\277!\\356\\00165\\370c\\3668\\177\\2207wU6t\\230\\243p\\247v\\363\\375}\\263\\322U@\\217\\260\\377\\224\\246q\\332\\313\\233\\305\\320\\333B\\233\\317Y\\325\\375\\256L\\027 [+6\\204\\020\\313\\345\\354"c\\227\\350\\005H\\353\\372{\\246\\210}\\220\\267\\027\\203Z\\333cD\\373\\371\\311\\376\\246Dg\\240{m\\264\\205\\255\\316\\274\\324Zi\\022\\261\\234\\275.F|n&g\\317\\306\\015p\\366[V\\312\\346\\330\\371\\347\\024N7k|\\311\\272\\017\\262q4\\305\\227\\324:\\316\\341\\303\\216\\034\\366\\246eM\\264e\\234\\243\\254\\221w\\367J\\025\\205\\345\\274-Q9\\340\\035J+\\014\\342\\330\\373K*\\037\\267Q\\255l^\\273\\233\\265\\212\\001T\\314-\\014\\341\\330\\207K\\252\\000\\240J4L\\235\\375(o\\025J\\245&\\272DW\\326fB\\003\\252\\207\\333\\217>\\207+X\\004\\267\\016A+\\216t\\025\\352S]F~\\215\\375\\364/\\370\\271\\177\\377\\032=\\220\\223\\005\\370\\202\\377\\275\\304\\214-\\315\\211\\007\\226\\223hI\\177\\203\\344\\211p\\341<\\375\\200\\352\\003\\231\\377\\245\\257W\\347\\020\\371\\232y\\317\\276o\\366\\357\\373t\\322(\\177\\360\\326h6\\357<\\356&i&\\230\\351\\000mX\\243\\371\\201+\\323<\\264+\\205;\\030\\255;\\036~I\\017\\207A\\232wF\\363\\356\\021\\011\\343\\276>\\260\\006\\020\\025d\\310\\275\\204\\201\\034d7\\275\\237z\\307\\213\\035,\\020<b\\267\\203l6Y\\364\\351\\263c\\220\\0352E\\3274\\3134\\203\\356\\276\\215_\\335\\336\\260{\\200\\337\\373\\377\\214\\264\\266\\2405\\356dB4i\\341B=\\320\\257\\212\\017>d\\354\\367\\255\\376\\177	2038-01-18 19:14:07-08
talkbox:messages:individual:Newarticletextanon	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Newarticletext	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Red-link-title	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Revertmerge	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Protect_change	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Unblocklink	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Change-blocklink	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Revertmove	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Undeletelink	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Undeleteviewlink	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Revdel-restore	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Hist	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Diff	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Pipe-separator	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Revdel-restore-deleted	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Revdel-restore-visible	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Talkpagetext	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Editnotice-1	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Editnotice-1-Main_Page	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Editing	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Anoneditwarning	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Longpage-hint	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Bold_sample	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Bold_tip	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Italic_sample	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Italic_tip	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Link_sample	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Link_tip	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Extlink_sample	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Extlink_tip	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Headline_sample	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Headline_tip	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Nowiki_sample	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Nowiki_tip	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Sig_tip	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Hr_tip	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Copyrightpage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Copyrightwarning2	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Summary	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Tooltip-summary	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Accesskey-summary	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Minoredit	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Watchthis	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Savearticle	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Accesskey-save	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Tooltip-save	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Showpreview	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Showdiff	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Accesskey-diff	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Tooltip-diff	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Cancel	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Edithelppage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Edithelp	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Newwindow	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Editpage-tos-summary	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Edittools	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Create	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Addsection	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:56-08
talkbox:messages:individual:Vector-view-create	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:57-08
talkbox:messages:individual:Vector-action-addsection	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:57-08
talkbox:messages:individual:Tooltip-ca-addsection	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:57-08
talkbox:messages:individual:Accesskey-ca-addsection	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:57-08
talkbox:resourceloader:filter:minify-js:ef2af7a5c42999eff3883facfbbd3bdb	\\305}\\377\\177\\3336\\222\\350\\357\\376+d\\325\\025\\310\\210\\222%'i\\033\\313\\214\\237\\233&\\333\\274\\266i\\256vw\\367\\236\\244\\370(\\211\\266iS\\242\\226\\244"\\373Y\\276\\277\\375\\315\\014\\276\\363\\213l\\367\\356>o\\273\\216H`f0\\030\\000\\203\\301`\\000f\\207\\257z\\257\\016\\372\\207\\315y8\\213\\202\\177D7Q7N\\202Y\\230v\\243\\3712\\016\\347\\341"w\\232\\327\\377Z\\205\\351]wz\\025No&\\311\\355\\351Ut\\221\\277\\213\\243\\351M\\323\\273X-\\246y\\224,\\234=o\\276v\\357\\035\\375\\356\\336_\\377\\033\\241],*0}\\005\\230\\207\\267\\271{\\3775H\\033\\3134\\374\\372N@\\372\\213U\\034\\0170u\\017\\337\\362\\253(\\033\\340Sw\\212\\330\\272\\230\\320\\275\\217.\\034\\023s\\327'\\334V+\\354fX\\334/\\341\\235{O\\250\\031\\240\\206\\316oA~\\325\\235G\\300!\\246E\\213Yxk\\341\\273\\236\\221\\021v\\363 \\275\\014s\\327\\3658^p\\373L\\274v\\337\\355\\006y\\236:\\367$\\204pv(\\363\\272"\\341\\230\\211\\007v\\310\\330\\203;x\\260\\344 \\241\\007\\220\\223\\206\\371*]\\220D\\006\\017\\220\\340p\\011\\273\\203\\301\\203w\\217\\377w\\007Oi\\3068\\202\\327\\355M\\267'\\240\\374E\\270\\326\\031\\262\\231\\222\\213(\\016\\007\\330&]\\361\\342\\0330\\320\\036\\371\\3352L.$\\244\\357\\373l\\005b\\271\\210\\026PINdu\\203i7\\213d\\275`\\324\\314\\267>\\273\\345O\\353(\\236\\375\\231\\205\\351\\311%0\\220\\371C\\366\\3732L\\003\\346\\261O\\301\\327\\3502\\310\\223\\024\\236\\177\\003Z\\027Q\\030\\317\\340\\371\\227\\237\\317~\\373\\025~\\337]\\245\\311<\\204\\207\\317\\277\\236\\374\\373\\351\\331\\311\\331\\307\\337?5^\\2621Q]I\\212gi\\260\\310\\342\\000\\231\\005\\342\\303}\\347C\\224\\206\\027\\311\\355\\346\\267\\323\\217\\3577D\\313\\033AW\\271\\011G\\331\\337\\240\\021\\222\\315/\\311\\002%\\227\\244\\356\\276\\307\\330\\330\\033\\212\\222\\032\\247\\301E\\220F\\272d\\314\\222\\314($J5\\331\\025\\345Q\\272Y\\245Oa\\236M\\203%'cW\\001\\252t\\012\\025\\361xU\\276\\206i\\006\\334\\177\\0062\\321m\\210\\022\\232\\006\\320\\241\\023\\000\\233J\\021\\\\\\210B<\\266\\220d\\275\\035\\365\\374\\035\\244'B\\252\\202\\032<\\335(\\226=\\026\\337-\\020y\\236EH-\\223\\025]fR\\236\\002\\355tu\\001L\\370\\314\\031\\215\\3667\\243\\321\\340x4\\3126\\2563\\014:\\377\\267\\327y3\\032uG\\243\\366\\370\\305\\261\\013\\371\\203\\315,\\374\\272I\\303\\030\\340\\334\\015\\302\\355\\271\\274\\305\\027\\301\\374\\031\\325\\330\\302\\247\\254\\223\\3427Z&3\\372\\271J\\026\\0100\\211\\003\\030Va\\232\\336Y\\225A\\006\\354~\\301\\323\\343\\340.YQ\\037\\274\\304\\236P(\\273P\\350:\\234\\334D931\\013}\\315\\302\\276\\271\\312\\3471\\265\\265\\240\\223\\247\\321\\014\\372'%I\\232\\240\\012\\262<ac\\223\\350\\337\\271\\344\\221\\253`\\011\\203[\\224\\353\\011\\0369\\350\\022J\\275H\\3229B\\255#l\\335y0EyE\\213\\025\\012,[-\\222\\014\\177\\223\\030$\\225i\\031\\331\\350\\305\\012\\024\\321\\20019\\362\\033\\271\\200\\015\\235,Y\\245\\323\\320\\313\\015d\\367\\036\\3109H:\\362{\\203\\350\\310\\314\\353\\306\\341\\3422\\277\\032D\\355\\266{\\317q}\\376\\323MC\\340\\004\\224\\266\\011>\\214\\306\\303\\336\\330+&\\365\\307\\240:\\205\\206\\344\\330\\240#\\255\\221\\357/\\344h\\353\\2524o\\036\\344\\323+\\017;\\200\\277\\272\\361\\270\\204\\365\\223\\350\\345\\230 E\\202\\3172\\371v\\000\\312\\216(\\240\\242l\\374\\021^\\276\\277]:\\314am[\\211u\\257\\023\\230p\\330\\206\\271m\\3462\\267\\033\\336\\206SG\\361\\340\\272\\367\\232G-E\\315c\\245\\356\\202\\332j,\\365\\324\\335\\311\\223_\\223u\\230\\276\\013\\262\\320qk\\371\\243!\\367([$\\026\\315\\021Q\\002A{\\305\\361\\002\\274\\324\\025$\\206\\320\\243E\\011\\311W\\024V\\036J\\217\\026'\\207\\210U\\352\\010T\\024\\250\\241Y[\\225_\\321\\037\\272\\226\\370\\024_\\262\\301\\227A\\232\\205\\037a2\\345\\334\\035\\214\\267\\260\\242\\206`e\\335u\\331\\022\\256T\\264\\352q\\025B\\251\\032\\240[x)L\\0316GmK\\227W\\264\\215\\254=/\\375\\345\\230\\312\\301>\\320\\245\\024g\\237\\353\\333}\\267\\325\\022\\240o_\\365z\\032\\217\\035t{L!\\2419\\300\\365\\233\\006\\367\\337t\\177\\320\\360\\2725\\004}\\221\\001\\3557\\304Y\\245;~\\341\\356G.\\310a\\263\\351\\367\\320`\\342v\\306=C\\372\\354\\020\\377\\005UG-\\307\\016\\371\\257|\\027]C&\\013\\312\\240i\\205@\\331\\241|\\322S\\343\\241\\202\\022\\017?B\\023\\261CG\\274\\201\\305y{\\214\\002?\\005\\025\\276\\270\\224\\311n7[M2\\260\\374z^\\337=\\004\\373Pb\\177Z\\315a\\012\\002|\\352M\\037\\300P\\313%\\216\\327\\357\\271\\233M\\257\\333s\\037\\2242\\223\\366\\326\\003\\267\\270r\\230\\021\\374\\035eo\\315\\203\\245e\\226\\371\\302\\352\\346\\366\\233\\264\\317@\\023 \\314,JE\\276\\303&\\311\\354\\016:c\\2249\\254\\233\\3461s\\217\\031\\376\\034\\2628O\\331@\\033qP\\300\\020\\360\\306\\273\\330l\\223\\353p\\232\\263\\315\\246\\2207\\024\\305tQ\\362\\343\\242\\275'\\352\\221\\247+\\250\\204\\234n\\375j\\334\\201\\234&\\246\\311b\\026\\321\\274\\022-\\010\\201\\3272Y\\372\\3702T\\3318\\027p\\203$\\210KY\\3751V\\004s|\\377"\\210\\263P1Co\\203\\207\\020\\376m\\350\\272\\022$\\313\\250\\031\\031Y\\262\\273N\\010\\211\\016\\223L\\312.\\321N\\226m\\326\\204\\241\\023\\304\\370\\213\\303\\325\\246\\\\Mz\\301\\233~\\033i\\321;\\260\\000\\310\\256 \\374`\\311\\023V\\001\\356`\\317\\231%\\323\\025Z\\371.L\\231\\301\\354\\256\\306f\\367\\367\\312\\375b\\317ad\\211\\3002e6{\\027\\007\\031t\\010\\016\\324\\001\\035f\\264\\315\\243\\000mf$\\030#e+"\\037\\206[A\\344\\200tq\\015\\364\\227W=Ir\\023\\205\\245U\\217\\034-\\224\\253W17\\341\\235\\007\\322_\\205^\\262\\024\\366\\013\\264\\030,\\304H\\310\\322by\\333o\\265\\034\\002\\363\\371\\242S\\015\\014J\\204\\021\\323\\344#\\246\\011\\255(\\010\\311\\361\\011\\253\\336p1s\\240\\002\\262\\004\\321U\\0251\\367~Gd\\001\\360\\022\\014\\341\\314\\357\\364I\\213\\212B\\212\\271f\\377\\242\\321\\036\\334e~\\001\\310\\313\\213)4U\\374\\204\\223\\213;\\310\\273Y\\230\\323s\\336\\275\\024On\\033\\351(\\333J\\3654)\\263a\\270\\230&\\263\\360\\317?>\\276K\\346K0!A\\350 >Pw>\\223u\\353\\246\\301\\372XjG\\254\\242{X\\201e\\001\\270^\\201\\317c6hH\\226qtX\\2310w\\376y\\366N\\020pa\\035\\255\\260\\227\\260lGT\\3745\\360\\360\\325\\004\\233%\\363 Z  \\1772@y\\202\\011\\234\\205\\323U\\032"0\\177\\302\\205\\373X\\314\\251\\240\\012\\006\\017\\262\\255\\251*\\233\\315=7D\\201\\317U\\234{\\263\\020k\\356\\233\\242Q\\375.S\\243=\\033<\\034rHSF\\302\\005\\340pR\\366,\\177|\\370e3h\\300t^\\323 m\\346;\\303/\\003\\230;\\245\\015RhJ\\327=\\346%\\012\\362hR\\037\\222\\037\\346\\341yc\\215l\\366\\253$\\206\\334\\247z\\210\\014\\024\\323\\227 U\\035N|a\\000\\246@\\301\\317@.\\010\\215\\332j1\\343\\215\\301\\314\\241\\253\\010z1\\017\\337\\013N\\371L\\032\\\\~B\\275&\\213\\341\\223\\223\\311\\011\\201\\301@8\\311\\241gMV0\\032,\\372|R\\335\\213\\026K\\260\\\\\\305\\274\\212(4\\224\\011W\\216g\\206s\\246\\221`P\\201a\\316)\\030*\\320*\\004q\\034\\023a\\360 \\020&\\361*\\255\\222\\210.\\325\\2757\\022\\014\\032\\203\\355E\\342\\264\\322\\235D\\240\\237\\330\\005\\0100k\\314\\322d\\331\\200N4K\\326`\\220\\004Y\\016\\013\\326\\202\\017NP\\274\\012\\262*\\212\\004\\022vQs\\001_H\\216\\241\\207.I\\243\\313h\\021\\304\\357\\277b\\033\\315\\202< \\203\\366\\002\\305\\222\\247w&\\367\\333\\200\\205\\262\\012\\034\\206\\336\\304}(\\031\\226\\274P\\213)\\231\\217\\341\\3554\\244\\301\\346\\3765zH\\011f\\2414D\\270\\237\\302\\213\\000\\306\\206\\343r\\343\\301\\244\\310\\230j\\2314\\234'_\\303:\\321rC\\016\\247\\264Vk\\317Q/d0\\316\\243\\274\\320\\244\\217\\011V\\344\\223-\\301\\334\\307\\212\\306\\377?\\177\\022\\245\\2745\\346\\005\\304Y\\027\\336\\037s!:\\354\\233\\365\\362t5\\237\\007)\\032\\232\\344\\004e\\363\\340\\366W\\232;\\231w\\360\\272\\347v\\241O\\241\\217#+zt\\303\\356\\372*\\202u\\214\\357\\3676\\233\\260;\\275\\012\\322w\\2505\\345{\\236\\306\\277\\204w\\370\\030\\304\\271x\\232\\207y@\\336\\336\\222\\301\\011\\323\\265\\257\\033Jy\\025\\366\\207\\243U\\257\\367C\\257\\003?\\337\\177\\3700Z\\375\\364C\\017_~\\372\\360\\341\\303x\\377\\322c/^\\220@\\015h\\001@\\320\\357{\\364\\362AC#\\270tf\\\\8\\360\\364\\366\\340\\325\\367\\356}\\330\\335)\\367\\236\\277b\\313\\350f\\210\\203\\305\\345*\\270,\\0334N\\341}\\276V\\260\\260>\\002\\223j\\372\\371\\327?\\3778\\371\\225\\035\\032\\036\\3709\\232X\\\\\\360\\362\\245\\233Gy\\034\\266Z\\352\\035\\026+\\240,s0\\353Z-\\203(\\314\\035\\013\\260\\365\\362\\317\\240\\213\\300\\\\\\265Hh\\024!\\025h=\\331:8X\\270\\235\\277Z\\344~\\005An\\007\\027\\370\\361\\260M\\225#\\274\\226\\015G\\255\\323\\211\\274\\353U\\260\\304W\\313\\025\\031\\260\\240\\320]\\2502[\\332BX\\007\\217Y%\\033b\\245\\242=\\362\\000p{\\237\\0367\\033\\356\\023\\250\\024\\210\\230\\335\\013\\334\\373~\\337=&,(\\373\\220?\\300\\312\\346\\201\\334\\203\\357jJ'0\\217\\023\\270\\207\\261\\004\\266\\276Y\\360\\221\\310\\341i\\313Uv\\305\\263\\207&P\\307\\364\\251Q\\206Q_\\271\\212U%r\\333\\323\\213\\026yx\\211\\372\\033\\253l\\266\\320\\014\\264-w\\343\\220\\343"\\230\\304z9\\306qy\\217\\310-\\020\\377\\021\\0228\\320\\314"\\225\\3548I\\027miz\\250,j\\276DW\\257rM\\342Z3/p\\0100C;m\\030\\215\\307~4x(0\\012\\200\\203\\207\\035Z\\337R\\021\\334\\032\\205Y\\241-\\212\\024\\313Z\\024^8\\343\\342\\3039\\303v\\214\\232\\270\\226c\\024;\\253\\315\\206\\011\\212<\\271\\367\\005\\352m\\377\\021\\0141\\207\\225\\320\\012p\\003\\265\\346\\024\\222>6z\\250\\205\\352\\036\\026\\022\\260\\303T\\264\\032#\\273\\322\\230\\210<\\245\\366\\236\\257\\013Wy\\024?\\256\\007\\025)\\004\\007U\\030-\\242<\\012\\342(\\303\\2157Z[{\\224f\\364hmQ\\031\\300\\332\\225P\\312\\241\\011g\\357\\031ko\\332\\272\\324\\013h\\345\\030#\\265\\215|\\302\\272&\\211\\363hy2\\235\\302$\\011\\223\\033\\367\\340\\371\\214\\2666;a6\\3550\\355\\305(\\320\\022\\273(\\217\\022s\\212\\013m\\300\\305\\335\\202c\\206\\323l\\207/T:\\260\\310\\201\\251\\266\\303\\334ry\\022\\017]D\\270\\331\\320j\\0258\\021\\3731:\\335\\362\\305\\275}}\\360\\335\\3435&^\\210\\003\\315\\300n\\025\\353\\3338pa\\301^\\235\\263\\331\\324HAgp\\204\\035c\\027\\307}"\\333\\365m$7\\2704\\303\\206\\343\\004\\362\\017\\236\\320\\027P(\\274?\\240\\001\\3520\\262\\007\\207dj\\313\\215\\367\\361\\341"\\311\\235\\356"!\\270,\\214\\303i\\216\\313\\300\\362\\306<\\357\\225\\273\\316\\023\\027R\\2740\\362\\177\\251\\222\\015\\3141\\224a\\274:|\\322E\\323\\020\\335\\2170w\\345\\270\\343%\\215&]\\325\\275)\\317\\362K\\240Z\\222\\230\\025\\244y4\\005u\\362\\010\\005\\005&\\024^%\\320T\\027\\241\\367\\332\\271\\015i{\\340<\\006k\\366U\\032\\363u\\266\\241/\\262\\034\\246\\031\\370\\307\\307\\2476\\032\\343y"}\\022\\222`\\305\\342\\034\\321\\264\\225\\271\\213\\246\\344\\267\\007}\\323\\362d<\\355{3m\\344\\360\\304\\037\\254D\\227'\\276\\261\\022_\\360\\304\\0233\\361?)\\355\\373\\367X]\\217\\241\\036\\375\\263\\256F\\346"\\334\\254y\\201\\361o\\017zH\\363\\334,\\345\\333\\227'\\230vh\\245\\035|\\300\\264}^2\\256@OO-kT\\306\\203d~]\\247\\313\\362;j\\315\\214/(\\371\\252o\\232e\\014R\\3220\\3669@v\\025\\2069\\271\\262\\263.%\\234b\\002\\264\\220\\361\\326\\005\\2543\\300\\366\\221\\204\\350\\035Yw'X.\\303\\305\\354\\035\\230M3\\247\\300\\004B\\177\\302\\332#F\\233\\373{\\024\\010\\254\\033\\005\\223\\331\\217wg\\334\\277\\3404\\257\\302`\\326t\\301x\\353\\232t3\\325'\\200!\\344e\\263\\311d[\\374-\\314\\343hqS\\323\\022\\353\\313\\3230\\005=\\321^_\\236\\360\\236\\375\\031\\203S\\244\\204\\331^\\237y\\324ZV\\263\\022\\011\\2229p\\371\\031\\355\\331\\277\\343j\\310(\\203\\214\\\\\\017\\332\\327\\275\\207\\177|\\370;\\206\\277CU\\2738\\231\\322NS\\367\\0124\\217piY>\\250\\341\\227o\\306/\\206\\255\\3431k\\357uC\\332\\257\\377\\343='+\\334O\\255o\\310\\377D\\310s?\\015\\305f\\023\\024I[\\225\\260\\264P\\276UU\\335\\262\\033\\314\\231[\\333\\275\\334G\\345\\261j\\005)'\\256r>\\260\\035\\336.\\331\\341\\376h\\350\\220\\236v\\217\\035\\004\\205\\037\\256O\\341\\001\\247X\\370\\351\\272\\243\\361\\336\\276\\307V\\313\\031\\366\\201\\002\\241\\3144\\203\\201\\327_\\243L\\364\\341=|\\315\\260n2\\035l\\250,\\017\\026S\\364\\340\\212\\325\\337=\\207\\362%\\210\\326q\\232\\230\\000\\331\\323I\\246\\003\\242\\206-\\207\\353\\265x5_t@p\\215\\300k|3_w\\260?\\312\\347e\\260\\010czYv\\342\\3442i\\004\\330\\243\\037#*\\265\\376\\243\\200q0\\011c\\004\\224.6^\\217\\2023/\\342\\302\\002l\\237\\373C\\244\\273\\200\\026}\\214OI\\273\\220MK\\317\\312\\311\\220\\267%\\357N\\220\\016\\363\\021R\\203?5,$\\346N5\\252\\307\\206\\254\\275}\\252m7\\367^\\217\\233\\270eR\\346\\321\\303B\\371\\252\\336cr^\\341f.)\\271\\317I\\012`\\371\\257\\366\\250^\\362T\\017\\007\\224\\207\\012\\305\\213f\\236(\\334\\013\\250t\\334\\212X@\\016\\312\\255r\\027\\342\\350\\245\\261\\266\\301\\201@\\375\\016\\325\\007NkG\\301\\333\\243\\375\\340\\255r\\300`I\\214\\312\\203\\331\\011\\310r}K\\016K^,t5\\304-TN\\344\\015\\036\\262u\\204>\\265\\354&Z\\300z\\003\\367A\\2617\\317\\202\\024\\254hz\\205\\356\\226\\\\.\\302\\011\\251\\226=\\247\\371\\315\\277V`VL\\202\\264\\351\\012\\365\\347\\210\\002.`9\\015\\014N\\322\\306\\376[\\335E8\\353\\250I\\235\\236; \\222`\\266\\344A|\\031\\005\\234`\\026\\006\\351\\364\\012M4 9\\001\\363)\\0159I\\365\\306\\032\\255o\\372\\007\\257\\006\\015VMu\\306\\3350\\207$)\\321\\006d\\003\\260\\266x#\\211\\310,\\265X\\327\\253uS\\324\\253\\330W\\220\\027\\3444]\\341vZ\\370/,\\012\\311\\254b\\213\\202I\\231\\303\\317\\242\\257\\312\\204\\3410\\012@\\210\\214\\035\\255bhH\\370G\\0311\\2254\\240\\320N\\337\\255\\306\\332\\316\\350C\\005\\247V]\\025\\252\\345a\\014\\347\\313\\374Ntn\\345\\020\\317\\303\\271\\317\\005\\276N\\003\\230\\027\\216\\342\\350\\355Q\\006\\252\\006\\230\\021?\\220\\202\\266a\\220\\242:\\327\\017\\264\\234\\237\\241S\\023h\\210>\\030\\315\\030\\014\\013\\316\\241\\032\\023v7U\\311L\\217\\032wg \\272m\\333g\\015\\030\\334*\\247\\315\\306<\\034\\341i]\\336,\\266\\325R8\\333U\\037\\365G\\036\\363 \\006o\\253%\\237Dm?\\221C\\023e\\316\\273%\\232\\320j\\244\\253\\216\\215\\202\\220M.\\232\\210\\332NCZ\\375\\006\\262\\345(31+\\320\\250\\331\\213\\305\\310)\\225\\313_\\014\\227\\007Pi_a\\215\\213U}?\\017"\\323\\317\\204\\2579Zl\\024zB\\317b\\347\\2414P\\322\\213\\351\\353\\227\\007\\007\\347\\001\\252\\034\\277\\311C\\004w\\277\\331\\373\\266\\305^\\264G\\243\\316\\276\\177\\374\\345\\374?\\3567\\017\\377\\331\\364\\000\\266\\337{\\371\\352<\\236]\\235\\243E\\335\\224\\001\\205\\235\\246\\207\\021\\226\\257\\317C,\\355<%\\335m\\031!_X\\033U\\271UZ\\233\\215F\\335q\\033r\\376\\227\\3125\\351C\\217\\300L\\347\\370\\020\\340\\252\\263\\335\\027\\000\\260\\207\\201rJ\\2518X7X\\364\\212z\\213h\\2252{hu=\\014l\\017\\0049\\016\\034\\367\\277\\307\\003\\022\\207\\227\\301\\364\\256\\033\\\\\\007\\267%G\\010,\\207g\\311\\272\\233a\\346\\371,\\234\\254.\\317\\347\\330\\361\\370b\\306\\312MCX\\327f\\37197\\252\\377\\366\\376\\214\\015\\312\\330\\305\\310m\\234\\232\\213\\304]k\\301\\204m\\037\\372\\0256\\362\\217w\\037A\\007\\031\\310b\\246\\207y.\\254\\265\\375\\227\\000\\024v\\247\\250}\\320\\272\\206\\365\\270I\\000\\262\\242\\231o'a\\371\\223\\252\\362\\015\\033]\\204\\303\\240s\\0278\\230\\300XI\\263\\234\\354t\\367~\\002m\\225\\205i\\376#\\037*\\241ge\\213\\0016\\261l\\373\\020[\\234\\333\\270u\\365 }=\\230w\\237\\272\\324p\\261\\332&\\360\\274\\260H\\265\\333\\012\\273\\3279\\217>07T\\015\\301H\\311\\033\\220\\216\\333\\230\\006q\\034\\316\\272]\\241\\313O\\006\\270\\015wB\\003\\354\\237\\277\\375\\372s\\236/\\377\\340\\275\\304\\321\\373k|\\257\\216\\003\\235@I_\\303\\177\\376\\316\\351\\261\\337\\262\\333y|\\320E\\324\\263\\263\\317\\354i8\\3214M\\262\\344"/\\243%S\\027qH\\245<\\240r\\335=)\\324\\351]\\262\\212g\\215E\\2227\\270\\014\\321\\343\\272\\010y\\204*\\257$VM\\252\\271\\223\\242\\330f\\3119J@\\213\\014\\037\\316)\\240\\014\\354\\256\\314\\023a\\375d\\256F\\336\\255\\267\\340!\\246i\\304\\303f\\301P9\\307\\215\\304\\001\\244\\370j\\231\\3468\\3608M\\243e.";\\216U\\002.\\334\\332l\\237N\\015t\\227W\\320\\271\\017e\\026\\254\\230\\216\\371n\\233\\217\\254\\361\\205ly\\234\\362\\201J\\343\\020\\012\\345\\347\\017~\\277p\\3301s}\\037l\\201{d\\005\\376\\200Z\\212\\221\\023\\025\\016\\010UG\\331\\231\\025J\\353)(\\350\\300\\346\\316k\\024\\221\\345\\2646\\011a\\346p\\\\M\\216\\362"\\\\\\322)\\021\\212V&~vt*{\\002G[\\030\\322\\204\\324\\3233\\230{\\270\\365+\\306\\014\\351\\254[\\367>\\210AI8\\354\\344\\177\\237\\374\\223:`\\266Z\\242\\311\\2041p\\003\\333\\203\\204]\\377\\266\\233\\300X\\256hQX\\200Gb\\237K\\017\\026(B\\364S\\275\\010\\207\\012\\010/"\\246\\305\\370\\316$\\027\\315\\177OV\\240\\365\\322d\\015\\232\\2531\\001\\200\\233\\2540\\200\\033y\\32200=P#w\\215U\\026-.\\033\\001,\\354\\203\\270!K\\300\\275\\037X\\205\\177\\015\\343d\\211\\352i\\037c\\020q\\177\\002\\326B\\017\\371\\025\\024\\322\\010\\311\\324\\251\\354\\236\\237\\177?\\305\\376y\\213\\261E\\242\\350\\237C\\234\\313`\\244\\207\\371\\025\\005\\350#L\\203\\265\\251\\2534p\\310\\357\\367\\273}\\020[\\025\\222p\\005v\\316\\356\\3504\\000\\306\\300G\\\\$\\373\\267\\235\\365z\\335\\301\\225AGy\\251P\\372\\017Ut>\\247\\301\\345\\034\\203\\354\\247\\260\\026\\015\\375\\2730\\253+\\020\\363;Xl\\232\\304x\\024!\\351\\250}\\025BI\\026\\024t\\007\\213\\224<\\234^\\005\\213\\313\\342y\\230[\\036\\225w\\212\\000\\273\\376+\\035pb\\251\\2564\\234\\206\\240\\007g\\015\\207\\265\\201\\017\\000^e \\016\\375rF\\226\\214K)i\\230A\\367\\314h\\216pu\\270\\246#\\024\\024\\272\\226\\005\\013\\030\\004B\\211\\316\\255[\\214x4\\300El'\\337\\363\\340\\007\\224D\\200\\014d~\\374\\364\\371O\\241d$3\\276\\177\\2001\\276\\002\\224G@\\330l\\211 \\310z\\244\\0104s\\212\\346\\022 \\356\\330\\230\\334\\265Q\\004cG0k6h\\356\\367\\233a\\232&i\\363\\355{\\3749ll\\025\\031\\227\\250Y\\002\\210\\361h\\037\\210\\275e8\\221Pib\\370N\\202Y\\203\\027L\\335\\336\\232\\026\\016i\\\\\\007\\015u\\346\\001\\000\\270\\334\\220\\001!K9\\271\\300\\324b6\\257\\322O\\300\\016\\364\\363\\206\\257\\372\\373>\\315\\033\\224\\240\\224\\022\\357\\211`\\257\\033)u\\324\\326AD\\243\\021'\\266Y\\010\\353\\260\\260q[m\\032\\254/N\\271N\\312N\\200\\224_\\330\\250\\022\\343\\266R\\305\\221?\\326\\304\\025\\300\\307X\\000\\337>\\223e\\213\\034\\345\\3344\\260t Ys\\215\\232\\255y\\330\\374\\007\\375z\\315\\325B\\246\\374)\\236<\\016\\0035\\223`T\\311\\256\\006\\346Y\\177\\252\\027\\236)\\026h\\235i\\320\\221$Of3r_7\\226\\301e\\210z\\357\\016\\265#\\345\\306Q\\226\\333H\\232\\223?h\\241k`^\\244\\311\\274\\210\\373\\\\#\\2752rF\\264\\317t\\225\\342\\302\\360\\003\\306\\\\\\2053_\\005Q\\313\\366\\013f\\263\\037Wy\\016\\026\\201v\\235\\315\\201\\261\\017Q\\034z\\3312\\014gg\\321\\022l\\224\\313\\337aj\\301\\337wq\\222AN\\200\\374\\234\\221{\\011\\301?\\316p\\237\\344=0\\302\\251\\211\\000\\200{&r\\331\\241x\\360\\230"/\\322\\250$&\\213b\\207\\252P&Je\\207\\262x&\\313\\247$\\316\\011\\032\\353\\222\\027@V\\317\\024\\225$*9_\\177$s[\\363\\347\\233\\036j<\\020C\\213Un\\203!S\\2656v4\\247%\\005\\302t\\327\\321\\014\\026\\311\\007/\\305\\353U\\030]^\\345\\376\\301\\201x\\327\\013\\0126_w\\260;L\\202\\264\\203\\2155!\\036\\310\\374\\242E\\261\\022!G\\204\\345\\206\\231\\014\\363 %g\\351\\324HG\\261\\211\\202&I\\212\\241\\205=\\361\\032\\3049\\207\\223\\222\\024\\351\\344\\205\\250\\314\\241\\315\\013\\354*Y\\222\\372l\\231\\340\\236<F\\354Sf\\262\\230\\332\\307k\\201M\\222&,t2\\316\\277l\\037\\371\\302[\\206\\227\\244\\032\\204\\246\\024\\031h\\274\\267k\\005\\364\\267Z*\\243\\013\\023\\341\\364\\346\\204\\212\\262\\201\\360\\014\\251\\221\\3510\\334\\000\\004ivY\\333\\252\\224\\336\\027j\\354_z\\315N\\323u\\213\\373m\\003\\336\\352\\326\\342\\207j[\\263\\000\\232\\257O!yy\\306\\333\\260\\250\\345D\\323\\326\\257G\\005\\200X\\213\\212\\267b\\024>Q\\0029M\\022<\\201\\371\\310\\332\\022\\001\\241\\012\\201$)\\361\\324\\246\\245M\\233\\302\\222\\004\\010n\\032\\361\\006\\237E\\031\\010\\352\\016\\244\\274\\300sz\\342\\010\\201*\\231\\357\\351B5[\\255r\\232\\030\\027\\177\\240i\\342bL\\227I]\\002\\201u\\222\\346*\\366\\274p\\350\\300\\016R\\261\\225\\207i_\\357\\224G\\257#D\\350YX\\334\\240.\\222}\\267\\312\\362d^G|+\\355\\022*/\\241\\262\\207\\350!ax3\\352\\265\\246y\\246\\331\\036\\013 K9\\022.\\026\\344O?\\225\\342,\\300\\331\\252\\035\\206\\220\\235\\320E\\237\\034\\366\\026\\373\\024\\030\\230^\\321\\005F\\236\\261\\315\\246\\200\\000z\\307g\\353\\345\\031o\\313>se\\310\\245N\\261\\031r\\030\\030\\304\\3012[a@\\233Je\\036F\\005\\206\\206\\332^\\206id\\352fH\\301\\365\\201R\\342\\017z3\\207F\\001\\357\\333\\330\\263U\\307\\303\\201N\\021\\255\\367"\\327\\267\\231\\027\\366\\035\\242c\\356s\\006\\220$Hx\\024\\213G\\246I\\030\\363\\351-;%\\276\\205w\\313\\344\\351\\351\\003\\344\\336D\\223\\017\\202+\\003\\271\\220\\323\\315\\246\\260<\\210\\317\\022q\\036\\013\\272\\332)\\245\\370\\217c(\\253\\\\\\201\\242;\\252\\226\\016fjdX\\202q\\231t)V[\\030k)-C\\266\\327\\024@\\205\\340|\\002\\247\\3762\\240\\230\\020\\336?@C\\343\\026\\0214\\270\\312\\366E?\\331i\\013\\324\\266\\354\\0274A\\012\\371\\267Z\\034\\003\\355'\\322+\\346\\012\\226b\\234p\\021\\300\\361|\\371`D,,0B\\200\\37446\\031\\207a$p0\\305\\031\\317\\353(D\\021\\256(8\\222ju\\240\\221\\337\\343f\\307\\026TU\\022\\227\\023_\\323\\377\\327\\372\\300\\3430\\276j\\332A]\\007\\250ir\\023S\\257\\350D/\\260\\025\\372fS\\235\\016\\312\\243'\\316\\011\\221\\226\\340]L\\301\\252\\316U\\325\\2672$\\3609\\311\\374j\\322\\334\\341\\273\\230UB@K\\250N'3yT6?-\\211\\3012\\222\\276\\307\\211\\270\\225]\\322B\\256%\\325\\363$1\\267-zn\\251\\343\\266\\353\\220y\\361\\236\\235-;\\214\\321\\333\\225\\232+\\312X\\226-\\213\\226\\263Y\\225T\\352\\200\\333v\\257\\226K\\343g\\025X\\240\\321.\\364\\376j~D\\342N\\261u\\037J\\235\\304\\327=\\010\\246t\\2716\\256h4\\276Y\\300yq\\357e7\\320S\\315@\\351o>_\\313\\256-\\331\\307\\021|\\222;vm:}\\234&\\033\\314 (\\362\\255nP\\304\\031\\250\\346Gd\\364\\002(O0\\325\\204,\\211\\244\\264H\\016Er\\255\\371hN\\300|\\264(1m\\301\\341\\322\\313\\223\\245@\\302b>`\\020b-\\216\\234c\\271Q)\\341[-\\301`\\253e\\350"\\024\\241|\\343\\335\\330\\275\\027pF+\\026@\\006\\017\\260\\334\\3749X\\314\\3420U\\364\\361\\346\\010<\\243b\\034\\377\\001\\271\\333\\210~\\2114\\235:y\\030\\\\%\\311\\015\\035\\266q\\030.\\224\\231gI\\332-\\347\\333\\226|\\005\\200\\301Da\\355\\374\\364\\366y\\256\\250w%\\202v\\343i\\177\\320\\202\\353IqZ9\\214\\347\\352\\002\\037<\\241\\002\\213BA\\230\\023\\212\\347\\366\\3313\\351p\\203\\014\\351|\\263\\355Ab\\230\\374\\252\\004\\002\\017\\233\\015\\343\\247\\26598\\206\\340*k\\011\\254S\\235*BvTy\\032\\307\\307\\240V\\236\\315\\355Y\\273LI\\322\\300-\\310\\032x!zR0\\350\\247\\240f\\3028\\245p\\201\\301\\367\\265Y\\342\\204\\031\\363\\204\\350\\244\\347[\\016}\\215\\230\\347\\301\\364\\212pMr:\\025\\226\\230\\234\\004^wbt\\014\\325&\\204J]\\261\\316\\234\\027>\\005\\262\\2701\\036\\204\\002\\350\\260{&ig\\025uP\\012"\\227w\\005\\376,#\\326p\\373]&\\361\\235\\363\\256\\210\\003\\372\\007W,\\372\\2206H\\341I\\220\\334\\014\\020\\223o}g\\267H\\361\\301&%\\364\\360\\227w\\223\\361y\\022\\345Y\\255\\263\\212\\242\\331?\\277\\253\\272V\\245\\320k\\345\\262+;\\247;j\\374}\\372\\331\\247\\273\\014\\034I\\007\\026\\246\\273\\373t+\\316&[&\\311E\\230n\\344\\245?\\243\\375\\357G\\335^\\021\\336 \\313\\203\\270\\375b\\3029$\\310D~M\\316\\271\\274cB\\203\\3620\\371R\\302\\371<\\230\\332\\233\\344\\202\\002\\277`Cr!\\257\\2500\\256\\342\\301kFfmw\\237\\272\\210\\211\\244D\\2479Vd\\324\\276\\235y\\247\\017\\214\\275N\\037\\326\\216% ! \\276\\305W\\222\\003U[\\275\\031\\370;\\212\\000G\\311x\\011\\203j\\021\\251C\\036f\\035(\\360\\262$\\2742\\207\\362\\360\\301\\256\\377x\\025\\354:\\030\\342WoU\\00408\\237\\223\\177\\320\\310\\027\\027\\007\\376\\276\\010\\252\\037\\355\\017\\017:o\\306\\233\\271\\274|k\\264\\377\\262\\256\\017\\001\\336\\371du\\231\\031\\310\\007[\\372\\033\\202\\013!\\303c\\025w\\225\\002\\026\\230\\267\\375\\376\\026L\\310-a\\321\\222\\311/\\274\\237\\343\\311I\\324j\\245\\2147\\257e\\022\\275\\177\\307\\253f&}_Nz\\363\\232\\247\\251\\245s\\2315q:e\\227\\366\\225\\213\\334\\221\\311\\366\\030\\213\\224\\012\\003]{l\\321\\235\\367\\211\\202d\\213\\270U\\210O\\301\\203\\332\\357\\323\\023\\014\\3047\\243\\356\\3605v\\202a\\037\\376\\305\\333c\\306n]\\273\\232\\262*U`P!=\\233S\\250\\225\\301\\302\\240J\\264&[\\257\\313|\\250~\\034~Wh\\212}\\274#\\254A\\267\\337\\214\\357\\373\\336\\303\\020\\324!>\\366\\274\\007 CA\\257\\212\\314\\256\\277\\303/@4\\256\\227\\341\\261Q\\335\\275\\276{\\344\\177\\327\\305\\030DY\\0047\\264\\327r\\332Y\\204\\277/pn\\370\\031,-c\\377\\001\\255\\025Y!\\312\\377\\200SB\\246:\\201\\231\\210'\\352$A\\230\\347\\014zj\\036A;\\216\\200\\371\\212\\300.\\026glMmh\\276\\210\\231v\\354+\\002b9\\244\\336\\351d\\255\\352\\021s\\334y\\022\\221\\027\\306\\036\\302\\2450\\317D\\220\\006\\345\\267\\3311w\\271W\\206\\000 \\216\\355\\251\\306s\\016\\205C\\015\\021?\\325`\\237~\\210\\370\\361\\2076k\\211X\\2164X\\267\\246d\\302\\321\\251\\205\\353\\340k\\220\\021\\007Lz\\263M\\266\\201\\013\\014\\3530\\266Gh\\346\\236\\361\\334\\314\\277\\257\\254,`\\351\\372R<?\\036G6\\021\\207\\220:.\\304\\350\\225\\001x\\357x\\344,\\006g\\036\\017cd\\326M\\011`\\3542:LP\\312\\311\\371\\316}\\261\\376\\356\\340\\0217 \\306\\255\\263m\\347(\\006Ei\\250c \\305\\346\\267E\\255\\300P\\334F\\217\\250n\\262i\\226\\265\\236\\337W\\334z\\346\\212\\315\\305C\\001y\\037\\215\\353\\004\\277\\303\\350\\204\\210;\\210K\\207`\\342\\362!\\230\\230\\316l\\340\\221\\016:g\\301\\351\\307]z\\360\\351\\337\\307N\\261\\324H?V\\322\\217u\\005\\005\\300\\351i\\3255\\257\\377\\377\\216\\365\\374\\267\\236\\352yRo\\324\\013\\015\\342\\015o\\235)\\354\\013` =\\2364L\\026\\311\\004\\224\\030\\337\\3271f"\\334f,\\367QE\\255\\015\\032\\247\\2154\\340\\201\\356I\\375\\356\\003]\\360\\206R3VQ\\306\\254\\365\\\\\\202\\337\\327\\023\\024\\323\\332s)\\276\\251\\244(-\\260gP\\373\\360\\341\\300"\\205\\353:\\266\\276\\374\\021Z\\364\\346\\003\\256\\2102<\\271\\310\\373d\\253%\\215\\\\3\\337tK\\347\\311rWX\\033j^\\2034\\025p\\345+\\005\\314\\337\\241<\\3510\\272J\\326g\\311\\364,\\271\\274,]\\205[\\323\\317\\304\\340\\206\\021\\3743\\277j\\246\\316\\371\\260\\303\\362d*\\217\\301\\220O\\3416\\242\\340+<I\\262m\\023\\023y\\021\\032\\002\\347X]\\324fc\\222\\260\\035\\020\\011\\350\\347\\364t\\031,\\352\\307(d\\002I\\005hn\\234#\\247T.\\217\\271\\345\\3176\\237\\005j\\264\\243\\243\\300(t\\327\\340\\334\\3142\\212\\241\\015\\357E\\020[\\371\\244\\336\\3307l@W\\332D\\323\\033\\351\\271\\3220\\306\\2155_A_\\360\\014h7}8\\363&\\212\\343\\367_s\\312\\307e\\264A\\377)\\272C/\\257\\347\\331%(\\210h\\026\\202HH\\367ky=\\205\\020\\033\\262Z\\034\\315\\323\\263\\251\\216\\221\\252\\356\\010OCjlAR\\345\\273\\342r\\003\\274F\\012\\335\\376\\205\\233\\245\\324\\012\\242)d\\3427\\251W*\\204\\267\\270F,"\\011o\\257\\002j\\377@WaX\\015g\\270my\\344\\035i}\\335\\320\\261\\267\\010\\327j\\0177\\214y0\\031O0\\337|\\001f8\\236b#\\312\\273\\325\\262^i\\267\\366\\357\\302\\217Z\\235\\241\\011*\\006E\\357\\362\\355n\\010\\377\\370\\360\\267\\263\\331\\0100\\362S\\2517rm\\031\\361}\\000Z\\270\\212\\310-\\270\\260\\312\\020 'L\\314@\\233}N\\023\\260O\\002\\256\\237\\304\\304\\210yS<\\221\\030\\377\\270\\232L\\224\\363\\275\\020\\204\\2414\\242\\020~9\\256bJ\\027\\247mQIS\\241\\302\\260\\003l\\007\\253\\231r\\361\\270\\222\\274\\357\\261J\\273<\\246\\005\\2016\\036\\340\\221\\210\\370<\\265\\303+|\\025^\\241\\273\\223\\251Bj\\207\\370\\240L\\212Q\\330-\\033\\024\\372\\265\\257\\006A\\2579\\020R+hQ&/\\346x\\012\\0178\\373\\324\\363@\\265\\251g\\241_\\307\\0026\\022\\000\\315\\302\\005\\253\\353\\012V<\\007\\256\\372Tz)\\026\\303\\310\\345\\307\\202\\377m\\225\\300\\342\\267\\312<\\264\\217\\0247Y\\323k^\\202\\266\\310\\2455\\247L\\3534\\364\\232\\243\\021k\\242\\366\\266PF\\243\\305#H\\213\\246>\\217o\\260\\2031\\246\\342<\\344C\\025\\273\\024\\203\\372(\\313\\254\\305\\266\\224\\276\\323l\\005\\363\\345\\240\\3045kn\\303j\\266\\376\\005\\034T`\\035m\\307\\212\\253p\\336n\\307\\271\\0248\\342\\002$Taz\\360\\327\\337@\\301\\003\\344\\204\\003\\004\\225\\3643..Q~\\276Z<\\313/X}1\\211q-\\210\\345\\011m\\265\\014W\\250\\355\\342\\3447\\217<\\353\\306\\221\\002iG\\275o6\\265.\\312N\\277*\\323\\270F\\204\\034j\\2170b\\213\\013\\254\\345zx\\353B\\220\\232\\246\\343\\207\\236\\375'\\037}\\227]\\240\\346\\300\\243\\036\\026\\372\\310:\\212\\313>\\015\\217\\232\\030\\343\\350A\\335@\\003\\340\\215\\377\\352l:\\336P\\317O\\246\\363':\\227\\2167\\340\\323\\251tV\\270\\244\\311&TA\\274vN\\2601)F\\014}#f\\252{_w\\252\\323\\002\\253\\231\\243\\350\\374\\374\\303\\303N\\035\\215GV\\225\\352d\\375_\\304/\\035\\270/\\\\/%\\332\\303\\212\\253\\343[\\225DJ\\335A\\200\\327>\\3113\\371"\\257p\\023\\246q6\\237N\\346?\\377D\\376\\226\\203\\370\\333\\017\\340K\\206\\262\\012\\206\\344A|\\355\\214\\260\\016\\337\\033\\216\\240\\347\\236\\275'U\\237$ym\\3372\\317\\216\\357"d\\305!\\330U\\234\\371\\230\\265\\305\\302\\341\\237\\244\\200"\\221\\016\\300\\033\\373\\213\\230\\352C\\022\\005\\276\\221\\211@)u\\313+E\\015\\246vY\\032\\331\\251\\374p\\225\\3355\\210+\\355V\\227=\\244\\335\\216h(\\027\\262\\241\\177\\220\\261{F\\207|\\372xQ~\\241\\2102\\002_\\241\\027\\001[\\255b\\212\\016\\206\\024\\233k\\263\\350\\353~\\344\\226\\313\\260\\026#\\324HB*TvE\\346\\203\\324I\\205\\226\\341\\274*\\003\\310~U\\375ug\\337\\371\\262i\\270\\346\\221w\\247\\261\\331s\\367\\275\\346\\336ASH\\372\\261\\345n\\374\\324\\325\\2448\\364\\031\\253\\325\\255\\272u%{\\302\\002=+\\256\\012\\371\\201tjn<\\236_\\207\\036\\343\\361f~\\370\\336\\364j\\321\\032O\\234\\315\\347a\\3553?\\232\\025\\217\\344\\023\\257\\366\\240\\254<\\231\\377\\364\\203\\371\\025\\024\\237z>\\277N\\201\\322\\211\\3234\\015\\356\\270H\\236tH\\237w\\031J\\266\\316\\002\\243(\\264\\2060\\206\\244\\035\\254\\316\\317\\326K\\2373\\274i\\223\\012\\324\\300G\\265\\0105\\326\\255f\\314qh\\335J/\\015\\327\\330\\214c \\220\\212K\\367\\005\\024,R\\345`\\245\\245\\254\\255\\311\\361xQ'\\203\\016\\335\\241\\370\\035\\332U\\265\\242\\300\\037\\307\\220\\245`\\247\\025\\007\\364Ll#YB\\032\\013q\\015\\247\\022EXoN7$\\222o!\\203i\\310\\334\\365\\343\\316\\361\\251\\322S\\2662\\213\\305\\327d\\370m%SK]\\361{K\\032\\375C<\\331\\357\\347\\030\\224\\240\\333\\200`w\\300*\\230\\240\\227\\220\\356\\037i\\274\\344\\220\\232\\012\\255\\360\\005\\204\\2722\\001`\\014K90\\226<\\001t\\314\\334h\\335Y\\202\\307G\\014\\307\\005\\277\\204\\015\\326C\\245\\023?\\250\\361\\324\\267\\300J\\271\\031FG\\275\\333\\362q5\\367\\336 \\016\\014Y\\344\\324'\\326\\310\\346x4\\010[X&\\344`\\023$LG[\\346p2\\306\\332\\251\\016\\3228\\275D(<FSD\\007\\362G\\372\\201\\226\\244n\\000u\\216\\262+\\036\\334\\330>x\\335CE\\304\\323\\336r\\002\\352 \\205\\200\\264RM\\023\\210H@\\367\\340p\\332\\372\\231N\\004\\016\\316R\\310\\306t"\\242\\253\\304C1$\\212I\\271\\262\\315\\006}dm\\200S\\023\\006\\236@t\\265\\241\\337\\260\\256\\335k\\310\\375s\\214\\370\\211\\026\\362\\212bP\\026\\276n+\\311\\272N\\031\\002\\300\\330\\237N\\006\\323\\011\\247\\354CB\\311\\3319\\235x\\323\\012\\211\\363\\341\\311+}T\\020\\031\\364\\241\\263h\\036&+\\353\\336\\351G\\032\\331\\343\\264\\360\\262#<\\3209x(uf\\023\\313\\320k\\226Z+\\250,\\025\\203C\\276+byW\\177\\304o\\263\\261:\\257\\324PV\\242\\270\\221\\023\\244c\\237\\014\\022\\002\\246\\363\\267\\034H|roG\\3073{\\262O\\250+?\\201\\314\\221I^\\366J\\235\\335\\356\\017D\\2173\\341\\344~\\023\\001[\\031\\002X\\023\\300\\017:\\224{\\247/X!\\323\\313\\350\\002\\240}\\004\\337\\276\\254\\015\\315\\311o\\011Q\\235E\\2611\\222\\2058\\222l\\235\\010\\256\\206!\\207\\352\\223$jL_ZU\\274S\\006\\224j\\360\\344}<\\207\\341\\235\\012-\\342%\\012F\\254\\332\\2024\\375\\203\\010K2\\276\\236\\237\\315s\\315H\\250\\246\\264\\302agA\\365S\\200\\227Jp\\332\\376\\026l\\307d\\211v\\025\\025\\267@\\367\\205\\236J\\0134u\\303]\\201\\236\\272:*d\\313\\021|%\\356\\356-d\\017\\257\\306\\325\\021\\236\\276\\257\\313/|\\021\\352\\276$\\253a)EEH\\224\\313\\3233U\\011\\213\\217\\020HV\\215P\\224B\\253E"\\014\\360\\362\\012\\371tX\\226\\252\\234,4679\\251D\\364>iYW\\267s\\303h\\015\\363P\\272=\\273\\033@\\326B\\266\\242\\230\\341NE\\242\\222\\222\\3516\\004\\333~4\\312\\334f\\333\\240\\216\\203C\\237J\\351\\340\\011E\\274\\202\\310m7\\035\\376\\001\\303\\246+O\\271W\\225\\375_)\\372\\361ri\\303N\\306\\023\\323%7\\277\\341r)\\314N\\214\\265\\3355\\010\\354\\372\\310hZ)\\260k\\024\\230D\\367\\015\\200\\341\\365x`P\\342\\273\\001\\222\\334\\015\\220\\2739\\252\\257\\327\\340F\\364\\367\\335*y\\334\\214y\\310\\223,VO\\231\\320\\273\\3152\\271\\247Y\\032Xx#\\217\\316|\\3368P\\002\\222\\275\\337)\\301\\032\\026K\\032\\316\\242\\024z\\334Y\\362\\001o\\207@\\311\\350\\233`D\\012\\3270\\3423k\\025\\241\\257b\\315z\\202q\\234\\377\\010'\\277\\024\\002BE$(\\035\\355\\242\\334\\277W\\177[\\256?\\226\\361\\243\\032\\346\\350\\325AOo\\330>T]\\012\\022\\300\\374B\\327oU\\346\\310:\\010_-\\205\\341\\322d\\257\\303\\257\\012_\\237\\250.@\\313b{1t\\037\\2426\\016\\300\\326\\246\\203\\273\\347\\3645\\036sO\\177\\232\\314\\347\\311b\\237r\\263}VBX-a\\005\\004\\353\\015x\\350^F\\027\\012`GA\\340\\247I\\004\\014>ZP\\012\\010wC\\004\\020>\\026\\201\\302U\\232,C\\274\\316\\020\\354\\204\\365\\245X\\261\\374*\\256\\237\\007\\253\\017wC4x\\020\\323Ft\\036\\236\\247\\311\\372\\034/>L3;d\\030\\200\\370]\\352\\347\\352\\306\\220\\363\\234n\\213'\\343\\273\\004E\\367\\205Yy\\310+"dt!Cq\\323-\\232\\001"\\014I~x\\000\\301\\374\\232YN\\032\\367x,\\037/`\\367\\230\\244\\314\\\\5\\272sT\\257yt\\304I\\251\\323A\\362\\376\\371]\\236>\\314A+\\242#\\300x\\265\\227\\350xc\\237\\242\\317+|\\036\\315\\316Y\\233\\370u\\321\\260\\301\\207\\301\\003\\324|\\016\\253\\243S\\001\\352h\\212\\246MY\\2002\\317\\354\\322\\025\\375|\\215\\220f\\371\\037\\311\\232\\237\\205\\200\\344.\\336}\\203' \\344\\263\\341FS0t\\307\\213\\004\\242\\227"\\250\\244\\353\\027a\\2065H\\235\\276t\\315\\025P\\011\\251'\\234`\\2732\\3238DbMq2\\277;\\015\\3438+\\271k1\\325\\267a\\304\\322\\205\\257F \\241~=\\262Z\\310\\266i\\310K\\242\\366\\034D1.\\216\\014\\032\\344sj~\\323\\224\\367\\255 \\316\\025]\\211\\323\\204\\022\\230\\274i\\240\\011\\255\\223\\206\\230y\\306\\233\\220>\\200d\\355\\0306\\337\\002<\\335\\377h\\322\\002=\\234\\254yV4\\277l\\340\\205\\011M\\326\\266TD{\\307\\032\\271m\\326l\\340}\\011\\315\\326\\014\\220\\007\\315}}\\235d\\360V\\006\\000\\325\\214K\\350\\255F\\206\\3509v\\037\\253w\\305\\210\\332X~\\002H\\037\\230\\330\\206\\0144r\\214\\0016\\312e\\027\\363\\033H+\\326\\326\\334i\\247\\266\\266g\\004\\252\\035P<5\\365\\363Y1\\221o\\240`\\006\\266\\337G2\\324\\2252\\200\\251\\333\\204\\347_\\001\\241\\234VkW\\216\\000\\316\\202\\032\\003\\3256\\251P\\032\\256\\030\\363\\242G\\033\\264\\037\\224z(\\2340*\\214\\276#\\277o\\003\\324*H\\271\\300\\313\\271\\346\\263\\277\\037\\341\\010\\363\\007(\\363\\203\\217O\\034\\317\\307\\275\\303>\\267H\\361`\\015\\014\\235\\314'o\\202\\242\\343\\367\\024\\366\\217\\311,\\012\\313\\037.63\\255a))\\266}\\013\\206LH\\315\\003\\325Z\\202\\036\\225\\344\\343*N\\372\\274\\206Q>\\267?\\022"\\001\\024/&q\\365\\245\\020\\255qp\\321h\\250\\220\\267\\274\\307\\240\\027w^\\362}U\\240\\0159<\\032#\\200\\000\\177\\332.\\3752\\034e\\243\\333\\2407n\\343w\\321\\255\\017%\\211\\364=\\312\\3407\\247\\314w\\311,\\2216\\035\\367\\357\\301\\210\\271X\\3708\\312iN\\276\\304\\023a\\321\\224\\337\\245\\007\\344\\322\\004\\275\\266I\\212\\214\\032=\\222"\\342\\277\\214f\\243\\331p\\264\\337mt\\306\\370\\271\\361\\223\\316\\377\\031\\337\\277|\\020)\\230\\211\\377\\355\\211 {(\\037\\277\\250[\\240\\311\\035\\3048\\257\\374\\022\\336\\351\\375UM\\233\\023\\322O\\377\\003$\\377\\0329\\347\\2133\\354\\214V\\007\\007\\375\\203q\\343\\205{L_\\262\\012^\\356AR/\\230\\322\\313+\\372\\367\\365xC\\277\\007{\\356\\326\\202\\370\\211\\262\\351]Ea\\005\\363d\\033\\025}\\344@\\214\\317\\020w\\332C\\2376\\020\\012>dlq\\260\\266q\\006bh\\261\\311\\215\\257pM\\343\\322\\\\\\036\\012'M\\036MKYz\\235\\243\\006\\306u\\305\\300\\270\\226\\023gj\\317\\307\\327z\\316L\\351L\\333S\\246\\314\\243\\036\\247u\\023\\336\\361 \\343\\3020J\\325\\224\\254\\007\\317\\205#\\241}\\355\\307u\\357e\\242\\374\\034V\\022\\317H\\211\\373\\216\\020\\335q\\347\\372\\360\\332-\\214\\210p\\346\\233\\222\\227\\244\\237?4\\335\\201\\020\\367P\\374Z\\313S.c\\250\\215g\\026\\355I\\036]\\355\\350\\022-3\\324\\217\\025\\204v\\220\\022\\377\\322\\316uG\\266\\026\\316\\301\\262l\\024\\261\\303u\\202r\\033$k\\214\\272!\\035\\315\\005B\\313?\\236\\352o\\261\\034\\254uA\\331p`\\262\\342]A\\326\\021[fYe\\037\\305\\213\\377\\325\\305\\333\\317+\\177\\265\\324\\245\\257T\\351[\\313\\022\\243\\241`\\021\\226d\\253\\255A\\354\\324F+\\200!\\250D\\212\\227#\\206\\330\\206\\303\\203\\261\\327\\363\\340\\241D\\330nz5\\207\\320\\240\\220\\335#\\302\\357,\\327\\017\\017\\344}\\222\\344y2W\\026\\245=\\011\\026\\242\\344-\\262n\\351~\\241\\377n\\216v\\377\\002G\\322j\\253]Q\\345\\251\\307\\3556\\261\\324\\301^a\\254\\245D\\243!\\005\\253\\036\\224\\202\\323\\253y\\255\\341\\343\\335\\250\\332\\376\\005\\255A=I\\323\\262\\206\\314_\\267\\205\\313&W!\\256\\235\\273\\353v\\360\\216[\\374\\276G\\236\\244\\005p\\323\\267\\277\\3318\\265\\200 ntX\\264Z\\353\\313\\237\\312\\037\\012\\203^K\\356\\014\\361Ec\\004x\\307\\227\\020x\\026\\316\\353\\216\\233\\203z\\023\\322\\370\\310\\367}=\\224\\370:o\\220M#~go\\035\\2334\\230r\\2479\\312\\345^?^\\236J_\\376\\252G\\353\\333hv\\357\\2402\\255\\336Q\\313\\346P\\025F\\237\\237#L\\012\\251\\220|W\\011\\257\\300\\263\\311o\\025\\370\\3778\\257\\252\\0151\\366\\253\\007\\003\\247\\017\\177\\007\\360\\367\\022\\376^\\301\\337k\\370\\373\\016\\376\\276\\207\\277\\037\\340\\357\\015\\374\\341\\177\\243Q\\227\\361\\265\\321<\\270%\\326\\371WD\\301J\\226\\\\\\022]\\372\\200_\\035[\\356=/\\233\\337vH\\317\\346\\304\\010\\377\\333\\033\\275\\030\\265G\\307\\243\\356\\310\\031\\271\\243\\315\\350~\\3640\\032\\216\\306\\243\\316x_\\037\\036P\\337h\\006\\256X;\\033<\\270\\374\\266 \\242'\\214l\\233K\\367\\276\\300\\265\\011\\313W\\2556\\000~\\374\\246\\320\\3371(J\\260/>4\\355\\361W\\227\\007M\\250\\013\\265L\\034\\247\\200\\2631\\220\\\\\\274\\363\\244\\344y2\\234\\322_\\234f{\\2479\\354\\264\\205\\231yL\\247Oi\\330\\215_8xO>\\177t\\217\\235\\3675P\\356q\\263\\335\\334\\300\\237\\221\\337lk\\016\\333\\315\\366\\267\\010\\342\\3565\\275f\\324\\264\\027\\324\\206\\301\\357\\227\\205\\337\\310\\012w\\014\\230\\250\\226\\325l\\354\\273\\313\\217\\234\\342\\203\\372lB\\277\\257\\342\\004(\\235\\337\\032\\343\\274\\364^\\272\\305\\015\\030\\372\\032\\3115\\250|\\372r\\310<Y\\3407\\305{}f\\004\\013\\260\\213pbg\\037X\\331\\363 \\265\\263_Z\\331\\301\\262\\220\\375\\252\\200}gg\\277\\266\\262\\257W\\005\\326\\276+d\\307v\\366\\367v\\331\\253K;\\373\\007+;\\013\\227v\\366\\033+;\\231\\346Vv\\277ge/\\222\\257v\\266-\\265Y8\\265\\263\\225\\324\\344\\246\\225\\3316\\337{\\257\\3346A\\266\\315\\344\\236w`\\034(\\263\\033Yx\\375\\012>^\\371)\\307\\2122\\276\\3032\\212\\324\\333v\\017\\221\\305=\\011\\377e\\021\\237\\263[\\315\\357\\017\\\\\\001\\334\\245\\276M\\363\\200\\1774Rn\\025\\334\\245\\356\\321k\\250\\032\\300\\261\\203\\036k\\337\\245\\202!L\\350\\277\\341\\011U\\365\\246[V$\\333wi{\\347\\011\\234\\2325\\005\\224'\\310F~'\\267'\\376\\307\\254Q\\252\\027\\213\\326\\370\\246(\\020\\305[o\\273\\233hW\\266\\240X:~Z\\241\\273\\304\\233\\252ia\\011\\223\\327\\362H\\231`K\\234\\270\\246~&\\017\\027-\\3719\\244G\\346\\015N\\230b\\205jf\\274\\251\\212\\307\\024\\240S\\250=\\255T?\\241\\237\\233\\270\\003\\326\\214#\\371\\306\\006\\337\\320k\\214\\371\\205w*\\255\\311\\325e\\323c\\035\\035\\314\\353D`y~\\302/\\333\\272\\307\\235\\217\\013\\214\\022\\310\\357\\016\\311\\243n\\312\\265\\264\\224\\257R\\237\\226\\374-f\\276\\010\\277\\002\\250\\360\\256'\\370\\262\\0130}5\\232v\\340M\\364^9\\330\\022G\\023\\370\\347\\270\\323?\\304\\227\\267\\364\\202\\317\\007\\343\\316\\004\\376\\261\\010*[\\264\\322\\265O\\217\\334j\\027K\\367\\232["\\3717<\\006\\025\\016\\273\\012w\\235\\242L.\\005\\003\\012m\\363\\232\\002R\\346\\0266V\\025\\205\\222\\243\\001V\\3114\\307I\\246\\377\\340\\356\\006#\\254\\224\\333Z\\270n\\221\\216\\017\\035@a\\270\\374\\370\\226\\253&W\\334i\\3259\\303\\233\\361.\\231\\322\\305$\\014\\250\\201\\344\\235bz2\\303\\270\\033\\263\\340\\266o\\301\\264\\371\\325h\\325\\025\\360-D\\347\\372\\333\\003\\337\\357\\035\\363\\302\\0169ms\\363\\357:\\373-3\\276\\0363\\017\\263\\014\\0266\\236\\336\\002\\026wAT\\306VW\\335\\277+(\\374\\024}\\255?\\0016_w\\256\\263\\216\\200\\024Ga5\\036~\\026\\270L\\243\\362C-\\346Q\\336b!\\342\\024\\203\\372\\200\\250q\\224\\261\\014*`\\214\\273\\035ka\\354XS\\315\\252\\367\\004\\324\\322\\027j\\032\\333k\\3608\\353\\352#\\252[X\\327\\337c}6\\353\\032\\265\\374q\\235\\302e\\304\\232\\\\\\325\\276c\\261\\311M\\350\\312\\363yt\\325\\215\\352\\204\\265\\304\\011\\246H\\277\\303\\332\\032\\327\\014\\310\\025\\371\\276\\031\\304\\3027`\\214\\002\\256\\202\\354\\235\\212hE\\003\\323\\310\\023_Y\\343\\237\\372\\321\\311\\226p\\214t\\323\\227\\261#\\322\\325\\347n5\\230v\\024\\210\\304\\332\\033\\222\\221\\347\\323%\\301\\233\\233a\\324b\\37096\\261\\255\\305\\001\\266_\\300.\\240\\350x7HO\\274vp;X\\345\\241\\367\\243> @B\\321~\\275|AW\\210|\\026\\367qt\\273]jOy@\\004C\\263O\\243I\\034-.\\361\\244.O\\324\\333Vv/\\025\\264\\274*dyT\\266L\\302\\016\\223'\\012\\246/\\2057cI\\220\\265\\002\\254P`\\246\\274x\\204\\232(\\346^\\326\\336`\\307\\3546U\\354\\254\\026U\\027\\362\\210\\253\\012\\314kx6\\233\\335:}Q\\251$\\364D\\351\\352\\035\\276\\302\\205B\\324\\307j\\343\\362q\\273oP\\023\\322\\014\\013<\\376\\2314\\305\\223\\313\\277\\251\\342\\330\\001\\022\\305\\331\\277\\342\\366 >\\375[w\\014Ec\\353\\336 }\\357e\\271\\347\\363\\013\\007\\275+\\021X{ot\\266\\212[\\017kr\\034\\233\\012w\\212\\233\\227\\036J<\\353\\316\\303r\\342\\016\\336y\\310\\332\\005\\236\\214\\232\\250\\0133\\355\\273\\227(\\024\\323\\270\\204\\311\\270\\350\\223#z\\025Pv\\\\wux\\257\\020\\222\\222\\216y\\203\\250\\310c\\0246\\300\\014n\\355\\241RK\\224g[\\222\\267\\020kd_\\221\\351\\330\\244J\\342\\227\\267a\\205\\025\\3227\\022\\271\\360\\013lU\\336sj\\215:\\276\\037\\032\\026\\256wQ\\267=U(\\301\\217\\357\\3715'\\327t\\313\\211u\\333\\210\\243\\256wl\\212s\\340\\315Czjz\\362\\2147$\\340\\023~\\250\\2449\\370\\177	2038-01-18 19:14:07-08
talkbox:messages:individual:Userlogin	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:58-08
talkbox:messages:individual:Userlogin-summary	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:58-08
talkbox:messages:individual:Nologinlink	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:58-08
talkbox:messages:individual:Nologin	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:58-08
talkbox:messages:individual:Loginstart	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:58-08
talkbox:messages:individual:Login	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:58-08
talkbox:messages:individual:Loginprompt	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:58-08
talkbox:messages:individual:Yourname	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:58-08
talkbox:messages:individual:Yourpassword	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:58-08
talkbox:messages:individual:Remembermypassword	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Mailmypassword	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Loginend	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Anontalk	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Nstab-special	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Tooltip-ca-special	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Accesskey-ca-special	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Tooltip-pt-anonuserpage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Accesskey-pt-anonuserpage	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Tooltip-pt-anontalk	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Accesskey-pt-anontalk	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Tooltip-pt-anonlogin	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Accesskey-pt-anonlogin	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:50:59-08
talkbox:messages:individual:Double-redirect-fixer	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:13-08
talkbox:messages:individual:Usermessage-editor	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:13-08
talkbox:messages:individual:Proxyblocker	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:13-08
talkbox:messages:individual:Nosuchuser	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:13-08
talkbox:messages:individual:Loginerror	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:13-08
talkbox:messages:individual:Gotaccountlink	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:22-08
talkbox:messages:individual:Gotaccount	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:22-08
talkbox:messages:individual:Signupstart	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:22-08
talkbox:messages:individual:Createaccount	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:22-08
talkbox:messages:individual:Yourpasswordagain	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:22-08
talkbox:messages:individual:Youremail	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:22-08
talkbox:messages:individual:Prefs-help-email	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:22-08
talkbox:messages:individual:Yourrealname	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:22-08
talkbox:messages:individual:Prefs-help-realname	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:22-08
talkbox:messages:individual:Signupend	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:22-08
talkbox:messages:individual:Editnotice-0	+\\26624\\262RR\\364\\363\\367s\\215\\360\\014\\016q\\365\\013Q\\262\\006\\000	2011-11-28 18:51:33-08
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
4	recordseries	15
3	record	OFF
5	recordorder	0
2	path_pics	http://localhost/pics/
1	vol	6
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
18	5	3	Edit Voice	Edit Voice	./edit-voice.php	\N	center	none	\N
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
763	he is gone somewhere between ottawa and Montreal	2011-11-24 06:02:28	main
764	ottawa and montreal 	2011-11-24 06:04:06	tts
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
902	Canada	2013-02-15 20:14:10	main
903	this is a test	2013-02-15 20:14:30	tts
904	test 	2013-02-15 20:14:36	tts
905	test 	2013-02-15 20:14:40	tts
906	test 	2013-02-15 20:14:41	tts
907	test 	2013-02-15 20:14:57	tts
908	test 	2013-02-15 20:14:59	tts
909	Good Bye	2013-02-15 20:23:18	main
910	Ouch	2013-02-15 20:32:30	main
911	oack	2013-02-15 20:32:39	tts
912	helo	2013-02-15 20:47:43	tts
913	hello	2013-02-15 20:47:50	tts
914	hello	2013-02-15 20:47:53	tts
915	this is a test	2013-02-15 20:51:27	tts
916	this is a test	2013-02-15 20:51:35	tts
917	this is a test	2013-02-15 21:00:29	tts
918	this is a test 	2013-02-15 21:00:39	tts
919	this is a test 	2013-02-15 21:00:46	tts
920	this is a test 	2013-02-15 21:00:53	tts
921	this is a test 	2013-02-15 21:00:59	tts
922	this is a test 	2013-02-15 21:01:03	tts
923	this is a test 	2013-02-15 21:01:04	tts
924	this is a test 	2013-02-15 21:05:24	tts
925	this is a test 	2013-02-15 21:05:26	tts
926	1	2013-02-15 21:05:30	tts
927	tehs	2013-02-15 21:05:39	tts
928	the	2013-02-15 21:05:44	tts
929	the	2013-02-15 21:05:46	tts
930	the	2013-02-15 21:05:52	tts
931	the	2013-02-15 21:05:58	tts
932	Hello	2013-02-15 21:15:28	main
933	hey it is Jeffrey	2013-02-15 21:15:46	main
934	hey it is Jeffrey	2013-02-15 21:15:49	main
935	hey it is Jeffrey	2013-02-15 21:15:49	main
936	hey it is Jeffrey	2013-02-15 21:15:50	main
937	hey it is Jeffrey	2013-02-15 21:15:56	main
938	Good Bye	2013-02-15 21:16:08	main
939	test 	2013-04-13 13:41:00	tts
940	Ouch	2013-04-13 13:41:07	main
941	Ouch	2013-04-13 13:41:10	main
942	Hello	2013-04-13 13:43:32	main
943	Hello	2013-04-13 13:43:34	main
944	Ouch	2013-04-13 13:45:25	main
945	Ouch	2013-04-13 13:46:47	main
946	Studying	2013-04-13 15:48:05	main
\.


--
-- Data for Name: phases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY phases (phases, pic, id, size, modified, created, filename, paraphase, boards_id) FROM stdin;
Hello	\N	12	\N	2011-11-04 23:02:56-07	2011-01-30 00:53:53-08	hello_3.jpg		0
Ouch		14	\N	2011-11-04 23:03:52-07	2011-01-30 20:32:52-08	ouch.gif		0
Good Bye		13	\N	2011-11-04 23:04:33-07	2011-01-30 01:36:52-08	goodbye.jpg		0
 Bathroom		17	\N	2011-11-04 23:07:31-07	2011-02-01 17:39:10-08	bathroom.jpg	I need to go to the  Bathroom	0
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
Juice And Banana And Cherry 	\N	70	\N	2011-11-24 14:35:29-08	2011-11-24 14:35:29-08	\N	\N	18
Banana And Pear 	\N	72	\N	2011-11-24 14:38:44-08	2011-11-24 14:38:44-08	\N	\N	18
Banana And Pear 	\N	73	\N	2011-11-24 14:38:44-08	2011-11-24 14:38:44-08	\N	\N	18
Pizza And French Fies 	\N	77	\N	2011-11-24 16:06:11-08	2011-11-24 16:06:11-08	\N	\N	18
Banana And Pear 	\N	78	\N	2011-11-24 16:06:54-08	2011-11-24 16:06:54-08	\N	\N	18
Juice And Banana And Cherry 	\N	79	\N	2011-11-24 16:07:07-08	2011-11-24 16:07:07-08	\N	\N	18
\.


--
-- Data for Name: storyboard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY storyboard (id, orderno, phase, "time", series, status) FROM stdin;
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

CREATE TRIGGER page_deleted
    AFTER DELETE ON page
    FOR EACH ROW
    EXECUTE PROCEDURE page_deleted();


--
-- Name: ts2_page_text; Type: TRIGGER; Schema: mediawiki; Owner: talkbox
--

CREATE TRIGGER ts2_page_text
    BEFORE INSERT OR UPDATE ON pagecontent
    FOR EACH ROW
    EXECUTE PROCEDURE ts2_page_text();


--
-- Name: ts2_page_title; Type: TRIGGER; Schema: mediawiki; Owner: talkbox
--

CREATE TRIGGER ts2_page_title
    BEFORE INSERT OR UPDATE ON page
    FOR EACH ROW
    EXECUTE PROCEDURE ts2_page_title();


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

