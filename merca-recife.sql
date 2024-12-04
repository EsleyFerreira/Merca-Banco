CREATE TABLE roles
(
    ID   SERIAL      NOT NULL,
    NAME VARCHAR(32) NOT NULL,

    CONSTRAINT pk_roles PRIMARY KEY (ID)
);

CREATE TABLE profiles
(
    ID      SERIAL       NOT NULL,
    NOME    VARCHAR(100) NOT NULL,
    CPF     VARCHAR(14)  NOT NULL,
    PHOTO   BYTEA        NOT NULL,
    STATUS  BOOLEAN      NOT NULL DEFAULT FALSE,
    ROLE_ID INT          NOT NULL,

    CONSTRAINT pk_profiles PRIMARY KEY (ID),
    CONSTRAINT fk_profiles_on_role FOREIGN KEY (ROLE_ID) REFERENCES roles (ID),
    CONSTRAINT unq_profiles_cpf UNIQUE (CPF)
);

CREATE UNIQUE INDEX idx_unq_profiles_cpf ON profiles (CPF);


CREATE TABLE users
(
    ID         SERIAL       NOT NULL,
    EMAIL      VARCHAR(50)  NOT NULL,
    PASSWORD   VARCHAR(255) NOT NULL,
    PROFILE_ID INT          NOT NULL,

    CONSTRAINT pk_users PRIMARY KEY (ID),
    CONSTRAINT fk_users_on_profile FOREIGN KEY (PROFILE_ID) REFERENCES profiles (ID),
    CONSTRAINT unq_users_email UNIQUE (EMAIL)
);


CREATE TABLE boxes
(
    ID   SERIAL NOT NULL,
    CODE INT    NOT NULL,

    CONSTRAINT pk_boxes PRIMARY KEY (ID)
);

CREATE INDEX idx_boxes_code ON boxes (CODE);

CREATE TABLE markets
(
    ID           SERIAL       NOT NULL,
    NAME         VARCHAR(100) NOT NULL,
    ADDRESS      VARCHAR(255) NOT NULL,
    NEIGHBORHOOD VARCHAR(64)  NOT NULL,

    CONSTRAINT pk_markets PRIMARY KEY (ID)
);


CREATE TABLE markets_boxes
(
    MARKET_ID INT NOT NULL,
    BOX_ID    INT NOT NULL,

    CONSTRAINT pk_markets_boxes PRIMARY KEY (MARKET_ID, BOX_ID),
    CONSTRAINT fk_markets_boxes_on_market FOREIGN KEY (MARKET_ID) REFERENCES markets (ID),
    CONSTRAINT fk_markets_boxes_on_box FOREIGN KEY (BOX_ID) REFERENCES boxes (ID)
);

CREATE UNIQUE INDEX idx_unq_markets_boxes ON markets_boxes (MARKET_ID, BOX_ID);


CREATE TABLE profiles_boxes
(
    PROFILE_ID INT NOT NULL,
    BOX_ID     INT NOT NULL,

    CONSTRAINT pk_users_boxes PRIMARY KEY (PROFILE_ID, BOX_ID),
    CONSTRAINT fk_profiles_boxes_on_profile FOREIGN KEY (PROFILE_ID) REFERENCES profiles (ID),
    CONSTRAINT fk_profiles_boxes_on_box FOREIGN KEY (BOX_ID) REFERENCES boxes (ID)
);

CREATE UNIQUE INDEX idx_unq_profiles_boxes ON profiles_boxes (PROFILE_ID, BOX_ID);

-- Tabela products
CREATE TABLE products
(
    ID          SERIAL      NOT NULL,
    NAME        VARCHAR(64) NOT NULL,
    DESCRIPTION TEXT        NOT NULL,
    PHOTO       BYTEA       NOT NULL,
    PRICE       DECIMAL     NOT NULL,
    SELLER_ID   INT         NOT NULL,

    CONSTRAINT pk_products PRIMARY KEY (ID),
    CONSTRAINT fk_products_on_profiles FOREIGN KEY (SELLER_ID) REFERENCES profiles (ID)
);

-- Tabela box_feedbacks
CREATE TABLE box_feedbacks
(
    ID        SERIAL NOT NULL,                            -- Identificador único do feedback.
    BOX_ID    INT    NOT NULL,                            -- Referência ao box.
    AUTHOR_ID INT    NOT NULL,                            -- Referência ao autor do feedback (perfil).
    CONTENT   TEXT   NOT NULL,                            -- Conteúdo textual do feedback.
    STARS     INT    NOT NULL,                            -- Avaliação (ex.: 1-5 estrelas).

    CONSTRAINT pk_box_feedbacks PRIMARY KEY (ID),         -- Define a chave primária.
    CONSTRAINT fk_box_feedbacks_on_boxes FOREIGN KEY (BOX_ID) -- Chave estrangeira para boxes.
        REFERENCES boxes (ID),
    CONSTRAINT fk_box_feedbacks_on_author FOREIGN KEY (AUTHOR_ID) -- Chave estrangeira para profiles.
        REFERENCES profiles (ID)
);

CREATE INDEX idx_box_feedbacks_box_id ON box_feedbacks (BOX_ID); -- Índice para consultants rápidas por box.
