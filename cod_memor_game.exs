defmodule JogoDaMemoria do
  @cartas ["🟥", "🟧", "🟨", "🟩", "🟦", "🟪", "🟫", "⬜️"]
  @cartas_baralhadas Enum.concat(@cartas, @cartas) |> Enum.shuffle()
  @cor_azul "\e[34m"
  @reset "\e[0m"

  def mostrar_estado(cartas_visiveis) do
    IO.puts("\nEstado atual do jogo:")
    Enum.with_index(cartas_visiveis)
    |> Enum.each(fn {carta, index} ->
      carta_formatada =
        if carta == "?" do
          "#{@cor_azul}#{carta}#{@reset}"
        else
          carta
        end

      IO.write("#{index}: #{carta_formatada}  ")
      if rem(index + 1, 4) == 0, do: IO.puts("")
    end)
    IO.puts("")
  end

  def iniciar() do
    cartas_visiveis = Enum.map(@cartas_baralhadas, fn _ -> "?" end)
    mostrar_estado(cartas_visiveis)
    jogar(@cartas_baralhadas, cartas_visiveis)
  end

  def jogar(cartas_baralhadas, cartas_visiveis) do
    IO.puts("\nEscolha duas cartas para virar (0-15):")

    carta1 = obter_indice("Primeira carta: ", cartas_visiveis)
    carta2 = obter_indice("Segunda carta: ", cartas_visiveis)

    if carta1 == carta2 do
      IO.puts("\nVocê deve escolher duas cartas diferentes. Tente novamente!")
      jogar(cartas_baralhadas, cartas_visiveis)
    else
      # Limpa o terminal antes de mostrar o estado atualizado
      IO.write("\e[H\e[2J")

      cartas_temporarias =
        atualizar_estado(cartas_visiveis, carta1, Enum.at(cartas_baralhadas, carta1),
                                          carta2, Enum.at(cartas_baralhadas, carta2))
      mostrar_estado(cartas_temporarias)
      Process.sleep(2000)

      carta_1_valor = Enum.at(cartas_baralhadas, carta1)
      carta_2_valor = Enum.at(cartas_baralhadas, carta2)

      IO.puts("\nREVELADO: Carta 1 (#{carta1}): #{carta_1_valor}")
      IO.puts("REVELADO: Carta 2 (#{carta2}): #{carta_2_valor}")

      cartas_visiveis =
        if carta_1_valor == carta_2_valor do
          IO.puts("\n🎉 Par encontrado! 🎉")
          cartas_temporarias
        else
          IO.puts("\n❌ Não é um par. Tente novamente! ❌")
          atualizar_estado(cartas_visiveis, carta1, "?", carta2, "?")
        end

      if Enum.all?(cartas_visiveis, fn x -> x != "?" end) do
        IO.puts("\n🏆 Parabéns! Você venceu! 🏆")
        mostrar_estado(cartas_visiveis)
      else
        mostrar_estado(cartas_visiveis)
        jogar(cartas_baralhadas, cartas_visiveis)
      end
    end
  end

  defp atualizar_estado(cartas_visiveis, indice1, valor1, indice2, valor2) do
    cartas_visiveis
    |> List.replace_at(indice1, valor1)
    |> List.replace_at(indice2, valor2)
  end

  defp obter_indice(mensagem, cartas_visiveis) do
    case IO.gets(mensagem) |> String.trim() |> Integer.parse() do
      {indice, ""} when indice in 0..(length(cartas_visiveis) - 1) ->
        if Enum.at(cartas_visiveis, indice) == "?" do
          indice
        else
          IO.puts("Essa carta já foi revelada! Escolha outra.")
          obter_indice(mensagem, cartas_visiveis)
        end
      _ ->
        IO.puts("Entrada inválida! Escolha um número entre 0 e #{length(cartas_visiveis) - 1}.")
        obter_indice(mensagem, cartas_visiveis)
    end
  end
end

JogoDaMemoria.iniciar()
