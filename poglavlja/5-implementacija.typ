#import "../funkcije.typ": todo

= Имплементација правила
<implementacija>

У овом поглављу описана је имплементација свих 21 правила алата.
Свако правило имплементира трејт `Rule` и добија приступ КСС стаблу и
оригиналном изворном тексту. Правила су подељена у два скупа: општа
правила добре праксе, описана у овом поглављу, и правила инспирисана
књигом _100 Go Mistakes_ @100mistakes, описана у следећем поглављу.

== Општа правила добре праксе

=== Празан блок кода (`empty_block`)

Празан блок кода је блок са телом без наредби. Иако је синтаксно
исправан, углавном представља грешку или заборављен код.

#figure(
```go
if err != nil {
    // заборављена обрада грешке
}
```,
  caption: [Пример празног блока кода],
) <lst:empty-block-go>

Правило обилази стабло рекурзивним обиласком у дубину и за сваки
чвор типа `block` броји именоване потомке употребом методе
`named_child_count`. Ако је тај број нула, блок је празан и
генерише се дијагностика.

#figure(
```rust
if node.kind() == "block" {
    let named = node.named_child_count();
    if named == 0 {
        diagnostics.push(Diagnostic::new(
            file, "Empty code block detected",
            EmptyBlock.name(), node.start_position(),
        ));
    }
}
```,
  caption: [Провера броја именованих потомака чвора `block`],
) <lst:empty-block-rs>

=== Недостижни код (`unreachable_code`)

Наредбе које следе после безусловне терминирајуће наредбе (`return`,
`break`, `continue`, `fallthrough` или позив `panic`) никада неће бити
извршене.

#figure(
```go
func f() {
    return
    fmt.Println("никада се не извршава")
}
```,
  caption: [Пример недостижног кода],
) <lst:unreachable-go>

Правило прегледа сваки чвор `statement_list` и линеарно пролази кроз
именоване потомке одржавајући заставицу `found_terminator`. Чим се
наиђе на терминирајућу наредбу, заставица се поставља и свака
наредна наредба у истом листу добија дијагностику. Позив `panic` се
препознаје тако што се провери да ли је чвор `expression_statement`
чији именовани потомак је `call_expression` са именом функције `panic`.

#figure(
```rust
let mut found_terminator = false;
for i in 0..node.named_child_count() {
    if let Some(stmt) = node.named_child(i as u32) {
        if found_terminator {
            diagnostics.push(/* дијагностика */);
            continue;
        }
        if Self::is_terminating(stmt, source) {
            found_terminator = true;
        }
    }
}
```,
  caption: [Линеарни пролаз кроз листу наредби са заставицом],
) <lst:unreachable-rs>

=== Игнорисана грешка (`ignored_error`)

У Go-у, функције које могу да генеришу грешку по конвенцији враћају
вредност типа `error` као последњи повратни аргумент. Додељивање те
вредности бланк идентификатору `_` тихо је занемарује.

#figure(
```go
val, _ := strconv.Atoi("abc") // грешка конверзије се игнорише
```,
  caption: [Тихо игнорисање грешке бланк идентификатором],
) <lst:ignored-error-go>

Правило обилази чворове `short_var_declaration` и
`assignment_statement` и прегледа све идентификаторе на левој страни
доделе (поље `left`). Ако неки идентификатор има текстуалну вредност
`_`, генерише се дијагностика. Правило пријављује сваки бланк
идентификатор, без обзира на тип вредности коју прима, будући да
информације о типовима нису доступне у приступу заснованом на КСС
стаблу.

#figure(
```rust
"short_var_declaration" | "assignment_statement" => {
    if let Some(lhs) = node.child_by_field_name("left") {
        for i in 0..lhs.named_child_count() {
            if let Some(id) = lhs.named_child(i as u32) {
                if id.utf8_text(source.as_bytes())
                        .unwrap_or("") == "_" {
                    diagnostics.push(/* дијагностика */);
                }
            }
        }
    }
}
```,
  caption: [Провера левих операнада доделе на бланк идентификатор],
) <lst:ignored-error-rs>

=== Некоришћена променљива (`unused_variable`)

Декларисана, а никада коришћена променљива указује на заборављен код
или логичку грешку. Иако Go компајлер већ одбија непакетске
некоришћене променљиве, правило покрива и случајеве у оквиру истог
`statement_list` чвора где компајлер не пријављује грешку.

#figure(
```go
func f() {
    x := 42   // x никада се не употребљава
    y := 10
    fmt.Println(y)
}
```,
  caption: [Пример некоришћене променљиве],
) <lst:unused-go>

Имплементација је двофазна. У првој фази, пролази се кроз именоване
потомке чвора `statement_list` и у хеш-мапу `declared` прикупљају
се сви идентификатори декларисани путем `short_var_declaration` и
`var_declaration`, уз искључивање бланк идентификатора `_`.
У другој фази, рекурзивно се прикупљају сви идентификатори унутар
блока у листу и бројеви јављања складиштени су у хеш-мапи `used`.
Ако се идентификатор јавља само један пут, то значи да се јавља
искључиво на месту декларације и никада се не употребљава.

#figure(
```rust
// Фаза 2: бројање јављања
let mut identifiers = Vec::new();
Self::collect_identifiers(node, source, &mut identifiers);
for name in identifiers {
    *used.entry(name).or_insert(0) += 1;
}
// Детекција: јавља се само у декларацији
for (name, decl_node) in declared {
    if used.get(&name).cloned().unwrap_or(0) <= 1 {
        diagnostics.push(/* дијагностика */);
    }
}
```,
  caption: [Двофазна детекција некоришћених променљивих],
) <lst:unused-rs>

=== Правила увоза (`import_rules`)

Правило детектује два проблема: дупликате увоза (исти пакет увезен
двапут) и некоришћене увозе (пакет увезен, али нигде не употребљен).

#figure(
```go
import (
    "fmt"
    "fmt"  // дупликат
    "os"   // некоришћен
)
```,
  caption: [Дупликат и некоришћен увоз],
) <lst:imports-go>

У првом пролазу, рекурзивно се прикупљају сви чворови `import_spec`.
Из сваког се извлачи путања пакета (чвор `interpreted_string_literal`)
и локално ime (чвор `identifier` ако постоји псеудоним, иначе
последњи сегмент путање). У другом пролазу, прикупљају се сви
чворови `selector_expression` и из поља `operand` читају имена
употребљених пакета. На крају се проверава да ли је путања
увоза виђена раније (дупликат) и да ли је локално ime пакета
присутно у скупу употребљених пакета (некоришћен увоз).

#figure(
```rust
for (path, local_name, position) in imports {
    if seen.contains_key(&path) {
        diagnostics.push(/* дупликат */);
    } else {
        seen.insert(path.clone(), true);
    }
    if local_name != "_" && !used_packages.contains(&local_name) {
        diagnostics.push(/* некоришћен */);
    }
}
```,
  caption: [Провера дупликата и некоришћених увоза],
) <lst:imports-rs>

=== Засенчење променљиве (`variable_shadowing`)

Засенчење (енг. _variable shadowing_) настаје када унутрашњи опсег
декларише нову променљиву истог имена као постојећа из спољашњег
опсега. Оригинална вредност постаје недоступна унутар унутрашњег
блока, што може проузроковати суптилне логичке грешке.

#figure(
```go
val := 10
if val > 5 {
    val := 20         // засенчује спољашњи val
    fmt.Println(val)  // исписује 20
}
fmt.Println(val)      // исписује 10, не 20
```,
  caption: [Пример засенчења променљиве],
) <lst:shadowing-go>

Правило одржава стек опсега: листу хеш-мапа, где свака хеш-мапа
представља скуп декларисаних променљивих у одређеном опсегу.
При уласку у нови `block` или `statement_list` чвор, прикупљају
се све `short_var_declaration` и `var_declaration` декларације.
За сваку нову декларацију, претражују се сви родитељски опсези;
ако нека родитељска хеш-мапа садржи исто ime, пријављује се
засенчење. По завршетку обраде блока, тренутни опсег се скида
са стека пре него што се настави обилазак суседних чворова.

#figure(
```rust
for parent_scope in parent_scopes.iter().rev() {
    if parent_scope.contains_key(name) {
        diagnostics.push(Diagnostic::new(
            file,
            format!("Variable `{}` shadows variable \
                     from outer scope", name),
            VariableShadowing.name(),
            id.start_position(),
        ));
        break;
    }
}
current_scope.insert(name.to_string(), id);
```,
  caption: [Провера засенчења претраживањем стека опсега],
) <lst:shadowing-rs>

=== Одлагање ресурса унутар петље (`defer_in_loop`)

Наредба `defer` у Go-у одлаже извршавање функције до тренутка повратка
из текуће функције, а не до краја тренутне итерације петље. Употреба
`defer` унутар петље стога акумулира одложена позивања кроз све
итерације и ослобађа ресурсе тек по изласку из функције, уместо
одмах по завршетку сваке итерације.

#figure(
```go
for _, f := range files {
    defer f.Close() // f.Close се позива тек кад функција врати вредност
}
```,
  caption: [Пример погрешне употребе `defer` унутар петље],
) <lst:defer-go>

Правило претражује стабло рекурзивним обиласком и за сваки чвор
`for_statement` покреће засебан унутрашњи обилазак. Унутрашњи
обилазак рекурзивно пролази кроз децу `for_statement` чвора и
пријављује сваки `defer_statement` на који наиђе. Кад год је
`defer_statement` пронађен директно у телу петље или у угнежденом
блоку унутар те исте петље, генерише се дијагностика. Наиђе ли се
на угнежден `func` литерал, обилазак у том подстаблу се не зауставља
јер `defer` унутар угнежденог функцијског литерала припада опсегу
те функције, а не спољашње петље.

#figure(
```rust
fn check_for_loop(node: Node, file: &str,
                  diagnostics: &mut Vec<Diagnostic>) {
    for i in 0..node.child_count() {
        if let Some(child) = node.child(i as u32) {
            if child.kind() == "defer_statement" {
                diagnostics.push(/* дијагностика */);
            }
            Self::check_for_loop(child, file, diagnostics);
        }
    }
}
```,
  caption: [Рекурзивна провера `defer` унутар `for_statement` чвора],
) <lst:defer-rs>
