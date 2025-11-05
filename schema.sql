--
-- PostgreSQL database dump
--

\restrict 598jIjdwFQwABD2i0guU3MfSkrwhrcG1VTZdcGh9vr8SVOvKIa6BfPDbYtKR8RT

-- Dumped from database version 14.19 (Homebrew)
-- Dumped by pg_dump version 14.19 (Homebrew)

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
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.activity_logs (
    log_id integer NOT NULL,
    user_id integer,
    action character varying(200) NOT NULL,
    details text,
    ip_address character varying(45),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.activity_logs OWNER TO atharvasharma;

--
-- Name: activity_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.activity_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_logs_log_id_seq OWNER TO atharvasharma;

--
-- Name: activity_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.activity_logs_log_id_seq OWNED BY public.activity_logs.log_id;


--
-- Name: cart; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.cart (
    cart_id integer NOT NULL,
    customer_id integer,
    product_id integer,
    quantity integer DEFAULT 1,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT cart_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.cart OWNER TO atharvasharma;

--
-- Name: cart_cart_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.cart_cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cart_cart_id_seq OWNER TO atharvasharma;

--
-- Name: cart_cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.cart_cart_id_seq OWNED BY public.cart.cart_id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.categories OWNER TO atharvasharma;

--
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_category_id_seq OWNER TO atharvasharma;

--
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- Name: delivery; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.delivery (
    delivery_id integer NOT NULL,
    order_id integer,
    delivery_person_name character varying(100),
    delivery_person_phone character varying(15),
    estimated_delivery timestamp without time zone,
    actual_delivery timestamp without time zone,
    status character varying(30) DEFAULT 'Preparing'::character varying,
    tracking_link text,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT delivery_status_check CHECK (((status)::text = ANY ((ARRAY['Preparing'::character varying, 'Out for Delivery'::character varying, 'Delivered'::character varying, 'Returned'::character varying])::text[])))
);


ALTER TABLE public.delivery OWNER TO atharvasharma;

--
-- Name: delivery_delivery_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.delivery_delivery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delivery_delivery_id_seq OWNER TO atharvasharma;

--
-- Name: delivery_delivery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.delivery_delivery_id_seq OWNED BY public.delivery.delivery_id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.notifications (
    notification_id integer NOT NULL,
    user_id integer,
    title character varying(100) NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    type character varying(30) DEFAULT 'System'::character varying,
    CONSTRAINT notifications_type_check CHECK (((type)::text = ANY ((ARRAY['Order'::character varying, 'Stock'::character varying, 'Promotion'::character varying, 'System'::character varying])::text[])))
);


ALTER TABLE public.notifications OWNER TO atharvasharma;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.notifications_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_notification_id_seq OWNER TO atharvasharma;

--
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.order_items (
    order_item_id integer NOT NULL,
    order_id integer,
    product_id integer,
    quantity integer NOT NULL,
    price_at_purchase numeric(10,2) NOT NULL
);


ALTER TABLE public.order_items OWNER TO atharvasharma;

--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.order_items_order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_items_order_item_id_seq OWNER TO atharvasharma;

--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.order_items_order_item_id_seq OWNED BY public.order_items.order_item_id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    customer_id integer,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_amount numeric(10,2) NOT NULL,
    payment_method character varying(50) DEFAULT 'Cash on Delivery'::character varying,
    status character varying(20) DEFAULT 'Pending'::character varying,
    delivery_address text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Shipped'::character varying, 'Delivered'::character varying, 'Cancelled'::character varying])::text[])))
);


ALTER TABLE public.orders OWNER TO atharvasharma;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_order_id_seq OWNER TO atharvasharma;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    order_id integer,
    payment_method character varying(50),
    transaction_id character varying(100),
    amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'Pending'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    payment_status character varying(20) DEFAULT 'Pending'::character varying,
    CONSTRAINT payments_payment_method_check CHECK (((payment_method)::text = ANY ((ARRAY['COD'::character varying, 'UPI'::character varying, 'Card'::character varying, 'NetBanking'::character varying, 'Online Payment'::character varying])::text[]))),
    CONSTRAINT payments_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['Pending'::character varying, 'Completed'::character varying, 'Failed'::character varying, 'Refunded'::character varying])::text[]))),
    CONSTRAINT payments_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Successful'::character varying, 'Failed'::character varying, 'Refunded'::character varying])::text[])))
);


ALTER TABLE public.payments OWNER TO atharvasharma;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_payment_id_seq OWNER TO atharvasharma;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    seller_id integer,
    category_id integer,
    product_name character varying(150) NOT NULL,
    description text,
    unit character varying(20),
    quantity_label character varying(50),
    stock_quantity integer DEFAULT 0,
    low_stock_alert integer DEFAULT 5,
    mrp numeric(10,2) NOT NULL,
    selling_price numeric(10,2) NOT NULL,
    product_image_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.products OWNER TO atharvasharma;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_product_id_seq OWNER TO atharvasharma;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.reviews (
    review_id integer NOT NULL,
    product_id integer,
    customer_id integer,
    rating integer NOT NULL,
    comment text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.reviews OWNER TO atharvasharma;

--
-- Name: reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviews_review_id_seq OWNER TO atharvasharma;

--
-- Name: reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.reviews_review_id_seq OWNED BY public.reviews.review_id;


--
-- Name: support_tickets; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.support_tickets (
    ticket_id integer NOT NULL,
    user_id integer,
    order_id integer,
    subject character varying(150) NOT NULL,
    message text NOT NULL,
    status character varying(20) DEFAULT 'Open'::character varying,
    priority character varying(20) DEFAULT 'Medium'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT support_tickets_priority_check CHECK (((priority)::text = ANY ((ARRAY['Low'::character varying, 'Medium'::character varying, 'High'::character varying])::text[]))),
    CONSTRAINT support_tickets_status_check CHECK (((status)::text = ANY ((ARRAY['Open'::character varying, 'In Progress'::character varying, 'Resolved'::character varying, 'Closed'::character varying])::text[])))
);


ALTER TABLE public.support_tickets OWNER TO atharvasharma;

--
-- Name: support_tickets_ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.support_tickets_ticket_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.support_tickets_ticket_id_seq OWNER TO atharvasharma;

--
-- Name: support_tickets_ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.support_tickets_ticket_id_seq OWNED BY public.support_tickets.ticket_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone_number character varying(15),
    password_hash text NOT NULL,
    role character varying(20) NOT NULL,
    address text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['Customer'::character varying, 'Seller'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO atharvasharma;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO atharvasharma;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: wishlist; Type: TABLE; Schema: public; Owner: atharvasharma
--

CREATE TABLE public.wishlist (
    wishlist_id integer NOT NULL,
    customer_id integer,
    product_id integer,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.wishlist OWNER TO atharvasharma;

--
-- Name: wishlist_wishlist_id_seq; Type: SEQUENCE; Schema: public; Owner: atharvasharma
--

CREATE SEQUENCE public.wishlist_wishlist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wishlist_wishlist_id_seq OWNER TO atharvasharma;

--
-- Name: wishlist_wishlist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: atharvasharma
--

ALTER SEQUENCE public.wishlist_wishlist_id_seq OWNED BY public.wishlist.wishlist_id;


--
-- Name: activity_logs log_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.activity_logs ALTER COLUMN log_id SET DEFAULT nextval('public.activity_logs_log_id_seq'::regclass);


--
-- Name: cart cart_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.cart ALTER COLUMN cart_id SET DEFAULT nextval('public.cart_cart_id_seq'::regclass);


--
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- Name: delivery delivery_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.delivery ALTER COLUMN delivery_id SET DEFAULT nextval('public.delivery_delivery_id_seq'::regclass);


--
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- Name: order_items order_item_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('public.order_items_order_item_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Name: reviews review_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.reviews ALTER COLUMN review_id SET DEFAULT nextval('public.reviews_review_id_seq'::regclass);


--
-- Name: support_tickets ticket_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.support_tickets ALTER COLUMN ticket_id SET DEFAULT nextval('public.support_tickets_ticket_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: wishlist wishlist_id; Type: DEFAULT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.wishlist ALTER COLUMN wishlist_id SET DEFAULT nextval('public.wishlist_wishlist_id_seq'::regclass);


--
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (log_id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (cart_id);


--
-- Name: categories categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_category_name_key UNIQUE (category_name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: delivery delivery_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_pkey PRIMARY KEY (delivery_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);


--
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (ticket_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key UNIQUE (phone_number);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: wishlist wishlist_pkey; Type: CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_pkey PRIMARY KEY (wishlist_id);


--
-- Name: idx_order_items_order_id; Type: INDEX; Schema: public; Owner: atharvasharma
--

CREATE INDEX idx_order_items_order_id ON public.order_items USING btree (order_id);


--
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: atharvasharma
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- Name: idx_orders_user; Type: INDEX; Schema: public; Owner: atharvasharma
--

CREATE INDEX idx_orders_user ON public.orders USING btree (customer_id);


--
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: atharvasharma
--

CREATE INDEX idx_products_category ON public.products USING btree (category_id);


--
-- Name: idx_products_name; Type: INDEX; Schema: public; Owner: atharvasharma
--

CREATE INDEX idx_products_name ON public.products USING btree (product_name);


--
-- Name: idx_products_seller; Type: INDEX; Schema: public; Owner: atharvasharma
--

CREATE INDEX idx_products_seller ON public.products USING btree (seller_id);


--
-- Name: idx_reviews_customer; Type: INDEX; Schema: public; Owner: atharvasharma
--

CREATE INDEX idx_reviews_customer ON public.reviews USING btree (customer_id);


--
-- Name: idx_reviews_product; Type: INDEX; Schema: public; Owner: atharvasharma
--

CREATE INDEX idx_reviews_product ON public.reviews USING btree (product_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: atharvasharma
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_phone; Type: INDEX; Schema: public; Owner: atharvasharma
--

CREATE INDEX idx_users_phone ON public.users USING btree (phone_number);


--
-- Name: activity_logs activity_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: cart cart_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: cart cart_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- Name: delivery delivery_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.delivery
    ADD CONSTRAINT delivery_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: payments payments_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON DELETE SET NULL;


--
-- Name: products products_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: reviews reviews_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: reviews reviews_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- Name: support_tickets support_tickets_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE SET NULL;


--
-- Name: support_tickets support_tickets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: wishlist wishlist_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: wishlist wishlist_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: atharvasharma
--

ALTER TABLE ONLY public.wishlist
    ADD CONSTRAINT wishlist_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 598jIjdwFQwABD2i0guU3MfSkrwhrcG1VTZdcGh9vr8SVOvKIa6BfPDbYtKR8RT

