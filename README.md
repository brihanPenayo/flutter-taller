# Chat App en Flutter

Este proyecto se realizó en el marco del Taller de Flutter de GDG Encarnación, Septiembre de 2023

## Instrucciones

1. [Instalar Flutter](https://docs.flutter.dev/get-started/install)

2. [Crear proyecto de Supabase](https://supabase.com/)

3. [Configurar Editor](https://docs.flutter.dev/get-started/editor)

4. Crear proyecto de Flutter:

    ```bash
    flutter create chat 
    ```

5. Añadir las dependencias especificadas en el [pubspec.yaml](pubspec.yaml)

6. Crear archivo .env para configurar Supabase

    ```bash
    SUPABASE_URL=TU_URL
    SUPABASE_KEY=TU_KEY
    ```

7. Habilitar Auth Email y deshabilitar el confirm email desde la pantalla de providers de Supabase

8. Crear tablas SQL:

```sql
CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "first_name" "text",
    "last_name" "text",
    "url" "text"
);

ALTER TABLE "public"."profiles" OWNER TO "postgres";

ALTER TABLE ONLY "public"."profiles"
ADD CONSTRAINT "profile_pkey" PRIMARY KEY ("id");


ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;


CREATE POLICY "Public profiles are viewable by everyone." ON "public"."profiles" FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile." ON "public"."profiles" FOR INSERT WITH CHECK (("auth"."uid"() = "id"));

CREATE POLICY "Users can update own profile." ON "public"."profiles" FOR UPDATE USING (("auth"."uid"() = "id"));

ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
    INSERT INTO public.profiles (id) VALUES (new.id);
    RETURN new;
END;
$$;

ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";
```

### ScreenShots

![Frame 19](https://github.com/brihanPenayo/flutter-taller/blob/master/assets/images/screenshots/simulatorScreen.jpg?raw=true)
![Frame 19](https://github.com/brihanPenayo/flutter-taller/blob/master/assets/images/screenshots/simulatorScreen2.jpg?raw=true)