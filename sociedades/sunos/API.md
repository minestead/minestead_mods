API do Mod Sunos v1.5

Variaveis Auxiliares
--------------------
Essas variaveis ficam armazenadas na tabela global `sunos.var` e 
podem ser encontradas no arquivo `diretrizes.lua`.
Não é recomendado modificar essas variaveis manualmente para que seja 
mantida a reprodução integral do repositório oficial.

Estruturas
----------
Um determinado tipo de estrutura deve estanciar suas funções, 
tabelas e outros valores em uma tabela `sunos.estruturas` cujo 
indice é o tipo de estrutura devendo ser apenas uma talavra como os 
demais existentes (casa, comunal, decor e etc). 

Alguns valores dentro dessa tabela são reservado para fins especificos:
* construir = function(pos, dist, vila) end : A API executa essa função que constrói a estrutura.
* pop = [true] : Informa para a API se essa estrutura contabiliza população
* fund_on_rightclick = function(...) end : Chamada do node de fundamento da estrutura receber chamada `on_rightclick`.
* fund_on_destruct = function(...) end : Chamada do node de fundamento da estrutura receber chamada `on_destruct`.
* defendido = function(pos) end : A API executa essa função para saber se a estrutura está defendida.
  * `pos` é a coordenada do fundamento da estrutura.
  * Deve retornar `true` caso a estrutura esteja defendida.
* verificar = function(pos) end : A API executa essa função para verificar se uma estrutura está destruida e toma as providencias caso esteja.
  * `pos` é a coordenada do fundamento da estrutura. 
* antes_restaurar_estrutura = function(pos) end: Função executada antes da estrutura ser restaurada.
* apos_restaurar_estrutura = function(pos) end: Função executada apos estrutura ser restaurada.

Nodes de Reposição
------------------
Nodes de reposição são usados para definir nodes que serão 
substituidos em uma estrutura ao ser construido, a substituição 
dos nodes pode mudar a cada nova estrutura tornando as estruturas 
menos repetidas. 
Atualmente os nodes só servem para substituir mobilias numa estrutura:
* Bancada : deve ficar sobre o chão
* Sobrebancada : Deve ficar sobre a bancada
* Decorativo : Pode ficar em qualquer local

### Metodos
* `sunos.decor_repo(pos, dist, Definições de nodes de reposição)`: Troca os itens de uma estrutura
  * `pos` é a coordenada do fundamento
  * `dist` é a distancia de centro até a borda da estrutura

### Definições de nodes de reposição
    {
        bancadas = {
            {
            	"itemstring", -- Item string do node 
            	<qtd>, -- Quantidade de itens que devem ser colocados
            	[sem sobrebancada] -- Define se deve deixar o espaço acima da bancada vazio (´true´ para deixar vazio)
            },
            {...},
            {...},
        },
        sobrebancadas = {
            {
            	"itemstring", -- Item string do node 
            	<qtd>, -- Quantidade de itens que devem ser colocados
            },
            {...},
            {...},
        },
        simples = {
            {
            	"itemstring", -- Item string do node 
            	<qtd>, -- Quantidade de itens que devem ser colocados
            },
            {...},
            {...},
        }
    }


Fundamento STEP
---------------
O fundamento step é usado para iniciar o processo de construção de uma estrutura.
Ao término da construção será executada a função `construir` da estrutura registrada.
sunos.colocar_fundamento_step(pos, Definições de Fundamento STEP)

### Definições de Fundamento STEP
    {
        tipo = "tipo_estrutura", -- Tipo de estrutura
        dist = 2, -- Distancia centro a borda da estrutura
        vila = vila, -- Numero da vila
        dias = 1, -- Dias em Minetest que demora para ficar pronta
        schem = schem, -- Nome do schem da estrutura (AVISO: não é o arquivo)
        rotat = "graus", -- Umas das quatro rotações em graus "0", "90", "180" ou "270" (sugestão: ´sunos.pegar_rotat()´)
    }


NPCs
----
Os NPCs podem ser registrados com a função `sunos.npcs.npc.registrar` que é 
apenas uma interface para realizar o registro em mobs_redo e gerenciar outros 
sistemas dos NPCs sunos.

### npcnode
Os npcnodes são nodes que guardam dados sobre um npc, esses nodes são usados 
por spawners para consutar dados de NPCs a serem spawnados

* `sunos.npcs.npc.registrar(tipo, Definições de NPC)` : Registrar um NPC comum
  * `tipo` é o nome da tipagem particular do npc (exemplo: "casa", "comunal")
* `sunos.npc_checkin.register_spawner(nodename, Definições de Spawner)` : Registra um node spawner
  * `nodename` é o itemstring do node spawner
* `sunos.npcnode.set_npcnode(pos, Definições de npcnode)` : Configura um npcnode
* `sunos.npcs.select_pos_spawn(pos, Definições da escolha do spawn)` : Seleciona uma coordenada de spawn
  * `pos` é uma coordenada em torno da qual será feita a seleção


### Definições de NPC
    {
        on_rightclick = function(self, player) end,
            ^ Função executada junto com on_rightclick da API mobs_redo
            
        on_spawn = function(self) end,
            ^ Função executada junto com on_spawn da API mobs_npc
        
        after_activate = function(self, staticdata, def, dtime) end,
            ^ Função executada junto com after_activate da API mobs_npc
        
        do_custom = function(self, dtime) end,
            ^ Função executada junto com do_custom da API mobs_npc
        
        drops = {{name = "default:wood", chance = 1, min = 1, max = 3}}
            ^ lista de itens que caem quando o npc morre (conforme definido nos mobs do mobs_redo)
    }

### Definições de Spawner
    {
        func_spawn = function(pos, tipo) end,
            ^ pos é a coordenada do spawner que vai spawnar um npc
            ^ tipo é o tipo de NPC registrado
    }

### Definições de npcnode
    {
        -- Tipo de NPC registrado nos sunos
        tipo = "",
    
        -- Ocupação do NPC (registrada na API advanced_npc). Não usado
        occupation = "",
    
        -- Node spawner de cada horario
        checkin = {
            ["0"] = {x=0, y=0, z=0}, 
            ["1"] = {x=0, y=0, z=0},
            ["2"] = {x=0, y=0, z=0},
            ...
            ["23"] = {x=0, y=0, z=0}
        },
    }

### Definições da escolha do spawn
    {
        tipo = "", 
            ^ Tipo escolhido
            ^ "fundamento" : Escolhe um node dentro de area de uma estrutura.
                             A coordenada `pos` deve ser o proprio fundamento.
        
        no_players = true, -- OPICIONAL, Se quer evitar jogadores, retorna nil se houver.
        
        nodes = {"nodename1", "nodename2", "nodename2"}, 
            ^ OPICIONAL. Tabela de nodes sobre o qual vai spawnar
            ^ Padrão é {"sunos:wood_nodrop", "default:stonebrick", "sunos:cobble_nodrop"}
        
        carpete = "nodename",
            ^ OPICIONAL. Node a ser considerado como carpete e deve estar acima do node, 
            ^ Colocar "air" para evitar qualquer carpete
            ^ Padrão é "sunos:carpete_palha_nodrop"
    }


Tabelas Globais
-----------------
Alguns aspectos do mod podem ser dinamicamente alterados sem que haja a necessidade de alteração no código desse mod.
Para isso basta que mods terceiros modifiquem as tabelas globais que estão aqui mostradas.

* `sunos.estruturas.casa.var.estante_livros`
    * itens que aparecem aleatóriamente nas estantes de livros das casas
    * tabela ordenada com itemstacks no formato tabela ou string
    * podem ser modificadas a qualquer momento
    * não repete itens na mesma estante

* `sunos.estruturas.casa.var.estante_frascos`
    * itens que aparecem aleatóriamente nas estantes de frascos das casas
    * tabela ordenada com itemstacks no formato tabela ou string 
    * podem ser modificadas a qualquer momento
    * não repete itens na mesma estante
    
### Exemplo
`
table.insert(sunos.estruturas.casa.var.estante_livros, {name="monname:book", count=5, wear=0, metadata=""})
table.insert(sunos.estruturas.casa.var.estante_frascos, "vessels:glass_bottle")
`


Registros Reservados
--------------------
Essa seção busca informar alguns dados de registro que não devem ser mexidos em códigos contribuidos

### Metadados do node de fundamento
Metadados do fundamento de uma estrutura (todos são armazenados no formato de strings)
* `"vila"` : numero da vila correspondente (exemplo: "12")
* `"tipo"` : nome do tipo de estrutura (exemplo: "casa")
* `"dist"` : distância do centro até a borda em blocos (exemplo: "3")

### Metadados de entidades
* variaveis da engine : Variaveis reservadas pela engine mobs_redo (veja a documentação da engine)
* `tipo` : Nome do tipo de npc suno
* `vila` : Vila do NPC
* `loop` : Controle de temporizador
* `temp` : Temporizador gerenciado pelo mod sunos
* `mypos` : Coordenada do node de origem
* `mynode` : Nome do node onde o npc spawnou
* `sunos_fundamento` : Coordenada do fundamento da estrutura do NPC

### Metadados de spawner
* `"sunos_npc_checkin_"..time`: Armazena tabelas de dados serializados
  * time varia de 0 a 23
  * Estrutura dos dados
    {
        ["x y z"] = { -- coordenada do node que registrou o checkin e que registra em si mesmo o NPC
            nodename = "itemstring", -- do node que registrou o checkin
        },
        ["x y z"] = {
            nodename = "itemstring",
        },
    }

### Metadados do nodes de NPC (npcnode)
* `"sunos_npchash"` : Hash do NPC
* `"sunos_npc_tipo"` : Tipo do NPC registrado nos sunos
* `"sunos_mynpc_checkin"`: Armazena tabelas de dados serializados
  * Estrutura dos dados
    {
        checkin = { -- Tabel a de checkins
            ["0"] = {x=0, y=0, z=0}, -- Index é a hora em formato string e armazena a tabela pos do node spawner
            ["1"] = {x=0, y=0, z=0},
            ["2"] = {x=0, y=0, z=0},
        }
    }

Métodos Auxiliares
------------------

* `minetest.get_node_light(pos, timeofday)`
    * Gets the light value at the given position. Note that the light value
      "inside" the node at the given position is returned, so you usually want
      to get the light value of a neighbor.
    * `pos`: The position where to measure the light.
    * `timeofday`: `nil` for current time, `0` for night, `0.5` for day
    * Returns a number between `0` and `15` or `nil`
    
* `sunos.montar_estrutura(pos, dist, tipo, rotat[, screm][, step])`
    * Monta uma estrutura aleatoria de um `tipo` definido dentre as estruturas salvas no formato esquemático
    * `pos` é a coordenada do centro do chão da estrutura
    * `dist` é a distancia do centro até a borda
    * `rotat` é a rotação opcional da estrutura ("0", "90", "180" ou "270")
    * `schem` [OPICIONAL] é um nome de schem (AVESI: não é o nome exato do arquivo), caso nulo, ele escolhe um aleatoriamente
    * `step` [OPICIONAL] é um número do STEP/estagio da estrutura para ser acrescentado o prefixo `-step` na busca do arquivo
    * Retorna um valor booleano `true` e `arquivo esquemático` se ocorrer corretamente 
    * Ocorre uma troca de itens durante a montagem da estrutura conforme definido em `sunos.var.nodes_trocados`
