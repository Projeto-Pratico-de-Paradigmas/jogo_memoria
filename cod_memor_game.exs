#cria o módulo
defmodule JogoDaMemoria do
  #define uma lista de 8 emojis
  @cartas ["🐶", "🐱", "🐭", "🐹", "🦊", "🐻", "🐼", "🐨"]
  #duplica as cartas
  @cartas_baralhadas Enum.concat(@cartas, @cartas) |> Enum.shuffle()

  #mostra o estado das cartas/exibe o indice de cada carta
  def mostrar_estado(cartas_visiveis) do
    IO.puts("\nEstado atual do jogo:")
    Enum.with_index(cartas_visiveis)
    |> Enum.each(fn {carta, index} ->
      IO.write("#{index}: #{carta}  ")
      if rem(index + 1, 4) == 0, do: IO.puts("")
    end)
    IO.puts("")
  end

  #cria uma lista de cartas visíveis inicialmente, todas escondidas como "?"
  #chama mostrar_estado para mostrar o jogo e inicia o loop de jogadas com "jogar"
  def iniciar() do
    cartas_visiveis = Enum.map(@cartas_baralhadas, fn _ -> "?" end)
    mostrar_estado(cartas_visiveis)
    jogar(@cartas_baralhadas, cartas_visiveis)
  end

  def jogar(cartas_baralhadas, cartas_visiveis) do

    #pede pro jogador escolher dois índices entre 0 e 15
    IO.puts("\nEscolha duas cartas para virar (0-15):")

    #garante que os dois indices sejam diferentes e que as cartas ainda estejam escondidas
    carta1 = obter_indice("Primeira carta: ", cartas_visiveis)
    carta2 = obter_indice("Segunda carta: ", cartas_visiveis)

    if carta1 == carta2 do
      IO.puts("\nVocê deve escolher duas cartas diferentes. Tente novamente!")
      jogar(cartas_baralhadas, cartas_visiveis)
    else
      # Revela temporariamente as cartas escolhidas
      cartas_temporarias =
        atualizar_estado(cartas_visiveis, carta1, Enum.at(cartas_baralhadas, carta1),
                                          carta2, Enum.at(cartas_baralhadas, carta2))
      #mostra o estado atual
      mostrar_estado(cartas_temporarias)

      #espera 2 segundos para dar tempo de ver as cartas
      Process.sleep(2000)

      # Pegando os valores corretos para comparação
      carta_1_valor = Enum.at(cartas_baralhadas, carta1)
      carta_2_valor = Enum.at(cartas_baralhadas, carta2)

      IO.puts("\nDEBUG: Carta 1 (#{carta1}): #{carta_1_valor}")
      IO.puts("DEBUG: Carta 2 (#{carta2}): #{carta_2_valor}")

      #compara as cartas escolhidas
      cartas_visiveis =
        if carta_1_valor == carta_2_valor do
          IO.puts("\n🎉 Par encontrado! 🎉")
          cartas_temporarias
        else
          IO.puts("\n❌ Não é um par. Tente novamente! ❌")
          atualizar_estado(cartas_visiveis, carta1, "?", carta2, "?")
        end

      #verifica se todas as cartas foram encontradas
      if Enum.all?(cartas_visiveis, fn x -> x != "?" end) do
        IO.puts("\n🏆 Parabéns! Você venceu! 🏆")
        mostrar_estado(cartas_visiveis)
      else #o jogo continua
        mostrar_estado(cartas_visiveis)
        jogar(cartas_baralhadas, cartas_visiveis)
      end
    end
  end

  #função auxiliar para atualizar a lista de cartas_visiveis com novos valores em dois indices
  defp atualizar_estado(cartas_visiveis, indice1, valor1, indice2, valor2) do
    cartas_visiveis
    |> List.replace_at(indice1, valor1)
    |> List.replace_at(indice2, valor2)
  end


  defp obter_indice(mensagem, cartas_visiveis) do
    #lê a entrada do jogador
    case IO.gets(mensagem) |> String.trim() |> Integer.parse() do
      #valida se é um número válido e dentro dos limites(0 a 15)
      {indice, ""} when indice in 0..(length(cartas_visiveis) - 1) ->
        #verifica se a carta já foi revelada
        if Enum.at(cartas_visiveis, indice) == "?" do
          indice
        else #em caso de erro, pede de novo
          IO.puts("Essa carta já foi revelada! Escolha outra.")
          obter_indice(mensagem, cartas_visiveis)
        end
      _ ->
        IO.puts("Entrada inválida! Escolha um número entre 0 e #{length(cartas_visiveis) - 1}.")
        obter_indice(mensagem, cartas_visiveis)
    end
  end
end

# Iniciando o jogo
JogoDaMemoria.iniciar()
