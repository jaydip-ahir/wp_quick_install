#!/bin/bash
#Script created by JD Ahir

# Function to display menu and choose an option
choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    while true
    do
        # List all options (option list is zero-based)
        index=0 
        for o in "${options[@]}"
        do
            if [ "$index" == "$cur" ]
            then echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
            else echo "  $o"
            fi
            index=$(( index + 1 ))
        done
        read -s -n3 key # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then cur=$(( cur - 1 ))
            [ "$cur" -lt 0 ] && cur=0
        elif [[ $key == $esc[B ]] # down arrow
        then cur=$(( cur + 1 ))
            [ "$cur" -ge $count ] && cur=$(( count - 1 ))
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
    # Export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}

# Function to handle errors
check_command() {
    if [ $? -ne 0 ]; then
        echo "Error occurred in the previous command. Exiting."
        exit 1
    fi
}

# Function to Create Files for Theme 
create_theme_files() {

local THEME_NAME=$1
local THEME_URI=$2
local AUTHOR_NAME=$3
local AUTHOR_URI=$4
local DESCRIPTION=$5
local VERSION=$6
local TEXT_DOMAIN=$7
local TEXT_DOMAIN_LOWER="${7,,}"
local FUNC_PREFIX="${TEXT_DOMAIN_LOWER//[ -]/_}"

# Define the content of the theme files

# style.css
STYLECSSFILE="/*
Theme Name: $THEME_NAME
Theme URI: $THEME_URI
Author: $AUTHOR_NAME
Author URI: $AUTHOR_URI
Description: $DESCRIPTION
Version: $VERSION
License: GNU General Public License v2 or later
License URI: http://www.gnu.org/licenses/gpl-2.0.html
Text Domain: $TEXT_DOMAIN
*/"

# header.php
HEADERFILE="<?php
/**
 * The header for our theme
 *
 * @package $TEXT_DOMAIN
 */

?>
<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
	<meta charset=\"<?php bloginfo( 'charset' ); ?>\">
	<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
	<?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
	<header>
		<nav>
			<?php wp_nav_menu( array( 'theme_location' => 'primary' ) ); ?>
		</nav>
	</header>"

# footer.php
FOOTERFILE="<?php
/**
 * The template for displaying the footer
 *
 * @package $TEXT_DOMAIN
 */

?>
	<footer>
		<p>&copy; <?php echo esc_html( gmdate( 'Y' ) ); ?> My Custom Theme. All rights reserved.</p>
	</footer>
	<?php wp_footer(); ?>
</body>
</html>"

# sidebar.php
SIDEBARFILE="<?php
/**
 * The sidebar containing the main widget area
 *
 * @package $TEXT_DOMAIN
 */

?>
<aside>
	<?php if ( is_active_sidebar( 'sidebar-1' ) ) : ?>
		<?php dynamic_sidebar( 'sidebar-1' ); ?>
	<?php endif; ?>
</aside>"

# functions.php
FUNCTIONSFILE="<?php
/**
 * Functions and definitions
 *
 * @package $TEXT_DOMAIN
 */

if ( ! function_exists( '${FUNC_PREFIX}_theme_setup' ) ) :
	/**
	 * Sets up theme defaults and registers support for various WordPress features.
	 */
	function ${FUNC_PREFIX}_theme_setup() {
		// Add support for various features.
		add_theme_support( 'title-tag' );
		add_theme_support( 'post-thumbnails' );

		// Register a primary menu.
		register_nav_menus(
			array(
				'primary' => __( 'Primary Menu', '$TEXT_DOMAIN' ),
			)
		);
	}
endif;
add_action( 'after_setup_theme', '${FUNC_PREFIX}_theme_setup' );


/**
 * Register widget area.
 */
function ${FUNC_PREFIX}_theme_widgets_init() {
	register_sidebar(
		array(
			'name'          => __( 'Sidebar', '$TEXT_DOMAIN' ),
			'id'            => 'sidebar-1',
			'description'   => __( 'Add widgets here to appear in your sidebar.', '$TEXT_DOMAIN' ),
			'before_widget' => '<section id=\"%1\$s\" class=\"widget %2\$s\">',
			'after_widget'  => '</section>',
			'before_title'  => '<h2 class=\"widget-title\">',
			'after_title'   => '</h2>',
		)
	);
}
add_action( 'widgets_init', '${FUNC_PREFIX}_theme_widgets_init' );

/**
* REQUIRED FILES
* Include required files.
*/

// register css and js file.
require get_template_directory() . '/inc/enqueue-function.php';"

# index.php
INDEXFILE="<?php
/**
 * The main template file
 *
 * @package $TEXT_DOMAIN
 */

get_header(); ?>

<div id=\"content\" class=\"site-content\">
	<?php
	if ( have_posts() ) :
		while ( have_posts() ) :
			the_post();
			the_content();
		endwhile;
	endif;
	?>
</div><!-- #content -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>"

# page.php
PAGEFILE="<?php
/**
 * The template for displaying all pages
 *
 * @package $TEXT_DOMAIN
 */

get_header(); ?>

<div id=\"content\" class=\"site-content\">
	<?php
	while ( have_posts() ) :
		the_post();
		the_content();

		if ( comments_open() || get_comments_number() ) :
			comments_template();
		endif;
	endwhile;
	?>
</div><!-- #content -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>"

# single.php
SINGLEFILE="<?php
/**
 * The template for displaying all pages
 *
 * @package $TEXT_DOMAIN
 */

get_header(); ?>

<div id=\"content\" class=\"site-content\">
	<?php
	while ( have_posts() ) :
		the_post();
		the_content();

		if ( comments_open() || get_comments_number() ) :
			comments_template();
		endif;
	endwhile;
	?>
</div><!-- #content -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>"

# archive.php
ARCHIVEFILE="<?php
/**
 * The template for displaying archive pages
 *
 * @package $TEXT_DOMAIN
 */

get_header(); ?>

<div id=\"content\" class=\"site-content\">
	<?php
	if ( have_posts() ) :
		while ( have_posts() ) :
			the_post();
			the_content();
		endwhile;
	endif;
	?>
</div><!-- #content -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>"

# 404.php
PAGE404FILE="<?php
/**
 * The template for displaying 404 pages (Not Found)
 *
 * @package  $TEXT_DOMAIN
 */

get_header(); ?>

<div id=\"content\" class=\"site-content\">
	<section class=\"error-404 not-found\">
		<header class=\"page-header\">
			<h1 class=\"page-title\"><?php esc_html_e( 'Oops! That page can’t be found.', '$TEXT_DOMAIN' ); ?></h1>
		</header><!-- .page-header -->
		<div class=\"page-content\">
			<p><?php esc_html_e( 'It looks like nothing was found at this location. Maybe try a search?', '$TEXT_DOMAIN' ); ?></p>
			<?php get_search_form(); ?>
		</div><!-- .page-content -->
	</section><!-- .error-404 -->
</div><!-- #content -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>"

# comments.php
COMMENTSFILE="<?php
/**
 * The template for displaying comments
 *
 * @package  $TEXT_DOMAIN
 */

if ( post_password_required() ) {
	return;
}
?>
<div id=\"comments\" class=\"comments-area\">
	<?php
	if ( have_comments() ) :
		?>
		<h2 class=\"comments-title\">
			<?php
			\$comment_count = get_comments_number();
			if ( '1' === \$comment_count ) {
				printf(
					/* translators: 1: title. */
					esc_html_x( 'One thought on &ldquo;%1\$s&rdquo;', 'comments title', '$TEXT_DOMAIN' ),
					esc_html( get_the_title() )
				);
			} else {
				printf(
					/* translators: 1: comment count number, 2: title. */
					wp_kses_post(
						/* translators: 1: comment count number, 2: title. */
						_nx(
							'%1$s thought on &ldquo;%2$s&rdquo;',
							'%1$s thoughts on &ldquo;%2$s&rdquo;',
							\$comment_count,
							'comments title',
							'new'
						)
					),
					esc_html( number_format_i18n( \$comment_count ) ),
					esc_html( get_the_title() )
				);
			}
			?>
		</h2>
		<ol class=\"comment-list\">
			<?php
			wp_list_comments(
				array(
					'style'      => 'ol',
					'short_ping' => true,
				)
			);
			?>
		</ol>
		<?php
		the_comments_navigation();
		if ( ! comments_open() ) :
			?>
			<p class=\"no-comments\"><?php esc_html_e( 'Comments are closed.', '$TEXT_DOMAIN' ); ?></p>
			<?php
		endif;
	endif;
	comment_form();
	?>
</div><!-- #comments -->"

# search.php
SEARCHFILE="<?php
/**
 * The template for displaying search results pages
 *
 * @package  $TEXT_DOMAIN
 */

get_header(); ?>

<div id=\"content\" class=\"site-content\">
	<section class=\"search-results\">
		<?php if ( have_posts() ) : ?>
			<header class=\"page-header\">
				<h1 class=\"page-title\">
					<?php
					printf(
						/* translators: %s: search query */
						esc_html__( 'Search Results for: %s', '$TEXT_DOMAIN' ),
						'<span>' . get_search_query() . '</span>'
					);
					?>
				</h1>
			</header><!-- .page-header -->

			<?php
			while ( have_posts() ) :
				the_post();
				the_content();
			endwhile;

			the_posts_navigation();

		endif;
		?>
	</section><!-- .search-results -->
</div><!-- #content -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>"

# search-form.php
SEARCHFORMFILE="<?php
/**
 * The template for displaying search forms
 *
 * @package  $TEXT_DOMAIN
 */

?>
<form role=\"search\" method=\"get\" class=\"search-form\" action=\"<?php echo esc_url( home_url( '/' ) ); ?>\">
	<label>
		<span class=\"screen-reader-text\"><?php echo esc_html_x( 'Search for:', 'label', '$TEXT_DOMAIN' ); ?></span>
		<input type=\"search\" class=\"search-field\" placeholder=\"<?php echo esc_attr_x( 'Search …', 'placeholder', '$TEXT_DOMAIN' ); ?>\" value=\"<?php echo get_search_query(); ?>\" name=\"s\" />
	</label>
	<button type=\"submit\" class=\"search-submit\"><?php echo esc_attr_x( 'Search', 'submit button', '$TEXT_DOMAIN' ); ?></button>
</form>"

# inc/enqueue-function.php
ENQUEUEFUNCTIONFILE="<?php
/**
 * Enqueue
 *
 * Register and Enqueue Styles.
 *
 * @package $TEXT_DOMAIN
 */

/**
 * All The File are enque here.
 */
function ${FUNC_PREFIX}_register_styles() {

	\$theme_version = wp_rand( 1, 10000 ) / wp_rand( 1, 100 ) * wp_rand( 1, 50 );

	wp_enqueue_style( 'theme-style', get_stylesheet_uri(), array(), \$theme_version );
	wp_enqueue_style( 'custom-style', get_template_directory_uri() . '/assets/css/custom-style.css', array(), \$theme_version );
	wp_enqueue_style( 'media-style', get_template_directory_uri() . '/assets/css/media.css', array(), \$theme_version );
}

add_action( 'wp_enqueue_scripts', '${FUNC_PREFIX}_register_styles' );

/**
 * Register and Enqueue Scripts.
 */
function ${FUNC_PREFIX}_register_scripts() {

	\$theme_version = wp_rand( 1, 10000 ) / wp_rand( 1, 100 ) * wp_rand( 1, 50 );

	wp_enqueue_script( 'settings-js', get_template_directory_uri() . '/assets/js/settings.js', array(), \$theme_version, true );
}

add_action( 'wp_enqueue_scripts', '${FUNC_PREFIX}_register_scripts' );"

# page-templates/custom-template.php
CUSTOMTEMPLATEFILE="<?php
/**
 * Template Name: Custom Page Template
 *
 * The template for displaying a custom page.
 *
 * @package  $TEXT_DOMAIN
 */

get_header(); ?>

<div id=\"content\" class=\"site-content\">
	<?php
	while ( have_posts() ) :
		the_post();
		?>
		<article id=\"post-<?php the_ID(); ?>\" <?php post_class(); ?>>
			<header class=\"entry-header\">
				<?php the_title( '<h1 class=\"entry-title\">', '</h1>' ); ?>
			</header><!-- .entry-header -->

			<div class=\"entry-content\">
				<?php the_content(); ?>
			</div><!-- .entry-content -->

			<footer class=\"entry-footer\">
				<?php edit_post_link( __( 'Edit', '$TEXT_DOMAIN' ), '<span class=\"edit-link\">', '</span>' ); ?>
			</footer><!-- .entry-footer -->
		</article><!-- #post-<?php the_ID(); ?> -->
		<?php
	endwhile;
	?>
</div><!-- #content -->

<?php get_sidebar(); ?>
<?php get_footer(); ?>"

# assets/js/settings.js
CUSTOMSTYLECSSFILE="/* Your custom css start */"

# assets/css/media.css
MEDIACSSFILE="/* Your media css start */"

# assets/css/custom-style.css
SETTINGSJSFILE="// Your custom js start"

mkdir -p $TEXT_DOMAIN && cd $TEXT_DOMAIN
mkdir assets assets/css assets/js inc page-templates
check_command

# Create theme files
echo "$STYLECSSFILE" > style.css
echo "$HEADERFILE" > header.php
echo "$FOOTERFILE" > footer.php
echo "$SIDEBARFILE" > sidebar.php
echo "$FUNCTIONSFILE" > functions.php
echo "$INDEXFILE" > index.php
echo "$PAGEFILE" > page.php
echo "$SINGLEFILE" > single.php
echo "$ARCHIVEFILE" > archive.php
echo "$PAGE404FILE" > 404.php
echo "$COMMENTSFILE" > comments.php
echo "$SEARCHFILE" > search.php
echo "$SEARCHFORMFILE" > search-form.php
echo "$ENQUEUEFUNCTIONFILE" > inc/enqueue-function.php
echo "$CUSTOMTEMPLATEFILE" > page-templates/custom-template.php
echo "$CUSTOMSTYLECSSFILE" > assets/css/custom-style.css
echo "$MEDIACSSFILE" > assets/css/media.css
echo "$SETTINGSJSFILE" > assets/js/settings.js

}

# Function for all required fields
prompt_required() {
    local prompt_message=$1
    local var_name=$2
    local input_value

    while true; do
        read -p "$prompt_message: " input_value
        if [ -n "$input_value" ]; then
            eval $var_name=\$input_value
            break
        else
            echo "This field is required. Please enter a value."
        fi
    done
}

# Function to Setup WordPress
setup_wordpress() {

    echo "====== Enter WordPress Details ======"

    # Get Details
    prompt_required "Enter Project Name" PROJECT_NAME
    prompt_required "Enter Database Name" DATABASE_NAME
    prompt_required "Enter admin user name" ADMIN_USER
    prompt_required "Enter admin password" ADMIN_PASSWORD
    prompt_required "Enter admin email" ADMIN_EMAIL
    prompt_required "Enter site title" SITE_TITLE

    # Make Project Folder
    mkdir "$PROJECT_NAME"
    check_command
    cd "$PROJECT_NAME" || exit

    # Download WordPress
    wp core download
    check_command

    # Create Config File
    wp core config --dbhost=localhost --dbname="$DATABASE_NAME" --dbuser=root --dbpass=Root@1234
    check_command

    # Create Database
    wp db create
    check_command

    # Install WordPress
    wp core install --url="http://localhost/$PROJECT_NAME" --title="$SITE_TITLE" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL"
    check_command

    # Give Permission to make changes in folder
    sudo chmod -R 777 "/var/www/$PROJECT_NAME"
    check_command
    
    wp rewrite structure '/%postname%/'
    check_command

    echo "====================================================="
    echo "- Site URL: http://localhost/$PROJECT_NAME"
    echo "- Login URL: http://localhost/$PROJECT_NAME/wp-admin"
    echo "- Username: $ADMIN_USER"
    echo "- Password: $ADMIN_PASSWORD"
    echo "====================================================="

}

# Function to Install Custom Theme
install_custom_theme() {

    # Get Details
    echo "====== Enter Theme Details ======"

    prompt_required "Enter Theme Name" THEME_NAME
    read -p "Enter Theme URI:" THEME_URI
    read -p "Enter Author Name:" AUTHOR_NAME
    read -p "Enter Author URI:" AUTHOR_URI
    read -p "Enter Description:" DESCRIPTION
    read -p "Enter Version:" VERSION
    prompt_required "Enter Text Domain" TEXT_DOMAIN

    create_theme_files "$THEME_NAME" "$THEME_URI" "$AUTHOR_NAME" "$AUTHOR_URI" "$DESCRIPTION" "$VERSION" "$TEXT_DOMAIN"
    check_command

    # Activate the theme
    wp theme activate "$TEXT_DOMAIN"
    check_command

    echo "=================================================================="
    echo "Custom theme \"$THEME_NAME\" created and activated successfully."
    echo "=================================================================="
}

# Define the actions for each selection
run_action() {
    case "$1" in

    "Setup WordPress")
        setup_wordpress
    ;;

    "Install Custom Theme")
        install_custom_theme
    ;;

    "Setup WordPress with Custom Theme")
        setup_wordpress      
	cd wp-content/themes
        install_custom_theme
    ;;

    "Quit")
        echo "Exiting..."
        exit 0
    ;;

    *)
        echo "Invalid option. Exiting."
        exit 1
    ;;
    esac
}


# Display menu and get user choice
choose_from_menu "" user_choice \
    "Setup WordPress" \
    "Install Custom Theme" \
    "Setup WordPress with Custom Theme" \
    "Quit"

# Run action based on user choice
run_action "$user_choice"
