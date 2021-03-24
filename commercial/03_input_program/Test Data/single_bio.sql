--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.4

-- Started on 2021-03-23 12:10:29

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
-- TOC entry 2874 (class 1262 OID 16545)
-- Name: dmar_entwicklung; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE dmar_entwicklung WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'German_Germany.1252' LC_CTYPE = 'German_Germany.1252';


ALTER DATABASE dmar_entwicklung OWNER TO postgres;

\connect dmar_entwicklung

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

--
-- TOC entry 219 (class 1259 OID 18130)
-- Name: single_bio; Type: TABLE; Schema: com_new_final; Owner: postgres
--

CREATE TABLE com_new_final.single_bio (
    bi_index integer,
    le_index integer,
    fish_id integer,
    parameter character varying,
    value character varying,
    unit character varying,
    comments character varying
);


ALTER TABLE com_new_final.single_bio OWNER TO postgres;

--
-- TOC entry 2868 (class 0 OID 18130)
-- Dependencies: 219
-- Data for Name: single_bio; Type: TABLE DATA; Schema: com_new_final; Owner: postgres
--

INSERT INTO com_new_final.single_bio (bi_index, le_index, fish_id, parameter, value, unit, comments) VALUES (4947, 161, 1, '1', '11.75', '1', NULL);
INSERT INTO com_new_final.single_bio (bi_index, le_index, fish_id, parameter, value, unit, comments) VALUES (4948, 161, 1, '2', '11', '2', NULL);
INSERT INTO com_new_final.single_bio (bi_index, le_index, fish_id, parameter, value, unit, comments) VALUES (4949, 161, 1, '3', 'U', '4', NULL);
INSERT INTO com_new_final.single_bio (bi_index, le_index, fish_id, parameter, value, unit, comments) VALUES (4950, 161, 1, '4', '1', '5', NULL);
INSERT INTO com_new_final.single_bio (bi_index, le_index, fish_id, parameter, value, unit, comments) VALUES (4951, 161, 1, '5', '0', '6', NULL);
INSERT INTO com_new_final.single_bio (bi_index, le_index, fish_id, parameter, value, unit, comments) VALUES (4952, 161, 1, '10', '1', '8', NULL);
INSERT INTO com_new_final.single_bio (bi_index, le_index, fish_id, parameter, value, unit, comments) VALUES (4953, 161, 1, '11', '0', '8', NULL);


-- Completed on 2021-03-23 12:10:30

--
-- PostgreSQL database dump complete
--

