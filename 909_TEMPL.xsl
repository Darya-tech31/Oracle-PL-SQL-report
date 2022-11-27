<?xml version="1.0"?>
<?mso-application progid="Excel.Sheet"?>
 <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="urn:schemas-microsoft-com:office:spreadsheet"
  xmlns:o="urn:schemas-microsoft-com:office:office" 
  xmlns:x="urn:schemas-microsoft-com:office:excel"
  xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
<xsl:template match="/">
<xsl:processing-instruction name="mso-application">
  <xsl:text>progid="Excel.Sheet"</xsl:text>
</xsl:processing-instruction>
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
  <AllowPNG/>
 </OfficeDocumentSettings>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <WindowHeight>11460</WindowHeight>
  <WindowWidth>19200</WindowWidth>
  <WindowTopX>0</WindowTopX>
  <WindowTopY>0</WindowTopY>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:CharSet="204" x:Family="Swiss" ss:Size="11"
    ss:Color="#000000"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s62">
   <Font ss:FontName="Calibri" x:CharSet="204" x:Family="Swiss" ss:Size="14"
    ss:Color="#000000" ss:Bold="1"/>
  </Style>
  <Style ss:ID="s64">
   <Font ss:FontName="Calibri" x:CharSet="204" x:Family="Swiss" ss:Size="14"
    ss:Color="#000000"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
   </Borders>
  </Style>
  <Style ss:ID="s65">
   <Font ss:FontName="Calibri" x:CharSet="204" x:Family="Swiss" ss:Size="11"
    ss:Color="#000000" ss:Bold="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>
   </Borders>
  </Style>
 </Styles>
 <Worksheet ss:Name="Лист1">
  <Table x:FullColumns="1" x:FullRows="1" ss:DefaultRowHeight="20">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="120"/>
   <Column ss:AutoFitWidth="0" ss:Width="700"/>
   <Column ss:AutoFitWidth="0" ss:Width="250"/>
   <Column ss:AutoFitWidth="0" ss:Width="100"/>
   <Column ss:AutoFitWidth="0" ss:Width="140"/>
   <Row ss:Index="2" ss:Height="18.75">
    <Cell ss:Index="2"><Data ss:Type="String"><xsl:value-of select="//V_NAME"/></Data></Cell> <!-- Поле 9 -->
   </Row>
   <Row ss:Height="18.75">
    <Cell ss:Index="3" ss:StyleID="s62"><Data ss:Type="String">Отчет</Data></Cell>
   </Row>
   <Row ss:Height="18.75">
    <Cell ss:Index="2"><Data ss:Type="String">Книга</Data></Cell>
    <Cell><Data ss:Type="String"><xsl:value-of select="//V_BOOK_TYPE_CODE"/></Data></Cell> <!-- Поле 6 -->
    <Cell ss:Index="5"><Data ss:Type="String">Дата</Data></Cell>
    <Cell><Data ss:Type="String"><xsl:value-of select="//V_DATE"/></Data></Cell> <!-- Поле 8 -->
   </Row>
   <Row ss:Height="18.75">
    <Cell ss:Index="2"><Data ss:Type="String">Период</Data></Cell> 
    <Cell><Data ss:Type="String"><xsl:value-of select="//V_PERIOD_NAME"/></Data></Cell> <!-- Поле 7 -->
   </Row>
   <Row>
    <Cell ss:StyleID="s65"><Data ss:Type="String">№ п/п</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">Инв.номер</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">Описание</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">Работник</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">Расположение</Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String">Категория</Data></Cell>
   </Row>
   <xsl:for-each select="//LINES_BLOCK">
   <Row ss:Height="18.75">
    <Cell ss:StyleID="s64"><Data ss:Type="String"><xsl:value-of select="RN"/></Data></Cell> <!-- Порядковый номер -->
    <Cell ss:StyleID="s64"><Data ss:Type="String"><xsl:value-of select="ASSET_NUMBER"/></Data></Cell> <!-- Поле 1 -->
    <Cell ss:StyleID="s64"><Data ss:Type="String"><xsl:value-of select="DESCRIPTION"/></Data></Cell> <!-- Поле 2 -->
    <Cell ss:StyleID="s64"><Data ss:Type="String"><xsl:value-of select="NAME"/></Data></Cell> <!-- Поле 3 -->
    <Cell ss:StyleID="s64"><Data ss:Type="String"><xsl:value-of select="SEGM12"/></Data></Cell> <!-- Поле 4 -->
    <Cell ss:StyleID="s64"><Data ss:Type="String"><xsl:value-of select="ATTRIBUTE_CATEGORY_CODE"/></Data></Cell> <!-- Поле 5 -->
   </Row>
   </xsl:for-each>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>600</HorizontalResolution>
    <VerticalResolution>600</VerticalResolution>
   </Print>
   <Selected/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>14</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
</Workbook>
</xsl:template>
</xsl:stylesheet>
