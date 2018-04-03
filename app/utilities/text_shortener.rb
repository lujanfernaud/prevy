class TextShortener
  include ActionView::Helpers::SanitizeHelper

  TEXT_ENDING = "..."

  def self.call(text:, characters:)
    new(text, characters).call
  end

  def initialize(text, characters)
    @text = strip_tags(text)
    @maximum_characters = characters
    @words = @text.split(" ")
    @current_word_index = 0
    @characters_count = 0
    @spaces = 0
  end

  def call
    get_last_word_index
    build_text
  end

  private

    attr_reader :words, :maximum_characters

    def get_last_word_index
      words.each.with_index do |word, index|
        count_characters_up_to_current(word, index)

        break if current_text_size >= maximum_characters

        @current_word_index = index
      end
    end

    def count_characters_up_to_current(word, index)
      @characters_count += word.size
      @spaces = index + 1
    end

    def current_text_size
      @characters_count + @spaces + TEXT_ENDING.size
    end

    def build_text
      words[0..@current_word_index].join(" ") + TEXT_ENDING
    end
end
