CREATE OR REPLACE PACKAGE XX_909_PKG IS
    -- Purpose : Отчет:

    -----------------------------------------------------------------------------
    -- Процедура ручного запуска.
    -----------------------------------------------------------------------------
    PROCEDURE main( p_errbuf              OUT NOCOPY VARCHAR2                                        -- Описание ошибки
                    , p_retcode           OUT NOCOPY VARCHAR2                                        -- Код ошибки
                    , p_ou                IN         NUMBER                                          -- Операционная единица
                    , p_book              IN         VARCHAR                                         -- Книга
                  );
END XX_BK909_PKG;
/
CREATE OR REPLACE PACKAGE BODY XX_909_PKG IS

    -- Отчет: 
    g_org_id           CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'ORG_ID' ) );                        -- Операционная единица на пользователе минуя профиль защиты
    g_resp_id          CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'RESP_ID' ) );                       -- Полномочие
    g_user_id          CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'USER_ID' ) );                       -- Пользователь
    g_login_id         CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'LOGIN_ID' ) );                      -- Логин
    g_mfg_org          CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'MFG_ORGANIZATION_ID' ) );           -- Текущая организация
    g_ou_security      CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'XLA_MO_SECURITY_PROFILE_LEVEL' ) ); -- Профиль защиты операционных единиц
    g_org_security     CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'PER_SECURITY_PROFILE_ID' ) );       -- Профиль защиты организаций

    g_nls              CONSTANT VARCHAR2( 4 )  := '.,';                                                            -- Требуемый nls для отчёта

    -----------------------------------------------------------------------------
    -- Процедура формирования XML-файла
    -----------------------------------------------------------------------------
    PROCEDURE create_xml( p_ou                  IN         NUMBER                                          -- Операционная единица
                          , p_book              IN         VARCHAR                                         -- Книга
                        )
    is
           v_nls                 VARCHAR2( 16 );                                                         -- Настройки nls для чисел
           v_book_type_code      VARCHAR2( 16 );
           v_date                VARCHAR2( 12 );
           v_period_name         VARCHAR2 (12);
           v_name                apps.xxpha_ouq_vq.name%type;                                               -- Наименование операционной единицы

     BEGIN

        xxpha_log( 'Запуск процедуры create_xml.', 'T' );

        xxpha_log( 'Запоминаем установленные nls-параметры.', 'T' );
        -- Под разными полномочиями разные nls-параметры. Приводим всё к одним.
        -- Запоминаем установленные nls-параметры

     BEGIN
            SELECT
                t.value
            INTO
                v_nls -- Параметры для nls для сессии по умолчанию
            FROM
                v$nls_parametersq t
            WHERE
                1 = 1
                and t.parameter = 'NLS_NUMERIC_CHARACTERS';
      EXCEPTION when others then
            xxpha_log( ' ', 'E' );
            xxpha_log( 'Ошибка: не найдены настройки nls.', 'T' );
            return; -- нет смысла работать дальше
      END;

        xxpha_log( 'Ставим нужные для отчёта nls-параметры.', 'T' );
        -- Под разными полномочиями разные nls-параметры. Приводим всё к одним.
        -- ставим нужные для отчёта
        BEGIN
            execute immediate 'alter session set nls_numeric_characters = ''' || g_nls || '''';
            xxpha_log( 'SQL = ' || '''alter session set nls_numeric_characters = ''' || g_nls || '''''', 'T' );
        EXCEPTION when others then
            xxpha_log( ' ', 'E' );
            xxpha_log( 'Ошибка установки nls.', 'T' );
        END;


        v_book_type_code := substr(p_book, 1, instr( p_book, '_', -1  )-1 );

        v_date := TO_CHAR(Sysdate, 'DD.MM.YYYY');


        BEGIN
            SELECT
                v.name
            INTO
                v_name -- Наименование операционной единицы
            FROM
                -------------------------
            WHERE
                1 = 1
                and v.organization_id = p_ou;
        EXCEPTION when others then
            xxpha_log( ' ', 'E' );
            xxpha_log( 'Ошибка: не найдена операционная единица.', 'T' );
        END;

        BEGIN
          SELECT  -- Текущий период -- поле 7 --
             fdp.period_name
         INTO
             v_period_name
         FROM
            ---------------------------

         WHERE   fdp.book_type_code = p_book
              and fdp.period_close_date is null;
         END;

        -- Начало создания xml-файла
        xxpha_bild_xml_pkg.init_xml;

       -- Книга -- поле 6 --
        xxpha_bild_xml_pkg.print_tag( 'V_BOOK_TYPE_CODE', V_BOOK_TYPE_CODE );

        -- Текущий период -- поле 7 --
        xxpha_bild_xml_pkg.print_tag( 'V_PERIOD_NAME', V_PERIOD_NAME );

        -- Дата -- поле 8 --
        xxpha_bild_xml_pkg.print_tag( 'V_DATE', V_DATE );

        -- Наименование операционной единицы -- поле 9 --
        xxpha_bild_xml_pkg.print_tag( 'V_NAME', V_NAME );

        for bk in ( SELECT
                        a.asset_id
                        , a.asset_number 
                        , a.description
                        , a.name
                        , a.segm12
                        , a.attribute_category_code
                        , row_number() over( order by a.segm12 asc, a.attribute_category_code asc, a.asset_number asc) rn
                    FROM------------------------
                        (   SELECT
                                distinct fdh.asset_id
                                , fav.asset_number                                  -- № Актива
                                , fav.description                                   -- Описание
                                , fe.name                                           -- Работник
                                , (fl.segment1 || '.' ||  fl.segment2) as segm12    -- Расположение
                                , fav.attribute_category_code -- Категория
                            FROM
                             --------------------------------- фрагмент
                    ORDER BY
                        a.segm12
                        , a.attribute_category_code asc
                        , a.asset_number asc
                  )
        loop
            -- Открытие блока строк
            xxpha_bild_xml_pkg.open_block( 'LINES_BLOCK' );
                                
            -- Порядковый номер --
            xxpha_bild_xml_pkg.print_tag( 'RN', bk.RN );

            -- № Актива -- поле 1 --
            xxpha_bild_xml_pkg.print_tag( 'ASSET_NUMBER', bk.ASSET_NUMBER );
------------------------фрагмент---------------

        -- Конец создания xml-файла
        xxpha_bild_xml_pkg.close_xml;

        xxpha_log( 'Возвращаем сохранённые nls-параметры.', 'T' );
        -- Под разными полномочиями разные nls-параметры. Приводим всё к одним.
        -- возвращаем сохранённые
        BEGIN
            execute immediate 'alter session set nls_numeric_characters = ''' || v_nls || '''';
            xxpha_log('SQL = ' || '''alter session set nls_numeric_characters = ''' || v_nls || '''''', 'T' );
        EXCEPTION when others then
            xxpha_log( ' ', 'E' );
            xxpha_log( 'Ошибка возврата nls.', 'T' );
        END;

    EXCEPTION when others then
        xxpha_log( 'Ошибка в работе процедуры create_xml.', 'T' );
        xxpha_log( ' ', 'E' );


    END create_xml;

    -----------------------------------------------------------------------------
    -- Процедура ручного запуска. из спецификации
    -----------------------------------------------------------------------------
    PROCEDURE main( p_errbuf              OUT NOCOPY VARCHAR2                                        -- Описание ошибки
                    , p_retcode           OUT NOCOPY VARCHAR2                                        -- Код ошибки
                    , p_ou                IN         NUMBER                                          -- операционная единица
                    , p_book              IN         VARCHAR                                         -- Книга
                  )
    is


        v_instance_name       VARCHAR2( 256 );                                                       -- Имя экземпляра, на котором запущена параллельная программа
    BEGIN

        xxpha_log( 'Входные параметры:', 'T' );
        xxpha_log( 'p_ou                                  => ' || p_ou, 'T' );    -- параметры Операционная единица
        xxpha_log( 'p_book                                => ' || p_book, 'T' );  -- параметры Книга

        xxpha_log( 'Полномочия                          => ' || g_resp_id, 'T' );
        xxpha_log( ' ', 'S' );
        xxpha_log( 'Операционная единица                => ' || g_org_id, 'T' );
        xxpha_log( 'Пользователь                        => ' || g_user_id, 'T' );
        xxpha_log( 'Логин                               => ' || g_login_id, 'T' );
        xxpha_log( 'Организация                         => ' || g_mfg_org, 'T' );
        xxpha_log( 'Профиль защиты операционная единица => ' || g_ou_security, 'T' );
        xxpha_log( 'Профиль защиты организация          => ' || g_org_security, 'T' );

      -----------------------------фрагмент-----------------------

        -- Настройка параметров возврата
        p_errbuf  := '';
        p_retcode := '0';

        -- Процедура формирования XML-файла
        create_xml( p_ou                => p_ou                                                       -- Идентификатор операционной единицы
                    , p_book            => p_book                                                     -- Идентификатор  книга
                  );

        xxpha_log( ' ' );


    EXCEPTION when others then
        p_errbuf  := sqlerrm;
        p_retcode := '2'; -- Ошибка
        xxpha_log( ' ', 'E' );
    END main;

END XX_909_PKG;
/
SHOW ERRORS
