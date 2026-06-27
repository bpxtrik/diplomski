#let format_strane = "a4"         // могуће вредности: iso-b5, a4
#let naslov = "Статичка анализа Go кода у циљу читљивости и одржавања"
#let autor = "Патрик Барши"


// На енглеском
#let naslov_eng = "Static Go code analysis for readability and maintainability"
#let autor_eng = "Patrik Barši"

#let indeks = "SV7/2022"

// Име и презиме ментора
#let mentor = "Игор Дејановић"
// Звање: редовни професор, ванредни професор, доцент
#let mentor_zvanje = "редовни професор"

// Скинути коментаре са одговарајућих линија
#let studijski_program = "Софтверско инжењерство и информационе технологије"
// #let studijski_program = "Рачунарство и аутоматика"
// #let stepen = "Мастер академске студије"
#let stepen = "Основне академске студије"

#let godina = [#datetime.today().year()]

#let kljucne_reci = "статичка анализа, линтер, Go, Rust, Tree-sitter, конкретно стабло синтаксе, дијагностике"
#let apstrakt = [
     У овом раду представљени су дизајн и имплементација алата за статичку
     анализу Go кода имплементираног у програмском језику Rust. Алат користи
     Tree-sitter за парсирање и ради над конкретним стаблом синтаксе, чиме
     остаје независан од Go инфраструктуре. Имплементирано је 21 правило
     подељено у општа правила добре праксе и правила изведена из књиге
     _100 Go Mistakes and How to Avoid Them_. Алат је доступан као апликација
     командне линије способна да анализира фајлове или целе директоријуме.
]

// На енглеском
#let kljucne_reci_eng = "static analysis, linter, Go, Rust, Tree-sitter, concrete syntax tree, diagnostics"
#let apstrakt_eng = [
     This thesis presents the design and implementation of a static analysis
     tool for Go source code written in Rust. The tool uses Tree-sitter to
     produce a Concrete Syntax Tree, keeping it decoupled from the Go toolchain.
     Twenty-one linting rules are implemented, divided into general best-practice
     rules and rules derived from _100 Go Mistakes and How to Avoid Them_. The
     tool is provided as a command-line application capable of analyzing
     individual files or entire directory trees.
]

// TODO: Текст задатка добијате од ментора. Заменити доле #lorem(100) са текстом задатка.
#let zadatak = [
     #lorem(100)
]

// TODO: Датум одбране и чланове комисије добијате од ментора
#let datum_odbrane = "01.01.2025"
#let komisija_predsednik = "Петар Петровић"
#let komisija_predsednik_zvanje = "ванредни професор"
#let komisija_clan = "Марко Марковић"
#let komisija_clan_zvanje = "доцент"

// На енглеском уписати чланове на латиници
#let komisija_predsednik_eng = "Petar Petrović"
#let komisija_clan_eng = "Marko Marković"
#let mentor_eng = "Igor Dejanović"


// Ово даље углавном не треба мењати.

#let zvanje_eng = (
     "редовни професор": "full professor",
     "ванредни професор": "assoc. professor",
     "доцент": "asist. professor",
)
#let komisija_predsednik_zvanje_eng = zvanje_eng.at(komisija_predsednik_zvanje)
#let komisija_clan_zvanje_eng = zvanje_eng.at(komisija_clan_zvanje)
#let mentor_zvanje_eng = zvanje_eng.at(mentor_zvanje)


#let vrsta_rada = if stepen == "Мастер академске студије" {
    "Дипломски - мастер рад"
} else {
    "Дипломски - бечелор рад"
}

#let oblast = "Електротехничко и рачунарско инжењерство"
#let oblast_eng = "Electrical and Computer Engineering"
#let disciplina = "Примењене рачунарске науке и информатика"
#let disciplina_eng = "Applied computer science and informatics"

#import "funkcije.typ": *
// Поглавља/страна/цитата/табела/слика/графика/прилога
#let fizicki_opis = physical()
