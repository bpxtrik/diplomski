#let format_strane = "a4"         // могуће вредности: iso-b5, a4
#let naslov = "Штатичка анализа Go кода у циљу читљивости и одржавања"
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
     анализу изворног кода написаног у програмском језику Go. Алат је
     имплементиран у програмском језику Rust и користи Tree-sitter као
     позадински систем за парсирање, чиме се добија конкретно стабло синтаксе
     анализираног кода. За разлику од анализатора интегрисаних у компајлер,
     овај приступ одржава алат независним од Go инфраструктуре. Имплементирано
     је 21 правило статичке анализе подељено у две категорије: општа правила
     која детектују честе програмерске грешке и правила изведена из књиге
     _100 Go Mistakes and How to Avoid Them_ аутора Теиве Харсањија. Свако
     правило независно обрађује стабло синтаксе и производи дијагностике са
     прецизним информацијама о позицији у изворном коду. Алат је доступан као
     самостална апликација командне линије способна да анализира појединачне
     фајлове или целе директоријуме.
]

// На енглеском
#let kljucne_reci_eng = "static analysis, linter, Go, Rust, Tree-sitter, concrete syntax tree, diagnostics"
#let apstrakt_eng = [
     This thesis presents the design and implementation of a static analysis
     tool for source code written in the Go programming language. The tool is
     implemented in Rust and uses Tree-sitter as its parsing backend to produce
     a Concrete Syntax Tree of the analyzed code. Unlike compiler-integrated
     analyzers, this approach keeps the tool decoupled from the Go toolchain.
     The implementation covers 21 linting rules divided into two categories:
     general rules targeting common programming mistakes, and rules derived from
     the book _100 Go Mistakes and How to Avoid Them_ by Teiva Harsanyi. Each
     rule operates independently on the syntax tree and emits diagnostics with
     precise source locations. The tool is provided as a standalone
     command-line application capable of analyzing individual Go source files
     or entire directory trees.
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
