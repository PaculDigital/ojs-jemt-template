{**
 * templates/frontend/pages/indexJournal.tpl (custom override)
 *
 * Homepage: deskripsi jurnal + kartu nama jurnal setelahnya.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal">

	{call_hook name="Templates::Index::journal"}

	{if $highlights->count()}
		{include file="frontend/components/highlights.tpl" highlights=$highlights}
	{/if}

	{if $activeTheme && !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
		<div class="homepage_image">
			<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}>
		</div>
	{/if}

	{* Journal Description *}
	{if $activeTheme && $activeTheme->getOption('showDescriptionInJournalIndex')}
		<section class="homepage_about">
			<a id="homepageAbout"></a>
			<h2>{translate key="about.aboutContext"}</h2>
			{$currentContext->getLocalizedData('description')}
		</section>
	{/if}

	<div class="jemt-bcard">
		<div class="jemt-bcard__header">
			<span class="jemt-bcard__header-logo" aria-hidden="true"></span>
		</div>

		<div class="jemt-bcard__body">
			<div class="jemt-bcard__item">
				<span class="jemt-bcard__label">Journal Title</span>
				<span class="jemt-bcard__value">Jurnal Ekonomi dan Manajemen Tridarma (JEMT)</span>
			</div>
			<div class="jemt-bcard__item">
				<span class="jemt-bcard__label">Frequency</span>
				<span class="jemt-bcard__value">{if $currentLocale eq 'en'}Published 6 times a year{else}Terbit 6 kali dalam setahun{/if}</span>
			</div>
			<div class="jemt-bcard__item">
				<span class="jemt-bcard__label">Chief Editor</span>
				<span class="jemt-bcard__value">Jizenji Tyas Wirastomo</span>
			</div>
			<div class="jemt-bcard__item">
				<span class="jemt-bcard__label">DOI Prefix</span>
				<span class="jemt-bcard__value">
					<a href="https://doi.org/10.64788/jpem" target="_blank" rel="noopener">https://doi.org/10.64788/jpem</a>
				</span>
			</div>
		</div>

		<div class="jemt-bcard__footer">
			<span class="jemt-bcard__badge"><i class="fa fa-tag" aria-hidden="true"></i> E-ISSN&nbsp;&nbsp;3163-608X</span>
			<span class="jemt-bcard__badge"><i class="fa fa-check-circle-o" aria-hidden="true"></i> Google Scholar</span>
			<span class="jemt-bcard__badge"><i class="fa fa-check-circle-o" aria-hidden="true"></i> Garuda</span>
			<span class="jemt-bcard__badge"><i class="fa fa-star" aria-hidden="true"></i> Nasional</span>
		</div>
	</div>

	<div class="jemt-indexed">
		<div class="jemt-indexed__header">
			<h2 class="jemt-indexed__title">INDEXED</h2>
		</div>
		<div class="jemt-indexed__row">
			<a href="https://scholar.google.com/citations?view_op=list_works&hl=en&authuser=2&user=xbvbr0kAAAAJ" target="_blank" rel="noopener"><img src="{$publicFilesDir}/indexed/1.webp" alt="Google Scholar"></a>
			<a href="https://garuda.kemdiktisaintek.go.id/journal/view/47326" target="_blank" rel="noopener"><img src="{$publicFilesDir}/indexed/2.webp" alt="Garuda"></a>
			<img src="{$publicFilesDir}/indexed/3.webp" alt="Indexed 3">
			<img src="{$publicFilesDir}/indexed/5.webp" alt="Indexed 5">
			<img src="{$publicFilesDir}/indexed/11.webp" alt="Indexed 11">
			<a href="https://search.worldcat.org/search?q=Jurnal+Ekonomi+dan+Manajemen+Tridarma&offset=1" target="_blank" rel="noopener"><img src="{$publicFilesDir}/indexed/7.webp" alt="WorldCat"></a>
			<a href="https://www.scilit.com/sources/507095" target="_blank" rel="noopener"><img src="{$publicFilesDir}/indexed/8.webp" alt="Scilit"></a>
			<img src="{$publicFilesDir}/indexed/4.webp" alt="Indexed 4">
			<a href="https://www.base-search.net/Search/Results?type=all&lookfor=Jurnal+Ekonomi+dan+Manajemen+Tridarma&ling=1&oaboost=1&newsearch=1" target="_blank" rel="noopener"><img src="{$publicFilesDir}/indexed/6.webp" alt="BASE"></a>
			<img src="{$publicFilesDir}/indexed/16.webp" alt="Indexed 16">
		</div>
		<div class="jemt-indexed__row">
			<img src="{$publicFilesDir}/indexed/12.webp" alt="Indexed 12">
			<img src="{$publicFilesDir}/indexed/13.webp" alt="Indexed 13">
			<img src="{$publicFilesDir}/indexed/15.webp" alt="Indexed 15">
			<img src="{$publicFilesDir}/indexed/clarivate-new.webp" alt="Clarivate">
			<img src="{$publicFilesDir}/indexed/jurnaltocnew.webp" alt="JournalTOC">
			<img src="{$publicFilesDir}/indexed/9.webp" alt="Indexed 9">
			<img src="{$publicFilesDir}/indexed/17.webp" alt="Indexed 17">
			<img src="{$publicFilesDir}/indexed/10.webp" alt="Indexed 10">
			<img src="{$publicFilesDir}/indexed/14.webp" alt="Indexed 14">
			<img src="{$publicFilesDir}/indexed/20.webp" alt="Indexed 20">
		</div>
	</div>

	<section class="jemt-announcements">
		<a id="homepageAnnouncements"></a>
		<h2 class="jemt-announcements__heading">Announcements</h2>
		<div class="jemt-announcements__grid">
			<article class="jemt-announcements__card">
				<h3 class="jemt-announcements__title">{if $currentLocale eq 'en'}Information About JEMT LoA{else}Informasi Tentang LoA JEMT{/if}</h3>
				<div class="jemt-announcements__date">2026-08-17</div>
				<div class="jemt-announcements__summary">
					{if $currentLocale eq 'en'}<p>To check the authenticity of an LoA issued by <strong>Jurnal Ekonomi dan Manajemen Tridarma (JEMT)</strong>, its authenticity can be verified by <em><strong>scanning the barcode</strong></em> printed on the LoA or through the <strong>verification link</strong> provided. Verification can also be carried out on the <strong>LoA Verification</strong> page by entering the LoA number. Make sure the data displayed matches the data shown on the verification result page. All LoAs can be verified; an LoA that cannot be verified was not issued by us and is not our responsibility. Please be careful.</p>{else}<p>Untuk mengecek keaslian LoA yang dikeluarkan <strong>Jurnal Ekonomi dan Manajemen Tridarma (JEMT)</strong> dapat dilakukan pengecekan <strong>keaslian LoA</strong> dengan <em><strong>scan barcode</strong></em> yang tertera di LoA atau <strong>link verifikasi</strong> yang tertera. Selain itu dapat juga dilakukan pengecekan pada laman <strong>Veifikasi LoA</strong> dengan menginput nomor LoA. Pastikan data yang ditampilkan sesuai dengan yang tertera di halaman hasil verifikasi. Seluruh LoA dapat diverifikasi, LoA yang tidak dapat diverifikasi bukan berasal dari kami dan tidak menjadi tanggung jawab kami. Harap berhati-hati.</p>{/if}
				</div>
				<a href="https://tridarma.id/jemt/en/announcement" class="jemt-announcements__link">Read More</a>
			</article>
			<article class="jemt-announcements__card">
				<h3 class="jemt-announcements__title">{if $currentLocale eq 'en'}Focus and Scope Information{else}Informasi Focus dan Scope{/if}</h3>
				<div class="jemt-announcements__date">2026-08-20</div>
				<div class="jemt-announcements__summary">
					{if $currentLocale eq 'en'}<p>Jurnal Ekonomi dan Manajemen Tridarma (JEMT) is a scholarly journal focusing on the publication of research results, theoretical studies, and conceptual thinking in the fields of economics and management. This journal serves as an academic forum for researchers, lecturers, practitioners, and students to disseminate ideas and scholarly findings that contribute to the advancement of knowledge and professional practice.</p>{else}<p>Jurnal Ekonomi dan Manajemen Tridarma (JEMT) merupakan jurnal ilmiah yang berfokus pada publikasi hasil penelitian, kajian teoretis, serta pemikiran konseptual dalam bidang ekonomi dan manajemen. Jurnal ini hadir sebagai wadah akademik bagi peneliti, dosen, praktisi, dan mahasiswa untuk menyebarluaskan gagasan serta temuan ilmiah yang berkontribusi terhadap pengembangan ilmu pengetahuan dan praktik profesional.</p>{/if}
				</div>
				<a href="https://tridarma.id/jemt/en/FocusAndScope" class="jemt-announcements__link">Read More &gt;</a>
			</article>
		</div>
	</section>

	{* Latest issue *}
	<section class="current_issue">
		<a id="homepageIssue"></a>
		<h2 class="jemt-section-heading">
			{translate key="journal.currentIssue"}
		</h2>
		{if $issue}
			<div class="current_issue_title">
				{$issue->getIssueIdentification()|escape}
			</div>
			{include file="frontend/objects/issue_toc.tpl" heading="h3"}
			<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}" class="read_more">
				{translate key="journal.viewAllIssues"}
			</a>
		{else}
			<p class="jemt-no-issue">Belum ada edisi terbit yang dipublikasikan.</p>
		{/if}
	</section>

	{* Additional Homepage Content *}
	{if $additionalHomeContent}
		<div class="additional_content">
			{$additionalHomeContent}
		</div>
	{/if}
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}