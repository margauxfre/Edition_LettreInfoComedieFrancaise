<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" version="2.0">

    <!-- on configure une sortie HTMl -->
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <!-- régularisation des espaces -->
    <!--<xsl:strip-space elements="*"/>-->

    <xsl:template match="/">
        <!-- mise en place des variables -->
        <!-- variables pour les fichiers de sortie, une variable par page HTML -->
        <!-- les variables semblant prendre le chemin absolu, il faut sûrement regénérer une transformation XSL après avoir cloné le dépot pour le bon fonctionnement des liens-->
        <xsl:variable name="witfile">
            <xsl:value-of select="replace(base-uri(.), 'Lettre_info_vol_CF_1786.xml', '')"/>
        </xsl:variable>
        <xsl:variable name="path_accueil">
            <xsl:value-of select="concat($witfile, 'html/accueil', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_personnes_index">
            <xsl:value-of select="concat($witfile, 'html/indexpersonnes', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_lieux_index">
            <xsl:value-of select="concat($witfile, 'html/indexlieux', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_organisations_index">
            <xsl:value-of select="concat($witfile, 'html/indexorganisations', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_texte_diplomatique">
            <xsl:value-of select="concat($witfile, 'html/versiondiplomatique', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_texte_modernise">
            <xsl:value-of select="concat($witfile, 'html/versioncorrigee', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_tableau_personnes">
            <xsl:value-of select="concat($witfile, 'html/tableaupersonnes', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_tableau_lieux">
            <xsl:value-of select="concat($witfile, 'html/tableaulieux', '.html')"/>
        </xsl:variable>

        <!-- variables d'éléments utilisés fréquemment -->
        <!-- variables qui sélectionnent des éléments dans le fichier TEI -->
        <xsl:variable name="titre">
            <xsl:value-of select="//titleStmt/title"/>
        </xsl:variable>
        <xsl:variable name="auteur">
            <xsl:value-of select="concat(//editionStmt//forename, ' ', //editionStmt//surname)"/>
        </xsl:variable>
        <!-- variables pour reproduire la structure HTML sur toutes les pages -->
        <xsl:variable name="meta">
            <meta charset="UTF-8"/>
            <meta name="description" content="Edition numérique - {$titre}"/>
            <meta name="author" content="{$auteur}"/>
            <link
                href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/css/bootstrap.min.css"
                rel="stylesheet"
                integrity="sha384-eOJMYsd53ii+scO/bJGFsiCZc+5NDVN2yr8+0RDqr0Ql0h+rP48ckxlpbzKgwra6"
                crossorigin="anonymous"/>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta3/dist/js/bootstrap.bundle.min.js" integrity="sha384-JEW9xMcG8R+pH31jmWH6WWP0WintQrMb4s7ZOdauHnUtxwoG2vI5DkLtS3qm9Ekf" crossorigin="anonymous"/>
        </xsl:variable>
        <xsl:variable name="footer">
            <br/>
            <footer class="fixed-bottom" style="background-color:grey">
                <div style="text-align:center;">
                    <p style="font-size:14px">© <xsl:copy-of select="$auteur"/>, Master 2
                        "Technologies numériques appliquées à l'histoire", 2022</p>
                </div>
            </footer>
        </xsl:variable>


        <!-- on met en place la page d'accueil -->
        <xsl:result-document href="{$path_accueil}" method="html" indent="yes">
            <html>
                <head>
                    <!-- on appelle la variable pour injecter les métadonnées -->
                    <xsl:copy-of select="$meta"/>
                    <title>
                        <xsl:value-of select="concat($titre, ' | ', 'Accueil')"/>
                    </title>
                </head>
                <body>
                    <!-- on insère la barre de navigation ici -->
                    <xsl:call-template name="navbar"/>
                    <div class="container" style="text-align:justify">
                        <h2 style="text-align:center">Projet d'édition numérique - <xsl:value-of
                                select="$titre"/>, réalisé par <xsl:value-of select="$auteur"/></h2>
                        <br/>
                        <h2 style="text-align:center">Accueil</h2>
                        <div>
                            <p>Bienvenue sur l'édition numérique d'une <xsl:value-of
                                    select="concat(lower-case(substring($titre, 1, 1)), substring($titre, 2))"
                                />, datée des <xsl:value-of select="//msDesc/head/date"/>.</p>
                            <p>Ce projet a été réalisé dans le cadre du cours de XSLT donné à
                                l'École nationale des chartes pour le master "Technologies
                                numériques appliquées à l'histoire" (2021-2022). L'encodage de la
                                source a été lui réalisé pour le cours de XML-TEI.</p>
                            <p>L'objectif de ce projet est de pouvoir proposer à la fois une
                                transcription du document original et une version correspondant aux
                                normes de l'orthographe contemporaine. En ce sens, la transformation
                                vers le HTML tend à faire ressortir au mieux les règles de
                                transcription et d'édition suivies tout en respectant l'aspect
                                matériel de la source : <ul>
                                    <li>Chaque changement de page est mentionné.</li>
                                    <li>Les mots barrés dans le texte sont balisés par l'élément
                                        HTML <code>del</code></li>
                                    <li>Les passages illisibles sont signalés entre crochets et en
                                        italique. Le nombre de caractères ou de mots manquants est
                                        précisé. Si le passage illisible est barré, il l'est
                                        également dans la transcription.</li>
                                    <li>Les signatures présentes dans le document apparaissent à
                                        droite, en italique.</li>
                                    <li>Les abréviations en exposant sont conservées dans la
                                        transcription.</li>
                                    <li>Les exclamations des déclarants qui n'ont pas été
                                        transcrites dans une forme indirecte par le clerc du
                                        commissaire sont marquées par l'ajout de guillemets.</li>
                                </ul>
                            </p>
                        </div>
                        <div>
                            <h5 style="text-align:center">Pour consulter le texte, cliquez sur l'un
                                des deux boutons ci-dessous :</h5>
                            <div class="row text-center" style="place-content:center">
                                <div class="col-md-2">
                                    <button type="button" class="btn">
                                        <a href="{$path_texte_diplomatique}" style="color: black;"
                                            >Version originale du texte</a>
                                    </button>
                                </div>
                                <div class="col-md-2">
                                    <button type="button" class="btn">
                                        <a href="{$path_texte_modernise}" style="color: black;"
                                            >Version modernisée du texte</a>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- on utilise les données du teiHeader pour présenter la source -->
                        <div>
                            <h3>Description de la source</h3>
                            <dl>
                                <dt>Lieu de conservation :</dt>
                                <dd>
                                    <xsl:value-of select="concat(//institution, ', ', //repository)"
                                    />
                                </dd>
                                <dt>Cote :</dt>
                                <dd>
                                    <xsl:value-of select="//msIdentifier/idno"/>
                                </dd>
                                <dt>Titre du document :</dt>
                                <dd>
                                    <xsl:value-of select="//head/title"/>
                                </dd>
                                <dt>Support :</dt>
                                <dd>
                                    <xsl:variable name="support">
                                        <xsl:value-of select="//support/text()"/>
                                    </xsl:variable>
                                    <xsl:value-of
                                        select="concat($support, ', ', //foliation/text())"/>
                                </dd>
                                <dt>Producteur :</dt>
                                <dd>
                                    <xsl:value-of
                                        select="concat(//msItem/respStmt/orgName, ' (', //origin, ')')"
                                    />
                                </dd>
                                <dd>
                                    <xsl:value-of select="//provenance/p[1]"/>
                                </dd>
                            </dl>
                        </div>
                        <div>
                            <h3>Contexte sur la production de la source</h3>
                            <p>
                                <xsl:value-of select="//respStmt[2]/note"/>
                            </p>
                        </div>
                        <div>
                            <h3>Bibliographie</h3>
                            <ul>
                                <xsl:for-each select="//teiHeader//bibl">
                                    <li style="text-align:start;">
                                        <xsl:value-of select="."/>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </div>
                </body>
                <!-- on insère la variable contenant le footer -->
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>

        <!-- page pour l'index des individus mentionnés dans le texte -->
        <xsl:result-document href="{$path_personnes_index}" method="html" indent="yes">
            <html>
                <head>
                    <xsl:copy-of select="$meta"/>
                    <title>
                        <xsl:value-of select="concat($titre, ' | ', 'Index des personnes')"/>
                    </title>
                </head>
                <body>
                    <xsl:call-template name="navbar"/>
                    <div class="container">
                        <h2>Index des personnes</h2>
                        <xsl:element name="dl">
                            <!-- pour chaque personne dans l'index de la TEI, on récupère le nom et le texte en note et on les insère dans des balises HTML -->
                            <xsl:for-each select="//listPerson/person">

                                <xsl:sort select="persName" order="ascending"/>
                                <xsl:variable name="PersonID">
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:variable>
                                <xsl:element name="dl">
                                    <xsl:element name="dt">
                                        <xsl:value-of select="persName/text()"/>
                                    </xsl:element>
                                    <xsl:element name="dd">
                                        <xsl:value-of select="note/text()"/>
                                    </xsl:element>
                                    <!-- pour donner des informations sur les fréquences de mention des individus -->
                                    <!-- pour compter le nombre de mentions de chaque individu  -->
                                    <xsl:element name="dd">
                                        <xsl:text>Nombre de mentions dans le texte : </xsl:text>
                                        <xsl:value-of
                                            select="count(ancestor::TEI//body//persName[replace(@ref, '#', '') = $PersonID])"
                                        />
                                    </xsl:element>
                                    <!-- pour afficher les pages où chaque individu est mentionné -->
                                    <xsl:element name="dd">
                                        <xsl:text>Page(s) où l'individu est mentionné : </xsl:text>
                                        <xsl:for-each
                                            select="ancestor::TEI//body//persName[replace(@ref, '#', '') = $PersonID]">
                                            <xsl:value-of select="count(preceding::pb/@n)"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                                <!-- on crée un lien qui envoie directement sur la déclaration faite par l'individu, dans le texte normalisé -->
                                <xsl:for-each
                                    select="ancestor::TEI//div[replace(@corresp, '#', '') = $PersonID]">
                                    <p>
                                        <xsl:text>Voir sa déclaration </xsl:text>
                                        <xsl:element name="a">
                                            <xsl:attribute name="href">
                                                <xsl:value-of
                                                  select="concat($path_texte_modernise, '#', count(preceding::div/@corresp) + 1)"
                                                />
                                            </xsl:attribute>
                                            <xsl:text>ici</xsl:text>
                                        </xsl:element>
                                    </p>
                                </xsl:for-each>
                            </xsl:for-each>

                        </xsl:element>
                    </div>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>

        <!-- page pour l'index des lieux -->
        <xsl:result-document href="{$path_lieux_index}" method="html" indent="yes">
            <html>
                <head>
                    <xsl:copy-of select="$meta"/>
                    <title>
                        <xsl:value-of select="concat($titre, ' | ', 'Index des lieux')"/>
                    </title>
                </head>
                <body>
                    <xsl:call-template name="navbar"/>
                    <div class="container">
                        <h2>Index des lieux</h2>
                        <xsl:element name="dl">
                            <xsl:for-each select="//listPlace/place">
                                <xsl:sort select="placeName" order="ascending"/>
                                <xsl:variable name="PlaceID">
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:variable>
                                <xsl:element name="dt">
                                    <xsl:value-of select="placeName/text()"/>
                                </xsl:element>
                                <xsl:element name="dd">
                                    <xsl:value-of select="note/text()"/>
                                    <xsl:element name="a">
                                        <xsl:attribute name="href"
                                            >https://gallica.bnf.fr/ark:/12148/btv1b69358230/f40.item</xsl:attribute>
                                        <xsl:value-of select="note/bibl/text()"/>
                                    </xsl:element>
                                </xsl:element>
                                <!-- pour donner des informations sur les fréquences de mention des individus -->
                                <!-- pour compter le nombre de mentions de chaque lieu  -->
                                <xsl:element name="dd">
                                    <xsl:text>Nombre de mentions dans le texte : </xsl:text>
                                    <xsl:value-of
                                        select="count(ancestor::TEI//body//placeName[replace(@ref, '#', '') = $PlaceID])"
                                    />
                                </xsl:element>
                                <!-- pour afficher les pages où chaque lieu est mentionné -->
                                <xsl:element name="dd">
                                    <xsl:text>Page(s) où le lieu est mentionné : </xsl:text>
                                    <xsl:for-each
                                        select="ancestor::TEI//body//placeName[replace(@ref, '#', '') = $PlaceID]">
                                        <xsl:value-of select="count(preceding::pb/@n)"/>
                                        <xsl:if test="position() != last()">
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </div>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>

        <!-- page pour l'index des organisations -->
        <xsl:result-document href="{$path_organisations_index}" method="html" indent="yes">
            <html>
                <head>
                    <xsl:copy-of select="$meta"/>
                    <title>
                        <xsl:value-of select="concat($titre, ' | ', 'Index des organisations')"/>
                    </title>
                </head>
                <body>
                    <xsl:call-template name="navbar"/>
                    <div class="container">
                        <h2>Index des organisations</h2>
                        <xsl:element name="dl">
                            <xsl:for-each select="//listOrg/org">
                                <xsl:sort select="orgName" order="ascending"/>
                                <xsl:variable name="OrgID">
                                    <xsl:value-of select="@xml:id"/>
                                </xsl:variable>
                                <xsl:variable name="Org-count">
                                    <xsl:value-of
                                        select="count(ancestor::TEI//body//orgName[replace(@ref, '#', '') = $OrgID])"
                                    />
                                </xsl:variable>
                                <xsl:element name="dt">
                                    <xsl:value-of select="orgName/text()"/>
                                </xsl:element>
                                <xsl:element name="dd">
                                    <xsl:value-of select="note/text()"/>
                                </xsl:element>
                                <!-- pour donner des informations sur les fréquences de mention des organisations -->
                                <!-- pour compter le nombre de mentions de chaque organisation  -->
                                <xsl:element name="dd">
                                    <xsl:text>Nombre de mentions dans le texte : </xsl:text>
                                    <xsl:value-of select="$Org-count"/>
                                </xsl:element>
                                <!-- pour afficher les pages où chaque organisation est mentionnée, si un @ref y renvoie dans le corps du texte -->
                                <!-- il a été décidé de faire également apparaitre dans l'index les éléments référencés dans les <teiHeader> et non dans le <body> car ceux-ci peuvent donner de précieux éléments de contexte sur le document -->
                                <xsl:element name="dd">
                                    <xsl:text>Page(s) où le lieu est mentionné : </xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="$Org-count != 0">
                                            <xsl:for-each
                                                select="ancestor::TEI//body//orgName[replace(@ref, '#', '') = $OrgID]">
                                                <xsl:value-of select="count(preceding::pb/@n)"/>
                                                <xsl:if test="position() != last()">
                                                  <xsl:text>, </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>L'organisation n'est pas mentionnée dans le document mais dans les métadonnées.</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </div>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>

        <!-- page pour afficher le texte dans sa version originale -->
        <xsl:result-document href="{$path_texte_diplomatique}" method="html" indent="yes">
            <html>
                <head>
                    <xsl:copy-of select="$meta"/>
                    <title>
                        <xsl:value-of select="concat($titre, ' | ', 'Version diplomatique')"/>
                    </title>
                </head>
                <body>
                    <xsl:call-template name="navbar"/>
                    <div class="container">
                        <h1 style="text-align:center">Transcription originale du texte</h1>
                        <div style="padding-left:150px; padding-right:150px; text-align:justify;">
                            <xsl:apply-templates select="//text" mode="version-diplomatique"/>
                        </div>
                    </div>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>

        <!-- page pour afficher le texte dans sa version modernisée -->
        <xsl:result-document href="{$path_texte_modernise}" method="html" indent="yes">
            <html>
                <head>
                    <xsl:copy-of select="$meta"/>
                    <title>
                        <xsl:value-of select="concat($titre, ' | ', 'Version modernisée')"/>
                    </title>
                </head>
                <body>
                    <xsl:call-template name="navbar"/>
                    <div class="container">
                        <h1 style="text-align:center">Transcription modernisée du texte</h1>
                        <div style="padding-left:150px; padding-right:150px; text-align:justify;">
                            <xsl:apply-templates select="//text" mode="version-modernisee"/>
                        </div>
                    </div>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>

        <!-- page pour le tableau répertoriant les déclarants et les individus qu'ils mentionnent-->
        <xsl:result-document href="{$path_tableau_personnes}" method="html" indent="yes">
            <html>
                <head>
                    <xsl:copy-of select="$meta"/>
                    <title>
                        <xsl:value-of select="concat($titre, ' | ', 'Qui a vu qui ?')"/>
                    </title>
                </head>
                <body>
                    <xsl:call-template name="navbar"/>
                    <div class="container">
                        <h2 style="text-align:center">Qui a vu qui ?</h2>
                        <p style="text-align:justify">Les déclarations des différents témoins
                            offrent différentes versions de l'évènement. Celles-ci sont la matière
                            première du policier pour mener son enquête et rendre son jugement. Tous
                            les individus n'interviennent pas automatiquement au même moment ni même
                            ne se croisent sur le terrain. Aussi, ce tableau listant les individus
                            mentionnés par chaque comparant montre que, dans le cas présent, les
                            individus se sont pratiquement tous au moins aperçus. Les noms
                            apparaissent dans l'ordre de mention des individus par chacun.</p>
                        <table class="table table-bordered table-striped table-hover">
                            <th class="table-dark"> Nom du déclarant</th>
                            <th class="table-dark"> Individus mentionnés</th>
                            <tbody>
                                <!-- on définit une variable pour faire correspondre au xml:id de l'index en standOff -->
                                <xsl:for-each select="//div[@corresp]">
                                    <xsl:variable name="correspPerson">
                                        <xsl:value-of select="./replace(@corresp, '#', '')"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <!-- lorsque la variable correspond, on récupère le nom de la personne pour l'indiquer dans la cellule -->
                                            <!-- on boucle pour créer une nouvelle cellule à chaque égalité trouvée -->
                                            <xsl:for-each
                                                select="ancestor::TEI/standOff//person[@xml:id = $correspPerson]">
                                                <xsl:value-of select="persName"/>
                                            </xsl:for-each>
                                        </td>
                                        <td>
                                            <!-- on récupère les persName présents dans chaque div[@corresp] en les groupant par leur attribut @ref afin de dédoulonner-->
                                            <!-- on ne sélectionne pas les mentions de Fayet et Landelle, qui ne sont pas présents lors de l'évènement -->
                                            <xsl:for-each-group
                                                select=".//persName[@ref != '#Fayet' and @ref != '#PierreLandelle']"
                                                group-by="@ref">
                                                <!-- on définit une variable pour faire correspondre le ref au xml:id de l'index en standOff -->
                                                <xsl:variable name="refPerson">
                                                  <xsl:value-of select="replace(@ref, '#', '')"/>
                                                </xsl:variable>
                                                <!-- chaque fois que la variable correspond, on sélectionne le nom -->
                                                <xsl:for-each
                                                  select="ancestor::TEI/standOff//person[@xml:id = $refPerson]">
                                                  <xsl:choose>
                                                  <xsl:when test="@xml:id = $correspPerson">
                                                  <xsl:value-of select="persName"/> (présentation
                                                  personnelle de l'individu) </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="persName"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:for-each>
                                                <xsl:if test="position() != last()">
                                                  <br/>
                                                </xsl:if>
                                            </xsl:for-each-group>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>

        <!-- page pour afficher le tableau des déclarants et des lieux qu'ils mentionnent -->
        <xsl:result-document href="{$path_tableau_lieux}" method="html" indent="yes">
            <html>
                <head>
                    <xsl:copy-of select="$meta"/>
                    <title>
                        <xsl:value-of select="concat($titre, ' | ', 'Qui mentionne quel lieu ? ?')"
                        />
                    </title>
                </head>
                <body>
                    <xsl:call-template name="navbar"/>
                    <div class="container">
                        <h2 style="text-align:center">Qui mentionne quel lieu ?</h2>
                        <p style="text-align:justify">Ce tableau regroupe les différents lieux
                            mentionnés par les déclarants devant le commissaire de police.</p>
                        <table class="table table-bordered table-striped table-hover">
                            <th class="table-dark"> Nom du déclarant</th>
                            <th class="table-dark"> Lieux mentionnés</th>
                            <tbody>
                                <xsl:for-each select="//div[@corresp]">
                                    <xsl:variable name="correspPerson">
                                        <xsl:value-of select="./replace(@corresp, '#', '')"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <xsl:for-each
                                                select="ancestor::TEI/standOff//person[@xml:id = $correspPerson]">
                                                <xsl:value-of select="persName"/>
                                            </xsl:for-each>
                                        </td>
                                        <td>
                                            <xsl:for-each-group select=".//placeName[@ref]"
                                                group-by="@ref">
                                                <xsl:variable name="refPlace">
                                                  <xsl:value-of select="replace(@ref, '#', '')"/>
                                                </xsl:variable>
                                                <xsl:for-each
                                                  select="ancestor::TEI/standOff//place[@xml:id = $refPlace]">
                                                  <xsl:value-of select="placeName"/>

                                                </xsl:for-each>
                                                <xsl:if test="position() = 1">
                                                  <xsl:text> (domicile)</xsl:text>
                                                </xsl:if>
                                                <xsl:if test="position() != last()">
                                                  <br/>
                                                </xsl:if>
                                            </xsl:for-each-group>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </body>
                <xsl:copy-of select="$footer"/>
            </html>
        </xsl:result-document>
    </xsl:template>

    <!-- barre de navigation -->
    <!-- on définit les variables -->
    <xsl:template name="navbar">
        <xsl:variable name="witfile">
            <xsl:value-of select="replace(base-uri(.), 'Lettre_info_vol_CF_1786.xml', '')"/>
        </xsl:variable>
        <xsl:variable name="path_accueil">
            <xsl:value-of select="concat($witfile, 'html/accueil', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_personnes_index">
            <xsl:value-of select="concat($witfile, 'html/indexpersonnes', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_lieux_index">
            <xsl:value-of select="concat($witfile, 'html/indexlieux', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_organisations_index">
            <xsl:value-of select="concat($witfile, 'html/indexorganisations', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_texte_diplomatique">
            <xsl:value-of select="concat($witfile, 'html/versiondiplomatique', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_texte_modernise">
            <xsl:value-of select="concat($witfile, 'html/versioncorrigee', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_tableau_personnes">
            <xsl:value-of select="concat($witfile, 'html/tableaupersonnes', '.html')"/>
        </xsl:variable>
        <xsl:variable name="path_tableau_lieux">
            <xsl:value-of select="concat($witfile, 'html/tableaulieux', '.html')"/>
        </xsl:variable>

        <!-- mise en place du HTML -->
        <nav class="navbar navbar-expand-md navbar-dark bg-dark justify-content-between">
            <a class="navbar-brand" href="{$path_accueil}">Accueil</a>

            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link dropdown-toggle navbar-brand" href="#" id="navbarDropdown"
                        role="button" data-toggle="dropdown" aria-haspopup="true"
                        aria-expanded="false">Les index</a>
                    <ul class="dropdown-menu multi-level" role="menu" aria-labelledby="dropdownMenu">
                        <li class="dropdown-item">
                            <a href="{$path_personnes_index}">Index des personnes</a>
                        </li>
                        <li class="dropdown-item">
                            <a href="{$path_lieux_index}">Index des lieux</a>
                        </li>
                        <li class="dropdown-item">
                            <a href="{$path_organisations_index}">Index des organisations</a>
                        </li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link dropdown-toggle navbar-brand" href="#" id="navbarDropdown"
                        role="button" data-toggle="dropdown" aria-haspopup="true"
                        aria-expanded="false">Mener l'enquête</a>
                    <ul class="dropdown-menu multi-level" role="menu" aria-labelledby="dropdownMenu">
                        <li class="dropdown-item">
                            <a href="{$path_tableau_personnes}">Qui a vu qui ?</a>
                        </li>
                        <li class="dropdown-item">
                            <a href="{$path_tableau_lieux}">Qui mentionne quel lieu ?</a>
                        </li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="{$path_texte_diplomatique}">Transcription
                        diplomatique</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="{$path_texte_modernise}">Transcription modernisée</a>
                </li>
            </ul>
        </nav>

        <!-- pour permettre le bon fonctionnement des menus déroulants -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"/>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"/>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/js/bootstrap.min.js" integrity="sha384-h0AbiXch4ZDo7tp9hKZ4TsHbi047NrKGLO3SEJAg45jXxnGIfYzk4Si90RDIqNm1" crossorigin="anonymous"/>
    </xsl:template>

    <!-- pour afficher la version originale du texte -->
    <!-- on crée un élément html <sup> pour faire rétablir les caractères en exposant dans la source -->
    <xsl:template match="body//choice" mode="version-diplomatique">
        <xsl:value-of
            select="descendant::orig/text() | descendant::sic/text() | descendant::abbr/text()"/>
        <xsl:element name="sup">
            <xsl:value-of select="descendant::abbr/hi/text()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="body//corr" mode="version-diplomatique">
        <xsl:value-of select="descendant::orig/text()"/>
    </xsl:template>

    <!-- pour afficher la version modernisée -->
    <xsl:template match="body//choice" mode="version-modernisee">
        <xsl:value-of
            select="descendant::reg/text() | descendant::expan/text() | descendant::ex/text()"/>
    </xsl:template>

    <xsl:template match="body//corr" mode="version-modernisee">
        <xsl:value-of
            select="descendant::corr/text() | descendant::expan/text() | descendant::ex/text()"/>
    </xsl:template>

    <!-- pour rétablir les élocutions dans la version modernisée -->
    <xsl:template match="body//said" mode="version-modernisee">
        <xsl:text>"</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>"</xsl:text>
    </xsl:template>

    <!-- pour récupérer la mise en forme du texte -->
    <xsl:template match="body/head" mode="#all">
        <h3 style="font-style:bold; text-align:center;">
            <xsl:apply-templates mode="#current"/>
        </h3>
    </xsl:template>

    <xsl:template match="p" mode="#all">
        <p>
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>

    <!-- pour afficher le numéro du folio sur la gauche, en italique -->
    <xsl:template match="pb" mode="#all">
        <br/>
        <span style="text-align: left; font-style:italic;">
            <xsl:value-of select="pb"/>page n° <xsl:value-of select="@n"/></span>
        <br/>
    </xsl:template>

    <!-- pour afficher au centre quel individu est en train de faire sa déclaration devant le commissaire -->
    <xsl:template match="div[@corresp]" mode="#all">
        <xsl:variable name="refPerson">
            <xsl:value-of select="./replace(@corresp, '#', '')"/>
        </xsl:variable>
        <p style="text-align: center; font-style:italic;">
            <xsl:attribute name="id">
                <xsl:number count="div[@corresp]" format="1" level="any"/>
            </xsl:attribute> - Déclaration de <xsl:for-each
                select="ancestor::TEI/standOff//person[@xml:id = $refPerson]">
                <xsl:value-of select="persName"/>
            </xsl:for-each> -</p>
        <xsl:apply-templates mode="#current"/>
    </xsl:template>

    <!-- gestion des passages illisibles, balisés comme <unclear/> -->
    <!-- on fait apparaitre le nombre de mots ou charactères illisibles en italique -->
    <xsl:template match="unclear[contains(@reason, 'illegible')]" mode="#all">
        <xsl:text>[</xsl:text>
        <i>
            <xsl:value-of select="@extent"/>
            <xsl:choose>
                <xsl:when test="@unit = 'words'"> mots illisibles</xsl:when>
                <xsl:when test="@unit = 'char'"> caractères illisibles</xsl:when>
            </xsl:choose>
        </i>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <!-- pour rendre compte des passages barrés -->
    <xsl:template match="del[@rend = 'barré']" mode="#all">
        <del>
            <xsl:apply-templates/>
        </del>
    </xsl:template>

    <!-- pour afficher les signatures sur la droite, en italique -->
    <xsl:template match="signed/persName" mode="#all">
        <span style="font-style:italic; display: block; text-align: right;">
            <xsl:copy-of select="."/>
        </span>
    </xsl:template>

</xsl:stylesheet>
