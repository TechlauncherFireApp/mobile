import 'package:fireapp/domain/models/reference/qualification.dart';
import 'package:fireapp/domain/models/reference/volunteer_role.dart';
import 'package:fireapp/domain/models/register_request.dart';
import 'package:fireapp/domain/models/role_response.dart';
import 'package:fireapp/domain/models/token_request.dart';
import 'package:fireapp/domain/models/token_response.dart';
import 'package:fireapp/domain/models/volunteer_listing.dart';
import 'package:fireapp/domain/models/dto/volunteer_information_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/models/role_request.dart';
import '../../../domain/models/shift_request.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://test.api.fireapp-au.com/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("/authentication/login")
  Future<TokenResponse> login(@Body() TokenRequest tokenRequest);

  @POST("/authentication/register")
  Future<TokenResponse> register(@Body() RegisterRequest registerRequest);

  @GET("/user/getAllVolunteer")
  Future<Map<String, String>> volunteerList();

  @GET("/reference/qualifications")
  Future<List<Qualification>> getQualifications();

  @GET("/v2/reference/roles")
  Future<List<VolunteerRole>> getRoles();

  @GET("/volunteer")
  Future<VolunteerInformationDto> getVolunteerInformation(
      @Query("volunteerID") String volunteerId
  );

  @POST("/user-role")
  Future<void> updateVolunteerRoles(
      @Body() RoleRequest roleRequest
  );
  @PATCH("/user-role")
  Future<void> patchVolunteerRoles(
      @Body() RoleRequest roleRequest
  );

  @POST("/user-qualification")
  Future<void> updateVolunteerQualifications(
      @Query("volunteerId") String volunteerId,
      @Query("qualificationId") String qualificationId
  );
  @PATCH("/user-qualification")
  Future<void> updateVolunteerQualificationsPatch(
      @Query("volunteerId") String volunteerId,
      @Query("qualificationId") String qualificationId
  );
  @GET("/shift/request")
  Future<List<ShiftRequest>> getShiftRequest(
      @Query("requestID") String requestID
      );

  // Corresponds to DELETE method in Flask
  @DELETE("/shift/request")
  Future<Map<String, dynamic>> deleteShiftAssignment(
      @Query("shift_id") int shiftId,
      @Query("position_id") int positionId
      );

  // Corresponds to PATCH method in Flask
  @PATCH("/shift/request")
  Future<Map<String, dynamic>> updateShiftByPosition(
      @Query("shift_id") int shiftId,
      @Query("position_id") int positionId,
      @Query("volunteer_id") int volunteerId
      );

}