--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.1
-- Dumped by pg_dump version 9.5.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: reporting; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA reporting;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: airports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE airports (
    id integer NOT NULL,
    iata character varying(4),
    airport character varying,
    city character varying,
    state character varying,
    country character varying,
    lat double precision,
    long double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lonlat geography(Point,4326)
);


--
-- Name: airports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE airports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: airports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE airports_id_seq OWNED BY airports.id;


--
-- Name: carriers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE carriers (
    id integer NOT NULL,
    code character varying(7),
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: carriers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE carriers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carriers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE carriers_id_seq OWNED BY carriers.id;


--
-- Name: departures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE departures (
    id integer NOT NULL,
    year integer,
    month integer,
    day_of_month integer,
    day_of_week integer,
    dep_time integer,
    crs_dep_time integer,
    arr_time integer,
    crs_arr_time integer,
    unique_carrier character varying(6),
    flight_num integer,
    tail_num character varying(8),
    actual_elapsed_time integer,
    crs_elapsed_time integer,
    air_time integer,
    arr_delay integer,
    dep_delay integer,
    origin character varying(3),
    dest character varying(3),
    distance integer,
    taxi_in integer,
    taxi_out integer,
    cancelled boolean,
    cancellation_code character varying(1),
    diverted boolean,
    carrier_delay integer,
    weather_delay integer,
    nas_delay integer,
    security_delay integer,
    late_aircraft_delay integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: departures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE departures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE departures_id_seq OWNED BY departures.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


SET search_path = reporting, pg_catalog;

--
-- Name: june_departures; Type: MATERIALIZED VIEW; Schema: reporting; Owner: -
--

CREATE MATERIALIZED VIEW june_departures AS
 SELECT departures.id,
    departures.unique_carrier,
    departures.flight_num,
    departures.tail_num,
    departures.origin,
    departures.dest,
    lead(departures.origin) OVER (PARTITION BY departures.tail_num ORDER BY departures.day_of_month, departures.dep_time) AS next_origin,
    to_date(((((departures.year || '-'::text) || departures.month) || '-'::text) || departures.day_of_month), 'YYYY-MM-DD'::text) AS dep_date,
    departures.dep_time,
    departures.arr_time,
    departures.actual_elapsed_time,
    departures.dep_delay,
    departures.arr_delay,
    departures.diverted
   FROM public.departures
  WHERE ((departures.year = 1999) AND (departures.month = 6) AND (departures.cancelled = false))
  WITH NO DATA;


--
-- Name: ua_departures; Type: TABLE; Schema: reporting; Owner: -
--

CREATE TABLE ua_departures (
    id integer NOT NULL,
    unique_carrier character varying(8),
    flight_num integer,
    tail_num character varying(8),
    origin character varying(3),
    dest character varying(3),
    dep_date date,
    dep_time integer,
    arr_time integer,
    actual_elapsed_time integer,
    dep_delay integer,
    arr_delay integer,
    diverted boolean,
    next_origin character varying(3),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ua_departures_id_seq; Type: SEQUENCE; Schema: reporting; Owner: -
--

CREATE SEQUENCE ua_departures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ua_departures_id_seq; Type: SEQUENCE OWNED BY; Schema: reporting; Owner: -
--

ALTER SEQUENCE ua_departures_id_seq OWNED BY ua_departures.id;


SET search_path = public, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY airports ALTER COLUMN id SET DEFAULT nextval('airports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY carriers ALTER COLUMN id SET DEFAULT nextval('carriers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY departures ALTER COLUMN id SET DEFAULT nextval('departures_id_seq'::regclass);


SET search_path = reporting, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY ua_departures ALTER COLUMN id SET DEFAULT nextval('ua_departures_id_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: airports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY airports
    ADD CONSTRAINT airports_pkey PRIMARY KEY (id);


--
-- Name: carriers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY carriers
    ADD CONSTRAINT carriers_pkey PRIMARY KEY (id);


--
-- Name: departures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY departures
    ADD CONSTRAINT departures_pkey PRIMARY KEY (id);


SET search_path = reporting, pg_catalog;

--
-- Name: ua_departures_pkey; Type: CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY ua_departures
    ADD CONSTRAINT ua_departures_pkey PRIMARY KEY (id);


SET search_path = public, pg_catalog;

--
-- Name: index_airports_on_iata; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_airports_on_iata ON airports USING btree (iata);


--
-- Name: index_airports_on_lonlat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_airports_on_lonlat ON airports USING gist (lonlat);


--
-- Name: index_carriers_on_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_carriers_on_code ON carriers USING btree (code);


--
-- Name: index_departures_on_cancelled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_departures_on_cancelled ON departures USING btree (cancelled);


--
-- Name: index_departures_on_dest; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_departures_on_dest ON departures USING btree (dest);


--
-- Name: index_departures_on_origin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_departures_on_origin ON departures USING btree (origin);


--
-- Name: index_departures_on_unique_carrier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_departures_on_unique_carrier ON departures USING btree (unique_carrier);


--
-- Name: index_departures_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_departures_on_year ON departures USING btree (year);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


SET search_path = reporting, pg_catalog;

--
-- Name: index_reporting.june_departures_on_dep_date_and_dep_time; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX "index_reporting.june_departures_on_dep_date_and_dep_time" ON june_departures USING btree (dep_date, dep_time);


--
-- Name: index_reporting.june_departures_on_dest; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX "index_reporting.june_departures_on_dest" ON june_departures USING btree (dest);


--
-- Name: index_reporting.june_departures_on_origin; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX "index_reporting.june_departures_on_origin" ON june_departures USING btree (origin);


--
-- Name: index_reporting.june_departures_on_tail_num; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX "index_reporting.june_departures_on_tail_num" ON june_departures USING btree (tail_num);


--
-- Name: index_reporting.june_departures_on_unique_carrier; Type: INDEX; Schema: reporting; Owner: -
--

CREATE INDEX "index_reporting.june_departures_on_unique_carrier" ON june_departures USING btree (unique_carrier);


SET search_path = public, pg_catalog;

--
-- Name: fk_rails_2efd7d3e72; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY departures
    ADD CONSTRAINT fk_rails_2efd7d3e72 FOREIGN KEY (origin) REFERENCES airports(iata);


--
-- Name: fk_rails_33ad74b498; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY departures
    ADD CONSTRAINT fk_rails_33ad74b498 FOREIGN KEY (dest) REFERENCES airports(iata);


--
-- Name: fk_rails_896cf6da7d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY departures
    ADD CONSTRAINT fk_rails_896cf6da7d FOREIGN KEY (unique_carrier) REFERENCES carriers(code);


--
-- PostgreSQL database dump complete
--

SET search_path TO public,reporting;

INSERT INTO schema_migrations (version) VALUES ('20160517135045');

INSERT INTO schema_migrations (version) VALUES ('20160517143601');

INSERT INTO schema_migrations (version) VALUES ('20160517143811');

INSERT INTO schema_migrations (version) VALUES ('20160517193058');

INSERT INTO schema_migrations (version) VALUES ('20160517201536');

INSERT INTO schema_migrations (version) VALUES ('20160517212635');

INSERT INTO schema_migrations (version) VALUES ('20160517213905');

INSERT INTO schema_migrations (version) VALUES ('20160517214857');

INSERT INTO schema_migrations (version) VALUES ('20160517222112');

INSERT INTO schema_migrations (version) VALUES ('20160517223526');

INSERT INTO schema_migrations (version) VALUES ('20160603133426');

