return function()
	local LuaChat = script.Parent.Parent
	local Location = require(script.Parent.Location)

	local ActionType = require(LuaChat.ActionType)
	local DialogInfo = require(LuaChat.DialogInfo)
	local Intent = DialogInfo.Intent

	-- TODO: CLICHAT-570 Remove this function after Luke's changes for fast flags
	local function isFFlagEnabled(flagName)
		local success, isFlagEnabled = pcall(function()
			return settings():GetFFlag(flagName)
		end)
		if success and not isFlagEnabled then
			warn("Fast Flag:", flagName, "is currently not enabled.")
		elseif not success then
			warn("GetFFlag failed for flag:", flagName)
		end
		return success and isFlagEnabled
	end

	local chatRemoveRouteEnabled = isFFlagEnabled("LuaChatEnableRemoveRoute")
	local chatPopToIntentFixEnabled = isFFlagEnabled("LuaChatPopToIntentFixEnabled")

	describe("initial state", function()
		it("should return an initial table when passed nil", function()
			local state = Location(nil, {})
			expect(state).to.be.a("table")
			expect(state.current).to.be.a("table")
			expect(state.history).to.be.a("table")
		end)
	end)

	describe("SetRoute", function()
		it("should set route to ConversationHub", function()
			local intent = Intent.ConversationHub

			local state = Location(nil, {
				type = ActionType.SetRoute,
				intent = intent,
				parameters = {},
			})

			expect(state.current.intent).to.equal(intent)
		end)

		it("should set route to Conversation with correct conversationId", function()
			local intent = Intent.Conversation
			local conversationId = "testConvoId"

			local state = Location(nil, {
				type = ActionType.SetRoute,
				intent = intent,
				parameters = {
					conversationId = conversationId
				},
			})

			expect(state.current.intent).to.equal(intent)
			expect(state.current.parameters.conversationId).to.equal(conversationId)
		end)
	end)

	if chatPopToIntentFixEnabled then
		describe("SetRoute with popToIntent", function()
			it("should pop to the right intent first and then add the new intent on top", function()
				local state = Location(nil, {
					type = ActionType.SetRoute,
					intent = Intent.ConversationHub,
					parameters = {},
				})

				state = Location(state, {
					type = ActionType.SetRoute,
					intent = Intent.Conversation,
					parameters = {
						conversationId = "testConvoId1"
					},
				})

				state = Location(state, {
					type = ActionType.SetRoute,
					intent = Intent.NewChatGroup,
				})

				state = Location(state, {
					type = ActionType.SetRoute,
					intent = Intent.Conversation,
					parameters = {
						conversationId = "testConvoId2"
					},
				})

				expect(#state.history).to.equal(4)

				state = Location(state, {
					type = ActionType.SetRoute,
					intent = Intent.Conversation,
					popToIntent = Intent.ConversationHub,
					parameters = {
						conversationId = "testConvoId3"
					},
				})

				expect(#state.history).to.equal(2)
				expect(state.history[1].intent).to.equal(Intent.ConversationHub)
				expect(state.current.parameters.conversationId).to.equal("testConvoId3")
				expect(state.history[#state.history].parameters.conversationId).to.equal("testConvoId3")
			end)
		end)
	end

	describe("route history", function()
		it("should push history", function()
			local state = Location(nil, {
				type = ActionType.SetRoute,
				intent = Intent.ConversationHub,
				parameters = {},
			})

			expect(#state.history).to.equal(1)
		end)

		it("should push history twice and have correct number of history entries", function()
			local state = Location(nil, {
				type = ActionType.SetRoute,
				intent = Intent.ConversationHub,
				parameters = {},
			})

			state = Location(state, {
				type = ActionType.SetRoute,
				intent = Intent.Conversation,
				parameters = {
					conversationId = "testConvoId"
				},
			})

			expect(#state.history).to.equal(2)
		end)

		it("should have current be equal to top of history", function()
			local state = Location(nil, {
				type = ActionType.SetRoute,
				intent = Intent.ConversationHub,
				parameters = {},
			})

			expect(state.history[1].intent).to.equal(state.current.intent)
		end)

		it("should pop history", function()
			local state = Location(nil, {
				type = ActionType.SetRoute,
				intent = Intent.ConversationHub,
				parameters = {},
			})

			state = Location(state, {
				type = ActionType.SetRoute,
				intent = Intent.Conversation,
				parameters = {
					conversationId = "testConvoId"
				},
			})

			state = Location(state, {
				type = ActionType.PopRoute
			})

			expect(state.current.intent).to.equal(Intent.ConversationHub)
			expect(#state.history).to.equal(1)
			expect(state.history[1].intent).to.equal(state.current.intent)
		end)

		if chatRemoveRouteEnabled then
			it("should remove from history properly", function()
				local state = Location(nil, {
					type = ActionType.SetRoute,
					intent = Intent.ConversationHub,
					parameters = {},
				})

				state = Location(state, {
					type = ActionType.SetRoute,
					intent = Intent.Conversation,
					parameters = {
						conversationId = "testConvoId1"
					},
				})

				state = Location(state, {
					type = ActionType.SetRoute,
					intent = Intent.NewChatGroup,
				})

				state = Location(state, {
					type = ActionType.SetRoute,
					intent = Intent.Conversation,
					parameters = {
						conversationId = "testConvoId2"
					},
				})

				expect(#state.history).to.equal(4)

				state = Location(state, {
					type = ActionType.RemoveRoute,
					intent = Intent.NewChatGroup
				})

				expect(#state.history).to.equal(3)

				state = Location(state, {
					type = ActionType.RemoveRoute,
					intent = Intent.EditChatGroup
				})

				expect(#state.history).to.equal(3)

				state = Location(state, {
					type = ActionType.RemoveRoute,
					intent = Intent.Conversation
				})

				expect(state.current.intent).to.equal(Intent.Conversation)
				expect(state.current.parameters.conversationId).to.equal("testConvoId1")
			end)
		end
	end)
end