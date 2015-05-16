class ApiController < ApplicationController
	#skip CSRF token request
    protect_from_forgery with: :null_session

    #POST /api/register_group
	def register_group
     @token
     @user = params['user']
     @pass = params['pass']

     #verify params params presence
	 if !@user || !@pass
     	response['Status Code'] = '400 BAD REQUEST'
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
      		
      		response['Status Code'] = '201 CREATED'
      		@body = {"success": true,"message": "Su usuario ha sido creado exitosamente.","token": @token}

      	#else if user not OK
      	else

      		response['Status Code'] = '500 INTERNAL ERROR'
      		@body = {"success": false,"message": "El usuario elegido ya esta en uso."}

      	end

      
     end
	
  	render :json => @body
	end

	#GET /api/get_token
	def get_token
		@token
		@user = params['user']
     	@pass = params['pass']

     	#verify params presence
		if !@user || !@pass
    		response['Status Code'] = '400 BAD REQUEST'
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

		 		response['Status Code'] = '200 OK'
		 		@body = {"token":@token}

			#else if user or pass not OK
		 	else
		 		response['Status Code'] = '400 BAD REQUEST'
		 		@body =     {"non_field_errors":["Error"]}
			end	
		end 

		render :json => @body
	end 

	#POST /api/new_order
	def new_order
		@order_id = params['order_id']
		@token = params['token']
        
        #verify params presence
        if !@order_id || !@token
        	response['Status Code'] = '400 BAD REQUEST'
     		@body = {"order_id":["Este campo es requerido."],"token":["Este campo es requerido."]}
        else

         	#verify token
         	#if token OK

         		#verify order
         		#if order OK

         			response['Status Code'] = '200 OK'
         			@body = {"success":true,"message":"La orden de compra ha sido recibida."}

          			#save order

          		#else if order not OK

          			response['Status Code'] = '500 INTERNAL ERROR'
      				@body = {"success": false,"message": "La orden no ha podido ser recibida."}

          		#end

        	#else if token not OK

         		response['Status Code'] = '401 UNAUTHORIZED'
         		@body = {"success":false,"message":"El token no es válido."}

         	#end

        end

		render :json => @body

	end

	#PUT /api/order_accepted
	def order_accepted
		@order_id = params['order_id']

		#verify params params presence
		if !@order_id
		 	response['Status Code'] = '400 BAD REQUEST'
     	 	@body = {"order_id":"Este campo es requerido."}
     	else
     		#verify order
     		#if order OK

     			#notify system new order
     			response['Status Code'] = '200 OK'
         		@body = {"success":true,"message":"Se notifico exitosamente que la orden fue aceptada."}

         	#else if order not OK

         		response['Status Code'] = '500 INTERNAL ERROR'
      			@body = {"success": false,"message": "No se ha podido notificar la orden."}

         	#end

		end

		render :json => @body
	end

	#DELETE /api/order_canceled
	def order_canceled
		@order_id = params['order_id']
		@token = params['token']

		#verify params presence
		if !@order_id || !@token
        	response['Status Code'] = '400 BAD REQUEST'
     		@body = {"order_id":["Este campo es requerido."],"token":["Este campo es requerido."]}
     	else
     		#verify token
     		#if token OK
     			#verify order
     			#if order OK

     				#delete order     			
     				response['Status Code'] = '200 OK'
         			@body = {"success":true,"message":"OK."}

         		#else if order not OK

         			response['Status Code'] = '500 INTERNAL ERROR'
      				@body = {"success": false,"message": "No se podido cancelar la orden"}

         		#end

         	#else if token not OK

         		response['Status Code'] = '401 UNAUTHORIZED'
         		@body = {"success":false,"message":"El token no es válido."}

         	#end
       end

       render :json => @body
	end

	#DELETE /api/order_rejected
	def order_rejected
		@order_id = params['order_id']

		#verify params presence
		if !@order_id
		    response['Status Code'] = '400 BAD REQUEST'
     	 	@body = {"order_id":"Este campo es requerido."}
		else

			#verify order
			#if order OK

				#update order to rejected
		    	response['Status Code'] = '200 OK'
         		@body = {"success":true,"message":"OK."}				

			#if order not OK

				response['Status Code'] = '500 INTERNAL ERROR'
      			@body = {"success": false,"message": "No se ha podido notificar el rechazo de orden."}

			#end
		end
		render :json => @body
	end

	#POST /api/new_invoice
	def new_invoice
		@invoice_id = params['invoice_id']

		#verify params presence
		if !@invoice_id 
			response['Status Code'] = '400 BAD REQUEST'
     	 	@body = {"invoice_id":"Este campo es requerido."}
     	 else

     	 	#validate invoice
     	 	#if invoice OK
     	 		#notify system new invoice 
     	 		response['Status Code'] = '200 OK'
         	 	@body = {"success":true,"message":"La factura de compra ha sido recibida exitosamente."}

         	#else if invoice not OK

         		response['Status Code'] = '500 INTERNAL ERROR'
      			@body = {"success": false,"message": "No se ha podido notificar la factura."}

         	#end

         end

         render :json => @body
	end

	#DELETE /api/invoice_rejected
	def invoice_rejected
		@invoice_id = params['invoice_id']

		#verify params presence
		if !@invoice_id 
			response['Status Code'] = '400 BAD REQUEST'
     	 	@body = {"invoice_id":"Este campo es requerido."}
     	else

     	 	#verify invoice
     	 	#if invoice OK

     	 		#notify invoice rejected
     	 		response['Status Code'] = '200 OK'
         	 	@body = {"success":true,"message":"La factura de compra fue rechazada exitosamente."}

         	#else if invoice not OK

         		response['Status Code'] = '500 INTERNAL ERROR'
      			@body = {"success": false,"message": "No se ha podido notificar el rechazo de la factura."}

         	#end

         end

         render :json => @body
	end
    
    #PUT /api/invoice_paid/
    def invoice_paid
    	@invoice_id = params['invoice_id']
    	@token = params['token']

    	#verify params presence

    	if !@invoice_id || !@token
    		response['Status Code'] = '400 BAD REQUEST'
     	 @body = {"order_id":["Este campo es requerido."],"token":["Este campo es requerido."]}
     	else
     		#verify token
     		#if token OK

     			#verify invoice
     			#if invoice OK
     				response['Status Code'] = '200 OK'
         	 		@body = {"success":true,"message":"Se aviso al proveedor exitosamente."}

         	 	#else if invoice not OK

         	 		response['Status Code'] = '500 INTERNAL ERROR'
      				@body = {"success": false,"message": "No se ha podido notificar el pago de la factura."}

         	 	#end

         	 #else if token not OK

         	 		response['Status Code'] = '401 UNAUTHORIZED'
      				@body = {"success": false,"message": "El token no es válido."}

     		#end

     	end

     	render :json => @body

    end
end

