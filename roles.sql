--marketer
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public.city TO marketer;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public.customers TO marketer;
GRANT SELECT ON TABLE public.orders TO marketer;
GRANT UPDATE, INSERT, DELETE ON TABLE public.product TO marketer;
GRANT SELECT ON TABLE public.provider TO marketer;
--analyst
GRANT SELECT ON TABLE public.city TO analyst;
GRANT SELECT, INSERT ON TABLE public.customers TO analyst;
GRANT SELECT ON TABLE public.orders TO analyst;
GRANT SELECT, INSERT ON TABLE public.product TO analyst;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public.provider TO analyst;
GRANT SELECT, INSERT ON TABLE public.reviews TO analyst;
--designer
GRANT SELECT ON TABLE public.product TO designer;
GRANT SELECT ON TABLE public.city TO designer;
GRANT SELECT ON TABLE public.customers TO designer;
--engineer
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, UPDATE, INSERT, DELETE ON TABLES TO engineer;
--seospecialist
GRANT SELECT, UPDATE, INSERT ON TABLE public.basket TO seospecialist;
GRANT SELECT, UPDATE, INSERT ON TABLE public.city TO seospecialist;
GRANT SELECT, INSERT ON TABLE public.customers TO seospecialist;
GRANT SELECT, INSERT ON TABLE public.orders TO seospecialist;
GRANT SELECT, INSERT ON TABLE public.product TO seospecialist;
GRANT SELECT, INSERT ON TABLE public.provider TO seospecialist;
GRANT SELECT ON TABLE public.reviews TO seospecialist;
--worker
GRANT SELECT, UPDATE, INSERT ON TABLE public.basket TO worker;
GRANT SELECT, UPDATE, INSERT ON TABLE public.city TO worker;
GRANT SELECT, UPDATE, INSERT ON TABLE public.customers TO worker;
GRANT SELECT, UPDATE, INSERT ON TABLE public.orders TO worker;
GRANT SELECT, UPDATE, INSERT ON TABLE public.product TO worker;
--thirdpartyservice
GRANT SELECT ON TABLE public.city TO thirdpartyservice;
GRANT SELECT ON TABLE public.product TO thirdpartyservice;
--admin
SUPERUSER