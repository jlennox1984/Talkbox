--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: folders; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA folders;


ALTER SCHEMA folders OWNER TO postgres;

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

SELECT pg_catalog.setval('history_id_seq', 717, true);


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

SELECT pg_catalog.setval('phases_id_seq', 67, true);


SET default_with_oids = true;

--
-- Name: storyboard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE storyboard (
    id integer NOT NULL,
    orderno integer NOT NULL,
    phase text,
    "time" timestamp without time zone,
    series integer
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

SELECT pg_catalog.setval('storyboard_id_seq', 47, true);


SET search_path = folders, pg_catalog;

--
-- Name: folderid; Type: DEFAULT; Schema: folders; Owner: postgres
--

ALTER TABLE folders ALTER COLUMN folderid SET DEFAULT nextval('folders_folderid_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE boards ALTER COLUMN id SET DEFAULT nextval('boards_id_seq'::regclass);


--
-- Name: fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE boards ALTER COLUMN fid SET DEFAULT nextval('boards_fid_seq'::regclass);


--
-- Name: name; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE boards ALTER COLUMN name SET DEFAULT nextval('boards_name_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE config ALTER COLUMN id SET DEFAULT nextval('config_id_seq'::regclass);


--
-- Name: folderid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE folders ALTER COLUMN folderid SET DEFAULT nextval('folders_folderid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE history ALTER COLUMN id SET DEFAULT nextval('history_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE phases ALTER COLUMN id SET DEFAULT nextval('phases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE storyboard ALTER COLUMN id SET DEFAULT nextval('storyboard_id_seq'::regclass);


SET search_path = folders, pg_catalog;

--
-- Data for Name: folders; Type: TABLE DATA; Schema: folders; Owner: postgres
--

COPY folders (folderid, orderno, parentid, title, name, url, isopen, img, pane, type) FROM stdin;
1	0	0	test	test	/test.html	\N		north	norm
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
2	path_pics	http://development.mwds.ca/talkbox2/pics/
3	record	OFF
5	recordorder	0
1	vol	7
4	recordseries	4
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
\.


--
-- Data for Name: phases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY phases (phases, pic, id, size, modified, created, filename, paraphase, boards_id) FROM stdin;
Hello	\N	12	\N	2011-11-05 02:02:56-04	2011-01-30 03:53:53-05	hello_3.jpg		0
Ouch		14	\N	2011-11-05 02:03:52-04	2011-01-30 23:32:52-05	ouch.gif		0
Good Bye		13	\N	2011-11-05 02:04:33-04	2011-01-30 04:36:52-05	goodbye.jpg		0
 Bathroom		17	\N	2011-11-05 02:07:31-04	2011-02-01 20:39:10-05	bathroom.jpg	I need to go to the  Bathroom	0
planet earth 	\N	32	\N	2011-11-05 23:47:34-04	2011-11-05 23:47:34-04	\N	\N	\N
 Montreal	\N	34	\N	2011-11-06 01:12:44-05	2011-11-06 01:33:37-05			13
Lego	\N	36	\N	2011-11-06 01:28:38-05	2011-11-06 01:28:38-05	lego_table_2.jpg		17
Canada	\N	38	\N	2011-11-12 02:39:25-05	2011-11-12 02:39:25-05	canada_flag.gif		13
 Quebec	\N	37	\N	2011-11-12 02:52:33-05	2011-11-11 13:59:56-05	quebec-flag.gif		13
Home	\N	41	\N	2011-11-12 03:27:21-05	2011-11-12 03:27:21-05	home.png		13
Vancouver	\N	46	\N	2011-11-13 09:01:34-05	2011-11-13 09:01:34-05	\N	\N	13
Study	\N	48	\N	2011-11-13 09:32:52-05	2011-11-13 09:31:33-05	study.gif	Studying	14
Ottawa	\N	45	\N	2011-11-13 09:40:06-05	2011-11-13 09:01:27-05	ottawa.jpg		13
Toronto	\N	44	\N	2011-11-13 09:41:38-05	2011-11-13 09:01:22-05	toronto.jpg		13
Ontario	\N	43	\N	2011-11-13 09:54:58-05	2011-11-13 09:01:12-05	ontario.png		13
BC	\N	42	\N	2011-11-13 09:55:14-05	2011-11-13 09:01:06-05	bc-flag.gif	British Columbia	13
Lettuce	\N	49	\N	2011-11-13 10:12:45-05	2011-11-13 10:12:45-05	lettuce.gif		18
Pizza	\N	50	\N	2011-11-13 10:13:13-05	2011-11-13 10:13:13-05	pizza2.gif		18
Banana	\N	51	\N	2011-11-13 10:29:12-05	2011-11-13 10:29:12-05	Banana.png		18
Cherry	\N	53	\N	2011-11-13 10:31:31-05	2011-11-13 10:31:31-05	cherry.png		18
French Fies	\N	54	\N	2011-11-13 10:32:06-05	2011-11-13 10:32:06-05	french_fies.png		18
Carrot	\N	55	\N	2011-11-13 10:33:54-05	2011-11-13 10:33:54-05	Carrot.jpg		18
Corn	\N	56	\N	2011-11-13 10:34:25-05	2011-11-13 10:34:25-05	corn.gif		18
Pear	\N	57	\N	2011-11-13 10:35:16-05	2011-11-13 10:35:16-05	pear.png		18
Juice	\N	52	\N	2011-11-13 10:38:30-05	2011-11-13 10:29:45-05	juice.png		18
The	\N	59	\N	2011-11-14 00:02:54-05	2011-11-14 00:02:54-05	\N		20
And	\N	58	\N	2011-11-14 00:03:11-05	2011-11-14 00:02:40-05			20
he	\N	60	\N	2011-11-14 17:32:58-05	2011-11-14 17:32:58-05	\N	\N	20
Time	\N	61	\N	2011-11-18 21:41:17-05	2011-11-18 21:39:47-05	clock.jpg	whattime	0
Date	\N	62	\N	2011-11-18 21:44:39-05	2011-11-18 21:44:39-05	calendar.jpg	get date	0
he is gone no where	\N	64	\N	2011-11-21 23:04:19-05	2011-11-21 23:04:19-05	\N	\N	20
he is gone	\N	65	\N	2011-11-21 23:04:32-05	2011-11-21 23:04:32-05	\N	\N	20
hey it is Jeffrey	\N	66	\N	2011-11-22 00:56:33-05	2011-11-22 00:56:33-05	\N	\N	0
he	\N	67	\N	2011-11-22 01:05:34-05	2011-11-22 01:05:34-05	\N	\N	13
\.


--
-- Data for Name: storyboard; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY storyboard (id, orderno, phase, "time", series) FROM stdin;
29	1	Banana	2011-11-22 16:57:05	3
30	2	And	2011-11-22 16:57:11	3
31	3	Pear	2011-11-22 16:57:16	3
\.


SET search_path = folders, pg_catalog;

--
-- Name: folders_pkey; Type: CONSTRAINT; Schema: folders; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (folderid);


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

