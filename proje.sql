CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,  -- Birincil Anahtar (otomatik artan)
    username VARCHAR(50) UNIQUE NOT NULL,  -- Kullanıcı adı (tekil ve boş olamaz)
    email VARCHAR(100) UNIQUE NOT NULL,    -- E-posta (tekil ve boş olamaz)
    password VARCHAR(255) NOT NULL,        -- Şifre (güvenlik için uzun tutulmuş)
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Kayıt tarihi (otomatik olarak şimdi)
    first_name VARCHAR(50) NOT NULL,       -- Ad
    last_name VARCHAR(50) NOT NULL         -- Soyad
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,               -- Birincil anahtar (otomatik artan)
    course_name VARCHAR(200) NOT NULL,          -- Eğitim adı
    description TEXT,                           -- Eğitim açıklaması
    start_date DATE NOT NULL,                   -- Başlangıç tarihi
    end_date DATE,                              -- Bitiş tarihi (zorunlu değil)
    instructor_name VARCHAR(100) NOT NULL       -- Eğitmen adı ve soyadı
);


CREATE TABLE categories (
    category_id SMALLINT PRIMARY KEY,         -- Birincil anahtar
    category_name VARCHAR(100) NOT NULL       -- Kategori adı (ör: yapay zeka, siber güvenlik)
);
ALTER TABLE courses
ADD COLUMN category_id SMALLINT,
ADD CONSTRAINT fk_category
    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
    ON DELETE SET NULL;
INSERT INTO categories (category_id, category_name) VALUES
(1, 'Yapay Zeka'),
(2, 'Blokzincir'),
(3, 'Siber Güvenlik');


CREATE TABLE enrollments (
    enrollment_id BIGSERIAL PRIMARY KEY,
    member_id BIGINT NOT NULL,                    -- users yerine members
    course_id BIGINT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_member
        FOREIGN KEY (member_id)
        REFERENCES members(member_id)             -- users yerine members
        ON DELETE CASCADE,

    CONSTRAINT fk_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE
);


CREATE TABLE certificates (
    certificate_id BIGSERIAL PRIMARY KEY,               -- Otomatik artan PK
    member_id BIGINT NOT NULL,                          -- Sertifikayı alan kişi
    course_id BIGINT NOT NULL,                          -- Tamamlanan kurs
    certificate_code VARCHAR(100) UNIQUE NOT NULL,      -- Benzersiz sertifika kodu
    issue_date DATE DEFAULT CURRENT_DATE,               -- Veriliş tarihi

    CONSTRAINT fk_cert_member
        FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_cert_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE
);


CREATE TABLE certificate_assignments (
    assignment_id BIGSERIAL PRIMARY KEY,       -- Otomatik artan birincil anahtar
    member_id BIGINT NOT NULL,                 -- Üye FK
    certificate_id BIGINT NOT NULL,            -- Sertifika FK
    assignment_date DATE DEFAULT CURRENT_DATE, -- Alım tarihi (isteğe bağlı)

    CONSTRAINT fk_ca_member
        FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_ca_certificate
        FOREIGN KEY (certificate_id)
        REFERENCES certificates(certificate_id)
        ON DELETE CASCADE
);

CREATE TABLE blog_posts (
    post_id BIGSERIAL PRIMARY KEY,             -- Otomatik artan birincil anahtar
    title VARCHAR(255) NOT NULL,               -- Blog başlığı
    content TEXT NOT NULL,                     -- Blog içeriği
    publish_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Yayın tarihi
    author_id BIGINT NOT NULL,                 -- Yazarı (members tablosundan)

    CONSTRAINT fk_post_author
        FOREIGN KEY (author_id)
        REFERENCES members(member_id)
        ON DELETE CASCADE
);


