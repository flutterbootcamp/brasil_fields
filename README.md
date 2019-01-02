# brasil_fields

O jeito mais fácil de utilizar padrões e formatos brasileiros em seu projeto.

## Apresentação

Este package facilita o desenvolvimento com a linguagem Dart em projetos que 
utilizam campos com os padrões e formatos brasileiros.

### Formatters 
* CPF 
<br> <img src="img/cpf.gif" width="250" ></img>
* CNPJ 
<br> <img src="img/cnpj.gif" width="250" ></img>
* CEP -
<br> <img src="img/cep.gif" width="250" ></img>
* Real (R$)
<br> <img src="img/moeda.gif" width="250" ></img>
* Centavos (R$)
<br> <img src="img/centavos.gif" width="250" ></img>
* Telefones (fixo e celular)
<br> <img src="img/telefone.gif" width="250" ></img>

### Padrões 
- Estados  
- Meses
- Regiões
- Semana

### Como utilizar:
Basta incluir o formatter que você quer que o campo tenha, na lista de `inputFormatters` :

**Para garantir que o campo aceite apenas valores numéricos, utilize em conjunto com o formatter `WhitelistingTextInputFormatter.digitsOnly` .**

```
TextFormField(
  inputFormatters: [
    WhitelistingTextInputFormatter.digitsOnly,
    CepInputFormatter(),
  ],
);
        
```

* `CpfInputFormatter()`
* `CnpjInputFormatter()`
* `CepInputFormatter()`
* `RealInputFormatter()`
* `TelefoneInputFormatter()`


