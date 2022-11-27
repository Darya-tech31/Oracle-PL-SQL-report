CREATE OR REPLACE PACKAGE XX_909_PKG IS
    -- Purpose : �����:

    -----------------------------------------------------------------------------
    -- ��������� ������� �������.
    -----------------------------------------------------------------------------
    PROCEDURE main( p_errbuf              OUT NOCOPY VARCHAR2                                        -- �������� ������
                    , p_retcode           OUT NOCOPY VARCHAR2                                        -- ��� ������
                    , p_ou                IN         NUMBER                                          -- ������������ �������
                    , p_book              IN         VARCHAR                                         -- �����
                  );
END XX_BK909_PKG;
/
CREATE OR REPLACE PACKAGE BODY XX_909_PKG IS

    -- �����: 
    g_org_id           CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'ORG_ID' ) );                        -- ������������ ������� �� ������������ ����� ������� ������
    g_resp_id          CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'RESP_ID' ) );                       -- ����������
    g_user_id          CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'USER_ID' ) );                       -- ������������
    g_login_id         CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'LOGIN_ID' ) );                      -- �����
    g_mfg_org          CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'MFG_ORGANIZATION_ID' ) );           -- ������� �����������
    g_ou_security      CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'XLA_MO_SECURITY_PROFILE_LEVEL' ) ); -- ������� ������ ������������ ������
    g_org_security     CONSTANT NUMBER := xxpha_to_number( fnd_profile.value( 'PER_SECURITY_PROFILE_ID' ) );       -- ������� ������ �����������

    g_nls              CONSTANT VARCHAR2( 4 )  := '.,';                                                            -- ��������� nls ��� ������

    -----------------------------------------------------------------------------
    -- ��������� ������������ XML-�����
    -----------------------------------------------------------------------------
    PROCEDURE create_xml( p_ou                  IN         NUMBER                                          -- ������������ �������
                          , p_book              IN         VARCHAR                                         -- �����
                        )
    is
           v_nls                 VARCHAR2( 16 );                                                         -- ��������� nls ��� �����
           v_book_type_code      VARCHAR2( 16 );
           v_date                VARCHAR2( 12 );
           v_period_name         VARCHAR2 (12);
           v_name                apps.xxpha_ouq_vq.name%type;                                               -- ������������ ������������ �������

     BEGIN

        xxpha_log( '������ ��������� create_xml.', 'T' );

        xxpha_log( '���������� ������������� nls-���������.', 'T' );
        -- ��� ������� ������������ ������ nls-���������. �������� �� � �����.
        -- ���������� ������������� nls-���������

     BEGIN
            SELECT
                t.value
            INTO
                v_nls -- ��������� ��� nls ��� ������ �� ���������
            FROM
                v$nls_parametersq t
            WHERE
                1 = 1
                and t.parameter = 'NLS_NUMERIC_CHARACTERS';
      EXCEPTION when others then
            xxpha_log( ' ', 'E' );
            xxpha_log( '������: �� ������� ��������� nls.', 'T' );
            return; -- ��� ������ �������� ������
      END;

        xxpha_log( '������ ������ ��� ������ nls-���������.', 'T' );
        -- ��� ������� ������������ ������ nls-���������. �������� �� � �����.
        -- ������ ������ ��� ������
        BEGIN
            execute immediate 'alter session set nls_numeric_characters = ''' || g_nls || '''';
            xxpha_log( 'SQL = ' || '''alter session set nls_numeric_characters = ''' || g_nls || '''''', 'T' );
        EXCEPTION when others then
            xxpha_log( ' ', 'E' );
            xxpha_log( '������ ��������� nls.', 'T' );
        END;


        v_book_type_code := substr(p_book, 1, instr( p_book, '_', -1  )-1 );

        v_date := TO_CHAR(Sysdate, 'DD.MM.YYYY');


        BEGIN
            SELECT
                v.name
            INTO
                v_name -- ������������ ������������ �������
            FROM
                -------------------------
            WHERE
                1 = 1
                and v.organization_id = p_ou;
        EXCEPTION when others then
            xxpha_log( ' ', 'E' );
            xxpha_log( '������: �� ������� ������������ �������.', 'T' );
        END;

        BEGIN
          SELECT  -- ������� ������ -- ���� 7 --
             fdp.period_name
         INTO
             v_period_name
         FROM
            ---------------------------

         WHERE   fdp.book_type_code = p_book
              and fdp.period_close_date is null;
         END;

        -- ������ �������� xml-�����
        xxpha_bild_xml_pkg.init_xml;

       -- ����� -- ���� 6 --
        xxpha_bild_xml_pkg.print_tag( 'V_BOOK_TYPE_CODE', V_BOOK_TYPE_CODE );

        -- ������� ������ -- ���� 7 --
        xxpha_bild_xml_pkg.print_tag( 'V_PERIOD_NAME', V_PERIOD_NAME );

        -- ���� -- ���� 8 --
        xxpha_bild_xml_pkg.print_tag( 'V_DATE', V_DATE );

        -- ������������ ������������ ������� -- ���� 9 --
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
                                , fav.asset_number                                  -- � ������
                                , fav.description                                   -- ��������
                                , fe.name                                           -- ��������
                                , (fl.segment1 || '.' ||  fl.segment2) as segm12    -- ������������
                                , fav.attribute_category_code -- ���������
                            FROM
                             --------------------------------- ��������
                    ORDER BY
                        a.segm12
                        , a.attribute_category_code asc
                        , a.asset_number asc
                  )
        loop
            -- �������� ����� �����
            xxpha_bild_xml_pkg.open_block( 'LINES_BLOCK' );
                                
            -- ���������� ����� --
            xxpha_bild_xml_pkg.print_tag( 'RN', bk.RN );

            -- � ������ -- ���� 1 --
            xxpha_bild_xml_pkg.print_tag( 'ASSET_NUMBER', bk.ASSET_NUMBER );
------------------------��������---------------

        -- ����� �������� xml-�����
        xxpha_bild_xml_pkg.close_xml;

        xxpha_log( '���������� ���������� nls-���������.', 'T' );
        -- ��� ������� ������������ ������ nls-���������. �������� �� � �����.
        -- ���������� ����������
        BEGIN
            execute immediate 'alter session set nls_numeric_characters = ''' || v_nls || '''';
            xxpha_log('SQL = ' || '''alter session set nls_numeric_characters = ''' || v_nls || '''''', 'T' );
        EXCEPTION when others then
            xxpha_log( ' ', 'E' );
            xxpha_log( '������ �������� nls.', 'T' );
        END;

    EXCEPTION when others then
        xxpha_log( '������ � ������ ��������� create_xml.', 'T' );
        xxpha_log( ' ', 'E' );


    END create_xml;

    -----------------------------------------------------------------------------
    -- ��������� ������� �������. �� ������������
    -----------------------------------------------------------------------------
    PROCEDURE main( p_errbuf              OUT NOCOPY VARCHAR2                                        -- �������� ������
                    , p_retcode           OUT NOCOPY VARCHAR2                                        -- ��� ������
                    , p_ou                IN         NUMBER                                          -- ������������ �������
                    , p_book              IN         VARCHAR                                         -- �����
                  )
    is


        v_instance_name       VARCHAR2( 256 );                                                       -- ��� ����������, �� ������� �������� ������������ ���������
    BEGIN

        xxpha_log( '������� ���������:', 'T' );
        xxpha_log( 'p_ou                                  => ' || p_ou, 'T' );    -- ��������� ������������ �������
        xxpha_log( 'p_book                                => ' || p_book, 'T' );  -- ��������� �����

        xxpha_log( '����������                          => ' || g_resp_id, 'T' );
        xxpha_log( ' ', 'S' );
        xxpha_log( '������������ �������                => ' || g_org_id, 'T' );
        xxpha_log( '������������                        => ' || g_user_id, 'T' );
        xxpha_log( '�����                               => ' || g_login_id, 'T' );
        xxpha_log( '�����������                         => ' || g_mfg_org, 'T' );
        xxpha_log( '������� ������ ������������ ������� => ' || g_ou_security, 'T' );
        xxpha_log( '������� ������ �����������          => ' || g_org_security, 'T' );

      -----------------------------��������-----------------------

        -- ��������� ���������� ��������
        p_errbuf  := '';
        p_retcode := '0';

        -- ��������� ������������ XML-�����
        create_xml( p_ou                => p_ou                                                       -- ������������� ������������ �������
                    , p_book            => p_book                                                     -- �������������  �����
                  );

        xxpha_log( ' ' );


    EXCEPTION when others then
        p_errbuf  := sqlerrm;
        p_retcode := '2'; -- ������
        xxpha_log( ' ', 'E' );
    END main;

END XX_909_PKG;
/
SHOW ERRORS
