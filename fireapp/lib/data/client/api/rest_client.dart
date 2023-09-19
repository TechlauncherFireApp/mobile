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

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST("/authentication/login")
  Future<TokenResponse> login(@Body() TokenRequest tokenRequest);

  @POST("/authentication/register")
  Future<TokenResponse> register(@Body() RegisterRequest registerRequest);

  @GET("/v2/volunteers")
  Future<List<VolunteerListing>> volunteerList();

  @GET("/reference/qualifications")
  Future<List<Qualification>> getQualifications();

  @GET("/v2/reference/roles")
  Future<List<VolunteerRole>> getRoles();

  @GET("/v2/volunteers/{volunteerID}")
  Future<VolunteerInformationDto> getVolunteerInformation(
      @Path("volunteerID") String volunteerId
  );

  @POST("/user-role")
  Future<void> updateVolunteerRoles(
      @Query("userId") int userId,
      @Query("roleId") int roleId
  );

  @PATCH("/user-role")
  Future<void> patchVolunteerRoles(
      @Query("userId") int userId,
      @Query("roleId") int roleId
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

  @DELETE("/shift/request")
  Future<void> deleteShiftAssignment(
      @Query("shift_id") int shiftId,
      @Query("position_id") int positionId
  );

  @PATCH("/shift/request")
  Future<void> updateShiftByPosition(
      @Query("shift_id") int shiftId,
      @Query("position_id") int positionId,
      @Query("volunteer_id") int volunteerId
  );
}