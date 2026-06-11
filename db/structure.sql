--
-- PostgreSQL database dump
--

\restrict Diqh81ax7up9u5odhdPl82C03PCwhmfaTMnS3oglQUfMKx5d0yGvN3ARY8EYKrm

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg13+1)

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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: passenger_bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.passenger_bookings (
    id bigint NOT NULL,
    trip_id bigint NOT NULL,
    passenger_id bigint NOT NULL,
    status character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: passenger_bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.passenger_bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: passenger_bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.passenger_bookings_id_seq OWNED BY public.passenger_bookings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: trips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trips (
    id bigint NOT NULL,
    driver_id bigint NOT NULL,
    vehicle_id bigint NOT NULL,
    start_city character varying,
    end_city character varying,
    start_time timestamp(6) without time zone,
    end_time timestamp(6) without time zone,
    price integer,
    seats_available integer,
    status character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: trips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trips_id_seq OWNED BY public.trips.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    pseudo character varying,
    credits integer DEFAULT 20,
    role character varying,
    is_chauffeur boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    suspended boolean DEFAULT false NOT NULL,
    suppressed boolean DEFAULT false NOT NULL,
    smoker boolean DEFAULT false NOT NULL,
    animal boolean DEFAULT false NOT NULL,
    custom_preferences text,
    terms_accepted boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vehicles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    plate_number character varying,
    date_first_registration date,
    brand character varying,
    model character varying,
    color character varying,
    electric boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: vehicles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vehicles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vehicles_id_seq OWNED BY public.vehicles.id;


--
-- Name: passenger_bookings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passenger_bookings ALTER COLUMN id SET DEFAULT nextval('public.passenger_bookings_id_seq'::regclass);


--
-- Name: trips id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trips ALTER COLUMN id SET DEFAULT nextval('public.trips_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vehicles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicles ALTER COLUMN id SET DEFAULT nextval('public.vehicles_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: passenger_bookings passenger_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passenger_bookings
    ADD CONSTRAINT passenger_bookings_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: trips trips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- Name: index_passenger_bookings_on_passenger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_passenger_bookings_on_passenger_id ON public.passenger_bookings USING btree (passenger_id);


--
-- Name: index_passenger_bookings_on_trip_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_passenger_bookings_on_trip_id ON public.passenger_bookings USING btree (trip_id);


--
-- Name: index_trips_on_driver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trips_on_driver_id ON public.trips USING btree (driver_id);


--
-- Name: index_trips_on_vehicle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trips_on_vehicle_id ON public.trips USING btree (vehicle_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_vehicles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicles_on_user_id ON public.vehicles USING btree (user_id);


--
-- Name: trips fk_rails_272ac73176; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trips
    ADD CONSTRAINT fk_rails_272ac73176 FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(id);


--
-- Name: passenger_bookings fk_rails_89941f4230; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passenger_bookings
    ADD CONSTRAINT fk_rails_89941f4230 FOREIGN KEY (passenger_id) REFERENCES public.users(id);


--
-- Name: vehicles fk_rails_9e34682d54; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT fk_rails_9e34682d54 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: trips fk_rails_e7560abc33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trips
    ADD CONSTRAINT fk_rails_e7560abc33 FOREIGN KEY (driver_id) REFERENCES public.users(id);


--
-- Name: passenger_bookings fk_rails_feaed086d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passenger_bookings
    ADD CONSTRAINT fk_rails_feaed086d0 FOREIGN KEY (trip_id) REFERENCES public.trips(id);


--
-- PostgreSQL database dump complete
--

\unrestrict Diqh81ax7up9u5odhdPl82C03PCwhmfaTMnS3oglQUfMKx5d0yGvN3ARY8EYKrm

