class ApiController < ApplicationController
    #skip CSRF token request
    protect_from_forgery with: :null_session

    require "base64"

    #POST /api/register_group
    def register_group
     @token
     @user = params['user']
     @pass = params['pass']

     #verify params params presence
     if !@user || !@pass
        @status = 400
        @body = {"user":["Este campo es requerido."],"pass":["Este campo es requerido."]}
        else 

        #validate user (username not used)
        @used_username = 0
        B2bUser.all.each do |user|
            if user.username==@user
                @used_username = 1
            end
        end
        #if user OK

        if @used_username==0
            #create user

            @new_user = B2bUser.new
            @new_user.username = @user
            @new_user.password = @pass

            @new_user.save

            ###############get token##############
            @token = @user + @pass
            @token = Base64.strict_encode64(@token)
            #response['Status Code'] = '201 CREATED'
            @status = 201
            @body = {"success": true,"message": "Su usuario ha sido creado exitosamente.","token": @token}
        #else if user not OK
        else
            @status = 500
            @body = {"success": false,"message": "El usuario elegido ya esta en uso."}
        end

        
      
     end
    render json: @body, status: @status
    end

    #GET /api/get_token
    def get_token
        @token
        @user = params['user']
        @pass = params['pass']

        #verify params presence
        if !@user || !@pass
            @status = 400
            @body = {"user":["Este campo es requerido."],"pass":["Este campo es requerido."]}
        else 
            #verify user and pass
            @login_ok = 0
            B2bUser.all.each do |user|
                if user.username == @user
                    if user.password == @pass
                        @login_ok = 1
                    end
                end
            end
            #if user and pass OK
            if @login_ok == 1
                
            ###############get token##############
            @token = @user + @pass
            @token = Base64.strict_encode64(@token)
                @status = 200
                @body = {"token":@token}

            #else if user or pass not OK
            else
                @status = 400
                @body =     {"non_field_errors":["Error"]}
            end 
        end 

        render :json => @body, status: @status
    end 

    #POST /api/new_order
    def new_order
        @order_id = params['order_id']
        @token = params['token']
        #verify params presence
        if !@order_id || !@token
            @status = 400
            @body = {"order_id":["Este campo es requerido."],"token":["Este campo es requerido."]}
        else

            #verify token
            B2bUser.all.each do |user|
                @saved_token = Base64.strict_encode64(user.username + user.password)
                if @saved_token == @token
                    @user = user
                end
            end
            #if token OK

            if @user != nil

                #verify order
                #if order OK

                    @status = 200
                    @body = {"success":true,"message":"La orden de compra ha sido recibida."}

                    #save order

                #else if order not OK

                    @status = 500
                    @body = {"success": false,"message": "La orden no ha podido ser recibida."}

                #end

            #else if token not OK
            else
                @status = 401
                @body = {"success":false,"message":"El token no es válido."}

            end

        end

        render :json => @body, status: @status

    end

    #PUT /api/order_accepted
    def order_accepted      
        @order_id = params['order_id']

        #verify params params presence
        if !@order_id
            @status = 400
            @body = {"order_id":"Este campo es requerido."}
        else
            #verify order
            #if order OK

                #notify system new order
                @status = 200
                @body = {"success":true,"message":"Se notifico exitosamente que la orden fue aceptada."}

            #else if order not OK

                @status = 500
                @body = {"success": false,"message": "No se ha podido notificar la orden."}

            #end

        end

        render :json => @body, status: @status
    end

    #DELETE /api/order_canceled
    def order_canceled      
        @order_id = params['order_id']
        @token = params['token']

        #verify params presence
        if !@order_id || !@token
            @status = 400
            @body = {"order_id":["Este campo es requerido."],"token":["Este campo es requerido."]}
        else
            #verify token
            B2bUser.all.each do |user|
                @saved_token = Base64.strict_encode64(user.username + user.password)
                if @saved_token == @token
                    @user = user
                end
            end
            #if token OK
            if @user != nil
                #verify order
                #if order OK

                    #delete order   
                    @status = 200           
                    @body = {"success":true,"message":"OK."}

                #else if order not OK

                    @status = 500
                    @body = {"success": false,"message": "No se podido cancelar la orden"}

                #end

            #else if token not OK
            else

                @status = 401
                @body = {"success":false,"message":"El token no es válido."}

            end
       end

       render :json => @body, status: @status
    end

    #DELETE /api/order_rejected
    def order_rejected
        @order_id = params['order_id']

        #verify params presence
        if !@order_id
            @status = 400
            @body = {"order_id":"Este campo es requerido."}
        else

            #verify order
            #if order OK

                #update order to rejected
                @status = 200
                @body = {"success":true,"message":"OK."}                

            #if order not OK

                @status = 500
                @body = {"success": false,"message": "No se ha podido notificar el rechazo de orden."}

            #end
        end
        render :json => @body, status: @status
    end

    #POST /api/new_invoice
    def new_invoice
        @invoice_id = params['invoice_id']

        #verify params presence
        if !@invoice_id 
            @status = 400
            @body = {"invoice_id":"Este campo es requerido."}
         else

            #validate invoice
            #if invoice OK
                #notify system new invoice 
                @status = 200
                @body = {"success":true,"message":"La factura de compra ha sido recibida exitosamente."}

            #else if invoice not OK

                @status = 500
                @body = {"success": false,"message": "No se ha podido notificar la factura."}

            #end

         end

         render :json => @body, status: @status
    end

    #DELETE /api/invoice_rejected
    def invoice_rejected
        @invoice_id = params['invoice_id']

        #verify params presence
        if !@invoice_id 
            @status = 400
            @body = {"invoice_id":"Este campo es requerido."}
        else

            #verify invoice
            #if invoice OK

                #notify invoice rejected
                @status = 200
                @body = {"success":true,"message":"La factura de compra fue rechazada exitosamente."}

            #else if invoice not OK

                @status = 500
                @body = {"success": false,"message": "No se ha podido notificar el rechazo de la factura."}

            #end

         end

         render :json => @body, status: @status
    end
    
    #PUT /api/invoice_paid/
    def invoice_paid
        @invoice_id = params['invoice_id']
        @token = params['token']

        #verify params presence

        if !@invoice_id || !@token
            @status = 400
            @body = {"order_id":["Este campo es requerido."],"token":["Este campo es requerido."]}
        else
            #verify token
            B2bUser.all.each do |user|
                @saved_token = Base64.strict_encode64(user.username + user.password)
                if @saved_token == @token
                    @user = user
                end
            end
            #if token OK
            if @user != nil

                #verify invoice
                #if invoice OK
                    @status = 200
                    @body = {"success":true,"message":"Se aviso al proveedor exitosamente."}

                #else if invoice not OK

                    @status = 500
                    @body = {"success": false,"message": "No se ha podido notificar el pago de la factura."}

                #end

             #else if token not OK
            else

                    @status = 401
                    @body = {"success": false,"message": "El token no es válido."}

            end

        end

        render :json => @body, status: @status

    end
end

