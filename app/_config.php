<?php

use SilverStripe\Forms\HTMLEditor\HTMLEditorConfig;
use SilverStripe\Security\Member;
use SilverStripe\Security\PasswordValidator;

// remove PasswordValidator for SilverStripe 5.0
$validator = PasswordValidator::create();
// Settings are registered via Injector configuration - see passwords.yml in framework
Member::set_password_validator($validator);

/** @var \SilverStripe\Forms\HTMLEditor\TinyMCEConfig $cfg */
$cfg = HTMLEditorConfig::get('cms');
$cfg->disablePlugins('table', 'importcss')
    ->enablePlugins('charmap')
    ->setButtonsForLine(1,
        'bold', 'styleselect', '|', 'sslink', 'unlink', '|',
        'bullist', 'numlist', '|', 'cut', 'copy', 'paste', '|', 'charmap', 'code', 'removeformat'
    )->setButtonsForLine(2, null)
    ->setOptions([
        'theme_advanced_blockformats' => 'p,h1,h2,h3,h4,h5',
        'paste_text_sticky' => true,
        'paste_text_sticky_default' => true,
        'extended_valid_elements' => "span[!class]",
        'style_formats' => [
            [ 'title' => 'Absatz', 'block' => 'p' ],
            [ 'title' => 'Überschrift 2', 'block' => 'h2' ],
            [ 'title' => 'Überschrift 3', 'block' => 'h3' ]/*,
            [ 'title' => 'Klein', 'classes' => 'small', 'inline' => 'span' ]*/
        ]
    ]);
