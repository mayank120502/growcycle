<?php
 use Tygh\Embedded; use Tygh\Registry; use Tygh\Less; use Tygh\Themes\Themes; use Tygh\Themes\Styles; use Tygh\Storage; function smarty_block_amp_styles($params, $content, &$smarty, &$repeat) { if ($repeat == true) { return; } $prepend_prefix = Embedded::isEnabled() ? 'html#tygh_html body#tygh_body .tygh' : ''; $current_location = Registry::get('config.current_location') . '/'; $root_dir = Registry::get('config.dir.root') . '/'; $css_dir = fn_get_theme_path('[themes]/[theme]', 'C') . '/css/'; $inline_styles = ''; $external_styles = array(); if (preg_match_all('/\<link(.*?href\s?=\s?(?:"|\')([^"]+)(?:"|\'))?[^\>]*\>/is', $content, $m)) { foreach ($m[2] as $k => $v) { $v = preg_replace('/\?.*?$/', '', $v); $media = ''; if (strpos($m[1][$k], 'media=') !== false && preg_match('/media="(.*?)"/', $m[1][$k], $_m)) { $media = $_m[1]; } if (strpos($v, $current_location) === false || strpos($m[1][$k], 'data-ca-external') !== false) { $external_styles[] = str_replace(' data-ca-external="Y"', '', $m[0][$k]); } else { $styles[] = array( 'file' => str_replace($current_location, $root_dir, $v), 'relative' => str_replace($current_location, '', $v), 'media' => $media ); } } } $controller = Registry::get('runtime.controller'); $amp_styles = Registry::get('amp_styles'); $components_dir = $css_dir . 'components/'; if (isset($amp_styles[$controller])) { foreach ($amp_styles[$controller] as $style_name => $true) { $style_path = $components_dir . $style_name . '.less'; if (file_exists($style_path)) { $styles[] = array( 'file' => $style_path, 'relative' => str_replace($root_dir, '', $style_path), 'media' => '' ); } } } else { $file_styles = fn_get_dir_contents($components_dir, false, true, 'less', '', true); foreach ($file_styles as $filename) { $style_path = $components_dir . $filename; $styles[] = array( 'file' => $style_path, 'relative' => str_replace($root_dir, '', $style_path), 'media' => '' ); } } if (preg_match_all('/\<style.*\>(.*)\<\/style\>/isU', $content, $m)) { $inline_styles = implode("\n\n", $m[1]); } if (!empty($styles) || !empty($inline_styles)) { fn_set_hook('styles_block_files', $styles); list($_area) = Tygh::$app['view']->getArea(); $params['compressed'] = true; $filename = fn_merge_styles($styles, $inline_styles, $prepend_prefix, $params, $_area); $relative_path = fn_get_theme_path('[relative]/[theme]/css/'); $path_css = Storage::instance('assets')->getAbsolutePath($relative_path) . fn_basename($filename); $content = fn_get_contents($path_css); $content .= PHP_EOL . implode(PHP_EOL, $external_styles); } if (AMP_COMPRESS_CSS) { $content = fn_sd_accelerated_pages_compress_css($content); } return $content; } function fn_sd_accelerated_pages_compress_css($content) { $content = preg_replace('!/\*[^*]*\*+([^/][^*]*\*+)*/!', '', $content); $replace = array( '; ' => ';', ' }' => '}', '{ ' => '{', "\r\n" => '', "\r" => '', "\n" => '', "\t" => '', '    ' => '', '  ' => '' ); return str_replace(array_keys($replace), $replace, $content); } function fn_sd_accelerated_pages_get_styles($content, $themeDirs) { $styles = ''; $styles_file = array(); $theme_name = Registry::get('runtime.layout.theme_name'); $style_id = Registry::get('runtime.layout.style_id'); $style = Styles::factory($theme_name); $variables = file_get_contents($style->getStyleFile($style_id)); $pattern = '/^@[\w\d#_:,\-; ]*$/m'; preg_match_all($pattern, $variables, $matches); if (!empty($matches[0])) { $matches = implode(' ', $matches[0]); $styles .= $matches; } if (preg_match_all('/\<link(.*?href\s?=\s?(?:"|\')([^"]+)(?:"|\'))?[^\>]*\>/is', $content, $m)) { $current_location = Registry::get('config.current_location'); foreach ($m[2] as $k => $v) { $v = preg_replace('/\?.*?$/', '', $v); $media = ''; if (strpos($m[1][$k], 'media=') !== false && preg_match('/media="(.*?)"/', $m[1][$k], $_m)) { $media = $_m[1]; } $styles_file[] = array( 'file' => str_replace($current_location, Registry::get('config.dir.root'), $v), 'relative' => str_replace($current_location . '/', '', $v), 'media' => $media ); if ($theme_name !== 'responsive' && isset($themeDirs['responsive'])) { $amp_file = str_replace($themeDirs[$theme_name]['absolute'], $themeDirs['responsive']['absolute'], $styles_file[0]['file']); $amp_relative = str_replace($themeDirs[$theme_name]['relative'], $themeDirs['responsive']['relative'], $styles_file[0]['relative']); $styles_file[] = array( 'file' => $amp_file, 'relative' => $amp_relative, 'media' => $media ); } } } if (!empty($styles_file)) { foreach ($styles_file as $style) { if (file_exists($style['file'])) { $styles .= file_get_contents($style['file']); } } } if (preg_match_all('/\<style.*\>(.*)\<\/style\>/isU', $content, $m)) { $styles .= implode("\n\n", $m[1]); } return $styles; } 