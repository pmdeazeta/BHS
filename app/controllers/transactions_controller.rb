class TransactionsController < ApplicationController
  layout 'pages'

  def index
    @transactions = Transaction.all
  end

  def create

  end

  def edit 

  end

  def update

  end

  def destroy

  end
end
