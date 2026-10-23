#!/usr/bin/env bash
# PASANG KONTEN DATABASE VERSI ENGLISH — JEMT (OJS 3.5)
# Isi: 13 halaman statis locale 'en' + operasi footer EN + deskripsi jurnal EN.
# Jalankan SETELAH install.sh, dari folder repo ini, di server (akses docker tanpa sudo).
# Aman: semua baris lama dicadangkan dulu ke tabel bak_en_*.
set -euo pipefail
DB_CONTAINER="ojs-ojs_db-1"
WEB_CONTAINER="ojs-ojs_web-1"
cd ~

echo "[1/6] Cadangkan baris EN yang ada..."
docker exec "$DB_CONTAINER" sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" ojs -e "
  CREATE TABLE IF NOT EXISTS bak_en_settings AS SELECT * FROM static_page_settings WHERE locale='"'"'en'"'"';
  CREATE TABLE IF NOT EXISTS bak_en_journal AS SELECT * FROM journal_settings WHERE journal_id=1 AND locale='"'"'en'"'"';
  CREATE TABLE IF NOT EXISTS bak_en_desc AS SELECT * FROM journal_settings WHERE journal_id=1 AND setting_name='"'"'description'"'"';"' 2>/dev/null
echo "  cadangan siap (bak_en_settings, bak_en_journal, bak_en_desc)"

echo "[2/6] Tulis berkas SQL..."
cat > pasang-en.sql <<'SQLEOF1'
DELETE FROM static_page_settings WHERE static_page_id=1 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Focus and Scope</h2>
<p>The Journal of Economics and Management Tridarma (JEMT) is a scholarly journal focusing on the publication of research findings, theoretical studies, and conceptual thinking in the fields of economics and management. The journal serves as an academic forum for researchers, lecturers, practitioners, and students to disseminate ideas and scientific findings that contribute to the development of knowledge and professional practice.</p>
<p>JEMT accepts manuscripts that have never been published and are not under consideration by another journal. Topics within scope include, but are not limited to:</p>
<ul>
<li>Human resource management and organizational behavior;</li>
<li>Marketing management and consumer behavior;</li>
<li>Financial management and banking;</li>
<li>Operations management and supply chains;</li>
<li>Entrepreneurship, MSMEs, and the creative economy;</li>
<li>Development economics, monetary economics, and public policy;</li>
<li>Digital economics and business, including e-commerce and digital marketing;</li>
<li>Management accounting and other relevant economics and management topics.</li>
</ul>
<p>Manuscripts may take the form of research articles (quantitative, qualitative, or mixed methods), theoretical studies, and conceptual papers within the scope above. JEMT is published six times a year, and all published articles are openly accessible free of charge.</p>', setting_type FROM static_page_settings WHERE static_page_id=1 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=2 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Reviewers</h2>
<p>JEMT\'s reviewers consist of academics and practitioners experienced in economics and management. Every manuscript is reviewed through a double-blind peer review process to safeguard publication quality and integrity: the identities of authors and reviewers remain unknown to each other throughout the review.</p>
<p>Reviewers assess manuscripts objectively based on topical relevance to the journal\'s scope, novelty and scientific contribution, methodological soundness, clarity of presentation, and compliance with scholarly writing standards. Review outcomes are the editor\'s primary consideration in deciding whether a manuscript is accepted, revised, or rejected.</p>
<p>The editorial board welcomes academics and practitioners in economics and management who wish to serve as JEMT reviewers. Prospective reviewers may contact the editor at admin@tridarma.id or via WhatsApp at +62 851-7813-8514, attaching their field of expertise and a brief scholarly profile. Active reviewers will be listed on this page and on the journal\'s masthead.</p>', setting_type FROM static_page_settings WHERE static_page_id=2 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=3 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Publication Ethics</h2>
<p>JEMT is committed to upholding standards of scholarly publication ethics throughout the publishing process, covering the responsibilities of authors, editors, reviewers, and the publisher. These guidelines refer to the principles established by the Committee on Publication Ethics (COPE).</p>
<h3>Authors\' Responsibilities</h3>
<ul>
<li>The submitted manuscript is original, has never been published, and is not under consideration by another journal;</li>
<li>All data and research findings are presented honestly, without fabrication, falsification, or manipulation;</li>
<li>All cited sources are listed in the references; the manuscript is free of plagiarism, including self-plagiarism;</li>
<li>All contributors are listed as authors, and the consent of every author is obtained before submission;</li>
<li>If a significant error is discovered after publication, authors must promptly notify the editor so that a correction or retraction can be made.</li>
</ul>
<h3>Editors\' Responsibilities</h3>
<ul>
<li>Assess manuscripts on their scholarly merit regardless of the authors\' background;</li>
<li>Keep manuscripts and author identities confidential during the review process;</li>
<li>Make publication decisions fairly, based on peer review results;</li>
<li>Not use unpublished manuscript content for personal purposes.</li>
</ul>
<h3>Reviewers\' Responsibilities</h3>
<ul>
<li>Conduct reviews objectively, constructively, and in a timely manner;</li>
<li>Keep reviewed manuscripts confidential and not misuse them;</li>
<li>Inform the editor of any similarity to other works or any conflict of interest.</li>
</ul>
<h3>Publisher\'s Responsibilities</h3>
<p>The publisher ensures that every stage of publication follows ethical standards, supports the independence of editorial decisions, and handles suspected publication ethics violations seriously, including issuing corrections, clarifications, or retractions where a violation is proven.</p>', setting_type FROM static_page_settings WHERE static_page_id=3 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=4 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Publication Process</h2>
<p>JEMT\'s publication process runs from manuscript submission, administrative screening, and editorial review, through peer review, to proofreading and publication. The complete stages are:</p>
<ol>
<li><strong>Manuscript submission.</strong> Authors submit manuscripts through the JEMT OJS system in accordance with the applicable template and author guidelines.</li>
<li><strong>Administrative screening.</strong> The editor checks manuscript completeness, template compliance, fit with the journal\'s scope, and similarity (plagiarism) level. Manuscripts that do not meet the requirements are returned to the authors.</li>
<li><strong>Editorial review.</strong> The editor assesses the manuscript\'s initial suitability for peer review.</li>
<li><strong>Peer review.</strong> Manuscripts are reviewed by at least two reviewers through double-blind peer review.</li>
<li><strong>Editorial decision.</strong> Based on the reviews, the editor decides whether the manuscript is accepted, accepted with revisions, or rejected. Authors asked to revise must resubmit the revised manuscript together with responses to the reviewers\' comments.</li>
<li><strong>Editing and proofreading.</strong> Accepted manuscripts proceed to language editing and layout in the journal\'s format.</li>
<li><strong>Publication.</strong> Articles are published in the current issue and openly accessible to the public. JEMT is published six times a year.</li>
</ol>
<p>The entire publication process at JEMT is free of charge, both for manuscript submission and article publication (see the Author Fees page).</p>', setting_type FROM static_page_settings WHERE static_page_id=4 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=5 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Peer Review Process</h2>
<p>JEMT applies a double-blind peer review system. Every manuscript is reviewed by at least two reviewers according to their fields of expertise. Under this system, authors do not know the reviewers\' identities and reviewers do not know the authors\' identities, so assessment is objective and free of conflicts of interest.</p>
<p>Reviewers assess the following aspects:</p>
<ul>
<li>Fit of the topic with the journal\'s focus and scope;</li>
<li>Novelty and scientific contribution of the manuscript;</li>
<li>Soundness and clarity of the research methodology;</li>
<li>Quality of the analysis, discussion, and conclusions;</li>
<li>Clarity of language and compliance with the template and scholarly writing standards.</li>
</ul>
<p>Based on the reviews, the editor decides one of the following: the manuscript is accepted without revision, accepted with revision (minor or major), or rejected. Authors receiving a revision decision must improve the manuscript according to the reviewers\' feedback and resubmit it through the OJS system. The final publication decision rests entirely with the editorial board, taking the peer review results into consideration.</p>', setting_type FROM static_page_settings WHERE static_page_id=5 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=6 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Open Access Statement</h2>
<p>JEMT provides full open access, so that all articles can be accessed and downloaded by the public free of charge. Readers may read, download, copy, and distribute articles published in JEMT at no cost and without asking permission, provided attribution to the authors and the original source is maintained in accordance with the applicable license.</p>
<p>This open access policy aims to broaden the dissemination of scholarly knowledge in economics and management, increase the readership and impact of authors\' work, and support the global exchange of knowledge. There is no embargo period: every article is openly accessible immediately upon publication.</p>
<p>Terms for reusing articles are further governed on the Copyright and License page.</p>', setting_type FROM static_page_settings WHERE static_page_id=6 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=7 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Copyright and License</h2>
<p>Copyright of articles remains with the authors. By publishing in JEMT, authors grant the journal permission to publish the article for the first time and to disseminate it openly.</p>
<p>All articles in JEMT are licensed under the <strong>Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)</strong>. This license allows anyone to copy, distribute, adapt, and use the article for any purpose, provided that:</p>
<ul>
<li>Appropriate attribution is given to the authors and JEMT as the original source, with a link to the license;</li>
<li>Any changes made to the original work are indicated;</li>
<li>Derivative works are distributed under the same license (ShareAlike).</li>
</ul>
<p>Authors may archive and distribute the published version of their article (for example, in institutional repositories or personal websites), provided it is stated that the article was published in JEMT.</p>', setting_type FROM static_page_settings WHERE static_page_id=7 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=8 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Plagiarism Policy</h2>
<p>Every manuscript submitted to JEMT is checked for similarity using plagiarism detection software before entering the review stage. This check applies to all manuscripts without exception.</p>
<p>JEMT does not tolerate plagiarism in any form, including:</p>
<ul>
<li>Claiming another person\'s work, text, data, or ideas as one\'s own without attribution;</li>
<li>Copying a substantial portion of another work, including one\'s own previously published work (self-plagiarism), without proper acknowledgment;</li>
<li>Submitting the same manuscript simultaneously to more than one journal.</li>
</ul>
<p>Manuscripts indicated to have a high similarity level or proven to contain plagiarism will be returned to the authors for correction or rejected, according to the severity of the violation and the editorial board\'s consideration. If a violation is discovered after publication, the editor reserves the right to correct or retract the article and announce the retraction on the journal\'s website.</p>', setting_type FROM static_page_settings WHERE static_page_id=8 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=9 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Indexing</h2>
<p>JEMT is currently in the process of being indexed in various national and international scholarly databases. Indexing applications are carried out progressively as part of JEMT\'s commitment to improving the quality, visibility, and credibility of its scholarly publications.</p>
<p>Every article published in JEMT is assigned a Digital Object Identifier (DOI) with the prefix 10.64788 and complete metadata, making articles easy to find through academic search engines such as Google Scholar and connected to the global scientific reference network.</p>
<p>Updates on JEMT\'s indexing status will be published and announced on this page. For further information about indexing, please contact the editor at admin@tridarma.id or via WhatsApp at +62 851-7813-8514.</p>', setting_type FROM static_page_settings WHERE static_page_id=9 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=10 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Author Guidelines</h2>
<p>Authors are required to follow the JEMT template and the writing provisions set out on this Author Guidelines page. Manuscripts that do not comply with the template and the following provisions will be returned to the authors before further processing.</p>
<h3>General Provisions</h3>
<ul>
<li>The manuscript is an original work, has never been published, and is not under consideration by another journal;</li>
<li>The manuscript is written in good Indonesian or English;</li>
<li>The manuscript is typed using the official JEMT template, downloadable via the Journal Template block in the sidebar of this website, or directly from the <a href="https://tridarma.id/public/journals/1/Template-JEMT-2026.docx">template download link</a>;</li>
<li>Authors must ensure the manuscript is free of plagiarism (see the Plagiarism page).</li>
</ul>
<h3>Manuscript Structure</h3>
<ol>
<li>Article title (clear, concise, and reflecting the manuscript\'s content);</li>
<li>Author names and institutional affiliations, with a correspondence email;</li>
<li>Abstract in Indonesian and English, with 3–5 keywords;</li>
<li>Introduction;</li>
<li>Research methods (for research articles);</li>
<li>Results and discussion;</li>
<li>Conclusion;</li>
<li>References, arranged consistently following the citation style exemplified in the JEMT template, preferably from up-to-date scholarly sources.</li>
</ol>
<h3>Manuscript Submission</h3>
<p>Manuscripts are submitted through the JEMT OJS system (the Register/Login buttons on this website). The entire publication process — from manuscript submission to published article — is free of charge. If you encounter any difficulties, please contact the editor at admin@tridarma.id or via WhatsApp at +62 851-7813-8514.</p>', setting_type FROM static_page_settings WHERE static_page_id=10 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=11 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Archive Policy</h2>
<p>All articles published in JEMT are permanently archived by the publishing system and digital archiving services. JEMT uses the Open Journal Systems (OJS) platform, which stores every manuscript, article file, and publication metadata in a structured manner, so that all published issues remain publicly accessible in the long term.</p>
<p>Every article is assigned a permanent DOI, so links and citations to the article remain valid even if the journal\'s website changes in appearance or structure. Authors may also store and distribute the published version of their article in institutional repositories or personal websites, in accordance with the provisions on the Copyright and License page.</p>
<p>If an article is later corrected or retracted, a record of the change will be linked to that article\'s archive so that its publication history remains transparent.</p>', setting_type FROM static_page_settings WHERE static_page_id=11 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=12 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Author Fees</h2>
<p>JEMT charges no manuscript submission fee and no article publication fee. All stages of publication — manuscript submission, peer review, editing, through to the article being published and publicly accessible — are entirely free (IDR 0).</p>
<p>This policy ensures that scholarly publication opportunities are open to all researchers, lecturers, practitioners, and students without financial barriers. Should this fee policy change in the future, the change will be officially announced on this page before taking effect.</p>
<p>Authors are advised to beware of irresponsible parties acting in JEMT\'s name and requesting payment. JEMT never collects fees through personal accounts. Official confirmation is available only via admin@tridarma.id or WhatsApp at +62 851-7813-8514.</p>', setting_type FROM static_page_settings WHERE static_page_id=12 AND locale='id' AND setting_name='content' LIMIT 1;
DELETE FROM static_page_settings WHERE static_page_id=13 AND locale='en' AND setting_name='content';
INSERT INTO static_page_settings (static_page_id, locale, setting_name, setting_value, setting_type)
SELECT static_page_id, 'en', setting_name, '<h2>Contact Us</h2>
<p>Contact for the Journal of Economics and Management Tridarma (JEMT):</p>
<ul>
<li><strong>Email:</strong> admin@tridarma.id</li>
<li><strong>WhatsApp:</strong> +62 851-7813-8514</li>
<li><strong>Website:</strong> https://tridarma.id/jemt</li>
<li><strong>E-ISSN:</strong> 3163-608X</li>
</ul>
<p><strong>Editor-in-Chief:</strong> Jizenji Tyas Wirastomo</p>
<p><strong>Publisher:</strong> Tridarma Journal Publishing.</p>
<p>Questions regarding manuscript submission, review status, or collaboration may be directed to the email or WhatsApp above during working days and hours. All official JEMT correspondence uses only the contacts listed on this page.</p>', setting_type FROM static_page_settings WHERE static_page_id=13 AND locale='id' AND setting_name='content' LIMIT 1;
UPDATE journal_settings
SET setting_value = REPLACE(REPLACE(setting_value, 'Universitas Pelita Bangsa', ''), '085720505555', '085178138514')
WHERE journal_id = 1 AND locale = 'en' AND setting_name = 'pageFooter';
SQLEOF1
cat > deskripsi-en.sql <<'SQLEOF2'
DELETE FROM journal_settings WHERE journal_id=1 AND locale='en' AND setting_name='description';
INSERT INTO journal_settings (journal_id, locale, setting_name, setting_value)
VALUES (1, 'en', 'description', '<p style="text-align: justify;"><strong>Jurnal Ekonomi dan Manajemen Tridarma (JEMT)</strong> is a scholarly journal focusing on the publication of research results, theoretical studies, and conceptual thinking in the fields of economics and management. This journal serves as an academic forum for researchers, lecturers, practitioners, and students to disseminate ideas and scholarly findings that contribute to the advancement of knowledge and professional practice.</p>
<p style="text-align: justify;">JEMT covers various studies in economics and management, including but not limited to micro and macro economics, development economics, public economics, finance, banking, human resource management, marketing management, financial management, operations management, entrepreneurship, and sharia-based economics and business.</p>');
SQLEOF2

echo "[3/6] Pasang 13 halaman statis EN + footer EN..."
docker cp pasang-en.sql "$DB_CONTAINER:/tmp/pasang-en.sql"
docker exec "$DB_CONTAINER" sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" ojs < /tmp/pasang-en.sql'
echo "  selesai"

echo "[4/6] Pasang deskripsi jurnal EN..."
docker cp deskripsi-en.sql "$DB_CONTAINER:/tmp/deskripsi-en.sql"
docker exec "$DB_CONTAINER" sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" ojs < /tmp/deskripsi-en.sql'
echo "  selesai"

echo "[5/6] Verifikasi..."
docker exec "$DB_CONTAINER" sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" ojs -e "
  SELECT COUNT(*) AS halaman_en_terisi FROM static_page_settings WHERE setting_name='"'"'content'"'"' AND locale='"'"'en'"'"';
  SELECT locale, LENGTH(setting_value) AS panjang_deskripsi FROM journal_settings WHERE journal_id=1 AND setting_name='"'"'description'"'"' ORDER BY locale;
  SELECT LOCATE('"'"'085720505555'"'"', setting_value) AS nomor_lama_footer_en, LOCATE('"'"'Universitas Pelita Bangsa'"'"', setting_value) AS upb_footer_en FROM journal_settings WHERE journal_id=1 AND locale='"'"'en'"'"' AND setting_name='"'"'pageFooter'"'"';"' 2>/dev/null

echo "[6/6] Bersihkan cache template..."
docker exec -u root "$WEB_CONTAINER" sh -c 'rm -rf /var/www/html/cache/t_cache/* /var/www/html/cache/t_compile/* 2>/dev/null || true'
echo
echo "=== KONTEN EN TERPASANG ==="
