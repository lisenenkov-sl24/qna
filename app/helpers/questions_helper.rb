module QuestionsHelper
  def new_comment(parent)
    @new_comments ||= {}

    result = @new_comments[parent]
    return result if result

    if controller.is_a?(CommentsController) && controller.instance_variable_get(:'@commentable') == parent
      result = controller.instance_variable_get(:'@comment')
    end
    result ||= Comment.new

    @new_comments[parent] = result
  end

  def new_answer
    return @new_answer if @new_answer

    @new_answer = controller.instance_variable_get(:'@new_answer') if controller.is_a? CommentsController
    @new_answer ||= Answer.new
  end
end
